class Craft < ActiveRecord::Base
  ## TODO: Rename this class "Recipe" and refactor
  # attr_accessible :title, :body
  self.table_name = 'recipe'
  ## TODO: Look into changing from MyISAM to InnoDB to implement relationships
  has_many :recipe_ingredient
  has_many :item, :through => :recipe_ingredient
  ## TODO: Find better way to store per-recipe data temporarily
  attr_accessor :bulk
  ## :data_id & :name are accessible for Test purposes
  attr_accessible :data_id, :name, :bulk
  ## Simple name-only search function
  def self.search(search)
    if search
	where('name LIKE ?', "%#{search}%")
    else
	scoped
    end
  end
  ## Getter for last calculated cost value
  def get_cost
    return self.cost
  end
  ## Method to force update on cost value and then return it
  def update_cost
    temp_cost = Item.select('item.max_offer_unit_price,recipe_ingredient.count').joins('JOIN recipe_ingredient ON recipe_ingredient.item_id = item.data_id').where('recipe_ingredient.recipe_id = ? ', self.data_id).map{|item| item.count * item.max_offer_unit_price}.sum
    if temp_cost != self.cost
	self.cost = temp_cost
	self.save!
    end
    return self.cost
  end
  ## Method to initially calculate total recipe Skill Point consumption,
  ##    and then return the stored value.
  def sp
    if !self.sp_cost
      self.sp_cost = Item.select('item.sp_cost,recipe_ingredient.count').joins('JOIN recipe_ingredient ON recipe_ingredient.item_id = item.data_id').where('recipe_ingredient.recipe_id = ? AND item.sp_cost > 0', self.data_id).map{|item| item.count * item.sp_cost}.sum
      self.save!
    end
    return self.sp_cost
  end
  ## Method to return the ingredients associated with this recipe.
  def items
    return Item.select('item.*, recipe_ingredient.count').joins("JOIN recipe_ingredient ON recipe_ingredient.item_id = item.data_id").where("recipe_ingredient.recipe_id = ?", self.data_id).order('count desc')
  end
  ## Method to return the associated end product.
  def resultItem
    return Item.where(:data_id => result_item_id).first
  end
end
