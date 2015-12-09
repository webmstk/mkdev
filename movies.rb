require 'csv'
require 'date'
require './movie'
require './movie_list'
require './my_movie_list'

def print_header(header)
  puts "\n***** #{header} *****\n\n"
end

def print_movies(movies, header = nil)
  print_header(header) if header

  movies.each do |movie|
    puts "Movie: \"#{movie.name}\", #{movie.country}, #{movie.year}, (#{movie.genre.join(', ')})"
    puts "Rating IMDB: #{movie.rating_to_stars}"
    puts "Director: #{movie.director}"
    puts "Stars: #{movie.stars.join(', ')}"
    puts "Duration: #{movie.duration}"
    puts "Release date: #{movie.release_date}"
    puts "\n"
  end
end

def print_directors(directors, header = nil)
  print_header(header) if header
  print directors.join(', ')
end

def print_count_movies(movies, header = nil)
  print_header(header) if header
  puts "Found: #{movies.count} movie(s)"
end

def print_by_director(movies, header = nil)
  print_header(header) if header

  print movies
            .group_by(&:director)
            .sort
            .map { |director, movies| "#{director}: #{movies.count}" }
            .join(', ')
end

def print_by_months(movies, header = nil)
  print_header(header) if header

  movies
      .map(&:release_date)
      .reject { |date| date.count('-') < 1 }
      .map { |date| Date.strptime(date, '%Y-%m') }
      .group_by(&:month)
      .sort
      .each { |month, dates| puts "#{Date::MONTHNAMES[month.to_i]}: #{dates.count} movie(s)" }
end

def print_rec(movies, header = nil)
  print_header(header) if header

  movies.each do |movie|
    puts '-' * 100
    puts movie.description
    puts '-' * 100
  end
end


# EXECUTE

# list = MovieList.new
# print_movies(list.find('Time'), 'Search "Time"')
# print_movies(list.long_movies, 'The Longest Movies')
# print_movies(list.by_genre('Comedy'), 'Comedy list')
# print_directors(list.directors, 'Directors list')
# print_count_movies(list.except_country('USA'), 'Movies was made not in USA')
# print_by_director(list.movies, 'Movies grouped by director')
# print_by_months(list.movies, 'Movies grouped by month')


# mylist = MyMovieList.new
#
# movies_seen = [
#     {name: 'The Good, the Bad and the Ugly', myrating: 9},
#     {name: 'Fight Club', myrating: 10},
#     {name: 'Goodfellas', myrating: 5},
#     {name: 'Bicycle Thieves', myrating: 1},
#     {name: 'Full Metal Jacket', myrating: 2},
#     {name: 'Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb', myrating: 3},
# ]
#
# mylist.watch_movie('The Godfather', 7, Date.new(2004, 10))
# mylist.watch_movie('The Dark Knight', 8, Date.new(2003, 3))
# mylist.watch_movies(movies_seen)
#
# print_rec(mylist.recommend_movies, 'ПОСМОТРИТЕ СЕГОДНЯ ВЕЧЕРОМ!')
# print_rec(mylist.recommend_movies_seen, 'ФИЛЬМЫ, КОТОРЫЕ СТОИТ ПОСМОТРЕТЬ НЕ РАЗ!')



# LESSON 7

list = MovieList.new


# print

# list.print { |movie| "#{movie.year}: #{movie.title}" }
# list.print


# sort by

# movies = list.sorted_by { |movie| [movie.genre, movie.year] }
# print_movies(movies)


# sort by algo

# list.add_sort_algo(:genres_years) { |movie| [movie.genre, movie.year] }
# movies = list.sorted_by(:genres_years)
# print_movies(movies)



# set filters

# list.add_filter(:rating) { |movie, rating| movie.rating > rating }
# list.add_filter(:genres) do |movie, *genres|
#   match = false
#   genres.each { |genre| match = true if movie.genre.include?(genre) }
#   match
# end
# list.add_filter(:years) { |movie, from, to| (from..to).include?(movie.year) }


# filter

# movies = list.filter(
#     rating: 8.2,
#     genres: ['Comedy', 'Thriller'],
#     years: [2005, 2010]
# )

# print_movies(movies)