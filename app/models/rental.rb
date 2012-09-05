# -*- coding: utf-8 -*-
class Rental < ActiveRecord::Base
  attr_accessible :book_id, :state, :user_id, :returned_at

  belongs_to :user
  belongs_to :book

  default_scope :order => "created_at DESC"

  scope :borrowed, where('returned_at IS NULL')

  def returned!
    raise "レンタル中じゃない!" if self.created_at.blank?
    update_attributes! :returned_at => Time.now
    freeze
  end

  def rental?
    !!self.created_at
  end

end
