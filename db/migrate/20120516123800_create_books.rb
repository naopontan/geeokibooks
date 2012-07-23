class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name
      t.integer :price
      t.string :isbn
      t.integer :quantity, :null => false, :default => 1

      t.timestamps
    end
  end
end
