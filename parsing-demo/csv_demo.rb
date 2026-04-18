require "csv"

# TODO - let's read/write data from beatles.csv
filepath = "data/beatles.csv"

existing_rows = []

# Parsing
CSV.foreach(filepath, headers: true) do |row|
  # write instruction on what to do with each row

  # If you don't use the headers optional argument
  # puts "#{row[0]} #{row[1]} plays the #{row[2]}"

  # If you tell that header is the first row
  puts "#{row['First Name']} #{row['Last Name']} plays the #{row['Instrument']}"

  existing_rows << [row['First Name'], row['Last Name'], row['Instrument']]
end


# Storing

CSV.open(filepath, 'wb') do |csv|
  # write instruction of all the rows you want to write
  csv << ['First Name', 'Last Name', 'Instrument']

  # Rewrite the existing rows
  existing_rows.each do |row|
    csv << row
  end

  # add more rows
  csv << ['Ryuichiro', 'Suzuki', 'Triangle']
  csv << ['Ryo', 'Masago', 'Piano']
end
