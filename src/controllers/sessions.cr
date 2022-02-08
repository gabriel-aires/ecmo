class Sessions < Application
  skip_action :require_read
  skip_action :require_write

  # GET login
  def new
    true
  end

  # POST verify
  def create
    true
  end

  # DELETE logout
  def destroy
    true
  end

end
