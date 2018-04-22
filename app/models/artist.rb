class Artist < ApplicationRecord
	
	has_many :albums
	has_many :tracks, through: :albums
	has_many :media_types, through: :tracks
	

	validates :name, presence: true
	
end
