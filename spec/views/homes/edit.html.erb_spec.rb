require 'rails_helper'

RSpec.describe "homes/edit", type: :view do
  let(:user) { create(:user) }
  let(:home) do
    create(:home,
      address: "123 Test St",
      city: "Test City",
      state: "Test State",
      created_by: user
    )
  end

  before do
    assign(:home, home)
    mock_current_user(user)
  end

  it "renders edit home form" do
    render

    assert_select "form[action=?][method=?]", home_path(home), "post" do
      assert_select "input[name=?]", "home[address]"
      assert_select "input[name=?]", "home[city]"
      assert_select "input[name=?]", "home[state]"
      assert_select "input[name=?]", "home[zip]"
      assert_select "input[name=?]", "home[bedrooms]"
      assert_select "input[name=?]", "home[baths]"
      assert_select "input[name=?]", "home[square_feet]"
      assert_select "input[name=?]", "home[price]"
      assert_select "textarea[name=?]", "home[description]"
    end
  end

  it "renders show and back links" do
    render
    expect(rendered).to match(/Show/i)
    expect(rendered).to match(/Back/i)
  end
end 