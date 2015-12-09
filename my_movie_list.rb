class MyMovieList < MovieList
  attr_accessor :movies_seen

  def initialize(filename = 'movies.txt')
    @movies = read_file(filename)
  end


  def read_file filename
    @movies = []

    begin
      @movies = CSV.read(filename, col_sep: '|', headers: FIELDS).map do |line|
        classify_movie(line.to_hash)
      end
    rescue
      puts "File not found: #{filename}"
    end
  end


  def classify_movie movie
    case movie[:year].to_i
      when 1900..1944
        AncientMovie.new(self, movie)
      when 1945..1969
        ClassicMovie.new(self, movie)
      when 1968..1999
        ModernMovie.new(self, movie)
      when 2000..Date::today.year
        NewMovie.new(self, movie)
      else
        raise 'error in parsing data'
    end
  end


  def watch_movies(movies)
    movies.each { |movie| watch_movie(movie[:name], movie[:myrating]) }
  end


  def watch_movie(name, myrating, date_seen = Date::today)
    movie = find_by_name(name)

    movie.myrating = myrating
    movie.date_seen = date_seen
  end


  def recommend_movies
    @movies
        .select(&:watched?)
        .sort_by { |movie| movie.class::PREFERENCE * movie.rating.to_f * rand }
        .first(5)
  end


  def recommend_movies_seen
    @movies
        .reject(&:watched?)
        .sort_by do |movie|
      date_koef = movie.date_seen.to_s.delete('-').to_i
      movie.class::PREFERENCE * movie.myrating * rand / date_koef
    end
        .first(5)
  end
end