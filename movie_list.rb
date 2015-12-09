class MovieList
  FIELDS = [:url, :name, :year, :country, :release_date, :genre, :duration, :rating, :director, :stars]

  attr_reader :movies

  def initialize(filename = 'movies.txt')
    read_file(filename)
    @sort_algo = {}
    @filter = {}
  end


  def read_file filename
    @movies = []

    begin
      @movies = CSV.read(filename, col_sep: '|', headers: FIELDS).map { |line| Movie.new(self, line.to_hash) }
    rescue
      puts "File not found: #{filename}"
    end
  end


  def find string
    @movies.select { |movie| movie.name.downcase.include? string.downcase }
  end


  def find_by_name name
    @movies.select { |movie| return movie if movie.name.downcase.include? name.downcase }
  end


  def long_movies quantity = 5
    @movies
        .sort_by { |movie| movie.duration.to_i }
        .reverse
        .first(quantity)
  end


  def by_genre genre
    @movies
        .select { |movie| movie.has_genre? genre }
        .sort_by(&:release_date)
  end


  def directors
    @movies
        .map do |movie|
      ar = movie.director.split
      name = ar.shift
      ar.push(name).join(' ')
    end.uniq.sort
  end


  def except_country country
    @movies.reject { |movie| movie.country?(country) }
  end


  def by_director director
    @movies.select { |movie| movie.director == director }
  end


  def print &block
    block ||= lambda { |movie| "#{movie.title}" }

    # @movies.each do |movie|
    #   puts block.call(movie)
    # end
    puts @movies.map(&block).join("\n")
  end


  def add_sort_algo(algo, &block)
    @sort_algo[algo] = block
  end


  def sorted_by(algo = nil, &block)
    # if @sort_algo.has_key? algo
    #   @movies.sort_by { |movie| @sort_algo[algo].call(movie) }
    # else
    #   @movies.sort_by(&block)
    # end

    sorter = case
               when algo
                 @sort_algo[algo] or raise("Unknown algo: #{algo}")
               when block
                 block
               else
                 raise('How can I sort this shit???')
             end

    @movies.sort_by(&sorter)
  end


  def add_filter(filter, &block)
    @filter[filter] = block
  end


  def filter filters
    filters.reduce(@movies) do |memo, (name, value)|
      # filter = @filter[name]
      # raise 'wrong filter' unless filter

      filter = @filter[name] or raise("Unknown filter: #{name}")

      memo.select { |movie| filter.call(movie, *value) }
    end
  end
end