module ViewSpecHelper
  def mock_current_user(user)
    without_partial_double_verification do
      allow(view).to receive(:current_user).and_return(user)
      allow(view).to receive(:logged_in?).and_return(true)
    end
  end
end

RSpec.configure do |config|
  config.include ViewSpecHelper, type: :view
  config.include ApplicationHelper, type: :view
  config.include HomesHelper, type: :view
end 