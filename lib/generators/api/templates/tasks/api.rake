require Rails.root.join("lib/api-test")

namespace :api do
  desc "Ping the Api"
  task :ping => [:environment] do
    Api.ping
  end
end
