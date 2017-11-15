class CreateCollaborators < ActiveRecord::Migration[5.1]
  def self.up
    create_table :collaborators do |t|
      t.references :list, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :accept

      t.timestamps
    end
  end

  def self.down
    drop_table :collaborators
  end
end
