class GoogleCalendarService
  def self.fetch(date:, config:)
    new(date, config).fetch
  end

  def initialize(date, config)
    @date = date
    @config = config
  end

  def fetch
    events_from_date
  end

  private

  attr_reader :config

  def events_from_date
    calendar.login_with_refresh_token(config.refresh_token)
    events = calendar.find_events_in_range(@date, @date + 1)
    events.map { |event| EventToBirthday.from_event(event).to_birthday }
  rescue
    []
  end

  def calendar
    @calendar ||= Google::Calendar.new(
      client_id: config.client_id,
      client_secret: config.client_secret,
      calendar: config.calendar_id,
      redirect_url: "urn:ietf:wg:oauth:2.0:oob" # this is what Google uses for 'applications'
    )
  end

  def show_authorize_url
    puts calendar.authorize_url
    # A user needs to approve access in order to work with their calendars.
    puts "Visit the following web page in your browser and approve access."
    puts "\nCopy the code that Google returned and paste it here:"
    refresh_token = cal.login_with_auth_code( $stdin.gets.chomp )
  end
end
