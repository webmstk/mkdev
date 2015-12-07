require 'csv'
require 'date'
require './movie'
require './movie_list'
require './my_movie_list'

def print_header(header)
  puts "\n***** #{header} *****\n\n"
end

def print_films(films, header = nil)
  print_header(header) if header

  films.each do |film|
    puts "Film: \"#{film.name}\", #{film.country}, #{film.year}, (#{film.genre.join(', ')})"
    puts "Rating IMDB: #{film.rating_to_stars}"
    puts "Director: #{film.director}"
    puts "Stars: #{film.stars.join(', ')}"
    puts "Duration: #{film.duration}"
    puts "Release date: #{film.release_date}"
    puts "\n"
  end
end

def print_directors(directors, header = nil)
  print_header(header) if header
  print directors.join(', ')
end

def print_count_films(films, header = nil)
  print_header(header) if header
  puts "Found: #{films.count} film(s)"
end

def print_by_director(films, header = nil)
  print_header(header) if header

  print films
            .group_by(&:director)
            .sort
            .map { |director, films| "#{director}: #{films.count}" }
            .join(', ')
end

def print_by_months(films, header = nil)
  print_header(header) if header

  films
      .map(&:release_date)
      .reject { |date| date.count('-') < 1 }
      .map { |date| Date.strptime(date, '%Y-%m') }
      .group_by(&:month)
      .sort
      .each { |month, dates| puts "#{Date::MONTHNAMES[month.to_i]}: #{dates.count} film(s)" }
end

def print_short(films)
  films.each do |film|
    puts "#{film.name} | #{film.class} | #{film.year} | #{film.rating_to_stars}"
  end
end

def print_rec(films, header = nil)
  print_header(header) if header

  films.each do |film|
    puts '-' * 100
    puts film.description
    puts '-' * 100
  end
end


# EXECUTE

# list = MovieList.new
# print_films(list.find('Time'), 'Search "Time"')
# print_films(list.long_films, 'The Longest Films')
# print_films(list.by_genre('Comedy'), 'Comedy list')
# print_directors(list.directors, 'Directors list')
# print_count_films(list.except_country('USA'), 'Films was made not in USA')
# print_by_director(list.films, 'Films grouped by director')
# print_by_months(list.films, 'Films grouped by month')


mylist = MyMovieList.new

films_seen = [
    {name: 'The Good, the Bad and the Ugly', myrating: 9},
    {name: 'Fight Club', myrating: 10},
    {name: 'Goodfellas', myrating: 5},
    {name: 'Bicycle Thieves', myrating: 1},
    {name: 'Full Metal Jacket', myrating: 2},
    {name: 'Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb', myrating: 3},
]

mylist.watch_film('The Godfather', 7, Date.new(2004, 10))
mylist.watch_film('The Dark Knight', 8, Date.new(2003, 3))
mylist.watch_films(films_seen)

print_rec(mylist.recommend_films, 'ПОСМОТРИТЕ СЕГОДНЯ ВЕЧЕРОМ!')
print_rec(mylist.recommend_films_seen, 'ФИЛЬМЫ, КОТОРЫЕ СТОИТ ПОСМОТРЕТЬ НЕ РАЗ!')