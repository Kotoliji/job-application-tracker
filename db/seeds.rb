# frozen_string_literal: true

# Demo data only — fictional companies and clients, not real application history.
# Run with: bin/rails db:seed

Rails.logger.debug "Seeding demo data..."

User.find_or_create_by!(email: "demo@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

acme = Organization.find_or_create_by!(name: "Acme Robotics") do |org|
  org.kind = :company
  org.location = "Coimbra, PT"
  org.website = "https://acme-robotics.example.com"
  org.notes = "Industrial monitoring UIs; frontend role surfaced via LinkedIn."
end

northwind = Organization.find_or_create_by!(name: "Northwind Labs") do |org|
  org.kind = :company
  org.location = "Lisbon, PT (hybrid)"
  org.website = "https://northwind-labs.example.com"
end

tidetech = Organization.find_or_create_by!(name: "TideTech Graduate Programme") do |org|
  org.kind = :company
  org.location = "Porto, PT"
end

studio_vega = Organization.find_or_create_by!(name: "Studio Vega") do |org|
  org.kind = :freelance_client
  org.location = "Remote"
  org.notes = "Small design studio, recurring frontend contract work."
end

opp1 = Opportunity.find_or_create_by!(organization: acme, title: "Frontend Developer") do |o|
  o.track = :full_time
  o.priority = :high
  o.posting_status = :live
  o.requirements = "Vue, TypeScript, REST APIs, industrial dashboards. C++/GTKmm a plus."
  o.product_description = "Monitoring and control UI for industrial equipment."
  o.found_at = 10.days.ago.to_date
  o.checked_at = 2.days.ago.to_date
end

channel1 = Channel.find_or_create_by!(opportunity: opp1, channel_type: :email) do |c|
  c.contact_email = "jobs@acme-robotics.example.com"
  c.cv_version = "Frontend v2"
end

[
  { event_type: :draft_prepared, occurred_at: 7.days.ago, notes: "Prepared CV + short cover email." },
  { event_type: :sent, occurred_at: 6.days.ago, notes: "Sent via email, asked about active hiring." }
].each do |attrs|
  next if channel1.submission_events.exists?(event_type: attrs[:event_type])

  RecordChannelEvent.call(channel: channel1, **attrs)
end

opp2 = Opportunity.find_or_create_by!(organization: northwind, title: "Full-Stack Developer (Junior)") do |o|
  o.track = :full_time
  o.priority = :high
  o.posting_status = :live
  o.requirements = "React or Vue, Node/Express, PostgreSQL, 1-2 years professional experience."
  o.found_at = 5.days.ago.to_date
  o.checked_at = 1.day.ago.to_date
end

channel2 = Channel.find_or_create_by!(opportunity: opp2, channel_type: :website) do |c|
  c.link = "https://northwind-labs.example.com/careers/full-stack-junior"
  c.cv_version = "Full-Stack v3"
end

[
  { event_type: :sent, occurred_at: 3.days.ago, notes: "Submitted via careers portal." },
  { event_type: :viewed, occurred_at: 2.days.ago, notes: "Portal shows 'application viewed'." }
].each do |attrs|
  next if channel2.submission_events.exists?(event_type: attrs[:event_type])

  RecordChannelEvent.call(channel: channel2, **attrs)
end

Opportunity.find_or_create_by!(organization: tidetech, title: "Technology Graduate Programme") do |o|
  o.track = :program
  o.priority = :medium
  o.posting_status = :live
  o.requirements = "CS degree, Python/JS/SQL, English."
  o.deadline = 60.days.from_now.to_date
end

opp4 = Opportunity.find_or_create_by!(organization: studio_vega, title: "Landing page refresh") do |o|
  o.track = :freelance_contract
  o.priority = :medium
  o.posting_status = :unknown
  o.product_description = "Rebuild a marketing landing page in React, two-week scope."
end

channel4 = Channel.find_or_create_by!(opportunity: opp4, channel_type: :personal_contact) do |c|
  c.contact_name = "Studio Vega — referral contact"
  c.cv_version = "Freelance portfolio"
end

[
  { event_type: :sent, occurred_at: 9.days.ago, notes: "Sent proposal + three portfolio examples." },
  { event_type: :response_received, occurred_at: 7.days.ago, notes: "Client asked for a call next week." },
  { event_type: :interview_scheduled, occurred_at: 6.days.ago, notes: "Call booked." },
  { event_type: :offer_received, occurred_at: 2.days.ago, notes: "Client confirmed the contract." }
].each do |attrs|
  next if channel4.submission_events.exists?(event_type: attrs[:event_type])

  RecordChannelEvent.call(channel: channel4, **attrs)
end

Rails.logger.debug do
  "Done. #{Organization.count} organizations, #{Opportunity.count} opportunities, #{Channel.count} channels."
end
