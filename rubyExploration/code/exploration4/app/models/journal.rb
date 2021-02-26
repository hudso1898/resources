class Journal < ActiveRecord::Base
	validates :title, presence: true, length: { minimum: 6 }
	validates :date, presence: true, format: { 
		  with: /\A[0-9]{2}\/[0-9]{2}\/[0-9]{4}\z/ }
	validates :content, presence: true, length: { maximum: 100 }
end
