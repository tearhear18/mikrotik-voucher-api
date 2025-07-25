class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_default_response_format

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from VoucherService::StationNotFoundError, with: :not_found
  rescue_from VoucherService::InvalidVoucherError, with: :unprocessable_entity

  private

  def set_default_response_format
    request.format = :json
  end

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def render_success(data, status: :ok)
    render json: { success: true, data: data }, status: status
  end

  def render_error(message, status: :bad_request)
    render json: { success: false, error: message }, status: status
  end
end