$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require "point_in_polygon"

module GeoRuby
  module SimpleFeatures
    class Polygon
      def contains?(point)
        pps = self.rings.map(&:points).map{|ps| ps.map{|p| [p.x, p.y]}}
        if pps.size == 1
          PointInPolygon.point_in_polygon? pps.first, point.x, point.y
        else
          # done
          raise NotImplementedError
        end
      end
    end
  end
end
