class CPU < Granite::Base
	connection embedded
	table cpu

	column id : Int64, primary: true
	column seconds : Int64
	column usage : Float64
end
