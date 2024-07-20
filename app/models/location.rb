class Location < ApplicationRecord
  has_many :items

  has_rich_text :description
end
