require 'rails_helper'

RSpec.describe "homes/new", type: :view do
  let(:user) { create(:user) }
  
  before do
    assign(:home, Home.new)
    mock_current_user(user)
  end

  it "renders new home form" do
    render

    assert_select "form[action=?][method=?]", homes_path, "post" do
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

  it "renders a back link" do
    render
    expect(rendered).to match(/Back/i)
  end
end 