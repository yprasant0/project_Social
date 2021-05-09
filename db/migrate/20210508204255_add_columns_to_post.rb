class AddColumnsToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :state, :string
    add_column :posts, :visible, :boolean
    add_column :posts, :video, :string
    add_column :posts, :image, :string
  end
end
