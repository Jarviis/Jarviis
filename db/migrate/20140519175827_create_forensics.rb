class CreateForensics < ActiveRecord::Migration
  def change
    create_table :forensics do |t|
      t.belongs_to :user
      t.integer :action
      t.string :description, limit: 1024

      t.timestamps
    end
  end
end
