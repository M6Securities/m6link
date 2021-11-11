class Shortlink < ApplicationRecord

  validates :shortcut,
            presence: true,
            uniqueness: true
  validates :url,
            presence: true,
            format: {
              with: %r{^(http|https)://[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?$}ix,
              message: 'not a url'
            }
  validates :clicks,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0
            }

  def self.generate_shortcut
    # 5 digits long should be enough
    SecureRandom.alphanumeric 5
  end

end
