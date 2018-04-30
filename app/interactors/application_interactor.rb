# frozen_string_literal: true

class ApplicationInteractor
  include Interactor

  Error = Struct.new(:details)

  def stop(errors, status)
    context.fail! errors: errors, status: status
  end
end
