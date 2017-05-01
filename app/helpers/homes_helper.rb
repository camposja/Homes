module HomesHelper
  def home_age_class(date)
    if date < 30.days.ago
      return "old-home"
    elsif date >= 2.days.ago
      return "new-home"
    else
      return "standard-home"
    end
  end

  def heart_class(home, user)
    # Does a favorite exist for THIS home and THIS user
    favorite = Favorite.find_by(home: home, user: user)

    if favorite
      "glyphicon-heart"
    else
      "glyphicon-heart-empty"
    end
  end
end
