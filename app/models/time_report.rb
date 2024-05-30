class TimeReport < ApplicationRecord
  validates :report_id, presence: true, uniqueness: true
end
