class Activity < ApplicationRecord
  ACTIVITY_TYPES = %w[staff account artifact project].freeze

  acts_as_tenant(:organization)
  validates :description, presence: true

  ACTIVITY_TYPES.each do |activity_type|
    define_singleton_method("create_#{activity_type}_activity") do |parameters|
      self.create(activity_type: activity_type, description: parameters) if parameters.is_a?(String)
      self.create(activity_type: activity_type, **parameters) if parameters.is_a?(Hash)
    end
  end
end
