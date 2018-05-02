# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def paginate(relation:)
    per_page = params[:per_page]&.to_i || Defaults::PER_PAGE
    page     = params[:page]&.to_i || Defaults::PAGE

    limit  = per_page
    offset = (page - 1) * limit

    relation.limit(limit).offset offset
  end

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
