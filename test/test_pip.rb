#!/usr/bin/env ruby

require "geo_ruby"
require "test/unit"

require File.expand_path(File.dirname(__FILE__) + "/../ext/point_in_polygon")


class TestPip < Test::Unit::TestCase
  def setup
    @poly = [
      [-3.015747, 16.774302],
      [-3.661194, 16.405788],
      [-3.389282, 16.252912],
      [-3.128357, 16.458476],
    ]
  end

  def test_point_with_wrong_type
    assert_raise(TypeError) { PointInPolygon.point_in_polygon?(@poly, nil, nil) }
    assert_raise(TypeError) { PointInPolygon.point_in_polygon?(@poly, 3.0, nil) }
    assert_raise(TypeError) { PointInPolygon.point_in_polygon?(@poly, nil, 5.0) }
    assert_raise(TypeError) { PointInPolygon.point_in_polygon?(@poly, 3, 5.0) }
    assert_raise(TypeError) { PointInPolygon.point_in_polygon?(@poly, 3.0, 5) }
    assert_raise(TypeError) { PointInPolygon.point_in_polygon?(@poly, "x", "y") }
    assert_raise(TypeError) { PointInPolygon.point_in_polygon?(@poly, "x", 5.0) }
    assert_raise(TypeError) { PointInPolygon.point_in_polygon?(@poly, 3.0, "y") }
  end

  def test_polygon_with_wrong_type
    assert_raise(TypeError) { PointInPolygon.point_in_polygon?(nil, 1.0, 2.0) }
    assert_raise(TypeError) { PointInPolygon.point_in_polygon?(3, 1.0, 2.0) }
    assert_raise(TypeError) { PointInPolygon.point_in_polygon?({}, 1.0, 2.0) }
  end

  def test_polygon_as_empty_array
    assert_raise(TypeError) { PointInPolygon.point_in_polygon?([], 1.0, 2.0) }
  end

  def test_polygon_with_one_and_two_points
    assert_raise(TypeError) do
      PointInPolygon.point_in_polygon?([[-3.128357, 16.458476]], 1.0, 2.0)
    end
    assert_raise(TypeError) do
      PointInPolygon.point_in_polygon?([[-3.389282, 16.252912],
                                        [-3.128357, 16.458476]], 1.0, 2.0)
    end
  end

  def test_polygon_with_three_points
    assert_nothing_raised do
      PointInPolygon.point_in_polygon?([[-3.015747, 16.774302],
                                        [-3.661194, 16.405788],
                                        [-3.389282, 16.252912]], 1.0, 2.0)
    end
  end

  def test_polygon_with_an_invalid_point
    assert_raise(TypeError) do
      PointInPolygon.point_in_polygon?([[-3.015747, 16.774302],
                                        [-3, 16.405788],
                                        [-3.389282, 16.252912]], 1.0, 2.0)
    end
    assert_raise(TypeError) do
      PointInPolygon.point_in_polygon?([[-3.015747, 16.774302],
                                        [16.405788],
                                        [-3.389282, 16.252912]], 1.0, 2.0)
    end
    assert_raise(TypeError) do
      PointInPolygon.point_in_polygon?([[-3.015747, 16.774302],
                                        [16.405788, nil],
                                        [-3.389282, 16.252912]], 1.0, 2.0)
    end
    assert_raise(TypeError) do
      PointInPolygon.point_in_polygon?([[-3.015747, 16.774302],
                                        [16.405788, 2.3, 23.0],
                                        nil], 1.0, 2.0)
    end
  end

  def test_inside
    inside = [-3.262939, 16.450574]
    assert PointInPolygon.point_in_polygon?(@poly, inside[0], inside[1])
  end

  def test_outside
    outside = [-3.361816, 16.834776]
    assert !PointInPolygon.point_in_polygon?(@poly, outside[0], outside[1])
  end

  def test_on_corner
    corner = @poly.first
    assert !PointInPolygon.point_in_polygon?(@poly, corner[0], corner[1])
  end

  def test_on_border
=begin TODO a better test for this...
    x0 = @poly[0][0]
    y0 = @poly[0][1]
    x1 = @poly[1][0]
    y1 = @poly[1][1]
    x = (rand * (x1 - x0)) + x0
    y = y0 + (x-x0)*((y1-y0)/(x1-x0))
    puts [x0, y0]
    puts [x1, y1]
    puts [x, y]
    assert !PointInPolygon.point_in_polygon?(@poly, x, y)
    assert PointInPolygon.point_in_polygon?(@poly, x+0.001, y)
=end
  end
end
