require 'json'
require 'net/http'
require 'uri'
require 'openssl'  
require 'net/http'
require 'uri'

module DataScraping
  class Scraper < ApplicationRecord
    def self.scraper
      uri = URI.parse("https://www.nba.com/players/active_players.json")
      request = Net::HTTP::Get.new(uri)
      request["Accept"] = "application/json, text/javascript, */*; q=0.01"
      request["X-Newrelic-Id"] = "UgcPVVdACgUAV1VVDgQ="
      request["Dnt"] = "1"
      request["X-Requested-With"] = "XMLHttpRequest"
      request["Referer"] = "https://www.nba.com/players"
      request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36"

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      fetched = response.body 

      json = JSON.parse fetched
      # playerContainer= []
      json.map do |pool|
        name = pool["firstName"]+ pool["lastName"]
        position = pool["pos"] + " : " + pool["posExpanded"]
        team = pool["teamData"]["tricode"]+""+pool["teamData"]["nickname"]
        height= pool["heightFeet"] + "'"+pool["heightInches"]
        site = "http://www.nba.com"

              Player.create(
                  "name" => name,
                  "height"=> height,
                  "jersey_num" => pool["jersey"],
                  "position" => position,
                  "teamName" => team,
                  "isAllStar" => pool["isAllStar"],"player_link" => site + pool["playerUrl"]
              )
            # playerContainer << player
      end
    end
  end
end