# TODO: you can build your instacart program here!

# How should we model our shop? => hash

store = {
  "kiwi" => { price: 1.25, stock: 5 },
  "banana" => { price: 0.5, stock: 2 },
  "cheese" => { price: 1.45, stock: 10 },
  "eggs" => { price: 2.00, stock: 10 },
  "vegemite" => { price: 5.00, stock: 10 }
}

cart = {}

# Print the welcome message
puts "-" * 20
puts "Welcome to Kohl's"
puts "-" * 20

item = ''

until item == 'quit'
  # Print available items and its price
  # use Hash#each to iterate over key, value
  store.each do |item, item_info|
    # print the name and price of each items
    puts "#{item}: #{item_info[:price]}€ (#{item_info[:stock]} available)"
  end
  # Prompt the user to pick an item
  puts "What item would you like? type `quit` to exit"
  # get the user input for an item
  item = gets.chomp
  # check if the item is available (.key?)
  if store.key?(item)
    # if so, we prompt the user to pick a number
    puts 'How many would you like?'
    amount = gets.chomp.to_i
    # How should we model our cart => hash
    # cart = {
    #   "kiwi" => 5
    # }
    # You have to handle two occasions

    # TODO: Check if the requested amount is more than available at the store, send them back to the top of the loop
    if amount > store[item][:stock]
      puts "Sorry we don't have enough of that"
      next
    end

    # TODO: if so, continue with the existing logic
    if cart.key?(item)
      # 2. when the item does exist in the cart => Increment the existing value
      cart[item] += amount
    else
      # 1. when the item doesn't exist in the cart yet => Assign new key value
      cart[item] = amount
    end
    # TODO: update the available amount in the store.
    store[item][:stock] -= amount
  elsif item == 'quit'
    puts "Let's check out"
  else
    puts 'not available'
  end
end

# when the user types quit, exit the loop

# Print the bill
# Use Hash#each to go over each items in the cart
# Print the subtotal for each item

puts "----- BILL ----"
total = 0
cart.each do |item, amount|
  # print the name and price of each items
  # Subtotal = amount * price per item
  subtotal = amount * store[item][:price]

  # kiwi: 2 X 1.25€ = 2.5€
  puts "#{item}: #{amount} X #{store[item][:price]}€ = #{subtotal}€"
  total += subtotal
end
# Add all the subtotal and print the total price of the cart
puts '---- TOTAL ----'

puts "#{total}€"
