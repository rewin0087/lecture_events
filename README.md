# Setup

- Install ruby 3.3.5
- Install bundler

Run:
```
bundle install
bundle exec rake db:setup
```

### Overview
Please solve the following problem in Ruby or a Ruby framework. You are welcome to solve the problem in any manner you see fit. This could be a service, an API, a singleton etc. Feel free to make assumptions about architecture and usage.

I have two lists of Calendar Events. An event has a start and end time. An event represents a weekly time slot such as a university lecture.

i) An event object or class:
```
Event{
  DateTime start;
  DateTime end;
}
```

ii) A list of Events I am booked into:
e.g. Event on Wednesday 4-5pm and one on Thursday 9-10am.
```
already_booked = [
   Event(start: 2018-12-19 16:00:00, end: 2018-12-19 17:00:00),
   Event(start: 2018-12-20 9:00:00, end: 2018-12-20 10:00:00)
]
```

iii) And a list of Events I can book:
e.g. Event on Wednesday 4-5pm, Thursday 9:30-11:30am and one on Friday 9-11am.
```
available = [
  Event(start: 2018-12-19 16:00:00, end: 2018-12-19 17:00:00),
  Event(start: 2018-12-20 9:30:00, end: 2018-12-20 11:30:00),
  Event(start: 2018-12-21 9:00:00, end: 2018-12-21 11:00:00)
]
```

Write a simple program that filters the events I can book. The result should only contain events that don't clash with events I am already booked into.

e.g. from the lists above I would expect the result to be a single event,
```
Event(start: 2018-12-21 9:00:00, end: 2018-12-21 11:00:00)
```

Please provide a way to verify your results.

#### IMPORTANT NOTES:

-   The list of events can be arbitrarily large, performance is a key concern.
-   An event can start and finish at any time during the day.
-   Week is insignificant, day and time is significant. Meaning that an event on Friday 21st
    Dec 1:00 – 1:30pm will clash with an event on Friday 28th Dec – 1:00-3:00pm, as they are
    on the same day of the week and overlap time despite being in separate weeks.
-   Please document any assumptions you make.

    Please solve the problem using the following data sets:

```
already_booked = [
  Event(start: 2018-12-19 16:00:00, end: 2018-12-19 17:00:00),
  Event(start: 2018-12-20 09:00:00, end: 2018-12-20 10:00:00),
  Event(start: 2018-12-21 13:00:00, end: 2018-12-21 13:30:00)
]
available = [
  Event(start: 2018-12-19 16:00:00, end: 2018-12-19 17:00:00),
  Event(start: 2018-12-20 09:30:00, end: 2018-12-20 11:30:00),
  Event(start: 2018-12-28 13:00:00, end: 2018-12-28 15:00:00),
  Event(start: 2018-12-29 13:00:00, end: 2018-12-29 14:00:00)
]
```

### Access api

##### Create user
```
Url: POST http://localhost:3000/users
Request params: { "user": { "email": "john.doe@test.com" } }
Response payload:
{
    "id": 1,
    "email": "john.doe@test.com",
    "created_at": "2024-12-02T03:35:51.056Z",
    "updated_at": "2024-12-02T03:35:51.056Z"
}
```

#####  User details with booked events
```
Url: GET http://localhost:3000/users/1.json
Response payload:
{
    "id": 1,
    "email": "john.doe@test.com",
    "created_at": "2024-12-02T02:31:22.046Z",
    "updated_at": "2024-12-02T02:31:22.046Z",
    "events": [
        {
            "id": 1,
            "start_datetime": "2018-12-19T16:00:00.000Z",
            "end_datetime": "2018-12-19T17:00:00.000Z",
            "day_of_week": 3,
            "created_at": "2024-12-02T02:31:22.058Z",
            "updated_at": "2024-12-02T02:31:22.058Z"
        },
        {
            "id": 2,
            "start_datetime": "2018-12-20T09:00:00.000Z",
            "end_datetime": "2018-12-20T10:00:00.000Z",
            "day_of_week": 4,
            "created_at": "2024-12-02T02:31:22.061Z",
            "updated_at": "2024-12-02T02:31:22.061Z"
        },
        {
            "id": 4,
            "start_datetime": "2018-12-21T13:00:00.000Z",
            "end_datetime": "2018-12-21T13:30:00.000Z",
            "day_of_week": 5,
            "created_at": "2024-12-02T02:31:22.067Z",
            "updated_at": "2024-12-02T02:31:22.067Z"
        }
    ]
}
```

#####  Available events for user
```
Url: GET http://localhost:3000/users/1/available_events.json
Response payload:
[
    {
        "id": 6,
        "start_datetime": "2018-12-29T13:00:00.000Z",
        "end_datetime": "2018-12-29T14:00:00.000Z",
        "day_of_week": 6,
        "created_at": "2024-12-02T02:31:22.072Z",
        "updated_at": "2024-12-02T02:31:22.072Z"
    }
]
```
#####  Book event
```
Url: PUT Url: http://localhost:3000/users/1/book_event.json
Request params: { "event_id": 3 }
Response payload:
{
    "message": "Event booked successfully"
}
```

### Run on console to fetch available events for user
```
> user = User.first
> AvailableEvents.for_user(user)
>  [#<Event:0x000000012c5f05a0 id: 6, start_datetime: Sat, 29 Dec 2018 13:00:00.000000000 UTC +00:00, end_datetime: Sat, 29 Dec 2018 14:00:00.000000000 UTC +00:00, day_of_week: 6, created_at: Mon, 02 Dec 2024 02:31:22.072358000 UTC +00:00, updated_at: Mon, 02 Dec 2024 02:31:22.072358000 UTC +00:00>]
```

### Run test
```
bundle exec rspec spec
```

### Future improvements
- Remove duplicate within range `start_datetime` and `end_datetime` values from booked events from user when query available events for user
- Authentication and Authorization on api
- Pagination on api