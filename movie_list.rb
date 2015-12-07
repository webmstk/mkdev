class MovieList
  FIELDS = [:url, :name, :year, :country, :release_date, :genre, :duration, :rating, :director, :stars]

  attr_reader :films

  def initialize(filename = 'movies.txt')
    read_file(filename)
  end


  def read_file filename
    @films = []

    begin
      @films = CSV.read(filename, col_sep: '|', headers: FIELDS).map { |line| Movie.new(self, line.to_hash) }
    rescue
      puts "File not found: #{filename}"
    end
  end


  def find string
    @films.select { |film| film.name.downcase.include? string.downcase }
  end


  def find_by_name name
    @films.select { |film| return film if film.name.downcase.include? name.downcase }
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


  def by_director director
    @films.select { |film| film.director == director }
  end
end