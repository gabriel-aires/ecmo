class Disk < Granite::Base
	connection embedded
	table disk
	has_many :mount
	has_many :partition, through: :mount

	column id : Int64, primary: true
	column seconds : Int64
	column size_mb : Float64
	column used_mb : Float64
	column free_mb : Float64
	column usage : Float64
end
