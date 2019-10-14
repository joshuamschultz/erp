UNASSIGNED = "Unassigned"
COMPANY_NAME = CompanyInfo.first.try(:company_name)
if Rails.env == 'production'
	DOMAIN_NAME = 'http://erp.chessgroupinc.com'
elsif Rails.env == 'staging'
	DOMAIN_NAME = 'http://staging.chessgroupinc.com'
else
	DOMAIN_NAME = 'http://localhost:3000'
end