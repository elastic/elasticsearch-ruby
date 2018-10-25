module Elasticsearch

  module Loggable


    def log_debug(message)
      logger.debug(message) if logger && logger.debug?
    end

    def log_error(message)
      logger.error(message) if logger && logger.error?
    end

    def log_fatal(message)
      logger.fatal(message) if logger && logger.fatal?
    end

    def log_info(message)
      logger.info(message) if logger && logger.info?
    end

    def log_warn(message)
      logger.warn(message) if logger && logger.warn?
    end
  end
end
