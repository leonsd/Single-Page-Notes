class CreateLists < ActiveRecord::Migration[5.1]
  def self.up
    create_table :lists do |t|
      t.string :title
      t.string :color

      t.timestamps
    end
  end

  def self.down
    drop_table :lists
  end
end
