require 'httparty'
require 'nokogiri'
require 'json'
require 'net/http'
require 'uri'
require 'openssl'  

majorContainer = []
#===============================CBRE=======================
  uri = URI.parse("http://looplink.natl.cbre.us/services/geography/lookupstates/US?_=1589569510773")
  request = Net::HTTP::Get.new(uri)
  request.content_type = "application/json"
  request["Connection"] = "keep-alive"
  request["Accept"] = "application/json, text/javascript, */*; q=0.01"
  request["Dnt"] = "1"
  request["X-Requested-With"] = "XMLHttpRequest"
  request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36"
  request["Referer"] = "http://looplink.natl.cbre.us/SearchResults?SearchType=FL&parentUrl=http%3A%2F%2Fwww.cbre.us%2Fproperties%2Fproperties-for-lease"
  request["Accept-Language"] = "en-US,en;q=0.9"
  request["Cookie"] = "__cfduid=d31ffedfb76ff9f965915655ba184b86f1589560235; _ga=GA1.2.682812274.1589560238; _gid=GA1.2.355216685.1589560238; _fbp=fb.1.1589560237935.1521037352; _vwo_uuid_v2=DE1613F4209E26150C5A1847EEAD6EE5A|0bd4f2af97c249645db94371e817cc27; _ga=GA1.4.682812274.1589560238; _gid=GA1.4.355216685.1589560238; LNUniqueVisitor=979969c9-01b5-4d85-b611-17b4baa295e5; notice_preferences=2:; notice_gdpr_prefs=0,1,2:; mf_4f7b949e-8822-4ec0-a038-f54c890143f8=-1; _dc_gtm_UA-25154432-1=1; _gat_UA-25154432-1=1; _gat=1"

  req_options = {
    use_ssl: uri.scheme == "https",
    verify_mode: OpenSSL::SSL::VERIFY_NONE,
  }

  response_one = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  
  data = response_one.body
    json_data = JSON.parse data
      dt = json_data 

  dt.map do |prop|
      example_hash = {
        "location_id" => prop['ID'],
        "state_abbrev" => prop['Code'],
        "state" => prop['Display'],
        "latitude" => prop['Location']["y"],
        "longitude" => prop['Location']["x"],
      }
      majorContainer << {"CBRE": example_hash.to_s}
        # p "[CBRE]" + example_hash.to_s
    end
# =================================JLL=================================
uri = URI.parse("https://powersearchapi.jll.com/api/search/properties/v2?queries%5B0%5D.type=1&queries%5B0%5D.term=United%20States&queries%5B0%5D.isStateOrCountry=true&options.siteOrganizationId=11111111-1111-1111-1111-111111111111&options.currencyCode=USD&options.unitOfMeasurement=1")
request = Net::HTTP::Get.new(uri)
request.content_type = "application/json"
request["Accept"] = "application/vnd.jll.v1+json"
request["Referer"] = "https://powersearch.jll.com/us-en/property/search;query=United%20States;searchType=1;page=1;perPage=24;zoomLevel=11;isStateOrCountry=true"
request["Dnt"] = "1"
request["Wlparam"] = "us-en"
request["Eloquaid"] = "6af1a86a-c976-4b1c-9196-49fa4a721651"
request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36"

req_options = {
  use_ssl: uri.scheme == "https",
}

response_two = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end
new_data = response_two.body

json_data = JSON.parse new_data
  jll = json_data
    tree = jll["results"]

    tree.map do |houses|
      hash_jll = {
        "Latitude: "=> houses["latitude"].to_s,
        "Longitude: "=> houses["longitude"].to_s,
        # pp houses["cultures"][0].keys
        "State:"=> houses["cultures"][0]["address"],
        "City:"=> houses["cultures"][0]["city"],
        "Region:"=> houses["cultures"][0]["region"],
        "Zip :"=> houses["cultures"][0]["postalCode"],
      }
      # p hash_jll  
    majorContainer << {"JLL": hash_jll}

  end
  # pp majorContainer

  # ========================= Zillow==================================

