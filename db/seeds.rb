# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.find_or_create_by!(email: 'erwin@gmail.com')

[
  { start_datetime: '2018-12-19 16:00:00', end_datetime: '2018-12-19 17:00:00' },
  { start_datetime: '2018-12-20 09:00:00', end_datetime: '2018-12-20 10:00:00' },
  { start_datetime: '2018-12-20 09:30:00', end_datetime: '2018-12-20 11:30:00' },
  { start_datetime: '2018-12-21 13:00:00', end_datetime: '2018-12-21 13:30:00' },
  { start_datetime: '2018-12-28 13:00:00', end_datetime: '2018-12-28 15:00:00' },
  { start_datetime: '2018-12-29 13:00:00', end_datetime: '2018-12-29 14:00:00' }
].each do |event_data|
  Event.create!(event_data)
end

[
  {
    start_datetime: '2018-12-19 16:00:00',
    end_datetime: '2018-12-19 17:00:00'
  },
  {
    start_datetime: '2018-12-20 9:00:00',
    end_datetime: '2018-12-20 10:00:00'
  },
  {
    start_datetime: '2018-12-21 13:00:00',
    end_datetime: '2018-12-21 13:30:00)'
  }
].each do |booked_event|
  user.user_events.create!(event: Event.find_by!(start_datetime: booked_event[:start_datetime], end_datetime: booked_event[:end_datetime]))
end
