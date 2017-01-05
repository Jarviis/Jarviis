class AddTeamIdToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :team_id, :integer
    add_index :issues, :team_id
  end
end
