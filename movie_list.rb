class MovieList
  Fields = [:url, :name, :year, :country, :release_date, :genre, :duration, :rating, :director, :stars]

  def initialize(filename = 'movies.txt')
    films = []

    begin
      CSV.foreach('movies.txt', col_sep: '|', headers: Fields) { |line|
        films.push Movie.new(line.to_hash)
      }
    rescue
      puts $!
      puts "File not found: #{filename}"
    end

    @films = films
  end


  def films
    @films
  end


  def find_film(find)
    return if @films.empty?

    puts "\nFilms found:\n\n"

    @films
      .select { |film| film.name.include? find }
      .each do |film|
        rating = '*' * film.rating[-1].to_i
        p "#{film.name} #{rating}"
    end

    puts "\n"
  end


  def show_long_films(quantity = 5)
    return if @films.empty?

    puts "\nTop-#{quantity} of the longest movies:\n\n"

    @films
      .sort_by { |film| film.duration.to_i }.reverse
      .first(quantity).each { |film| puts "#{film.name} (#{film.duration})" }

    puts "\n"
  end


  def show_by_genre(genre)
    return if @films.empty?

    puts "\n#{genre}-genre films:\n\n"

    @films
      .select { |film| film.genre.include? genre }
      .sort_by(&:release_date)
      .each { |film| puts "#{film.name}, genre: #{film.genre}, (#{film.release_date})" }

    puts "\n"
  end


  def show_directors
    return if @films.empty?

    puts "\nDirectors list:\n\n"

    puts @films
      .map(&:director)
      .uniq.sort_by { |director| director.split.last }

    puts "\n"
  end


  def show_directors_by_lastname
    return if @films.empty?

    puts "\nDirectors list (2-nd variant):\n\n"

    # directors = films.map do |film| film[:director].split.reverse.join(' ') }
    puts @films
      .map { |film|
        ar = film.director.split
        name = ar.shift
        ar.push(name).join(' ')
      }.uniq.sort

    puts "\n"
  end


  def show_not_usa_films
    return if @films.empty?

    films = @films.reject { |film| film.country == 'USA' }
    puts "\nFilms was made not in USA: #{films.count}\n"
  end


  def group_by_director
    return if @films.empty?

    puts "\nGrouped by Director:\n\n"

    @films
      .group_by(&:director)
      .sort
      .each { |director, films| puts "#{director}: #{films.count}" }
    
    puts "\n"
  end


  def count_films_by_actors
    return if @films.empty?

    puts "\nCount films for each actor:\n\n"

    stars = {}
    @films.each do |film|
      film.stars.rstrip.split(',').each do |star|
        unless stars.has_key? star
          stars[star] = films.reduce(0) { |memo, film| film.stars.include?(star) ? memo + 1 : memo }
          puts "#{star}: #{stars[star]} film(s)"
        end
      end
    end

    puts "\n"
  end


  def films_by_months
    return if @films.empty?

    puts "\nFilms by month:\n\n"

    @films
      .map(&:release_date)
      .reject { |date| date.count('-') < 1 }
      .map { |date| Date.strptime(date, '%Y-%m') }
      .group_by(&:month)
      .sort
      .each { |month, dates| puts "#{Date::MONTHNAMES[month.to_i]}: #{dates.count}" }
    puts "\n"
  end
end