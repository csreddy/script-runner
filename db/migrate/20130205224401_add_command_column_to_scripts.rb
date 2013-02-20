class AddCommandColumnToScripts < ActiveRecord::Migration
  def change
	add_column :scripts, :command, :string
  end
end
