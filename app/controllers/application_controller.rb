# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def respond_with(interactor:)
    if interactor.success?
      success_response interactor
    else
      error_response interactor
    end
  end

  def success_response(interactor)
    if interactor.result
      render json: interactor.result, status: interactor.status
    else
      head interactor.status
    end
  end

  def error_response(interactor)
    if interactor.errors
      errors_json = { errors: interactor.errors.details }
      render json: errors_json, status: interactor.status
    else
      head interactor.status
    end
  end
end
