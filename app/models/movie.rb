class Movie < ActiveRecord::Base


  def self.with_ratings(ratings_list)
  return all if ratings_list.empty? || ratings_list == 0
  keys = ratings_list.keys
  where(rating: keys)
  end

  def self.all_ratings
    @ratings = ['G','PG','PG-13','R']
  end


  def self.ratings_to_show
    @checked_ratings = Array.new()
  end

end
