class ShortcutController < ApplicationController

  def link
    shortcut = params[:shortcut]

    cached_url = Rails.cache.read(Shortlink.cache_key(shortcut))

    unless cached_url.blank?
      # update the DB asynchronous so that we have faster redirects
      ProcessClickWorker.perform_async(shortcut)
      return redirect_to cached_url
    end

    shortlink = Shortlink.find_by shortcut: shortcut

    if shortlink.nil?
      puts "do something because it doesn't exist"
      return
    end

    # update the DB asynchronous so that we have faster redirects
    ProcessClickWorker.perform_async(shortcut)

    redirect_to shortlink.url
  end

end
