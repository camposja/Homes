require 'rails_helper'
require 'stringio'

RSpec.describe Home, type: :model do
  describe 'validations' do
    subject { build(:home) }  # This will include the created_by association

    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:bedrooms).is_greater_than(0) }
    it { should validate_numericality_of(:baths).is_greater_than(0) }
    it { should validate_numericality_of(:square_feet).is_greater_than(0) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
  end

  describe 'image handling' do
    let(:home) { create(:home) }
    let(:image_data) do
      data = StringIO.new("fake image data")
      data.instance_eval do
        def original_filename; "test_image.jpg"; end
        def content_type; "image/jpeg"; end
      end
      data
    end

    it 'can attach an image' do
      home.image = image_data
      expect(home.image).to be_present
    end

    it 'stores image metadata' do
      home.image = image_data
      home.save
      
      expect(home.image.metadata["filename"]).to eq("test_image.jpg")
      expect(home.image.metadata["size"]).to be > 0
    end

    it 'stores images in the database' do
      home.image = image_data
      home.save
      
      # Verify image data is stored in the database
      image_data = JSON.parse(home.image_data)
      expect(image_data["id"]).to be_present
      expect(image_data["storage"]).to be_present
      expect(image_data["metadata"]).to be_present
    end
  end

  describe 'factory' do
    it 'creates a valid home' do
      expect(build(:home)).to be_valid
    end

    it 'creates a home with image' do
      home = create(:home)
      data = StringIO.new("fake image data")
      data.instance_eval do
        def original_filename; "test_image.jpg"; end
        def content_type; "image/jpeg"; end
      end
      home.image = data
      home.save
      expect(home.image).to be_present
    end
  end
end 