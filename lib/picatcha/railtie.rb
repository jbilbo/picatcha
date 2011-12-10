require 'net/http'
require 'picatcha'
module Rails
  module Picatcha
    class Railtie < Rails::Railtie
      initializer "setup config" do
        begin
          ActionView::Base.send(:include, ::Picatcha::ClientHelper)
          ActionController::Base.send(:include, ::Picatcha::Verify)
        end
      end
    end
  end
end

