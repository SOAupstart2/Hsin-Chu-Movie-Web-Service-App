require 'virtus'
require 'active_model'

# String attribute for form objects of TutorialForm
class StringStripped < Virtus::Attribute
  def coerce(value)
    value.is_a?(String) ? value.strip : nil
  end
end

# Form object
class UserForm
  include Virtus.model
  include ActiveModel::Validations

  attribute :language, StringStripped
  attribute :location, StringStripped
  attribute :movie_name, StringStripped
  attribute :search_time

  validates :language, presence: true
  validates :location, presence: true
  validates :search_time, presence: true
end
