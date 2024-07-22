class PageController < ApplicationController
  def home
    locations = Location.includes(items: :current_checkout)
    render :home, locals: {locations:}
  end
end
