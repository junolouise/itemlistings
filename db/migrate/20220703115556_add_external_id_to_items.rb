class AddExternalIdToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :external_id, :bigint, null: false
    add_index :items, :external_id
  end
end
