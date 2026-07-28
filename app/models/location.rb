# == Schema Information
#
# Table name: locations
# Database name: primary
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Location < ApplicationRecord
  has_many :items

  has_rich_text :description

  def item_count
    items.count
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w[name]
  end
end
