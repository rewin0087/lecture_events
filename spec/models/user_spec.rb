require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'association' do
    subject { build(:user) }

    it { should have_many(:user_events).dependent(:destroy) }
    it { should have_many(:events).through(:user_events) }
  end

  describe 'validation' do
    subject { create(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end
end
