# This controller has been generated to enable Rails' resource routes.
# More information on https://docs.avohq.io/3.0/controllers.html
class Avo::ItemsController < Avo::ResourcesController
  def not_checked_out_items
    data = Item.with_attached_images.not_checked_out.map do |item|
      {
        value: item.id,
        label: item.title,
        avatar: item.images.first&.url
      }
    end

    render json: data
  end
end
