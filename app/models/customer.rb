# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ohio_id    :string           not null
#
class Customer < ApplicationRecord
  validates :name, presence: true
  validates :ohio_id, presence: true

  has_rich_text :notes

  def email = "#{ohio_id}@ohio.edu"
end
