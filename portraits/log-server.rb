require 'osc-ruby'

server = OSC::Server.new(5300)

# rebind socket

# server.add_method '*' do |message|
#   puts "ANY ADDRESS: #{message.ip_address}:#{message.ip_port} -- #{message.address} -- #{message.to_a}"
# end

server.add_method '/log' do |message|
  puts "[#{message.ip_address}:#{message.ip_port} #{Time.now}]  #{message.to_a[0]}"
end

server.run


