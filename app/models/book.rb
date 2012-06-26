class Book < ActiveRecord::Base
  attr_accessible :isbn, :name, :price

  has_many :rentals
  has_many :users, :through => :rentals
  has_one :last_rental, :class_name => 'Rental', :order => 'created_at DESC'

  def rental?
    return false if last_rental.blank?
    last_rental.rental?
  end

  # TODO: 「借りる」と「返す」のメソッド作る?メソッド名は?
end
