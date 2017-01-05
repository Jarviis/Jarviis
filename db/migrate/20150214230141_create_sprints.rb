class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.string :name, null: false
      t.belongs_to :team, index: true
      t.float :percentage, default: 0.0
      t.datetime :starttime
      t.datetime :endtime

      t.timestamps
    end
  end
end
