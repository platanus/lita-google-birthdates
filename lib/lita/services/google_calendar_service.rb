class GoogleCalendarService
  def self.fetch(date: query_date)
    new(date).fetch
  end

  def initialize(date)
    @date = date
  end

  def fetch
    events_from_date
  end

  private

  def events_from_date
    calendar.login_with_refresh_token(ENV['GOOGLE_CALENDAR_REFRESH_TOKEN'])
    events = calendar.find_events_in_range(@date, @date + 1)
    events.map { |event| EventToBirthday.from_event(event).to_birthday }
  rescue
    []
  end

  def calendar
    @calendar ||= Google::Calendar.new(
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      calendar: ENV['GOOGLE_CALENDAR_ID'],
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
