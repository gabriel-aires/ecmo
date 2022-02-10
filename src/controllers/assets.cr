require "mime"

class Assets < Application

  skip_action :require_read
  skip_action :require_write
  skip_action :require_login

  rescue_from BakedFileSystem::NoSuchFileError, :file_not_found

  def file_not_found(e)
    render :not_found, text: "404 Not Found"
  end

  def show
    path = "assets/#{params["id"]}"
    file = Storage.get path
    response.headers["Content-Type"] = MIME.from_filename(path, "application/octet-stream")
    response.headers["Content-Length"] = file.size.to_s
    render binary: file.gets_to_end
  end

end
