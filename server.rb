require 'bundler/setup'
require 'sinatra'
require 'riak'
require 'net/http'

client = Riak::Client.new(:http_port => 8098, :pb_port => 8087, :protocol => "pbc")
bucket_name = "user"

# Supports ?rows=50&start=1&from=1994-01-01T01:01:01Z&to=2018-12-13T23:59:59Z
get '/user/query/:term/:value' do
  results = []
  query = "#{params[:term]}:#{params[:value]}"
  rows = (params[:rows])? params[:rows].to_i : 10
  start = (params[:start])? params[:start].to_i : 1

  if(params[:from] && params[:to])
    query = "((#{query}) AND (created_dt:[#{params[:from]} TO #{params[:to]}]))"
  end
  begin
    resp = client.search(bucket_name, query, {:rows => rows, :start => start, :df => "name_t"})
    resp["docs"].each do |doc|
      results << JSON.parse(client.bucket(bucket_name).get(doc["_yz_rk"]).raw_data)
    end
  rescue
    results = {:error => "There was a problem with the query, or there were no results"}
  end

  erb :index, :locals => {:output => results.to_json}
end