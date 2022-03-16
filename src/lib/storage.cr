class Storage
  extend BakedFileSystem

  bake_folder "../../vfs"

  def self.read(path)
    file = get path
    file.gets_to_end
  end

end
