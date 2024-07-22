# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

AdminUser
  .find_or_initialize_by(email: "ricky@rickychilcott.com") do |admin_user|
    admin_user.name = "Ricky Chilcott"
    admin_user.password = "password"
  end
  .save!

location = Location.find_or_create_by(name: "House")
group = Group.find_or_create_by(name: "Default")

parent_item =
  Item
    .find_or_initialize_by(name: "Parent Item") do |item|
    item.location = location
    item.group = group
  end

parent_item.save!
child_item = Item.find_or_initialize_by(name: "Child Item")
child_item.location = location
child_item.group = group
child_item.parent = parent_item
child_item.save!
