class MyMovieList < MovieList
  attr_accessor :films_seen

  def initialize(filename = 'movies.txt')
    @films = read_file(filename)
  end


  def read_file filename
    @films = []

    begin
      @films = CSV.read(filename, col_sep: '|', headers: FIELDS).map do |line|
        classify_film(line.to_hash)
      end
    rescue
      puts "File not found: #{filename}"
    end
  end


  def classify_film film
    case film[:year].to_i
      when 1900..1944
        AncientMovie.new(self, film)
      when 1945..1969
        ClassicMovie.new(self, film)
      when 1968..1999
        ModernMovie.new(self, film)
      when 2000..Date::today.year
        NewMovie.new(self, film)
      else
        raise 'error in parsing data'
    end
  end


  def watch_films(films)
    films.each { |film| watch_film(film[:name], film[:myrating]) }
  end


  def watch_film(name, myrating, date_seen = Date::today)
    film = find_by_name(name)

    film.myrating = myrating
    film.date_seen = date_seen
  end


  def recommend_films
    @films
        .select(&:watched?)
        .sort_by { |film| film.class::PREFERENCE * film.rating.to_f * rand }
        .first(5)
  end


  def recommend_films_seen
    @films
        .reject(&:watched?)
        .sort_by do |film|
      date_koef = film.date_seen.to_s.delete('-').to_i
      film.class::PREFERENCE * film.myrating * rand / date_koef
    end
        .first(5)
  end
end