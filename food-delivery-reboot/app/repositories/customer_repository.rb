require 'csv'
require_relative '../models/customer'

class CustomerRepository
  def initialize(csv_file_path)
    @customers = []
    @next_id = 1
    @csv_file_path = csv_file_path
    load_csv if File.exist?(@csv_file_path)
  end

  def find(id)
    @customers.find { |customer| customer.id == id }
  end

  def all
    @customers
  end

  # expects a customer instance
  def create(customer)
    # assign the next id to the customer
    customer.id = @next_id
    # put the customer into @customers array
    @customers << customer
    # update the next id by 1
    @next_id += 1

    # save the csv
    save_csv
  end

  private

  def load_csv
    # opne the file using CSV foreach
    CSV.foreach(@csv_file_path, headers: true, header_converters: :symbol) do |row|
      row[:id] = row[:id].to_i
      # go over each row to create a customer instance
      # add the customer instance into the @customers array
      @customers << Customer.new(row)
    end

    @next_id = @customers.empty? ? 1 : @customers.last.id + 1
  end

  def save_csv
    # Open the csv file in wb mode
    CSV.open(@csv_file_path, 'wb') do |csv|
      # insert the first row (header)
      csv << ['id', 'name', 'address']
      # iterate over the @customers array
      @customers.each do |customer|
        # on each customer, insert a row
        csv << [customer.id, customer.name, customer.address]
      end
    end
  end
end
