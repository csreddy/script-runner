class ChangeCommandColumnTypeInScripts < ActiveRecord::Migration
  def up
     change_column :scripts, :command, :text
  end

  def down
  end
end
