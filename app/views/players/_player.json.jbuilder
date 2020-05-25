json.extract! player, :id, :name, :height, :jersey_num, :position, :teamName, :isAllStar, :player_link, :created_at, :updated_at
json.url player_url(player, format: :json)
