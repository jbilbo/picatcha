require 'test/unit'
require 'cgi'
require File.dirname(File.expand_path(__FILE__)) + '/../lib/picatcha'

class PicatchaClientHelperTest < Test::Unit::TestCase
  include Picatcha
  include Picatcha::ClientHelper
  include Picatcha::Verify

  attr_accessor :session

  def setup
    @session = {}
    Picatcha.configure do |config|
      config.public_key = '0000000000000000000000000000000000000000'
      config.private_key = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    end
  end

  def test_picatcha_tags
    # Might as well match something...
    #assert_match /http:\/\/api.picatcha.com\/g/, picatcha_tags
  end #http:\/\/www.google.com\/recaptcha\/api\/challenge/

  def test_picatcha_tags_with_ssl
    assert_match /https:\/\/www.google.com\/recaptcha\/api\/challenge/, picatcha_tags(:ssl => true)
  end

  def test_picatcha_tags_without_noscript
    assert_no_match /noscript/, picatcha_tags(:noscript => false)
  end

  def test_should_raise_exception_without_public_key
    assert_raise PicatchaError do
      Picatcha.configuration.public_key = nil
      picatcha_tags
    end
  end

  def test_different_configuration_within_with_configuration_block
    key = Picatcha.with_configuration(:public_key => '12345') do
      Picatcha.configuration.public_key
    end

    assert_equal('12345', key)
  end

  def test_reset_configuration_after_with_configuration_block
    Picatcha.with_configuration(:public_key => '12345')
    assert_equal('0000000000000000000000000000000000000000', Picatcha.configuration.public_key)
  end
end
