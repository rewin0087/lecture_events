# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AvailableEvents do
  let!(:user) { create(:user) }

  subject { described_class.for_user(user) }

  describe '#for_user' do
    shared_examples_for 'return available events' do
      it 'return results' do
        result = subject

        expect(result.ids).to match_array(expected_ids)
        expect(result.count).to eq(expected_count)
      end
    end

    context 'case 1' do
      let!(:event_1) { create(:event, start_datetime: '2018-12-19 16:00:00', end_datetime: '2018-12-19 17:00:00') }
      let!(:event_2) { create(:event, start_datetime: '2018-12-20 09:00:00', end_datetime: '2018-12-20 10:00:00') }
      let!(:event_3) { create(:event, start_datetime: '2018-12-20 09:30:00', end_datetime: '2018-12-20 11:30:00') }
      let!(:event_4) { create(:event, start_datetime: '2018-12-21 13:00:00', end_datetime: '2018-12-21 13:30:00') }
      let!(:event_5) { create(:event, start_datetime: '2018-12-28 13:00:00', end_datetime: '2018-12-28 15:00:00') }
      let!(:event_6) { create(:event, start_datetime: '2018-12-29 13:00:00', end_datetime: '2018-12-29 14:00:00') }

      context 'when there are no booked events' do
        let(:expected_ids) { [event_1.id, event_2.id, event_3.id, event_4.id, event_5.id, event_6.id] }
        let(:expected_count) { 6 }

        it_behaves_like 'return available events'
      end

      context 'when there are 3 booked events' do
        let(:expected_ids) { [event_6.id] }
        let(:expected_count) { 1 }

        before do
          user.event_ids = [event_1.id, event_2.id, event_4.id]
          user.save
          user.reload
        end

        it_behaves_like 'return available events'
      end
    end

    context 'case 2' do
      let!(:event_1) { create(:event, start_datetime: '2018-12-19 16:00:00', end_datetime: '2018-12-19 17:00:00') }
      let!(:event_2) { create(:event, start_datetime: '2018-12-20 09:00:00', end_datetime: '2018-12-20 10:00:00') }
      let!(:event_3) { create(:event, start_datetime: '2018-12-20 09:30:00', end_datetime: '2018-12-20 11:30:00') }
      let!(:event_4) { create(:event, start_datetime: '2018-12-21 09:00:00', end_datetime: '2018-12-21 11:00:00') }

      context 'when there are no booked events' do
        let(:expected_ids) { [event_1.id, event_2.id, event_3.id, event_4.id] }
        let(:expected_count) { 4 }

        it_behaves_like 'return available events'
      end

      context 'when there are 3 booked events' do
        let(:expected_ids) { [event_4.id] }
        let(:expected_count) { 1 }

        before do
          user.event_ids = [event_1.id, event_2.id]
          user.save
          user.reload
        end

        it_behaves_like 'return available events'
      end
    end
  end
end
