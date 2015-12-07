class MovieList
  FIELDS = [:url, :name, :year, :country, :release_date, :genre, :duration, :rating, :director, :stars]

  attr_reader :films

  def initialize(filename = 'movies.txt')
    @films = []

    begin
      @films = CSV.read('movies.txt', col_sep: '|', headers: FIELDS).map { |line| Movie.new(line.to_hash) }
    rescue
      # puts $!
      puts "File not found: #{filename}"
    end
  end


  def find string
    @films.select { |film| film.name.include? string }
  end


  def long_films quantity = 5
    @films
      .sort_by { |film| film.duration.to_i }
      .reverse
      .first(quantity)
  end


  def by_genre genre
    @films
      .select { |film| film.has_genre? genre }
      .sort_by(&:release_date)
  end


  def directors
    @films
      .map do |film|
        ar = film.director.split
        name = ar.shift
        ar.push(name).join(' ')
      end.uniq.sort
  end


  def except_country country
    @films.reject { |film| film.country?(country) }
  end
end