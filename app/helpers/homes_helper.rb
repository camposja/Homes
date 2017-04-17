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
end
