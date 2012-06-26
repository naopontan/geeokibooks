require 'test_helper'

class BookTest < ActiveSupport::TestCase
  test "rental?" do
    assert books(:tanoruby).rental?
  end
end
