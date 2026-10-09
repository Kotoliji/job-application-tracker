# Job Application Tracker

A Rails app for tracking job search activity — companies, freelance clients,
opportunities found, and every channel used to apply (email, a job board,
LinkedIn, a personal contact) with its own history and follow-up schedule.

Built to mirror how a real job search actually works, not a generic CRUD demo:

- **A posting being live, expired or closed is a different thing from how your
  own application on it is going.** An expired listing doesn't mean you were
  rejected; a live one doesn't mean anyone is reviewing you. The app tracks
  these as two independent statuses instead of collapsing them into one.
- **One opportunity can have several channels.** You might apply through a
  company's website *and* email a recruiter *and* get introduced by a contact
  — each with its own timeline, but all pointing at the same opportunity.
- **Sending is always a human action.** This app prepares and tracks
  applications; it never sends anything on your behalf. No automated outreach,
  no scraping — just a record of what you actually did.

## Features

- Organizations split into **companies** and **freelance clients**, each with
  their own opportunities
- Opportunities carry requirements, a priority, a deadline, and a posting
  status independent from how the application is going
- Channels (website / email / LinkedIn / personal contact) each track their
  own outcome: draft → sent → viewed → responded → interview → rejected/offer
- A timestamped event history per channel — every status change is a record,
  not just a label
- CV/cover-letter files attachable per channel (Active Storage)
- Automatic follow-up reminders: if a sent application has had no response
  after 6 days, a background job emails a reminder and logs that a follow-up
  was sent — it never emails the employer itself
- A dashboard with live counts, an outcome board, and the companies/freelance
  split

## Stack

- **Rails 7.1** with Hotwire (Turbo + Stimulus), server-rendered views
- **PostgreSQL**
- **Devise** for authentication
- **Sidekiq + Redis** for the follow-up reminder job
- **RSpec, FactoryBot, Shoulda Matchers, Capybara** for tests
- **RuboCop** (rails + rspec cops) for style
- **Docker Compose** for local development; separate `Dockerfile` for a
  production build
- **GitHub Actions** CI running RuboCop and the full test suite

## Architecture

```
Organization (company | freelance_client)
  └─ Opportunity (posting_status: unknown/live/expired/closed — independent axis)
       └─ Channel (outcome_status: draft/sent/viewed/responded/interview/rejected/offer)
            └─ SubmissionEvent (append-only history: what happened, when)
```

- `RecordChannelEvent` (`app/services`) is the single place that writes a
  `SubmissionEvent` and keeps `Channel#outcome_status` / `#follow_up_at` in
  sync with it — a controller action never updates channel status directly.
- `FollowUpReminderJob` checks for channels past their follow-up date,
  emails a reminder, and reschedules itself for the next day — no cron gem
  required.

## Getting started

Requires Docker and Docker Compose.

```bash
docker compose build
docker compose run --rm web bin/rails db:prepare
docker compose run --rm web bin/rails db:seed   # optional demo data
docker compose up
```

The app is then available at [localhost:3000](http://localhost:3000).
Sidekiq runs as its own service in the same `docker compose up`.

Demo login after seeding: `demo@example.com` / `password123`.

## Running tests

```bash
docker compose run --rm -e RAILS_ENV=test web bin/rails db:test:prepare
docker compose run --rm -e RAILS_ENV=test web bundle exec rspec
```

Lint:

```bash
docker compose run --rm web bundle exec rubocop
```

## Notes

Seed data uses fictional companies — it is not a record of anyone's real job
search.
