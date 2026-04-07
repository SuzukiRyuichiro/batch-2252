def hello(name)
  puts 'hello'
  puts yield(name)
  puts 'Good bye'
end

hello('Ryo') do |name|
  "#{name}! welcome to lewagon"
end

hello('Ryo') do |name|
  name_all_caps = name.upcase
  "#{name_all_caps}! WELCOME TO LEWAGON"
end
