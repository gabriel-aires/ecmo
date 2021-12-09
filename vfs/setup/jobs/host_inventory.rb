# name:			Host Inventory 
# schedule:	* * * * * 
# log:			true 
# revision:	1 

keys = [
  :memory,
  :hostname,
  :domain,
  :fqdn,
  :platform,
  :platform_version,
  :filesystem,
  :cpu,
  :virtualization,
  :kernel,
  :block_device,
  :user,
  :group,
]

inventory = {}

keys.each do |key|
	inventory[key] = node[key]
end

puts inventory.to_yaml