class Birthday
  attr_accessor :name, :date, :email, :full_name

  def to_s
    puts "Name: #{name}"
    puts "Date: #{date}"
    puts "Email: #{email}"
    puts "Full Name: #{full_name}"
  end
end
