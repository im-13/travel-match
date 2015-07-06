class PaperclipImage 
	include Neo4j::ActiveNode
	property :created_at, type: DateTime
	property :updated_at, type: DateTime
	property :asset_file_name, type: String
	property :asset_content_type, type: String
	property :asset_file_size, type: Integer
	property :asset_updated_at, type: DateTime

end
