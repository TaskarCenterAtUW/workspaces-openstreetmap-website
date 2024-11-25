json.min_lat GeoRecord::Coord.new(@bbox.to_unscaled.min_lat)
json.min_lon GeoRecord::Coord.new(@bbox.to_unscaled.min_lon)
json.max_lat GeoRecord::Coord.new(@bbox.to_unscaled.max_lat)
json.max_lon GeoRecord::Coord.new(@bbox.to_unscaled.max_lon)
