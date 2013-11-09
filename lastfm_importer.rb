require 'rest_client'
require 'JSON'

class LastfmImporter

  API_ROOT = "http://ws.audioscrobbler.com/2.0/"
  API_METHOD = "user.getrecenttracks"
  API_FORMAT = "json"
  API_LIMIT = 20

  attr_accessor :listens

  def initialize options={}
    @username = options[:username] || 'hyfen'
    @api_key = options[:api_key] || 'XX'
    @listens = []
  end

  def load_all
    total_pages = determine_total_pages
    
    (1..total_pages).each do |page|
      
      history = retrieve_history page
      puts "Parsing page #{page} / #{total_pages}"
      
      history["recenttracks"]["track"].each do |track|
        next if track["@attr"] && track["@attr"]["nowplaying"]
        @listens << parse_track(track)
      end 
    end
  end

  private

  def determine_total_pages
    sample_recent_history = retrieve_history
    return sample_recent_history["recenttracks"]["@attr"]["totalPages"].to_i
  end
  
  def retrieve_history page=nil
    options = {
      method: API_METHOD,
      format: API_FORMAT,
      limit: API_LIMIT,
      api_key: @api_key,
      user: @username,
      page: page
    }
    response = RestClient.get API_ROOT, params: options
    JSON.parse(response)
  end

  def parse_track track
    track_info = {}
    track_info[:name] = track["name"]
    track_info[:lastfm_mbid] = track["mbid"]
    track_info[:lastfm_url] = track["url"]
    track_info[:lastfm_image_url_extralarge] = track["image"].last["#text"]
    track_info[:artist_name] = track["artist"]["#text"]
    track_info[:artist_lastfm_mbid] = track["artist"]["mbid"]
    track_info[:listened_at] = Time.at(track["date"]["uts"].to_i)
    return track_info
  end

end
