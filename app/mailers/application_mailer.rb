# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "tracker@job-application-tracker.local"
  layout "mailer"
end
