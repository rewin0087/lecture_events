require 'rails_helper'

RSpec.describe UserEvent, type: :model do
  describe 'association' do
    subject { build(:user_event) }

    it { should belong_to(:user) }
    it { should belong_to(:event) }
  end
end
