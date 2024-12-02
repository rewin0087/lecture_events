require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validation' do
    subject { create(:event) }

    it { should validate_presence_of(:start_datetime) }
    it { should validate_presence_of(:end_datetime) }
    it { should validate_uniqueness_of(:start_datetime).scoped_to(:end_datetime) }
  end
end
