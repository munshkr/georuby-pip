#!/usr/bin/env ruby

require "geo_ruby"
require "test/unit"

require File.expand_path(File.dirname(__FILE__) + "/../lib/georuby_pip")


class TestGeorubyPip < Test::Unit::TestCase
  def setup
    l1 = GeoRuby::SimpleFeatures::LinearRing.from_coordinates([
      [-8.964844,27.059126],
      [-8.964844,27.059126],
      [3.427734,18.729502],
      [11.777344,23.402765],
      [9.492188,30.297018],
      [7.646484,34.234512],
      [8.525391,36.879621],
      [-2.021484,34.885931],
      [-2.021484,32.472695],
      [-8.964844,27.059126]
    ])
    l2 = GeoRuby::SimpleFeatures::LinearRing.from_coordinates([
      [-2.285156,27.605671],
      [2.460938,32.7688],
      [5.976563,26.902477],
      [2.373047,24.126702],
      [-2.285156,27.605671]
    ])
    @p1 = GeoRuby::SimpleFeatures::Polygon.from_linear_rings([l1, l2])

    l3 = GeoRuby::SimpleFeatures::LinearRing.from_coordinates([
      [-15.908203,16.636192],
      [-11.777344,12.46876],
      [-16.875,11.953349],
      [-18.369141,14.43468],
      [-15.908203,16.636192]
    ])
    @p2 = GeoRuby::SimpleFeatures::Polygon.from_linear_rings([l3])

    @p3 = GeoRuby::SimpleFeatures::Polygon.new
    @p3.rings << GeoRuby::SimpleFeatures::LinearRing.from_coordinates([
      [8.085938,14.264383],
      [-0.351562,12.21118],
      [5.449219,8.320212],
      [15.292969,14.179186],
      [15.292969,21.779905],
      [2.636719,15.45368],
      [8.085938,14.264383]
    ])
    @p3.rings << GeoRuby::SimpleFeatures::LinearRing.from_coordinates([
      [8.129883,15.961329],
      [11.293945,18.437925],
      [12.436523,15.961329],
      [8.129883,15.961329],
    ])
    @p3.rings << GeoRuby::SimpleFeatures::LinearRing.from_coordinates([
      [5.053711,11.609193],
      [12.084961,15.072124],
      [6.547852,10.09867],
      [5.053711,11.609193]
    ])

    # This polygon is inside a hole of @p3
    @p4 = GeoRuby::SimpleFeatures::Polygon.new
    @p4.rings << GeoRuby::SimpleFeatures::LinearRing.from_coordinates([
      [10.228271,16.551962],
      [10.38208,17.340152],
      [11.293945,17.245744],
      [11.063232,16.488765],
      [10.228271,16.551962]
    ])

    @multi = GeoRuby::SimpleFeatures::MultiPolygon.from_polygons([@p1, @p2, @p3, @p4])
  end

  def test_simple_polygon
    inside_p2 = GeoRuby::SimpleFeatures::Point.from_coordinates([-15.46875,14.179186])
    assert @p2.contains_point?(inside_p2)
    assert !@p1.contains_point?(inside_p2)
    assert !@p3.contains_point?(inside_p2)
    assert !@p4.contains_point?(inside_p2)
  end

  def test_outside
    outside = GeoRuby::SimpleFeatures::Point.from_coordinates([-2.285156,17.392579])
    assert !@p1.contains_point?(outside)
    assert !@p2.contains_point?(outside)
    assert !@p3.contains_point?(outside)
    assert !@p4.contains_point?(outside)
  end

  def test_inside_polygon_with_one_hole
    inside_p1 = GeoRuby::SimpleFeatures::Point.from_coordinates([6.943359,23.80545])
    assert @p1.contains_point?(inside_p1)
    assert !@p2.contains_point?(inside_p1)
    assert !@p3.contains_point?(inside_p1)
    assert !@p4.contains_point?(inside_p1)
  end

  def test_inside_only_hole
    in_p1_hole = GeoRuby::SimpleFeatures::Point.from_coordinates([2.460938,26.273714])
    assert !@p1.contains_point?(in_p1_hole)
    assert !@p2.contains_point?(in_p1_hole)
    assert !@p3.contains_point?(in_p1_hole)
    assert !@p4.contains_point?(in_p1_hole)
  end

  def test_polygon_with_holes
    inside_p3 = GeoRuby::SimpleFeatures::Point.from_coordinates([6.767578,15.707663])
    assert !@p1.contains_point?(inside_p3)
    assert !@p2.contains_point?(inside_p3)
    assert @p3.contains_point?(inside_p3)
    assert !@p4.contains_point?(inside_p3)

    in_hole1 = GeoRuby::SimpleFeatures::Point.from_coordinates([11.557617,16.551962])
    assert !@p1.contains_point?(in_hole1)
    assert !@p2.contains_point?(in_hole1)
    assert !@p3.contains_point?(in_hole1)
    assert !@p4.contains_point?(in_hole1)

    in_hole2 = GeoRuby::SimpleFeatures::Point.from_coordinates([6.240234,11.566144])
    assert !@p1.contains_point?(in_hole2)
    assert !@p2.contains_point?(in_hole2)
    assert !@p3.contains_point?(in_hole2)
    assert !@p4.contains_point?(in_hole2)

    outside = GeoRuby::SimpleFeatures::Point.from_coordinates([11.777344,10.358151])
    assert !@p1.contains_point?(outside)
    assert !@p2.contains_point?(outside)
    assert !@p3.contains_point?(outside)
    assert !@p4.contains_point?(outside)
  end

  def test_polygon_inside_hole
    inside = GeoRuby::SimpleFeatures::Point.from_coordinates([10.722656,16.930705])
    assert !@p1.contains_point?(inside)
    assert !@p2.contains_point?(inside)
    assert !@p3.contains_point?(inside)
    assert @p4.contains_point?(inside)

    outside = GeoRuby::SimpleFeatures::Point.from_coordinates([11.689453,16.467695])
    assert !@p1.contains_point?(outside)
    assert !@p2.contains_point?(outside)
    assert !@p3.contains_point?(outside)
    assert !@p4.contains_point?(outside)
  end

  def test_multipolygon
    inside_p2 = GeoRuby::SimpleFeatures::Point.from_coordinates([-15.46875,14.179186])
    assert @multi.contains_point?(inside_p2)

    outside = GeoRuby::SimpleFeatures::Point.from_coordinates([-2.285156,17.392579])
    assert !@multi.contains_point?(outside)

    inside_p1 = GeoRuby::SimpleFeatures::Point.from_coordinates([6.943359,23.80545])
    assert @multi.contains_point?(inside_p1)

    in_p1_hole = GeoRuby::SimpleFeatures::Point.from_coordinates([2.460938,26.273714])
    assert !@multi.contains_point?(in_p1_hole)

    inside_p3 = GeoRuby::SimpleFeatures::Point.from_coordinates([6.767578,15.707663])
    assert @multi.contains_point?(inside_p3)

    in_hole1_p3 = GeoRuby::SimpleFeatures::Point.from_coordinates([11.557617,16.551962])
    assert !@multi.contains_point?(in_hole1_p3)

    in_hole2_p3 = GeoRuby::SimpleFeatures::Point.from_coordinates([6.240234,11.566144])
    assert !@multi.contains_point?(in_hole2_p3)

    outside_p3 = GeoRuby::SimpleFeatures::Point.from_coordinates([11.777344,10.358151])
    assert !@multi.contains_point?(outside_p3)

    inside_p4 = GeoRuby::SimpleFeatures::Point.from_coordinates([10.722656,16.930705])
    assert @multi.contains_point?(inside_p4)

    outside_p4 = GeoRuby::SimpleFeatures::Point.from_coordinates([11.689453,16.467695])
    assert !@multi.contains_point?(outside_p4)
  end
end
