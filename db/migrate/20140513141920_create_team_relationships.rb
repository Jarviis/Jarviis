class CreateTeamRelationships < ActiveRecord::Migration
  def change
    create_table :team_relationships do |t|
      t.belongs_to :user, index: true
      t.belongs_to :team, index: true

      t.timestamps
    end
  end
end
