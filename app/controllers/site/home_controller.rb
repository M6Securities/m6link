# frozen_string_literal: true
module Site
  class HomeController < SiteController

    def create_shortlink
      url = params[:create][:url]

      if url.blank?
        payload = {
          info: 'URL cannot be blank'
        }
        return render json: payload, status: :bad_request
      end

      url = url.strip

      shortlink = Shortlink.new(url: url, shortcut: Shortlink.generate_shortcut)

      if shortlink.invalid?
        payload = {
          info: "Shortlink object invalid.\n #{shortlink.errors.messages}"
        }
        return render json: payload, status: :bad_request
      end

      if shortlink.save
        payload = {
          info: 'Created Shortlink',
          shortened_url: shortlink.shortcut_url,
          details_path: site_shortlink_detail_path(shortlink.shortcut)
        }
        render json: payload, status: :ok
      end

    end

  end
end
