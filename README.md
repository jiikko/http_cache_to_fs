# HttpResponseTofs
* HTTPレスポンスをファイルに書き出します。
* I'm respect to https://github.com/gurgeous/chuckle .

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_response_to_fs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_response_to_fs

## Usage
```ruby
2.4.1 :001 > HttpResponseTofs.cache_dir = './lib/http_cache/'
 => "./lib/http_cache/"
2.4.1 :002 > HttpResponseTofs.open('http://google.net')
 => #<File:./lib/http_cache/http:,,google.net>
2.4.1 :003 > HttpResponseTofs.open('http://google.net')
 => #<File:./lib/http_cache/http:,,google.net> # from cache
2.4.1 :004 >
```
