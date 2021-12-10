# name:         Host Inventory 
# schedule:     * * * * * 
# log:          error
# revision:     1 

include_recipe "lib/host.rb"

puts Host.inventory(node).to_json
