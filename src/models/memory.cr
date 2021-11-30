class Memory < Granite::Base
	connection embedded
	table memory

	column id : Int64, primary: true
	column seconds : Int64
	column total_mb : Float64
	column used_mb : Float64
	column free_mb : Float64
end
