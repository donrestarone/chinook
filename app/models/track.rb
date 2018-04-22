class Track < ApplicationRecord
	
	belongs_to :album
	belongs_to :artist
	belongs_to :genre
	belongs_to :media_type
	has_and_belongs_to_many :playlists


	SHORT = 180000
	LONG = 360000

	
	# def self.starts_with(char)
	# 	where('name ILIKE ?', "#{char}%")
	# end
	#shorten the above start_with
	validates :name, :composer, :milliseconds, :bytes, :unit_price, presence: true
	
	validates :milliseconds, :bytes, numericality: {
		only_integer: true, 
		greater_than: 0
	}

	validates :unit_price, numericality: {
		greater_than_or_equal_to: 0.0
	}

	#custom validator!!
	validate :name_must_be_capitalized



	scope :starts_with, -> (char) { where('name ILIKE ?', "#{ char }%") }
	

	def self.short
		#where('milliseconds < ?', SHORT)
		shorter_than(SHORT)
	end 

	def self.long
		#where('milliseconds >= ?', LONG )
		longer_than_or_equal_to(LONG)
	end 

	def self.medium 
		longer_than_or_equal_to(SHORT).shorter_than(LONG)
		#where('milliseconds >= ?', SHORT).where('milliseconds < ?', LONG)
		#where('milliseconds >= ? AND milliseconds < ?', 180000, 360000)
	end 

	# def self.shorter_than(milliseconds)
	# 	if (milliseconds && milliseconds > 0)
	# 		where('milliseconds < ?', milliseconds)
	# 	else 
	# 		all
	# 	end
	# end 
	#the above is the same as:
	scope :shorter_than, -> (milliseconds) {
		if (milliseconds && milliseconds > 0)
	 		where('milliseconds < ?', milliseconds)
	 	end
	}

	def self.longer_than_or_equal_to(milliseconds)
		if (milliseconds && milliseconds > 0)
			where('milliseconds >= ?', milliseconds)
		else
			all
		end
	end 
 
	scope :rock, -> { where(genre_id: 1) }
	#to search for all rock songs. Hash style search. the above are array style searches

	private 

		def name_must_be_capitalized
			#step 1- make sure there is a name, if not dont run this method
			return unless name.present?
			#step 2 - check the first char is an uppercase letter
			first_char = name[0]
			first_char_is_not_upcased = (first_char != first_char.upcase)
			#step 3 - if the first character is not uppercase, add an error
			if first_char_is_not_upcased
				errors.add(:name, 'must be capitalized!!')
			end
		end
end
