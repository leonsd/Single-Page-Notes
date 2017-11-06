class CreateItems < ActiveRecord::Migration[5.1]
  def self.up
    create_table :items do |t|
      t.string :description
      t.boolean :done, default: false
      t.references :list, foreign_key: true

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
