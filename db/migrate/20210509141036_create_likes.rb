class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.string :likable_type
      t.integer :likable_id
      t.boolean :value
    end
  end
end
