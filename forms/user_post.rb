require 'virtus'
require 'active_model'

##
# String attribute for form objects of TutorialForm
class StringStripped < Virtus::Attribute
  def coerce(value)
    value.is_a?(String) ? value.strip : nil
  end
end

##
# Form object
class UserForm
  include Virtus.model
  include ActiveModel::Validations

  attribute :language, StringStripped
  attribute :location, StringStripped

  validates :language, presence: true
  validates :location, presence: true

  def error_fields
    errors.messages.keys.map(&:to_s).join(', ')
  end
end