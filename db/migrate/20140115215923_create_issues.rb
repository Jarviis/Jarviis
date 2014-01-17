class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :state
      t.string :name
      t.string :description
      t.integer :assignee_id
      t.integer :reporter_id
      t.datetime :due_date
      t.integer :parent_id

      t.timestamps
    end

    add_index :issues, :parent_id
    add_index :issues, :assignee_id
    add_index :issues, :reporter_id
  end
end
