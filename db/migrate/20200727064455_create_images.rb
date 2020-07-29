class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.references :content, null: false, foreign_key: true
      t.string :content_image, null: false
      t.timestamps
    end
  end
end
