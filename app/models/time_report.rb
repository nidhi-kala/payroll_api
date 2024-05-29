class TimeReport < ApplicationRecord
  validates :date, presence: true
  validates :hours_worked, presence: true, numericality: { greater_than 0 }
  validates :employee_id, presence: true, numericality: { only_integer: true }
  validates :job_group, presence: true, inclusion: { in: %w(A B) }
  validates report_id, presence: true, uniqueness: true
end
