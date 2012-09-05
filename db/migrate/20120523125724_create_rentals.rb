class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.integer :book_id, :null => false
      t.integer :user_id, :null => false
      t.string :state
      t.datetime :returned_at

      t.timestamps
    end
  end
end
