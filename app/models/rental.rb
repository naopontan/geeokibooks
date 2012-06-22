class Rental < ActiveRecord::Base
  attr_accessible :book_id, :state, :user_id

  belongs_to :user
  belongs_to :book

  default_scope :order => "created_at DESC"
end
