class Memory < Granite::Base
  connection embedded
  table memory

  column id : Int64, primary: true
  column seconds : Int64
  column ram_size_mb : Float64
  column ram_used_mb : Float64
  column ram_free_mb : Float64
  column swp_size_mb : Float64
  column swp_used_mb : Float64
  column swp_free_mb : Float64  
end
