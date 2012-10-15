class CraftController < ApplicationController
  helper_method :sort_column, :sort_direction
  ## Index Method to gather data for display
  def index
  ## Discipline_id > 0 ;; Using discipline_id = 0 for Mystic Forge recipes,
  ##	so this selects non-Mystic Forge recipes only.
    @recipe = Craft.where("discipline_id > 0").search(params[:search]).order(sort_column + ' ' + sort_direction).page(params[:page])

  ## UpdateTimer ;; To update the Recipe Listings table at most once every 
  ##    5 minutes.
    ut = UpdateTimer.where(:id => 0).first

      @recipe.each do |recipe|
	## recipe.bulk ;; Bulk attribute storage variable to reduce queries
	##    during rendering.
        recipe.bulk = { :cost => recipe.get_cost,
			:sell_value => recipe.resultItem.sellprice,
			:count => recipe.count  }

        if ut.craft_listings < 5.minutes.ago
	  ## Listing::Recipe_Listing.new ;; Store current profitability info.
	  listing = Listing::Recipe_Listing.new
	  listing.recipe_id = recipe.data_id
	  listing.cost = recipe.get_cost
	  listing.sell_value = recipe.resultItem.sellprice
	  listing.profit = (recipe.resultItem.sellprice*0.85 - recipe.get_cost).floor
	  listing.listing_datetime = DateTime.now
	  listing.save!
	  ## Reset the last updated time to now.
          ut.craft_listings = DateTime.now
	  ut.save!
        end
      end
  end

  ## Item ;; Graph handler for the individual recipes.
  def item
    ## recipe_info ;; Get profitability info for passed recipe id.
    recipe_info = Listing::Recipe_Listing.where(:recipe_id => params[:recipe]).where('listing_datetime > ?',4.days.ago).order('listing_datetime ASC')
    ## Setting the options for the new Highchart graph.
    @h = LazyHighCharts::HighChart.new('graph') do |f|
	f.options[:chart][:defaultSeriesType] = "line"
	## We won't use a title because the graph appears underneath the
	##    relevant listing.
	f.title(:text => '') 
	## Multiplying the datetime values to millisecond-format to make them
	##    play nicely with the chart.
	f.series(:name => 'Profit', :data => recipe_info.map { |c| [c.listing_datetime.to_f*1000, c.profit]}, :yAxis => 1)
	f.series(:name => 'Cost', :data => recipe_info.map { |c| [c.listing_datetime.to_f*1000, c.cost]})
	f.series(:name => 'Sale Price', :data => recipe_info.map { |c| [c.listing_datetime.to_f*1000, c.sell_value]})
	## Datetime horizontal axis, monetary vertical axes.
	f.xAxis(:type => :datetime)
	f.yAxis([{ :title => { :text => 'Cost & Sell Value' } }, { :title => { :text => 'Profit' }, :opposite => true}])
    end
  end
  private
  ## Helper functions for AJAX table sorting.
  def sort_column
    Craft.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
