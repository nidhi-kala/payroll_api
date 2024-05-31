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
    timesheets = Timesheet.all
    report_data = {}

    timesheets.each do |timesheet|
      employee_id = timesheet.employee_id
      pay_period = get_pay_period(timesheet.date)
      amount_paid = timesheet.hours_worked * hourly_rate(timesheet.job_group)

      report_data[employee_id] ||= {}
      report_data[employee_id][pay_period] ||= 0
      report_data[employee_id][pay_period] += amount_paid

    end
    formatted_report_data = format_report_data(report_data)
    render json:{ payrollReport: { employeeReports: formatted_report_data } }
  end

  private

  def get_pay_period(date)
    date.day <= 15 ? {startDate: date.beginning_of_month, endDate: date.change(day: 15)}: {startDate: date.change(day: 16), endDate: date.end_of_month }
  end

  def hourly_rate(job_group)
    case job_group
      when 'A' then 20
      when 'B' then 30
      else 0
    end
  end

 def format_report_data(report_data)
    formatted_data = []

    report_data.each do |employee_id, periods|
      periods.each do |period, amount|
        formatted_data << {
          employeeId: employee_id.to_s,
          payPeriod: {
            startDate: period[:startDate].strftime('%Y-%m-%d'),
            endDate: period[:endDate].strftime('%Y-%m-%d')
          },
          amountPaid: "$%.2f" % amount
        }
      end
    end

    # Sorting by employeeId and payPeriod startDate
    formatted_data.sort_by { |data| [data[:employeeId].to_i, data[:payPeriod][:startDate]] }
  end
end
