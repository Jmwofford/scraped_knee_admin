class Player < ApplicationRecord
  include Datascraping
  Datascraping::Scraper::scraper
end
