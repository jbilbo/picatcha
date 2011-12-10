require 'net/http'
require 'picatcha'

ActionView::Base.send(:include, Picatcha::ClientHelper)
ActionController::Base.send(:include, Picatcha::Verify)