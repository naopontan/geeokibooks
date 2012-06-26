class Book < ActiveRecord::Base
  attr_accessible :isbn, :name, :price

  has_many :rentals
  has_many :users, :through => :rentals
end
