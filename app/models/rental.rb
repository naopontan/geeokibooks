# -*- coding: utf-8 -*-
class Rental < ActiveRecord::Base
  # TODO: rentaled_at は不要で created_at で代用できるかも
  attr_accessible :book_id, :state, :user_id, :returned_at

  belongs_to :user
  belongs_to :book

  default_scope :order => "created_at DESC"

  scope :borrowed, where('returned_at IS NULL')

  before_save do |record|
    record.rentaled_at = Time.now if record.new_record?
  end

  def returned!
    raise "レンタル中じゃない!" if self.rentaled_at.blank?
    update_attributes! :returned_at => Time.now
    freeze
  end

  def rental?
    !!self.rentaled_at
  end

end
