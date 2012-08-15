class Book < ActiveRecord::Base
  attr_accessible :isbn, :name, :price

  has_many :rentals
  has_many :users, :through => :rentals
  has_one :last_rental, :class_name => 'Rental', :order => 'created_at DESC'

  def rental?
    return false if last_rental.blank?
    last_rental.rental?
  end

  def on_rental_count
    rentals.borrowed.count
  end

  def left?
    (quantity - on_rental_count) > 0
  end

  def borrowed_users
    rentals.borrowed.map(&:user)
  end
end
