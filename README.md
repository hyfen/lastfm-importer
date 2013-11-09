lastfm-importer
===============

Quick and dirty script to retrieve all your listening history from last.fm. 

Before running, you'll need to get an [api key](http://www.last.fm/api/account/create).

### Usage


```ruby
history = LastfmImporter.new username: 'hyfen', api_key: 'XXXXXX'
history.load_all
puts history.listens
```

After running ```load_all```, all history will be available in an array ```listens``` which is a hash with the following keys:
* name
* lastfm_mbid
* lastfm_url
* lastfm_image_url_extralarge
* artist_name
* artist_lastfm_mbid
* listened_at
