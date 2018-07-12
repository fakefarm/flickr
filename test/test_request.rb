# -*- coding: utf-8 -*-

lib = File.dirname(__FILE__)
$:.unshift lib unless $:.include?(lib)

require 'test/unit'

class TestRequest < Test::Unit::TestCase

  def setup
    @flickr = Flickr::Flickr.new

    @flickr.access_token = ENV['FLICKR_ACCESS_TOKEN']
    @flickr.access_secret = ENV['FLICKR_ACCESS_SECRET']
  end

  def test_flickr_api_is_accessible_via_methods
    # Reset Flickr (was initialized in test/helper.rb) so the request methods
    # are properly built
    old_flickr = $flickr
    $flickr = nil
    Flickr::Request.instance_variable_set(:@flickr_objects, nil)

    Flickr::Flickr.build(['flickr.fully.legal'])

    assert_equal true, @flickr.methods.include?(:fully)
    assert_equal true, @flickr.fully.methods.include?(:legal)

    # Fix for failing subsequent tests
    $flickr = old_flickr
  end

  def test_invalid_keys_are_skipped
    assert_nothing_raised {
      Flickr::Flickr.build ["flickr.hacked; end; raise 'Pwned'; def x"]
    }

    assert_equal false, @flickr.methods.include?(:hacked)
  end

end