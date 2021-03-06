require 'test_helper'

class Xccov::ParseTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Xccov::VERSION
  end

  def test_parse_only_targets
    data = Xccov::Parse.new(file: './test/data/only_targets.json').data
    assert_equal 6, data.size
  end

  def test_parse_only_targets_names
    parsed = Xccov::Parse.new(file: './test/data/only_targets.json')

    expected = [
      "test.examplesEarlGreyTests.xctest",
      "nanopb.framework",
      "GoogleToolboxForMac.framework",
      "test.examplesUITests.xctest",
      "test.examples.app",
      "test.examplesTests.xctest"
    ]
    assert_equal expected, parsed.targets_name
  end

  def test_parse_only_targets_line_coverage
    parsed = Xccov::Parse.new(file: './test/data/only_targets.json')

    expected = {
      "test.examplesEarlGreyTests.xctest" => 0.43243243243243246,
      "nanopb.framework" => 0,
      "GoogleToolboxForMac.framework" => 0,
      "test.examplesUITests.xctest" => 1,
      "test.examples.app" => 0.35,
      "test.examplesTests.xctest" => 1
    }

    assert_equal expected, parsed.targets_line_coverage
    assert_equal 0.35, parsed.targets_line_coverage["test.examples.app"]
  end

  def test_help
    xccov = Xccov.new
    expected =<<-E
xccov help [view]

xccov view [--file-list | --file <path>] archive.xccovarchive

xccov view [--only-targets | --files-for-target <target name> | --functions-for-file <name or path>] [--json] report.xccovreport

xccov is a command line utility that can generate Xcode coverage data. For detailed information regarding a particular command, try help <command>.
    E

    assert_equal expected, xccov.help
  end
end
