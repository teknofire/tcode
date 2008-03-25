require 'drb'

DRb.start_service()
def connect
	DRbObject.new(nil, 'druby://localhost:9000')
end
