class Country < ApplicationRecord
  validates :code, format: { with: /[a-z]{2}/ }, allow_blank: true
end
