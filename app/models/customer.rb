class Customer < ApplicationRecord
  validates :name, presence: true
  validates :ohio_id, presence: true

  has_rich_text :notes

  def email = "#{ohio_id}@ohio.edu"
end
