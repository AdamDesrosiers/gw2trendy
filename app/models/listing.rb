class Listing < ActiveRecord::Base
  ## Nested class to handle historical data.
  # attr_accessible :title, :body
  self.table_name = 'discipline'

  ## TODO: Refactor associated functionality into methods located here.
end
  ## Purchase orders for Items
class Buy_Listing < Listing
  self.table_name = 'buy_listing'
end
  ## Sale orders for Items
class Sell_Listing < Listing
  self.table_name = 'sell_listing'
end
  ## Historical profitability data for recipes
class Recipe_Listing < Listing
  self.table_name = 'recipe_listing'
end
