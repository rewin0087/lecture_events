class Event < ApplicationRecord
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user

  validates :start_datetime, :end_datetime, presence: true
  validates :start_datetime, uniqueness: { scope: :end_datetime }

  before_save :set_day_of_week

  private

  def set_day_of_week
    self.day_of_week = start_datetime.strftime('%u')
  end
end
