class Movie
  attr_accessor :url, :name, :year, :country, :release_date, :genre, :duration, :rating, :director, :stars

  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end
end