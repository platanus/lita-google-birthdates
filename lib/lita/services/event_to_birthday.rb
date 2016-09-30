class EventToBirthday
  attr_reader :event

  def self.from_event(event)
    new(event)
  end

  def initialize(event)
    @event = event
  end

  def to_birthday
    birthday = Birthday.new
    birthday.name = name
    birthday.full_name = full_name
    birthday.date = date
    birthday.email = email
    birthday.has_contact_info = has_contact_info
    birthday
  end

  private

  def date
    Time.parse(event.start_time)
  end

  def email
    prefs["goo.contactsEmail"]
  end

  def full_name
    prefs["goo.contactsFullName"]
  end

  def name
    prefs["goo.contactsGivenName"] || event.title
  end

  def has_contact_info
    !prefs.empty?
  end

  def prefs
    event.raw["gadget"]["preferences"]
  rescue
    {}
  end
end
