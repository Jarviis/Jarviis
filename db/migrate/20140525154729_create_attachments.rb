class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.belongs_to :issue, index: true
      t.string :filename

      t.timestamps
    end
  end
end
