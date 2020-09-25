class AddAdminReports < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_reports do |t|
      t.references :author
      t.foreign_key :users, column: :author_id, primary_key: 'id'

      t.string :entity, null: false
      t.string :format, null: false, default: :csv
      t.integer :status, null: false
      t.string :location_url

      t.timestamps
    end
  end
end
