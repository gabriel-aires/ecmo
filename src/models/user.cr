require "ssh2"

class UserError < Exception; end
class InvalidUserParamsError < UserError; end
class UserNotFoundError < UserError; end
class UserAuthenticationError < UserError; end

class User
  getter id : Int64, gid : Int64, name : String, group : String, type : Symbol

  def initialize(txt :  String)
    if str.starts_with? "uid="
      self.from_id_output txt
    else
      self.from_username txt
    end
  end

  def initialize(num : Int64)
    self[num]
  end

  protected def self.init_ivars
    @id = @gid = 100000000
    @name = @group = ""
    @type = :other
    @membership = [] of Array(String)
  end

  protected def self.from_id_output(id_output :  String)
    self.init_ivars
    self.parse_id_output id_output
  end

  protected def self.parse_id_output(id_output :  String)
    _id = _gid = _name = _group = ""
    fields = id_output.gsub(") ", ")|").split("|")
    records = {} of Symbol => String
    [:uid_info, :gid_info, :group_info].each { |k| records[k] =  fields.shift.split("=").last }

    records.each do |k, v|
      case k
      when :uid_info
        _id, _name = v.split("(").map &.delete(")")
      when :gid_info
        _gid, _group = v.split("(").map &.delete(")")
      when :group_info
        @membership = v.split(",").map { |info| info.split("(").map &.delete(")") }
      end
    end

    @id = _id.to_i64
    @gid = _gid.to_i64
    @name = _name.to_s
    @group = _group.to_s
    @type = case @id
      when 0
        :root
      when .in? (1...1000)
        :system
      when .in? (1000..60000)
        :regular
      else
        :other
      end

    self

	rescue
    msg = "User should take a string in the form "
    msg += "'uid=00(AAAA) gid=11(BBBB) groups=22(CCCC),11(BBBB)'"
		raise InvalidUserParamsError.new(msg)
  end

  protected def self.[](uid : Int64)
    self.from_username self.get_name_from_uid
  end

  protected def self.get_name_from_uid(uid : Int64)
    File
      .read("/etc/passwd")
      .split("\n")
      .select { |l| l.split(":")[2].to_i64 == uid }
      .split(":")
      .first
  rescue
    raise UserNotFoundError.new("Couldn't find username matching uid #{uid}")
  end

  protected def self.from_username(username : String)
    sanitized_username = username.delete &.in?('$', ';', ':', '(', ')', '<', '>', '&', '#', '=', '/', '\\', '?', '*')
    self.from_id_output `id #{sanitized_username}`
  rescue
    raise UserNotFoundError.new("Couldn't find user '#{username}'")
  end

  def member_of?(gid : Int64)
    group_ids.includes? gid
  end

  def member_of?(group_name : String)
    groups.includes? group_name
  end

  def groups
    @membership.map { |group_info| group_info.last }.flatten
  end

  def group_ids
    @membership.map { |group_info| group_info.first.to_i64 }.flatten
  end

  def root?
    type == :root
  end

  def system?
    type == :system
  end

  def regular?
    type == :regular
  end

  def self.authenticate!(username : String, password :  String)

    authenticated = false
    requested_user = User.new(username)

    SSH2::Session.open("127.0.0.1") do |conn|
      conn.login(username, password)
      conn.open_session do |ssh|
        ssh.command("id")
        ssh_user = User.new(ssh.read_line)
        authenticated = requested_user == ssh_user
      end
    end

    if authenticated
      ssh_user
    else
      raise UserAuthenticationError.new("Failed login for #{username}")
    end

  rescue error
    raise UserAuthenticationError.new("Failed login for #{username}")
  end

end
