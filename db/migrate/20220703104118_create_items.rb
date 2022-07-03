class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :title
      t.string :thumbnail_url
      t.float :distance
      t.integer :views
      t.integer :likes

      t.timestamps
    end
  end
end
