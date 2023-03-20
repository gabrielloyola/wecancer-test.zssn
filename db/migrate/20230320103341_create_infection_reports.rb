class CreateInfectionReports < ActiveRecord::Migration[6.1]
  def change
    create_table :infection_reports do |t|
      t.references :reporter, null: false, foreign_key: { to_table: :survivors }
      t.references :infected, null: false, foreign_key: { to_table: :survivors }

      t.timestamps
    end

    add_index :infection_reports, [:reporter_id, :infected_id]
  end
end
