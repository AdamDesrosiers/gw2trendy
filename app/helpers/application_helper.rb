module ApplicationHelper
  ## A method for dynamically creating the appropriate AJAX link and CSS style
  ##    for the table header sorting.
  def sortable(title, column)
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end
  ## A method for changing an integer into a set of HTML tags resembling
  ##    the Guild Wars 2 in-game currency display.
  def coin(val = 0)
    result = ""
    negative = false;
   if val < 0
    result += "<span class='negative'>-"
     negative = true;
    val = val.abs
   end
   if val >= 10000
    result += "<span class='gold'>" unless negative
    result += (val/10000).floor.to_s
    result += image_tag('Gold_coin.png')
    result += "</span>" unless negative
    val = (val%10000).floor
   end
   if val >= 100
    result += "<span class='silver'>" unless negative
    result += (val/100).floor.to_s
    result += image_tag('Silver_coin.png')
    result += "</span>" unless negative
    val = (val%100).floor
   end
   result += "<span class='copper'>" unless negative
   result += val.to_s
   result += image_tag('Copper_coin.png')
   result += "</span>"
   return result  
  end
end
