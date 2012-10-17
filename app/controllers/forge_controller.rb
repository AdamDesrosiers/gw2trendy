class ForgeController < ApplicationController
  helper_method :sort_column, :sort_direction
  ## Index ;; Default page method to gather information for display.
  def index
    ## Default filter to Transmute-style recipes with Random outcome.
    params[:filter] ||= "random"
    params[:filter] == "random" ?
	## Load the appropriate category of Mystic Forge Recipes
	##    (Random vs Static outcome)
	@recipe = Craft.where(:discipline_id => 0).where("result_min_qty IS NOT NULL").search(params[:search]).order(sort_column + ' ' + sort_direction).page(params[:page]) :
	@recipe = Craft.where(:discipline_id => 0).where("result_min_qty IS NULL").search(params[:search]).order(sort_column + ' ' + sort_direction).page(params[:page])
    ## UpdateTimer to only do bulk-update once per 5 minute interval.
    ut = UpdateTimer.first

    @recipe.each do |recipe|
    ## recipe.bulk ;; Holds information to reduce repeated queries
    ##    during view rendering.
	recipe.bulk = { :min_qty => recipe.result_min_qty,
			:max_qty => recipe.result_max_qty,
			:cost => recipe.get_cost,
			:sell_value => recipe.resultItem.sellprice,
			:count => recipe.count,
			:sp => recipe.sp}
	## Check the appropriate timer for bulk-update
	## TODO: Find a better solution that will work properly with pagination
	##       and doesn't waste time on user's page load.
        if (params[:filter] == "random" && ut.random_listings < 5.minutes.ago)||
           (params[:filter] == "static" && ut.static_listings < 5.minutes.ago) 
          listing = Listing::Recipe_Listing.new
          listing.recipe_id = recipe.data_id
	  recipe.update_cost
	  listing.cost = recipe.get_cost
  	  listing.sell_value = recipe.resultItem.sellprice*recipe.count
	  listing.profit = (recipe.resultItem.sellprice*recipe.count*0.85 - recipe.get_cost).floor
	  listing.listing_datetime = DateTime.now
	  listing.profit_per_sp = ((recipe.resultItem.sellprice*recipe.count*0.85 - recipe.get_cost)/recipe.sp).floor if recipe.sp > 0
	  listing.save!
        end
      end
   if (params[:filter] == "random" && ut.random_listings < 5.minutes.ago)||
      (params[:filter] == "static" && ut.static_listings < 5.minutes.ago) 
      ## Update the appropriate timer that was used.
      ut.random_listings = DateTime.now if params[:filter] == "random"
      ut.static_listings = DateTime.now if params[:filter] == "static"
      ut.save!
   end  
  end
  ## Item ;; Function for handling graphing of individual recipe data.
  def item
    ## Get relevant recipe historical data.
    recipe_info = Listing::Recipe_Listing.where(:recipe_id => params[:recipe]).where('listing_datetime > ?',4.days.ago).order('listing_datetime ASC')
    ## Set options for new Highchart.
    @h = LazyHighCharts::HighChart.new('graph') do |f|
	f.options[:chart][:defaultSeriesType] = "line"
	## We're not using a title because the graph will sit underneath
	##    the relevant recipe.
	f.title(:text => '')
	## Multiplying datetime by 1000 to be compatible with Highcharts
	f.series(:name => 'Profit', :data => recipe_info.map { |c| [c.listing_datetime.to_f*1000, c.profit]}, :yAxis => 1)
	f.series(:name => 'Cost', :data => recipe_info.map { |c| [c.listing_datetime.to_f*1000, c.cost]})
	f.series(:name => 'Sale Price', :data => recipe_info.map { |c| [c.listing_datetime.to_f*1000, c.sell_value]})
	if params[:filter] == "random"
	## Extra series for SkillPoint-using recipes
	## TODO: Check passed params to ensure [:filter] is being passed,
	##       because this is currently not displayed.
	  f.series(:name => 'Profit per SP', :data => recipe_info.map { |c| [c.listing_datetime.to_f*1000, c.profit_per_sp]}, :yAxis => 1)
	end
	## Datetime horizontal axis, Monetary left and right vertical axes
	f.xAxis(:type => :datetime)
	f.yAxis([{ :title => { :text => 'Cost & Sale Price' }}, { :title => { :text => 'Profit' }, :opposite => true }])
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
