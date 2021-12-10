# name:         Probe Restart 
# schedule:     on-demand 
# log:          debug 
# revision:     1 

service 'os-probe' do
  action :restart
end
