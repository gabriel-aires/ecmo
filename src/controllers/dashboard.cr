class Dashboard < Application

  def index
    welcome_text = "You're being trampled by Spider-Gazelle!"
    Log.warn { "logs can be collated using the request ID" }

    # You can use signals to change log levels at runtime
    # USR1 is debugging, USR2 is info
    # `kill -s USR1 %APP_PID`
    Log.debug { "use signals to change log levels at runtime" }

    respond_with do
      html template("welcome.ecr")
      text "Welcome, #{welcome_text}"
      json({welcome: welcome_text})
    end

  end

end
