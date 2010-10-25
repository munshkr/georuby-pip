require File.expand_path(File.dirname(__FILE__) + "/../ext/point_in_polygon")

module GeoRuby::SimpleFeatures

	class LinearRing
		def contains_point?(point)
			pps = self.points.map {|p| [p.x, p.y]}
			PointInPolygon.point_in_polygon? pps, point.x, point.y
		end
	end

	class Polygon
		def contains_point?(point)
			return false if self.rings.empty?

			outer_ring = self.rings.first
			if rings.size == 1
				return outer_ring.contains_point?(point)
			else
				inner_rings = self.rings[1..-1]
				if outer_ring.contains_point?(point)
					return inner_rings.all? { |r| not r.contains_point?(point) }
				else
					return false
				end
			end
		end
	end

	class MultiPolygon
		def contains_point?(point)
			return false if self.geometries.empty?

			self.geometries.any? { |p| p.contains_point?(point) }
		end
	end

end
