class Birthday
  attr_accessor :name, :date, :email, :full_name, :has_contact_info

  def to_s
    puts "Name: #{name}"
    puts "Date: #{date}"
    puts "Email: #{email}"
    puts "Full Name: #{full_name}"
    puts "Has Contact Info : #{has_contact_info}"
  end

  def message
    if has_contact_info
      "#{name} cumple años! :partyparrot:"
    else
      "#{name} :partyparrot:"
    end
  end
end
