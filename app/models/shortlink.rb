# frozen_string_literal: true

# shortlink model
class Shortlink < ApplicationRecord

  EXCLUDE_LIST = %w[app admin].freeze

  validates :shortcut,
            presence: true,
            uniqueness: true
  validates :url,
            presence: true,
            format: {
              with: URL_REGEX,
              message: 'not a url'
            }
  validates :clicks,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0
            }

  def self.generate_shortcut
    # 5 digits long should be enough
    shortcut = SecureRandom.alphanumeric 5

    generate_shortcut if EXCLUDE_LIST.include? shortcut
  end

end
