# -*- coding: utf-8 -*-
require 'amazon/ecs'
class Book < ActiveRecord::Base
  attr_accessible :isbn, :quantity, :name, :price, :author, :publisher, :pub_date, :img_url, :amz_url

  has_many :rentals
  has_many :users, :through => :rentals
  has_one :last_rental, :class_name => 'Rental', :order => 'created_at DESC' #FIXME:バグ（スコープを限定すること）

  validates :isbn, :quantity, :name, :price, :author, :publisher, :pub_date, :img_url, :amz_url, :presence => true

  def self.fetch_amz_info(isbn)
    item_hash = {}
    Amazon::Ecs.options = {
      :associate_tag => ENV['AMZ_ASSOC_TAG'],
      :AWS_access_key_id => ENV['AMZ_ACCESS_KEY'],
      :AWS_secret_key => ENV['AMZ_SECET_KEY']
      }

    res = Amazon::Ecs.item_search(
      isbn, {
        :country => 'jp',
        :search_index => 'Books',
        :response_group => 'Medium'
      }
    )

    raise "ISBNで複数結果が返ってきちゃった" if res.items.size >= 2

    if res.items.empty?
      return {}
    end

    Book.new(
      :name => res.items.first.get('ItemAttributes/Title'),
      :price => res.items.first.get('ItemAttributes/ListPrice/FormattedPrice'),
      :author => res.items.first.get('ItemAttributes/Author'),
      :publisher => res.items.first.get('ItemAttributes/Publisher'),
      :pub_date => res.items.first.get('ItemAttributes/PublicationDate'),
      :img_url => res.items.first.get('MediumImage/URL'),
      :amz_url => res.items.first.get('DetailPageURL'),
      :isbn => isbn
    )
  end

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
