class User < ActiveRecord::Base
  attr_accessible :name, :provider, :screen_name, :uid
  has_many :rentals
  has_many :books, :through => :rentals

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.screen_name = auth["info"]["nickname"]
    end
  end
end
