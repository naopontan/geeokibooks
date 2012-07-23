# -*- coding: utf-8 -*-
require 'test_helper'

class BookTest < ActiveSupport::TestCase
  test "rental?" do
    assert books(:tanoruby).rental?
  end

  test "on_rental_count" do
    assert_equal 1, books(:tanoruby).on_rental_count, '2冊中,1冊はレンタル中'
    assert books(:metapro).on_rental_count.zero?, '1度もレンタル実績なし'
  end

  test "left ok" do
    assert books(:tanoruby).left?, '2冊のうち、1冊はレンタル中なので、あと1冊はレンタル可'
  end

  test "left ng" do
    assert books(:metapro).left?
  end

end
