class ShortcutController < ApplicationController

  def link
    shortcut = params[:shortcut]

    shortlink = Shortlink.find_by shortcut: shortcut

    redirect_to shortlink.url
  end

end
