class TimeReportsController < ApplicationController

  def upload
    file = params[:file]
    
    if file.blank?
      render json: { error: 'No file uploaded'}, status: :bad_request
      return
    end

    filename = file.original_filename
    id = filename.match(/-(\d+)\./).captures.first.to_i
  end
end
