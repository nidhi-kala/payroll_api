class CreateTimeReports < ActiveRecord::Migration[7.1]
  def change
    create_table :time_reports do |t|
      t.date :date
      t.decimal :hours_worked
      t.integer :employee_id
      t.string :job_group
      t.integer :report_id

      t.timestamps
    end
  end
end
