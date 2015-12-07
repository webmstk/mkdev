class Movie
  PREFERENCE = 50
  attr_accessor :url, :name, :year, :country, :release_date, :genre, :duration, :rating, :director, :stars, :myrating, :date_seen

  def initialize(owner, args)
    @owner = owner
    args.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end

    @stars = @stars.split(',')
    @genre = @genre.split(',')

    @sort_date = case release_date.count('-')
                   when 2
                     Date.strptime(release_date, '%Y-%m-%d')
                   when 1
                     Date.strptime(release_date, '%Y-%m')
                   when 0
                     Date.strptime(release_date, '%Y')
                 end
                     .strftime('%m %B %Y')
  end


  def watched?
    date_seen.nil?
  end


  def has_genre?(g)
    genre.include? g
  end


  def rating_to_stars
    '*' * rating[-1].to_i
  end


  def country?(c)
    country == c
  end


  def description
    name
  end
end

class AncientMovie < Movie
  PREFERENCE = 20

  def description
    "#{name} - старый фильм (#{year} год)"
  end
end

class ClassicMovie < Movie
  PREFERENCE = 40

  def description
    director_films = @owner
                         .by_director(director)
                         .map(&:name)
    "#{name} - классика, режиссер #{director} (#{director_films.join(', ')})"
  end
end

class ModernMovie < Movie
  PREFERENCE = 60

  def description
    "#{name} - современное кино (в ролях: #{stars.join('; ')})"
  end
end

class NewMovie < Movie
  PREFERENCE = 100

  def description
    "#{name} - НОВЫЙ! (жанр: #{genre.join(', ')})"
  end
end