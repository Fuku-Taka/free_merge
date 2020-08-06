class CreateContents < ActiveRecord::Migration[6.0]
  def change
    create_table :contents do |t|
      t.references :seller, foreign_key: {to_table: :users}, null: false
      t.references :buyer, foreign_key: {to_table: :users}
      t.references :auction, foreign_key: {to_table: :users}
      t.string :name, null: false
      t.integer :price, null: false
      t.text :explain, null: false
      t.integer :status, null: false
      t.integer :size, null: false
      t.integer :prefecture, null: false
      t.integer :postage, null: false
      t.integer :shipment, null: false
      t.string :brand
      t.integer :category_id
      t.timestamps
    end
  end
end
