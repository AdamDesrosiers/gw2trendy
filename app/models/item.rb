class Item < ActiveRecord::Base
  ## Describes individual Items.
  self.table_name = 'item'
  self.primary_key = 'data_id'
  ## Associations not yet functional, pending database storage engine change.
  has_many :recipe_ingredient
  has_many :recipe, :through => :recipe_ingredient
  ## Some aliases for those really long column names.
  alias_attribute :buyprice, :max_offer_unit_price
  alias_attribute :sellprice, :min_sale_unit_price
  alias_attribute :buylist, :offer_availability
  alias_attribute :selllist, :sale_availability
  attr_accessible :offer_availability, :sale_availability
  ## TODO: Refactor existing functionality into methods contained here.
 
  ## Simple name-based search. 
  def self.search(search)
    if search
	where('name LIKE ?', "%#{search}%")
    else
	scoped
    end
  end
end
