module CommonActions

	def self.object_crud_paths(show_path, edit_path, delete_path, others = [])
		paths = "<a href='#{show_path}' class='btn btn-mini btn-success'>View</a> "
      	paths += "<a href='#{edit_path}' class='btn btn-mini btn-info'>Edit</a> "
      	paths += "<a href='#{delete_path}' class='btn btn-mini btn-danger' rel='nofollow' data-method='delete' data-confirm='Are you sure?'>Delete</a> "
		others.each do |other|
			paths += "<a href='#{other[:path]}' class='btn btn-mini btn-orange'>#{other[:name]}</a> "
		end
		paths
	end

	def self.process_application_shortcuts(shortcuts_html, shortcuts)
		shortcuts.each do |shortcut|
			unless shortcut[:drop_down]
				shortcuts_html += '<li><a class="'+ shortcut[:class] + '" href="' + shortcut[:path] + '"><i></i>' + shortcut[:name] + '</a>'
			else
				shortcuts_html += '<li class="dropdown submenu">'
				shortcuts_html += '<a href="' + shortcut[:path] + '" class="dropdown-toggle ' + shortcut[:class] + '" data-toggle="dropdown"><i></i>' + shortcut[:name] + '</a>'
				shortcuts_html += '<ul class="dropdown-menu submenu-show submenu-hide pull-left">'
					shortcuts_html += CommonActions.process_application_shortcuts('', shortcut[:sub_menu])
				shortcuts_html += '</ul>'
			end
		end
		shortcuts_html += '</li>' if shortcuts.count > 0
		shortcuts_html
	end

end