module CountriesHelper

	def create_if_not_found ( countryName )
		countryFound = Country.find_by( name: "#{countryName}" )
        if countryFound
          countryFound
        else
          countrycreated = Country.new
          countrycreated.name = countryName
          countrycreated.save
          countrycreated
        end
	end

end
