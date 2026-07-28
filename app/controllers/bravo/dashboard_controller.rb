class Bravo::DashboardController < Bravo::BaseController
  def show
    @checkouts_chart = Bravo::Cards::CheckoutsChart.new(current_user: current_admin_user, range: params[:range] || "30")
    @available_items_chart = Bravo::Cards::AvailableItemsChart.new(current_user: current_admin_user)
  end
end
