
class Restaurant
	attr_accessor :name, :price, :cuisine
	@@filepath = nil

	def self.filepath=(path=nil)
		@@filepath = File.join(APP_ROOT,path)
	end

	def self.file_exists?
		if @@filepath && File.exists?(@@filepath)
			return true
		else
			return false
		end
	end

	def self.file_useable?
		return false unless @@filepath
		return false unless File.exists?(@@filepath)
		return false unless File.readable?(@@filepath)
		return false unless File.writable?(@@filepath)
		return true
	end

	def self.create_file
		File.open(@@filepath, 'w') unless file_exists?
		return file_useable?
	end

	def self.saved_restaurants
		restaurants = []
		if file_useable?
			file = File.open(@@filepath, "r")
			file.each_line do |line|
				restaurants << Restaurant.new.import_line(line.chomp)
			end
			file.close			
		end
		return restaurants
	end

	def import_line(line)
		line_array = line.split("\t")
		@name,@cuisine,@price = line_array
		return self
	end

	def save
		return false unless Restaurant.file_useable?
		File.open(@@filepath, "a") do |file|
			file.puts("#{[@name,@cuisine,@price].join("\t")}")
		end
		return true
	end

end