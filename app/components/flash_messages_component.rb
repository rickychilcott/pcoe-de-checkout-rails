# frozen_string_literal: true

class FlashMessagesComponent < ApplicationComponent
  prop :flash, _Any, reader: :private

  def render? = flash.any?

  def view_template
    FLASH_TYPES.each do |type|
      next unless (message = flash[type])

      div(class: "mt-4 alert alert-#{BOOTSTRAP_CLASSES[type]} alert-dismissible fade show", role: "alert") do
        plain message
        button(
          type: "button",
          class: "btn-close",
          data_bs_dismiss: "alert",
          aria_label: "Close"
        )
      end
    end
  end

  private

  FLASH_TYPES = Set[:alert, :notice, :error, :success].freeze
  BOOTSTRAP_CLASSES = {
    alert: "warning",
    notice: "info",
    error: "danger",
    success: "success"
  }.freeze
end
