module Elasticsearch

  # Module to encapsulate all logging functionality.
  #
  # @since 7.0.0
  module Loggable

    # Log a debug message.
    #
    # @example Log a debug message.
    #   log_debug('Message')
    #
    # @param [ String ] message The message to log.
    #
    # @since 7.0.0
    def log_debug(message)
      logger.debug(message) if logger && logger.debug?
    end

    # Log an error message.
    #
    # @example Log an error message.
    #   log_error('Message')
    #
    # @param [ String ] message The message to log.
    #
    # @since 7.0.0
    def log_error(message)
      logger.error(message) if logger && logger.error?
    end

    # Log a fatal message.
    #
    # @example Log a fatal message.
    #   log_fatal('Message')
    #
    # @param [ String ] message The message to log.
    #
    # @since 7.0.0
    def log_fatal(message)
      logger.fatal(message) if logger && logger.fatal?
    end

    # Log an info message.
    #
    # @example Log an info message.
    #   log_info('Message')
    #
    # @param [ String ] message The message to log.
    #
    # @since 7.0.0
    def log_info(message)
      logger.info(message) if logger && logger.info?
    end

    # Log a warn message.
    #
    # @example Log a warn message.
    #   log_warn('Message')
    #
    # @param [ String ] message The message to log.
    #
    # @since 7.0.0
    def log_warn(message)
      logger.warn(message) if logger && logger.warn?
    end
  end
end
