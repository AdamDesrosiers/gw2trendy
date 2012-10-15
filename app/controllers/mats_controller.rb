class MatsController < ApplicationController
  helper_method :sort_column, :sort_direction
  ## Index method to gather data for display on page.
  def index
    ## item_type_id => 5 ;; 5 signifies that it is a "Crafting Material"
    ## TODO: Rewrite this page as subsections for each item_type_id
    ##       For now this is functional since we're tracking mostly recipes.
    @mats = Item.where(:item_type_id => 5).search(params[:search]).page(params[:page]).order(sort_column + ' ' + sort_direction)
  end

  ## Item method for graphing individual items.
  def item
    ## Fetch Buy and Sell listing historical data for the passed item id.
    buy_info = Listing::Buy_Listing.where(:item_id => params[:item]).where('listing_datetime > ?',4.days.ago).order('listing_datetime ASC ')
    sell_info = Listing::Sell_Listing.where(:item_id => params[:item]).where('listing_datetime > ?',4.days.ago).order('listing_datetime ASC ')
    ## Set up the options for the new Highchart graph.
    @h = LazyHighCharts::HighChart.new('graph', :style => '') do |f|
	f.options[:chart][:defaultSeriesType] = "line"
	## We're not using a title here since the graph will sit below
	##    the item in question.
	f.title(:text => '')
	## Overriding colour #4 to be more visible on top of the area.
	## TODO: Find a better way to override this.
	f.colors(['#4572A7','#AA4643','#89A54E',"#9400D3"])
	## Using 'area' for the Unit based series to emphasize coporeality	
	f.series(:name => 'Supply', :type => 'area', :data => sell_info.map { |c| [c.listing_datetime.to_f*1000,c.quantity]}, :yAxis => 1)
	f.series(:name => 'Demand', :type => 'area', :data => buy_info.map { |c| [c.listing_datetime.to_f*1000,c.quantity]}, :yAxis => 1)
	f.series(:name => 'Buy Price', :data => buy_info.map { |c| [c.listing_datetime.to_f*1000,c.unit_price]}, :yAxis => 0)
        f.series(:name => 'Sell Price', :data => sell_info.map { |c| [c.listing_datetime.to_f*1000,c.unit_price]}, :yAxis => 0)
	## Datetime horizontal axis, monetary left vertical axis, Units right
	##    vertical axis.
	f.xAxis(:type => :datetime)
	f.yAxis([{ :title => { :text => 'Price'} },{ :title => { :text => 'Units'}, :opposite => true}])
	
    end
  end
  private
  ## Helper functions for AJAX table sorting.
  def sort_column
    Item.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
