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
  	count = 0
  	rentals.each do |x|
  		count += 1 if x.returned_at != nil
  	end
  	count
  end

  def left?
  	if (quantity - on_rental_count) > 0
  		return true
  	else
  		return false
  	end
  end

  # TODO: 「借りる」と「返す」のメソッド作る?メソッド名は?
  def borrow
 
  end

  def put_back
  	
  end
end
