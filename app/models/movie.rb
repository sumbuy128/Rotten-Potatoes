class Movie < ActiveRecord::Base
  def self.all_ratings
   Array['G','PG','PG-13','R']
 end
end
