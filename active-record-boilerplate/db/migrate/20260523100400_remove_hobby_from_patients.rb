class RemoveHobbyFromPatients < ActiveRecord::Migration[8.1]
  def change
    remove_column :patients, :hobby, :string
  end
end
