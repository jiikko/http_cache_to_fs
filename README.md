# HttpCacheToFs
HTTPレスポンスをファイルに書き出します。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_cache_to_fs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_cache_to_fs

## Usage
```ruby
2.4.1 :002 > HttpCacheToFs.open('http://google.net')
2.4.1 :003 > HttpCacheToFs.open('http://google.net')
```
