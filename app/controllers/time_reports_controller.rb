require 'csv'

class TimeReportsController < ApplicationController

  def upload
    file = params[:file]
    
    if file.blank?
      render json: { error: 'No file uploaded'}, status: :bad_request
      return
    end

    filename = file.original_filename
    id = filename.match(/-(\d+)\./).captures.first.to_i

    # todo: check if report id already exists here and return error

    CSV.foreach file.tempfile, headers: true do |row|
      TimeReport.create!(
        report_id: id,
        date: row["date"], 
        hours_worked: row["hours worked"],
        employee_id: row["employee id"],
        job_group: row["job group"]
       )
    end
  end
end
