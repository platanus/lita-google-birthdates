require "lita"
require 'google_calendar'
require 'active_support/all'

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/google_birthdates"

Lita::Handlers::GoogleBirthdates.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
