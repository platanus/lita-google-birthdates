class GreetingsService
  attr_reader :plugin, :response, :date, :show_soon

  delegate :config, :robot, :log, to: :plugin

  def initialize(plugin, response: nil, show_soon: false)
    @plugin = plugin
    @date = Time.now
    @response = response
    @show_soon = show_soon
  end

  def greet
    log.info "Checking birthdays for #{date}"
    birthdays = fetch_birhdays date: date
    send_greetings(birthdays)
  end

  def target
    @target ||= Source.new(room: config.room)
  end

  def send_message(message)
    if response.nil?
      robot.send_message(target, message)
    else
      response.reply(message)
    end
  end

  def send_greetings(birthdays)
    if birthdays.empty?
      send_message "Hoy no tenemos cumpleaños :robot_face:"
      inform_soon_birthdays if show_soon
    else
      birthdays.each do |birthday|
        send_message birthday.message
      end
    end
  end

  def inform_soon_birthdays
    birthdays = fetch_birhdays range: in_30_days
    send_message "Pero los proximos son" unless birthdays.empty?
    birthdays.each do |birthday|
      send_message "#{birthday.message} - #{birthday.date.to_date}"
    end
  end

  def in_30_days
    (date..(date + 1.month))
  end

  def fetch_birhdays(date: nil, range: nil)
    GoogleCalendarService.fetch date: date,
                                range: range,
                                config: config.calendar_credentials
  end
end
