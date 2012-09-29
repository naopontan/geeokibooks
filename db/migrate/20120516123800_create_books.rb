class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name
      t.integer :price
      t.string :isbn
      t.integer :quantity, :null => false, :default => 1
      
      t.string :author
      t.string :publisher
      t.date :pub_date
      t.string :img_url
      t.string :amz_url

      t.timestamps
    end
  end
end
