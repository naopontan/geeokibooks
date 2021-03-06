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

  def borrow(b)
    rentals.create!(:book_id => b.id) if b.left?
  end

  def give_back(b)
    rentals.borrowed.each do |rental| #まずborrowedでスコープする
      if rental.book == b #オブジェクトで比較したほうがわかりやすい。 book.idよりも。
        rental.update_attribute(:returned_at, Time.now) #saveはコミ
        return rental #ひとつtrueになるとeachを抜ける。ことによって一冊にたいしてだけの処理とする。
      end
    end
    nil #失敗したときのためにnilを明示。
  end

  def borrowed_rental(b)
    rental_borrowed = rentals.borrowed.select{|x| x.book == b}
    if rental_borrowed.empty?
      nil
    else
      rental_borrowed.first
    end
  end

end
