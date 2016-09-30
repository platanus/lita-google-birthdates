require 'rufus-scheduler'
require "lita/services/google_calendar_service"
require "lita/services/event_to_birthday"
require "lita/services/greetings_service"
require "lita/models/birthday"

module Lita
  module Handlers
    def self.scheduler
      @scheduler ||= Rufus::Scheduler.start_new
    end

    class GoogleBirthdates < Handler
      on :loaded, :load_on_start
      config :calendar_credentials, required: true do
        config :refresh_token, type: String
        config :client_id, type: String
        config :client_secret, type: String
        config :calendar_id, type: String
      end
      config :room, type: String, required: true
      config :timezone, type: String, default: "America/Santiago"

      route /^birthday today$/, :check_birthdays_today, help: {
        t("help.birthday.usage") => t("help.birthday.description")
      }

      def load_on_start(_payload)
        Lita::Handlers.scheduler.cron "0 9 * * * #{config.timezone}" do
          GreetingsService.new(self, response: response).greet
        end
      end

      def check_birthdays_today(response)
        GreetingsService.new(self, response: response, show_soon: true).greet
      end

      Lita.register_handler(self)
    end
  end
end
