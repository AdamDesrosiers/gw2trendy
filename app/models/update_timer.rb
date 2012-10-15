class UpdateTimer < ActiveRecord::Base
  ## Interface for the timestamp locks on the bulk-updates.
  ## TODO: Find a better solution to creating historical recipe data
  ##       that will make this class redundant.
  self.table_name = 'last_update'
end
