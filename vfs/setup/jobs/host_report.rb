# name:         Host Report 
# schedule:     */5 * * * * 
# log:          debug
# revision:     1 

include_recipe "lib/host.rb"

puts Host.inventory(node).to_yaml
