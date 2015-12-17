PDFKit.configure do |config|
	config.wkhtmltopdf = '/usr/local/bin/wkhtmltopdf' if Rails.env.production? 
  config.default_options[:ignore_load_errors] = true
config.wkhtmltopdf = `which wkhtmltopdf`.gsub(/\n/, '')
  config.default_options = {
    :encoding=>"UTF-8",
    :page_size=>"A4",
    :margin_top=>"0.5in",
    :margin_right=>"0.3in",
    :margin_bottom=>"0.5in",
    :margin_left=>"0.3in",
    :disable_smart_shrinking=> false
  }
end
