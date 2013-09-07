#riak-search-demo

This is a simple demo app that illustrates a sample usage of yokozuna as a search engine with Ruby Sinatra

##Prerequisites

You must have a [yokozuna](http://github.com/basho/yokozuna) Riak instance running. I advise making a backup of the data directory after installation and wiping data like so between tests from the riak bin directory:

```
./riak stop ; rm -rf ../data ; cp -R ../data.bak ../data ; ./riak start
```

Update: Yokozuna is now in the main Riak repository, but I haven't tested it out from there yet: [Riak Develop Branch](http://github.com/basho/riak/tree/develop)

##Setup

Download

```
git clone git@github.com:drewkerrigan/riak-search-demo.git
```

Install dependencies

```
cd riak-search-demo
bundle install
```

Setup the index and seed the user data

```
ruby setup_search.rb
```

##Run the server

```
ruby server.rb
```

##Test it out

Simple term query

```
curl http://localhost:4567/user/query/name_t/*Drew*
```

Pagination

```
curl http://localhost:4567/user/query/title_t/*Engineer*?rows=10&start=0
```

Range query

```
curl http://localhost:4567/user/query/*/*?from=1994-01-01T01:01:01Z&to=2018-12-13T23:59:59Z
```