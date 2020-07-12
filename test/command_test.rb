# frozen_string_literal: true

require 'minitest/unit'
require 'minitest/autorun'
require './lib/command'

class TestCommand < MiniTest::Unit::TestCase
  def test_choice
    assert_includes(%w[a b c], choice(%w[a b c]))
    assert_includes(%w[あ い う え お], choice(['あ　い　う　え　お']))
  end
end
