# frozen_string_literal: true

module Site
  class ShortlinkDetailsController < SiteController

    def show
      puts 'showing'

      @shortlink = Shortlink.find_by shortcut: params[:id]
    end

  end
end
