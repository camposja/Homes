require 'rails_helper'

RSpec.describe "homes/show", type: :view do
  let(:user) { create(:user) }
  let(:home) do
    create(:home,
      address: "123 Test St",
      city: "Test City",
      state: "Test State",
      zip: "12345",
      bedrooms: 3,
      baths: 2,
      square_feet: 1500,
      price: 250000,
      description: "A test home",
      created_by: user
    )
  end

  before do
    assign(:home, home)
    mock_current_user(user)
  end

  it "renders home attributes" do
    render
    
    expect(rendered).to match(/Test City/)
    expect(rendered).to match(/Test State/)
    expect(rendered).to match(/12345/)
    expect(rendered).to match(/3/)  # bedrooms
    expect(rendered).to match(/2/)  # baths
    expect(rendered).to match(/1500/)  # square_feet
    expect(rendered).to match(/\$250,000/)  # price with currency symbol
    expect(rendered).to match(/A test home/)
  end

  it "renders edit and back links" do
    render
    expect(rendered).to match(/Edit/i)
    expect(rendered).to match(/Back/i)
  end
end 