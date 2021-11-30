class Mount < Granite::Base
	connection embedded
	table mount
	belongs_to :partition
	belongs_to :disk

	column id : Int64, primary: true
end
