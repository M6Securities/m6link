class ProcessClickWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options lock: :until_executed,
                  queue: :clicks

  def perform(shortcut)
    shortlink = Shortlink.find_by shortcut: shortcut

    shortlink.update(clicks: shortlink.clicks + 1)
  end
end
