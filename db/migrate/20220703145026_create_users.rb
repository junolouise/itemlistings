class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :display_picture
      t.string :name
      t.integer :rating
      t.bigint :external_id, null: false

      t.timestamps
    end
  end
end
