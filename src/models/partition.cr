class Partition < Granite::Base
	connection embedded
	table partition
	has_many :mount
	has_many :disk, through: :mount

	column id : Int64, primary: true
	column mountpoint : String
	column fs_type : String
	column device : String
end
