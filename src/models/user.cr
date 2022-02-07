class User

  getter id : Int64, gid : Int64, name : String, group : String, type : Symbol

  def initialize(id_output :  String)

    fields = id_output.gsub(") ", ")|").split("|")
    records = {} of Symbol => String
    [:uid_info, :gid_info, :group_info].each { |k| records[k] =  fields.shift.split("=").last }
    _id = _gid = _name = _group = ""
    @membership = [] of Array(String)

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

end
