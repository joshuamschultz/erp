class AccountController < ApplicationController
  
  def dashboard
	@menus[:dashboard][:active] = "active"

	# @name = "Sree"
	# html = render_to_string(:action => "tester", :layout => false)
	# kit = PDFKit.new(html)
	# # kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/test.css"
	# # file = kit.to_file("#{Rails.root}/public/test.pdf")
	# # send_data(kit.to_pdf, :filename => 'test.pdf', :type => 'application/pdf', :disposition  => "inline", :orientation => 'A4')
	# send_data(kit.to_pdf, :filename => 'test.pdf', :type => 'application/pdf', :disposition  => "inline")
  end

  def tester  		

  end

end
