class Home < ApplicationRecord
  include ImageUploader::Attachment.new(:image)

  belongs_to :created_by, class_name: "User"

  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :bedrooms, numericality: { greater_than: 0 }
  validates :baths, numericality: { greater_than: 0 }
  validates :square_feet, numericality: { greater_than: 0 }

  after_commit :create_derivatives, on: [:create, :update]

  def create_derivatives
    if image.present?
      begin
        Rails.logger.info "Creating derivatives for home #{id}"
        attacher = image_attacher
        attacher.create_derivatives if attacher.stored?
        Rails.logger.info "Derivatives created successfully"
      rescue => e
        Rails.logger.error "Failed to create derivatives for home #{id}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  end

  def can_this_user_edit?(user)
    return created_by == user
  end

  def can_this_user_destroy?(user)
    return created_by == user
  end

  def self.search(search)
    where("address ILIKE ? or city ILIKE ? or state ILIKE ? or zip ILIKE ? or description ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%" , "%#{search}%")
  end
end
