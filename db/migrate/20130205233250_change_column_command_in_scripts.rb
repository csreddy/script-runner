class ChangeColumnCommandInScripts < ActiveRecord::Migration
  def up
 change_table :scripts do |t|
      t.change :command, :text
    end
  end

  def down
 change_table :scripts do |t|
      t.change :command, :string
    end
  end
end
