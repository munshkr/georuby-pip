#!/usr/bin/env ruby

require "geo_ruby"
require "test/unit"

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require "georuby_pip"


class TestGeorubyPip < Test::Unit::TestCase
  def setup
    linner = GeoRuby::SimpleFeatures::LinearRing.from_coordinates([
      [-3.015747, 16.774302],
      [-3.661194, 16.405788],
      [-3.389282, 16.252912],
      [-3.128357, 16.458476],
      [-3.015747, 16.774302],
    ])
    @poly = GeoRuby::SimpleFeatures::Polygon.from_linear_rings([linner])

  end

  def test_inside
    inside = GeoRuby::SimpleFeatures::Point.from_x_y(-3.262939, 16.450574)
    assert @poly.contains?(inside)
  end

  def test_outside
    outside = GeoRuby::SimpleFeatures::Point.from_x_y(-3.361816, 16.834776)
    assert !@poly.contains?(outside)
  end
end
