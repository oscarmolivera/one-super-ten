class AddPropertiesToCups < ActiveRecord::Migration[8.0]
  def change
    add_column :cups, :description, :string
    add_column :cups, :location, :string
  end
end
