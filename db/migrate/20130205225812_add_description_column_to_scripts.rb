class AddDescriptionColumnToScripts < ActiveRecord::Migration
  def change
    add_column :scripts, :description, :text
  end
end
