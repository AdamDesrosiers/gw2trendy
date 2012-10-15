# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "buy_listing", :force => true do |t|
    t.datetime "listing_datetime", :null => false
    t.integer  "item_id",          :null => false
    t.integer  "listings",         :null => false
    t.integer  "unit_price",       :null => false
    t.integer  "quantity",         :null => false
  end

  add_index "buy_listing", ["item_id", "listing_datetime"], :name => "retrieve_by_date_time"

  create_table "discipline", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "forge", :force => true do |t|
    t.string  "name",           :limit => 45
    t.integer "item_1",                       :null => false
    t.integer "item_2",                       :null => false
    t.integer "item_3",                       :null => false
    t.integer "item_4",                       :null => false
    t.integer "item_1_qty",                   :null => false
    t.integer "item_2_qty",                   :null => false
    t.integer "item_3_qty",                   :null => false
    t.integer "item_4_qty",                   :null => false
    t.integer "result",                       :null => false
    t.integer "result_min_qty",               :null => false
    t.integer "result_max_qty",               :null => false
    t.integer "count",                        :null => false
    t.string  "forgecol",       :limit => 45
  end

  add_index "forge", ["item_1"], :name => "item_1_idx"
  add_index "forge", ["item_2"], :name => "item_2_idx"
  add_index "forge", ["item_3"], :name => "item_3_idx"
  add_index "forge", ["item_4"], :name => "item_4_idx"
  add_index "forge", ["result"], :name => "result_idx"

  create_table "gem_to_gold_rate", :primary_key => "rate_datetime", :force => true do |t|
    t.integer "rate",                :null => false
    t.integer "volume", :limit => 8, :null => false
  end

  create_table "gold_to_gem_rate", :primary_key => "rate_datetime", :force => true do |t|
    t.integer "rate",                :null => false
    t.integer "volume", :limit => 8, :null => false
  end

  create_table "gw2db_item_archive", :primary_key => "ID", :force => true do |t|
    t.integer "ExternalID"
    t.integer "DataID"
    t.string  "Name"
  end

  create_table "gw2session", :primary_key => "session_key", :force => true do |t|
    t.boolean  "game_session", :null => false
    t.datetime "created",      :null => false
    t.string   "source"
  end

  create_table "item", :primary_key => "data_id", :force => true do |t|
    t.integer  "type_id",                                                                     :null => false
    t.string   "name",                                                                        :null => false
    t.string   "gem_store_description",                                                       :null => false
    t.string   "gem_store_blurb",                                                             :null => false
    t.integer  "restriction_level",                                                           :null => false
    t.integer  "rarity",                                                                      :null => false
    t.integer  "vendor_sell_price",                                                           :null => false
    t.string   "img",                                                                         :null => false
    t.string   "rarity_word",                                                                 :null => false
    t.integer  "item_type_id"
    t.integer  "item_sub_type_id"
    t.integer  "max_offer_unit_price",                                                        :null => false
    t.integer  "min_sale_unit_price",                                                         :null => false
    t.integer  "offer_availability",                                         :default => 0,   :null => false
    t.integer  "sale_availability",                                          :default => 0,   :null => false
    t.decimal  "sp_cost",                      :precision => 3, :scale => 1, :default => 0.0, :null => false
    t.integer  "gw2db_external_id"
    t.datetime "last_price_changed"
    t.integer  "sale_price_change_last_hour",                                :default => 0
    t.integer  "offer_price_change_last_hour",                               :default => 0
  end

  add_index "item", ["item_sub_type_id"], :name => "item_FI_2"
  add_index "item", ["item_type_id"], :name => "item_FI_1"

  create_table "item_sub_type", :id => false, :force => true do |t|
    t.integer "id",           :null => false
    t.integer "main_type_id", :null => false
    t.string  "title",        :null => false
  end

  add_index "item_sub_type", ["main_type_id"], :name => "item_sub_type_FI_1"

  create_table "item_type", :force => true do |t|
    t.string "title", :null => false
  end

  create_table "recipe", :primary_key => "data_id", :force => true do |t|
    t.string   "name",                                                        :null => false
    t.integer  "discipline_id"
    t.integer  "result_item_id"
    t.integer  "count",                                        :default => 1
    t.integer  "cost"
    t.integer  "sell_price"
    t.integer  "profit"
    t.datetime "updated"
    t.integer  "result_min_qty"
    t.integer  "result_max_qty"
    t.decimal  "sp_cost",        :precision => 3, :scale => 1
  end

  add_index "recipe", ["discipline_id"], :name => "recipe_FI_1"
  add_index "recipe", ["result_item_id"], :name => "recipe_FI_2"

  create_table "recipe_ingredient", :id => false, :force => true do |t|
    t.integer "recipe_id",                :null => false
    t.integer "item_id",                  :null => false
    t.integer "count",     :default => 1, :null => false
  end

  add_index "recipe_ingredient", ["item_id"], :name => "recipe_ingredient_FI_2"

  create_table "recipe_listing", :force => true do |t|
    t.datetime "listing_datetime", :null => false
    t.integer  "recipe_id",        :null => false
    t.integer  "cost",             :null => false
    t.integer  "sell_value",       :null => false
    t.integer  "profit",           :null => false
    t.integer  "profit_per_sp"
  end

  create_table "sell_listing", :force => true do |t|
    t.datetime "listing_datetime", :null => false
    t.integer  "item_id",          :null => false
    t.integer  "listings",         :null => false
    t.integer  "unit_price",       :null => false
    t.integer  "quantity",         :null => false
  end

  add_index "sell_listing", ["item_id", "listing_datetime"], :name => "retrieve_by_date_time"

end
