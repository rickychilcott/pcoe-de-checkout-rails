# app/controllers/customers_controller.rb
class CustomersController < ApplicationController
  include Autocompletable

  def index
    query = params[:q]

    autocomplete_for(Customers::AutocompleteComponent) do
      Customer
        .resolved_policy_scope_for(current_admin_user)
        .ransack(
          name_cont: query,
          ohio_id_cont: query,
          pid_cont: query,
          m: "or"
        )
        .result(distinct: false)
        .then do |customers|
          customers.to_a.concat([
            Customer.new(name: query, ohio_id: query)
          ])
        end
    end
  end

  def new
    customer = Customer.new(params.permit(:name, :ohio_id))
    render :new, locals: {customer:}
  end

  def create
    customer_params = params.require(:customer).permit(:name, :role, :ohio_id, :pid, :notes)
    customer = Customer.new(customer_params)

    if customer.save
      redirect_to customer_path(customer)
    else
      render :new, status: :unprocessable_entity, locals: {customer:}
    end
  end

  def show
    customer =
      Customer
        .resolved_policy_scope_for(current_admin_user)
        .find(params[:id])

    render :show, locals: {customer:}
  end
end
