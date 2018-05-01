# frozen_string_literal: true

RSpec.shared_examples 'application_form' do
  describe '#persisted?' do
    it 'is never persisted' do
      form = described_class.new

      expect(form).not_to be_persisted
    end
  end
end

