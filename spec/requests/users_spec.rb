require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /create' do
    subject { post '/users', params: params }

    context 'with valid params' do
      let(:params) do
        { user: { email: 'test@test.com' } }
      end

      it 'return success' do
        expect { subject }.to change { User.count }.by(1)

        expect(response).to have_http_status(:success)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).not_to be_nil
        expect(parsed_response['email']).to eq('test@test.com')
      end
    end

    context 'with invalid params' do
      let(:params) do
        { user: { email: nil } }
      end

      it 'return errors' do
        expect { subject }.not_to change { User.count }

        expect(response).to have_http_status(:unprocessable_entity)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']).to eq(["Email can't be blank"])
      end
    end
  end

  describe 'GET users/1' do
    let!(:user) { create(:user) }
    let!(:event_1) { create(:event, start_datetime: '2018-12-19 16:00:00', end_datetime: '2018-12-19 17:00:00') }
    let!(:event_2) { create(:event, start_datetime: '2018-12-20 09:00:00', end_datetime: '2018-12-20 10:00:00') }

    subject { get "/users/#{user.id}" }

    before do
      user.event_ids = [event_1.id, event_2.id]
      user.save
    end

    it 'return success' do
      subject
      expect(response).to have_http_status(:success)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eq(user.id)
      expect(parsed_response['email']).to eq(user.email)
      expect(parsed_response['events'].count).to eq(2)
      expect(parsed_response['events'].map { |e| e['id'] }).to match_array([event_1.id, event_2.id])
    end
  end

  describe 'GET users/1/available_events' do
    let!(:user) { create(:user) }
    let!(:event_1) { create(:event, start_datetime: '2018-12-19 16:00:00', end_datetime: '2018-12-19 17:00:00') }
    let!(:event_2) { create(:event, start_datetime: '2018-12-20 09:00:00', end_datetime: '2018-12-20 10:00:00') }
    let!(:event_3) { create(:event, start_datetime: '2018-12-20 09:30:00', end_datetime: '2018-12-20 11:30:00') }
    let!(:event_4) { create(:event, start_datetime: '2018-12-21 09:00:00', end_datetime: '2018-12-21 11:30:00') }

    subject { get "/users/#{user.id}/available_events" }

    context 'when there are no booked events' do
      it 'return success' do
        subject
        expect(response).to have_http_status(:success)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response.count).to eq(4)
        expect(parsed_response.map { |e| e['id'] }).to match_array([event_1.id, event_2.id, event_3.id, event_4.id])
      end
    end

    context 'when there are 3 booked events' do
      before do
        user.event_ids = [event_1.id, event_2.id]
        user.save
      end

      it 'return success' do
        subject
        expect(response).to have_http_status(:success)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response.count).to eq(1)
        expect(parsed_response.map { |e| e['id'] }).to match_array([event_4.id])
      end
    end
  end

  describe 'PUT users/1/book_event' do
    let!(:user) { create(:user) }
    let!(:event_1) { create(:event, start_datetime: '2018-12-19 16:00:00', end_datetime: '2018-12-19 17:00:00') }

    subject { put "/users/#{user.id}/book_event", params: { event_id: event_1.id } }

    it 'return success' do
        expect { subject }.to change { user.events.count }.by(1)
        expect(response).to have_http_status(:success)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('Event booked successfully')
      end
  end
end
