# -*- coding: utf-8 -*-
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should book rental" do
    assert users(:dummy1).borrow(books(:tanoruby))
  end

  test "should not book rental" do
    assert users(:dummy1).borrow(books(:tanoruby)), '最後の1冊をレンタル'
    assert_nil users(:dummy2).borrow(books(:tanoruby)), '全てレンタル中なのでレンタルできない'
  end
end
