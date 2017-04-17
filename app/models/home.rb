class Home < ApplicationRecord
  include ImageUploader[:image]

  belongs_to :created_by, class_name: "User"
end
