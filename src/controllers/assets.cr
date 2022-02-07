require "mime"

class Assets < Application
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
