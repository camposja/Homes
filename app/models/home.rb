class Home < ApplicationRecord
  include ImageUploader[:image]

  belongs_to :created_by, class_name: "User"

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
