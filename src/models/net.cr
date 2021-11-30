class Net < Granite::Base
	connection embedded
	table net

	column id : Int64, primary: true
	column seconds : Int64
	column received_mb : Float64
	column sent_mb : Float64
	column received_packets : UInt64
	column sent_packets : UInt64
end
