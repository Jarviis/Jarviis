class AddSlugToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :slug, :string, null: false
    add_index :teams, :slug
  end
end
