class Movie < ActiveRecord::Base
    def self.all_ratings
        ['G','PG','PG-13','R'] #simple definition of allowed ratings
    end
    def self.with_ratings(ratings)
       Movie.where(rating: ratings) #simple getter function
    end
end
