require "xccov/parse/version"
require "json"

module Xccov
  class Parse
    attr_reader :data

    def initialize(file: nil, json: nil)
      @data = JSON.parse(json) if json
      @data = JSON.parse(File.read(file)) if file
    end

    def targets_name
      @data.map { |data| data["name"] }
    end

    def targets_line_coverage
      @data.reduce({}) do |memo, data|
        memo.merge({ data["name"] => data["lineCoverage"] })
      end
    end
  end
end
