require "xccov-parse/version"
require "xccov-parse/parse"
require "open3"

class Xccov
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
