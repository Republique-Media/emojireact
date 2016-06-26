class CreateReactions < ActiveRecord::Migration[5.0]
  def change
    create_table :reactions do |t|
      t.references :page, foreign_key: true
      t.string :emoji
      t.string :ip_address
      t.text :referrer

      t.timestamps
    end
  end
end
