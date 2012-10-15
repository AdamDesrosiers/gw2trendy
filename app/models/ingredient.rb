class Ingredient < ActiveRecord::Base
  ## Simple middle-man between Recipes and their Item components.
  attr_accessible :recipe_id, :item_id, :count
  self.table_name = 'recipe_ingredient'
  belongs_to :recipe
  belongs_to :item
end
