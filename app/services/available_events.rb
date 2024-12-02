class AvailableEvents
  def self.for_user(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    not_booked_events
  end

  private

  attr_reader :user

  def not_booked_events
    where_clause = <<-SQL
      (start_datetime::time >= :start AND start_datetime::time <= :end AND day_of_week = :day_of_week)
      OR
      (end_datetime::time >= :start AND end_datetime::time <= :end  AND day_of_week = :day_of_week)
    SQL

    booked_dates.reduce(Event.all) do |acc, (start, _end, day_of_week)|
      acc.where.not(where_clause, start: start, end: _end, day_of_week: day_of_week)
    end
  end

  def time_only(datetime)
    datetime.strftime('%H:%M:%S')
  end

  def booked_dates
    user.events.map { |e| [time_only(e.start_datetime), time_only(e.end_datetime), e.day_of_week] }
  end
end
