require_relative "restaurant"

class Guide
	class Config
		@@actions = ["list", "find", "add" , "quit"]
		def self.actions
			@@actions
		end
	end

	def initialize(path = nil)
		Restaurant.filepath= path
		if Restaurant.file_exists?
			puts "found restaurant file"
		elsif Restaurant.create_file
			puts "created restaurant file"
		else
			puts "exiting..."
			exit!
		end
	end
	
	def launch!
		introduction

		result = nil
		until result == :quit
			action , args = get_action
			result = do_action(action,args)
		end
		conclution
	end

	def get_action
		action = nil
		until Guide::Config.actions.include?(action)
			puts "action: " +Guide::Config.actions.join(", ")
			print "> "
			user_response = gets.chomp
			args = user_response.downcase.strip.split(" ")
			action = args.shift
		end
		return action,args
	end

	def do_action(action, args=[])
		case action
		when "list"
			list
		when "add"
			add
		when "find"
			keyword = args.shift
			find(keyword)
		when "quit"
			return :quit
		else
			puts "plase enter add/find/list or quit"
		end
	end

	def list
		puts "list of restaurants".center(20)
		restaurants = Restaurant.saved_restaurants
		output_rastaurant(restaurants)
		# puts "_"*63
		# restaurants.each do |restau|
			# puts "#{restau.name.center(20," ")}|#{restau.cuisine.center(20," ")}|#{restau.price.center(20," ")}"
			# puts "--------------------+--------------------+---------------------"
		# end
	end

	def add
		puts "add a restaurant."
		restaurant = Restaurant.new
		
		print "enter name: "
		restaurant.name = gets.chomp.strip.downcase
		
		print "enter cuisine type: "
		restaurant.cuisine = gets.chomp.strip.downcase

		print "enter price: "
		restaurant.price = gets.chomp.strip.downcase
		
		if restaurant.save
			puts "restaurant added"
		else
			puts "save error: can't add restaurant"
		end
	end

	def find(keyword="")
		puts "find restaurant"
		if keyword 
			restaurants = Restaurant.saved_restaurants
			found = restaurants.select do |res|
				res.name.downcase.include?(keyword.downcase) ||
				res.cuisine.downcase.include?(keyword.downcase) ||
				res.price.to_i == keyword.to_i
			end
			output_rastaurant(found)
		else
			puts "find using a key phrase to search."
		end
	end

	def output_rastaurant(restaurants=[])
		print " " + "name".center(20)
		print " " + "cuisine".center(20)
		print " " + "price".center(20) +"\n"
		puts "-" * 60
		restaurants.each do |res|
			line= " " << res.name.center(20)
			line << " " + res.cuisine.center(20)
			line << " " + res.price.center(20)
			puts line
		end
		puts "no list found" if restaurants.empty?
		puts "-" * 60
	end

	def introduction
		puts "hi welcome to the food finder"
		puts "it was guide to help you find best food."
	end

	def conclution
		puts "good bye"
	end

end