require 'riak'
require 'net/http'

client = Riak::Client.new(:http_port => 8098, :pb_port => 8087, :protocol => "pbc")
bucket_name = "user"
port = 8098
host = "localhost"
path = "/yz/index/#{bucket_name}"

puts "Creating Index"
req = Net::HTTP::Put.new(path, initheader = { 'Content-Type' => 'application/json'})
# Optionally set schema here
#req.body = '{"schema": "schema_name"}'
Net::HTTP.new(host, port).start {|http| http.request(req) }

sleep(15)

puts "Adding index to bucket"
bucket = Riak::Bucket.new(client, bucket_name)
bucket.props = {'yz_index' => bucket_name}

sleep(15)

puts "Populating users"
users = JSON.parse( IO.read("user_fixtures.json") )

users.each do |user|
  object = bucket.new()
  object.raw_data = user.to_json
  object.content_type = 'application/json'
  object.store
end

puts "Done"