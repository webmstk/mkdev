require 'csv'
require 'date'
require 'ostruct'
require './movie'
require './movie_list'


# EXECUTE

list = MovieList.new
list.find_film('Time')
list.show_long_films
list.show_by_genre('Comedy')
list.show_directors
list.show_directors_by_lastname
list.show_not_usa_films
list.group_by_director
list.count_films_by_actors
list.films_by_months