class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :postal_code, null: false
      t.integer :prefecture, null: false
      t.string :city, null: false
      t.string :address, null: false
      t.string :apartment
      t.timestamps
    end
  end
end