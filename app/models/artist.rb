class Artist < ApplicationRecord
	
	has_many :albums
	has_many :tracks, through: :albums
	

	validates :name, presence: true
	
end
