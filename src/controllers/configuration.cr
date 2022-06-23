class JobSettings < Application

    def index

    end

    def new

    end

    def create

    end

    def show

    end

    def edit

    end

    def update

    end

    def destroy

    end

    private def job_path(name)
        "#{App::ROOT}/jobs/#{name}.rb"
    end

    private def jobs
        Dir.glob App::ROOT + "/jobs/*.rb"
    end

    private def deps
        Dir.glob App::ROOT + "/jobs/lib/**.rb"
    end

end
