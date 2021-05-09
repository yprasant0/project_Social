class AddColumnToAttachment < ActiveRecord::Migration[6.0]
  def change
    create_table :attachments do |t|
      t.string :attachable_type
      t.integer :attachable_id
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.string :file_url
      t.index [:attachable_type, :attachable_id]
    end
  end
end
