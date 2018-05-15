require "xccov/parse/version"
require "json"

require 'open3'

class Xccov
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

  # @example
  #
  #     xccov = Xccov.new
  #     xccov.help
  #     json = xccov.view '--only-targets', '--json', '/path/to/Build/Logs/Test/*.xccovreport'
  #     parsed = Xccov::Parse.new(json: json)
  #     parsed.targets_line_coverage["test.examples.app"] #=> 0.35
  #
  def initialize
    @xccov = "#{get_xcrun} xccov"
  end

  private

  def run(*args)
    cmd = args.join ' '
    sto, ste, status = Open3.capture3(cmd)
    if status.success?
      sto
    else
      puts ste
      raise(sto)
    end
  end

  def method_missing(method, *args, &_block)
    if respond_to_missing?
      run(@xccov, method, args)
    else
      super
    end
  end

  def respond_to_missing?
    true
  end

  def get_xcrun
    cmd = `which xcrun`.strip
    return cmd unless cmd.empty?
    raise "You should install xcrun"
  end
end
