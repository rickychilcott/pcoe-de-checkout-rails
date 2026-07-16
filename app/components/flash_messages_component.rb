# frozen_string_literal: true

class FlashMessagesComponent < ApplicationComponent
  prop :flash, _Any, reader: :private

  def render? = flash.any?

  def view_template
    FLASH_TYPES.each do |type|
      next unless (message = flash[type])

      div(class: "mt-4 rounded-md border px-4 py-3 text-sm font-medium #{CLASSES[type]}", role: "alert") do
        plain message
      end
    end
  end

  FLASH_TYPES = Set[:alert, :notice, :error, :success].freeze
  CLASSES = {
    alert: "bg-amber-50 text-amber-800 border-amber-200",
    notice: "bg-primary-50 text-primary-700 border-primary-200",
    error: "bg-red-50 text-red-800 border-red-200",
    success: "bg-green-50 text-green-800 border-green-200"
  }.freeze
end
