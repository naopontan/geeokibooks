# -*- coding: utf-8 -*-
require 'amazon/ecs'
class Book < ActiveRecord::Base
  attr_accessible :isbn, :quantity, :name, :price, :author, :publisher, :pub_date, :img_url, :amz_url

  has_many :rentals
  has_many :users, :through => :rentals
  has_one :last_rental, :class_name => 'Rental', :order => 'created_at DESC' #FIXME:バグ（スコープを限定すること）

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

    res.is_valid_request?
    p res.has_error?
    p res.error

    res.items.each do |item|
      item_hash = {
        "tile" => item.get('ItemAttributes/Title'),
        "author" => item.get('ItemAttributes/Author'),
        "price" => item.get('ItemAttributes/ListPrice/FormattedPrice'),
        "publisher" => item.get('ItemAttributes/Publisher'),
        "pub_date" => item.get('ItemAttributes/PublicationDate'),
        "img_url" => item.get('MediumImage/URL'),
        "amz_url" => item.get('DetailPageURL')
      }
    end
    item_hash
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
