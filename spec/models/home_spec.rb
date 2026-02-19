require 'rails_helper'

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
    let(:image_file) { File.open(Rails.root.join("spec/fixtures/test_image.jpg")) }

    after { image_file.close }

    it 'can attach an image' do
      home.image = image_file
      expect(home.image).to be_present
    end

    it 'stores image metadata' do
      home.image = image_file
      home.save!

      expect(home.image.metadata["filename"]).to eq("test_image.jpg")
      expect(home.image.metadata["size"]).to be > 0
    end

    it 'stores images in the database' do
      home.image = image_file
      home.save!

      # Verify image data is stored in the database
      stored = JSON.parse(home.image_data)
      expect(stored["id"]).to be_present
      expect(stored["storage"]).to be_present
      expect(stored["metadata"]).to be_present
    end
  end

  describe 'factory' do
    it 'creates a valid home' do
      expect(build(:home)).to be_valid
    end

    it 'creates a home with image' do
      home = create(:home, :with_image)
      expect(home.image).to be_present
    end
  end
end
