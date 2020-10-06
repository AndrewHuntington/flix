module MoviesHelper
  def total_gross(movie)
    if movie.flop?
      "Flop!"
    elsif movie.upcoming?
      "Not Yet Released"
    else
      number_to_currency(movie.total_gross, precision: 0)
    end
  end

  def year_of(movie)
    movie.released_on.year
  end

  def nav_link_to(name, path)
    if current_page?(path)
      link_to name, path, class: 'active'
    else
      link_to name, path
    end
  end

  # def average_stars(movie)
  #   if movie.average_stars.zero?
  #     content_tag(:strong, 'No reviews')
  #   else
  #     # Display the star rating with astrisks
  #     '*' * movie.average_stars.round
      
  #     # Display the star rating with text
  #     # pluralize(number_with_precision(movie.average_stars, precision: 1),'star')
  #   end
  # end
end
