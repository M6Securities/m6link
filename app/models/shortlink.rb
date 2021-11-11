# frozen_string_literal: true

# shortlink model
class Shortlink < ApplicationRecord

  EXCLUDE_LIST = %w[app admin site].freeze

  validates :shortcut,
            presence: true,
            uniqueness: true
  validates :url,
            presence: true,
            uniqueness: true,
            format: {
              with: URL_REGEX,
              multiline: true,
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

    if EXCLUDE_LIST.include? shortcut
      generate_shortcut
    else
      shortcut
    end
  end

  def shortcut_url
    "https://#{ENV['SHORT_HOST_URL']}/#{shortcut}"
  end
end
