require 'rails_helper'

RSpec.describe "homes/index", type: :view do
  let(:user) { create(:user) }
  
  before do
    homes = [
      create(:home, 
        address: "123 Test St",
        city: "Test City",
        state: "Test State",
        created_by: user
      ),
      create(:home,
        address: "456 Test Ave",
        city: "Test City",
        state: "Test State",
        created_by: user
      )
    ]
    # Mock pagination using Kaminari
    @homes = Kaminari.paginate_array(homes).page(1).per(8)
    assign(:homes, @homes)
    
    mock_current_user(user)
  end

  it "renders a list of homes" do
    render
    
    expect(rendered).to match(/Test City/)
    expect(rendered).to match(/Test State/)
  end

  it "renders the new home link" do
    render
    expect(rendered).to match(/New Home/i)
  end
end 