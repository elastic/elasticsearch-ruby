module Elasticsearch
  module Extensions
    module ANSI

      # Wrapper for the Elasticsearch response body, which adds a {#to_ansi} method
      #
      class ResponseBody < DelegateClass(Hash)
        def initialize(body)
          super(body)
        end

        # Return a [colorized and formatted](http://en.wikipedia.org/wiki/ANSI_escape_code)
        # representation of the Elasticsearch response body
        #
        def to_ansi(options={})
          output = Actions.public_methods.select do |m|
            m.to_s =~ /^display_/
          end.map do |m|
            Actions.send(m, self, options)
          end

          output.compact.join("\n")
        end
      end

    end
  end
end

module Elasticsearch
  module Transport
    module Transport

      class Response
        # Wrap the response body in the {Extensions::ANSI::ResponseBody} class
        #
        def body_to_ansi
          Extensions::ANSI::ResponseBody.new @body
        end

        alias_method :body_original, :body
        alias_method :body, :body_to_ansi
      end

    end
  end
end
