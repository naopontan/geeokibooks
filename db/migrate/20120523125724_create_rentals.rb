class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.integer :book_id, :null => false
      t.integer :user_id, :null => false
      t.string :state

      t.timestamps
    end
  end
end
