# frozen_string_literal: true

# shortlink model
class Shortlink < ApplicationRecord

  EXCLUDE_LIST = %w[app admin site].freeze

  after_commit :cache_self
  after_destroy :destroy_cache_self

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

  def self.cache_key(shortcut)
    "shortlink_#{shortcut}"
  end

  def cache_key
    Shortlink.cache_key(shortcut)
  end

  # caching methods
  #
  def cache_all
    Shortlink.all.each do |s|
      Rails.cache.write(s.cache_key, s.url)
    end
  end

  def cache_self
    Rails.cache.write(cache_key, url)
    puts 'cached'
  end

  def destroy_cache_self
    Rails.cache.delete(cache_key)
  end


end
