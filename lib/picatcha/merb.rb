require 'picatcha'

Merb::GlobalHelpers.send(:include, Picatcha::ClientHelper)
Merb::Controller.send(:include, Picatcha::Verify)
