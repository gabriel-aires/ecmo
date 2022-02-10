module SessionUtils

  def current_user
    # username should be unique and is used instead of id in order to support network users
    # session data is stored in a cryptographically signed cookie (tamper-proof)
    @_current_user ||= session["username"]? ? User.new session["username"].to_s : nil
  end

  def current_user (username : String)
    session["username"] = username
  end

  def notice
    unpack_string cookies.delete("notice").not_nil!.value.to_s
  end

  def notice?
    cookies["notice"]?
  end

  def notice(message : String)
    cookies["notice"] = pack_string message
  end

  def tone
    unpack_string cookies["tone"].value
  rescue
    "blue"
  end

  def tone(color : String)
    cookies["tone"] = pack_string(color.in?(["green", "orange", "red", "black"]) ? color : "blue")
  end

  def tone(level : Symbol)
    case level
    when :success then  tone "green"
    when :warn    then  tone "orange"
    when :error   then  tone "red"
    when :none    then  tone "black"
    when :random  then  tone ["green", "orange", "red", "blue"].shuffle.first
    else                tone "blue"
    end
  end

  def theme
    unpack_string cookies["theme"].value
  rescue
    "bg-white"
  end

  def theme(palette : String)
    cookies["theme"] = pack_string palette
  end

  def theme(level : Symbol)
    case level
    when :ocean   then  theme "bg-blue light-text"
    when :sky     then  theme "bg-default light-text"
    when :grass   then  theme "bg-green light-text"
    when :sunset  then  theme "bg-orange light-text"
    when :blood   then  theme "bg-red light-text"
    when :night   then  theme "bg-black light-text"
    when :rain    then  theme "bg-gray light-text"
    when :day     then  theme "bg-white"
    else                theme "bg-white"
    end
  end

  def end_session
    session.delete "username"
    @_current_user = nil
  end

  def require_login
    redirect_to Sessions.new unless current_user
  end

  # safe string encoding inside cookies
  # See https://tools.ietf.org/html/rfc6265#section-4.1.1
  def pack_string(txt : String)
    txt.tr " ,\";\\", "|&@\$#"
  end

  def unpack_string(txt : String)
    txt.tr "|&@\$#", " ,\";\\"
  end

end
