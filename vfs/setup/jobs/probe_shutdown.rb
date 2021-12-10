# name:         Probe Shutdown 
# schedule:     on-demand 
# log:          debug 
# revision:     1 

service 'os-probe' do
  action :stop
end
