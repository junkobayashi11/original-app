class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string   :room_name,     null: false
      t.integer  :prefecture_id, null: false
      t.string :municipalities,  null: false
      t.datetime :host_date,     null: false
      t.references :user,        null: false, foreign_key: true
      t.timestamps
    end
  end
end
