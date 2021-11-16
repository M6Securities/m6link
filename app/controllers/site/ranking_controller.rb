# frozen_string_literal: true

module Site
  class RankingController < SiteController

    def index
      @top = Shortlink.all.order(clicks: :desc).limit(10)
      @new = Shortlink.all.order(created_at: :desc).limit(10)
    end

  end
end