uri = URI.parse("https://www.zillow.com/search/GetSearchPageState.htm?searchQueryState=%7B%22pagination%22%3A%7B%7D%2C%22mapBounds%22%3A%7B%22west%22%3A-98.7351416015625%2C%22east%22%3A-94.9448583984375%2C%22south%22%3A32.39318064737669%2C%22north%22%3A33.61393194285851%7D%2C%22mapZoom%22%3A8%2C%22isMapVisible%22%3Atrue%2C%22filterState%22%3A%7B%22sort%22%3A%7B%22value%22%3A%22globalrelevanceex%22%7D%7D%2C%22isListVisible%22%3Atrue%7D&includeMap=true&includeList=false")
request = Net::HTTP::Get.new(uri)
request["Authority"] = "www.zillow.com"
request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36"
request["Dnt"] = "1"
request["Accept"] = "*/*"
request["Sec-Fetch-Site"] = "same-origin"
request["Sec-Fetch-Mode"] = "cors"
request["Sec-Fetch-Dest"] = "empty"
request["Referer"] = "https://www.zillow.com/homes/for_sale/?searchQueryState=%7B%22pagination%22%3A%7B%7D%2C%22mapBounds%22%3A%7B%22west%22%3A-98.7351416015625%2C%22east%22%3A-94.9448583984375%2C%22south%22%3A32.39318064737669%2C%22north%22%3A33.61393194285851%7D%2C%22isMapVisible%22%3Atrue%2C%22mapZoom%22%3A8%2C%22filterState%22%3A%7B%22sort%22%3A%7B%22value%22%3A%22globalrelevanceex%22%7D%7D%2C%22isListVisible%22%3Atrue%7D"
request["Accept-Language"] = "en-US,en;q=0.9"
request["Cookie"] = "zguid=23|%24c6288a8b-a162-4e0d-aa15-a9dc2e132257; zgsession=1|39cd3613-2053-4261-9943-b5f310ead768; zjs_user_id=null; _ga=GA1.2.1987669277.1589579259; _gid=GA1.2.2037400640.1589579259; _gat=1; zjs_anonymous_id=%22c6288a8b-a162-4e0d-aa15-a9dc2e132257%22; _pxvid=b2675f35-96f5-11ea-b5f5-0242ac12000b; _pxff_rsk=1; JSESSIONID=8C2FB7C367C6B688E75D68321691E2E5; _gcl_au=1.1.2061792249.1589579260; KruxPixel=true; DoubleClickSession=true; GASession=true; _fbp=fb.1.1589579260802.2143870511; _px3=9f030e80060b86378e667cbf3899cbd863d4e1c09663bf904f6f35b308bb0184:jjyRSZE1fUGohSKVbERZQNM/5kix6E1IoxEoUMxq73hkkFLmvbafx6csVP5tbq0R1enxdyrHg3Zg0T4h/+riQg==:1000:OebUn8Ds+vVeX517daEkb+aYFgeR9PrKhZGZH5JvMTHZa86cyvhBllK79vI3+fiou5wwTtuUY2aNYDxQhNV3w3hCcFBRU8Tz/93ECPvm4dvWmsIn/Yygznd+SHBQyU4e+83xjAQnqZRQoKHGqN2PlsccW3Y+KzILJUjUy13yxS4=; _uetsid=24b8549f-4865-3f93-52bc-24e99b643a9f; KruxAddition=true; AWSALB=OS93b/P1bF5gTR3ak4Dv6qVIklAxeANRd/YxdwAAQpFjikHxv58l7AQYbag6s4HnZJhxv751+A4gvn/96ao+USEa84kdrBb77XfUYXNn2B25d/Dsab6yRXLYnuNl; AWSALBCORS=OS93b/P1bF5gTR3ak4Dv6qVIklAxeANRd/YxdwAAQpFjikHxv58l7AQYbag6s4HnZJhxv751+A4gvn/96ao+USEa84kdrBb77XfUYXNn2B25d/Dsab6yRXLYnuNl; search=6|1592171289531%7Crect%3D33.61393194285851%252C-94.9448583984375%252C32.39318064737669%252C-98.7351416015625%26disp%3Dmap%26mdm%3Dauto%26pt%3Dpmf%252Cpf%26fs%3D1%26fr%3D0%26rs%3D0%26ah%3D0%26singlestory%3D0%26abo%3D0%26garage%3D0%26pool%3D0%26ac%3D0%26waterfront%3D0%26finished%3D0%26unfinished%3D0%26cityview%3D0%26mountainview%3D0%26parkview%3D0%26waterview%3D0%26hoadata%3D1%26zillow-owned%3D0%263dhome%3D0%09%09%09%09%09%09%09%09"

req_options = {
  use_ssl: uri.scheme == "https",
}

response_three = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

data_pool = response_three.body

big_pool = JSON.parse(data_pool)

# ["queryState",
#  "filterDefinitions",
#  "defaultFilterState",
#  "defaultQueryState",
#  "searchPageConstants",
#  "searchList",
#  "searchResults",
#  "user",
#  "mapState",
#  "searchPageSeoObject",
#  "abTrials"]
big_pool["searchResults"]["mapResults"].map do |trees|
# pp trees.keys
p "============================================"

thisOne = {
  "latitude" =>trees["latLong"]['latitude'].to_s,
  "longitude" => trees["latLong"]['longitude'].to_s,
  "beds" => trees["beds"],
  "bath" =>  trees["baths"]
}
# p thisOne
# p"============================================"
majorContainer << thisOne
end

pp majorContainer[(10...20)]
