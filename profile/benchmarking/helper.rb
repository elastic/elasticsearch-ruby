module Elasticsearch
  # Helper functions used by benchmarking tasks
  module Benchmarking

    extend self

    # Load a json file and represent each document as a Hash.
    #
    # @example Load a file.
    #   Benchmarking.load_file(file_name)
    #
    # @param [ String ] The file name.
    #
    # @return [ Array ] A list of json documents.
    #
    # @since 7.0.0
    def load_file(file_name)
      File.open(file_name, "r") do |f|
        f.each_line.collect do |line|
          parse_json(line)
        end
      end
    end

    # Get the median of values in a list.
    #
    # @example Get the median.
    #   Benchmarking.median(values)
    #
    # @param [ Array ] The values to get the median of.
    #
    # @return [ Numeric ] The median of the list.
    #
    # @since 7.0.0
    def median(values)
      values.sort![values.size / 2 - 1]
    end
  end
end
