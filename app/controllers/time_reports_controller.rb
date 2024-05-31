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
    report = TimeReport.new(report_id: id)
    
    if report.save
    # todo: check if report id already exists here and return error
    CSV.foreach file.tempfile, headers: true do |row|
      Timesheet.create!(
        time_report: report,
        date: row["date"], 
        hours_worked: row["hours worked"],
        employee_id: row["employee id"],
        job_group: row["job group"]
       )
    end
    else
      render json: { error: report.errors.full_messages.to_sentence}, status: :unprocessable_entity
    end
  end

  def payroll_report
    reports = Timesheet.all
    render json:{message: "this is the payroll rpeort",
  report: reports}
  end

  private

  def get_pay_period(date)
    date <= 15 ? {startDate: date.beginning_of_month, endDate: date.change(day: 15)}: {startDate = date.change(day: 16), endDate = date.end_of_month }
  end

  def hourly_rate(job_group)
    case job_group
      when 'A' then 20
      when 'B' then 30
      else 0
    end
  end
end
