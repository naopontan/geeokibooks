# -*- coding: utf-8 -*-
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should book rental" do
    assert users(:dummy1).book_rental(books(:tanoruby))
  end

  test "should not book rental" do
    assert users(:dummy1).book_rental(books(:tanoruby)), '最後の1冊をレンタル'
    assert_nil users(:dummy2).book_rental(books(:tanoruby)), '全てレンタル中なのでレンタルできない'
  end
end
