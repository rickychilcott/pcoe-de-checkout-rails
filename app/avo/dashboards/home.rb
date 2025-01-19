class Avo::Dashboards::Home < Avo::Dashboards::BaseDashboard
  self.id = "home"
  self.name = "Home"
  self.grid_cols = 4

  def cards
    card Avo::Cards::Documentation
    card Avo::Cards::CheckoutsChart
    card Avo::Cards::AvailableItemsChart
  end
end
