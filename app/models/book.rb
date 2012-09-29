class Book < ActiveRecord::Base
  attr_accessible :isbn, :quantity, :name, :price, :author, :publisher, :pub_date, :img_url, :amz_url

  has_many :rentals
  has_many :users, :through => :rentals
  has_one :last_rental, :class_name => 'Rental', :order => 'created_at DESC' #FIXME:バグ（スコープを限定すること）

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

  def borrowed?(u)
    borrowed_users.include?(u)
  end

end
