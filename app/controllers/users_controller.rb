class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :book_event]
  before_action :find_user, only: [:available_events, :book_event]

  def create
    user = User.new(user_params)

    if user.valid?
      user.save

      render json: user
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.includes(:events).find(params[:id])

    render json: user.as_json(include: :events)
  end

  def available_events
    render json: AvailableEvents.for_user(@user)
  end

  def book_event
    event = Event.find(params[:event_id])

    @user.events << event

    render json: { message: 'Event booked successfully' }
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
