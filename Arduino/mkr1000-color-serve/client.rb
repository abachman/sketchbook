
require 'socket'

# send one char at a time
s = TCPSocket.new '192.168.1.115', 23
[99, 108, 240].each do |c|
  s.write [c].pack('C')
end
s.write "\n"

sleep 2

# send whole word at once
s = TCPSocket.new '192.168.1.115', 23
s.write [99, 108, 240].pack('C*')
s.write "\n"

puts "DONE"
