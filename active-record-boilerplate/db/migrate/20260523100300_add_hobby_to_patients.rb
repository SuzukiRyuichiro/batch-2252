class AddHobbyToPatients < ActiveRecord::Migration[8.1]
  def change
    add_column :patients, :hobby, :string
  end
end
