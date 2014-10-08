require 'test_helper'

#
# Tests for pry-byebug breakpoints.
#
class BreakpointsTestGeneral < MiniTest::Spec
  def test_add_file_raises_argument_error
    Pry.stubs eval_path: 'something'
    File.stubs :exist?
    assert_raises(ArgumentError) do
      PryByebug::Breakpoints.add_file('file', 1)
    end
  end

  #
  # Minimal dummy example class.
  #
  class Tester
    def self.class_method; end
    def instance_method; end
  end

  def test_add_method_adds_instance_method_breakpoint
    Pry.stub :processor, PryByebug::Processor.new do
      PryByebug::Breakpoints.add_method 'BreakpointsTest::Tester#instance_method'
      bp = Byebug.breakpoints.last
      assert_equal 'BreakpointsTest::Tester', bp.source
      assert_equal 'instance_method', bp.pos
    end
  end

  def test_add_method_adds_class_method_breakpoint
    Pry.stub :processor, PryByebug::Processor.new do
      PryByebug::Breakpoints.add_method 'BreakpointsTest::Tester.class_method'
      bp = Byebug.breakpoints.last
      assert_equal 'BreakpointsTest::Tester', bp.source
      assert_equal 'class_method', bp.pos
    end
  end
end

#
# Some common specs for breakpoints
#
module BreakpointSpecs
  def test_shows_breakpoint_enabled
    @output.string.must_match @regexp
  end

  def test_shows_breakpoint_hit
    match = @output.string.match(@regexp)
    @output.string.must_match(/^Breakpoint #{match[:id]}\. First hit/)
  end

  def test_shows_breakpoint_line
    @output.string.must_match(/\=> \s*#{@line}:/)
  end
end

#
# Tests for breakpoint commands
#
class BreakpointsTestCommands < Minitest::Spec
  let(:break_first_file) { test_file('break1') }
  let(:break_second_file) { test_file('break2') }

  before do
    Pry.color, Pry.pager, Pry.hooks = false, false, Pry::DEFAULT_HOOKS
    @output = StringIO.new
  end

  describe 'Set Breakpoints' do
    before do
      @input = InputTester.new 'break --delete-all'
      redirect_pry_io(@input, @output) { load break_first_file }
    end

    describe 'set by line number' do
      before do
        @input = InputTester.new('break 7')
        redirect_pry_io(@input, @output) { load break_first_file }
        @line = 7
        @regexp = /^Breakpoint (?<id>\d+): #{break_first_file} @ 7 \(Enabled\)/
      end

      include BreakpointSpecs
    end

    describe 'set by method_id' do
      before do
        @input = InputTester.new('break Break1Example#a')
        redirect_pry_io(@input, @output) { load break_first_file }
        @line = 7
        @regexp = /Breakpoint (?<id>\d+): Break1Example#a \(Enabled\)/
      end

      include BreakpointSpecs
    end

    describe 'set by method_id when its a bang method' do
      before do
        @input = InputTester.new('break Break1Example#c!')
        redirect_pry_io(@input, @output) { load break_first_file }
        @line = 17
        @regexp = /Breakpoint (?<id>\d+): Break1Example#c! \(Enabled\)/
      end

      include BreakpointSpecs
    end

    describe 'set by method_id within context' do
      before do
        @input = InputTester.new('break #b')
        redirect_pry_io(@input, @output) { load break_second_file }
        @line = 11
        @regexp = /Breakpoint (?<id>\d+): Break2Example#b \(Enabled\)/
      end

      include BreakpointSpecs
    end
  end

  describe 'List breakpoints' do
    before do
      @input = InputTester.new('break --delete-all', 'break #b', 'breakpoints')
      redirect_pry_io(@input, @output) { load break_second_file }
    end

    it 'shows all breakpoints' do
      @output.string.must_match(/Yes \s*Break2Example#b/)
    end
  end
end
