require 'test_helper'

class CraftTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Craft CRUD test" do
    assert (c = Craft.new(:name => 'Test Recipe')), "Check Craft class definition, .new has failed"
    assert (c.save!), "Check database structure, Craft .save has failed"
    assert (Craft.where(:name => 'Test Recipe')), "Check database structure, retrieve failed"
    assert (c.delete), "Check Craft class definition, .delete has failed"
  end

  test "Items table is selectable and has stuff" do
    assert (Item.all.size > 10), "Check item.yml, it is not generating enough data"
  end

  test "resultItem return correct" do
    i = Item.all.first
    c = Craft.new
    c.result_item_id = i.data_id
    assert_equal(c.resultItem, i, "resultItem returned incorrect Item object")
  end
 
  test "resultItem with item id 0" do
    c = Craft.new
    c.result_item_id = 0
    assert !c.resultItem, "resultItem returned an object when item id was 0"
  end

  test "resultItem with nil result_item_id" do
    assert !Craft.new.resultItem, "resultItem returned an object when item id was nil"
  end
  
  test "clone test" do
    p = Item.where('data_id >= (SELECT FLOOR(MAX(data_id) * RAND()) FROM `item`)').order('data_id asc').first
    q = p.clone
    assert_equal(q,p,"CLONE is not performing a perfect copy")
    begin 
	p = Item.where('data_id >= (SELECT FLOOR(MAX(data_id) * RAND()) FROM `item`)').order('data_id asc').first
    end while p == q
    r = p.clone
    assert_equal(r,p,"CLONE is not performing a perfect copy")
    assert !(r==q), "Check this test case, it might be broken"
  end
  
  test "items, cost, SP on recipe with N components" do
#    ActiveRecord::Base.logger = Logger.new(STDOUT)

    a = []
    for i in 0..5 do
        sp = 0
	cost = 0
	a << []
	r = Craft.new(:name => i.to_s)
	assert r.save!, "Generated recipe could not be saved to the database!"
	for x in 1..i do
	  item = Item.where('data_id >= (SELECT FLOOR(MAX(data_id) * RAND()) FROM `item`)').order('data_id asc').first
          assert Ingredient.new(:recipe_id => r.data_id, :item_id => item.data_id).save!, "Generated ingredient could not be saved to the database!"
          sp += item.sp_cost if item.sp_cost > 0
	  cost += item.max_offer_unit_price
	  a[i] << item.clone
        end
	assert_equal(r.update_cost, cost, "Result of Craft.update_cost did not match calculated value")
        assert_equal(r.sp, sp, "Result of Craft.sp did not match calculated value")
        assert_equal(r.items,a[i],"Result of Craft.items did not match array of items on pass #{i}")
    end
  end

end
