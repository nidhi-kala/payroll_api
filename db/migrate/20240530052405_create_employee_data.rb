class CreateEmployeeData < ActiveRecord::Migration[7.1]
  def change
    create_table :timesheets do |t|
      t.date :date
      t.decimal :hours_worked
      t.integer :employee_id
      t.string :job_group
      t.references :time_report, null: false, foreign_key: true

      t.timestamps
    end

    remove_columns :time_reports, :date, :hours_worked, :employee_id, :job_group
  end
end
