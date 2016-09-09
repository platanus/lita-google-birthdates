require 'rufus-scheduler'
require "lita/models/birthday"

module Lita
  module Handlers
    def self.scheduler
      @scheduler ||= Rufus::Scheduler.start_new
    end

    class GoogleBirthdates < Handler
      on :loaded, :load_on_start
      config :calendar_credentials do
        config :refresh_token, type: String
        config :client_id, type: String
        config :client_secret, type: String
        config :calendar_id, type: String
      end
      config :channel, type: String

      route /^birthday today$/, :check_birthdays_today, help: {
        t("help.birthday.usage") => t("help.birthday.description")
      }

      def load_on_start(_payload)
        Lita::Handlers.scheduler.cron '0 11 * * *' do
          date = Time.now
          log.info "Checking birthdays for #{date}"
          birthdays = GoogleCalendarService.fetch date: date, config: config.calendar_credentials
          birthdays.each do |birthday|
            target = Source.new(room: config.channel)
            robot.send_messages(target, "Feliz cumple #{birthday.name}! :partyparrot:")
          end
        end
      end

      def check_birthdays_today(response)
        date = Time.now
        log.info "Checking birthdays for #{date}"
        birthdays = GoogleCalendarService.fetch date: date, config: config.calendar_credentials
        birthdays.each do |birthday|
          response.reply("Hoy #{birthday.name} cumple años! :partyparrot:")
        end
      end

      Lita.register_handler(self)
    end
  end
end
