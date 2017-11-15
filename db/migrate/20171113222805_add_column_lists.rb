class AddColumnLists < ActiveRecord::Migration[5.1]
  def self.up
    add_column :lists, :status, :boolean, default: true
    add_reference :lists, :user, index: true
  end

  def self.down
    remove_column :lists, :status
    remove_reference :lists, :user
  end
end
