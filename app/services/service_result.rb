# frozen_string_literal: true

class ServiceResult
  attr_reader :object, :error

  def initialize(attrs = {})
    @object = attrs[:obect]
    @error = attrs[:error]
  end

  def success?
    !error.present?
  end

  def error?
    error.present?
  end
end
