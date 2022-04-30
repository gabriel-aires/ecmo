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
