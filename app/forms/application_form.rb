# frozen_string_literal: true

class ApplicationForm
  include ActiveModel::Model

  def persisted?
    false
  end
end
