module CommonActions

	def self.object_crud_paths(show_path, edit_path, delete_path, others = [])
		paths = "<a href='#{show_path}' class='btn btn-mini btn-success'>Show</a> "
      	paths += "<a href='#{edit_path}' class='btn btn-mini btn-info'>Edit</a> "
      	paths += "<a href='#{delete_path}' class='btn btn-mini btn-danger' rel='nofollow' data-method='delete' data-confirm='Are you sure?'>Delete</a> "
		others.each do |other|
			paths += "<a href='#{other[:path]}' class='btn btn-mini btn-orange'>#{other[:name]}</a> "
		end
		paths
	end

end