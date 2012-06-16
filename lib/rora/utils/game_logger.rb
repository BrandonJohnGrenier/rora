class GameLogger

  def initialize
    @log = Logger.new(STDOUT)
    @log.sev_threshold = Logger::INFO
    @log.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime}: #{msg}\n"
    end
  end

  def debug message
    @log.debug(message)
  end

  def info message
    @log.info(message)
  end

end