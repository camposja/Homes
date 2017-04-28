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
    where("address LIKE ? or city LIKE ? or state LIKE ? or zip LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
  end
end
