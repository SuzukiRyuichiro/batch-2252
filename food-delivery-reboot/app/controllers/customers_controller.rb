require_relative '../views/customers_view'
require_relative '../models/customer'

class CustomersController
  def initialize(customer_repository)
    @customer_repository = customer_repository
    @view = CustomersView.new
  end

  def add
    # ask the user for a name (view)
    name = @view.ask_for('name')
    # ask the user for a address (view)
    address = @view.ask_for('address')
    # make customer instance out of those info (model)
    customer = Customer.new(name: name, address: address)
    # ask the repository to create the customer (repo)
    @customer_repository.create(customer)
  end

  def list
    # get all the customers from the repository
    customers = @customer_repository.all
    # display them in order (views)
    @view.display_list(customers)
  end
end
