class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def record_not_found
    { errors: ['Record not found'] }
  end

  def record_invalid
    { errors: ['Record is invalid'] }
  end
end
