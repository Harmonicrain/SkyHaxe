package com.sulake.habbo.snowstorm
;
    import com.sulake.habbo.snowstorm.data.SnowStormGeneratedMapData;

    /** Runtime view of the one generated seven-map manifest shared with server SQL. */
     final class SnowStormMapCatalog
    {
        static var _maps:ASObject;

        public static function getMap(mapId:Int):ASObject
        {
            ensureLoaded();
            return _maps[Std.string(mapId)];
        }

        public static function isCompatible(mapId:Int, revision:Int, checksum:Int):Bool
        {
            var map:ASObject = getMap(mapId);
            return map != null && ASCompat.toInt(map.revision) == revision && ASCompat.toInt(map.checksum) == checksum;
        }

        public static function contains(map:ASObject, tileX:Int, tileY:Int):Bool
        { return map != null && tileX >= 0 && tileY >= 0 && tileX < ASCompat.toInt(map.width) && tileY < ASCompat.toInt(map.height); }

        public static function isFloor(map:ASObject, tileX:Int, tileY:Int):Bool
        { return contains(map, tileX, tileY) && ASCompat.toString(map.floorRows[tileY]).charAt(tileX) != "x"; }

        public static function isWalkable(map:ASObject, tileX:Int, tileY:Int):Bool
        { return contains(map, tileX, tileY) && ASCompat.toString(map.collisionRows[tileY]).charAt(tileX) != "x"; }

        public static function toTile(map:ASObject, worldX:Int, worldY:Int):ASObject
        {
            if (map == null) return null;
            var pitch= ASCompat.toInt(map.worldUnitsPerTile);
            var relativeX= worldX - ASCompat.toNumber(map.worldOrigin.x);
            var relativeY= worldY - ASCompat.toNumber(map.worldOrigin.y);
            if (relativeX < -(pitch / 2) || relativeY < -(pitch / 2)) return null;
            var tileX= Std.int((relativeX + pitch / 2) / pitch) + ASCompat.toInt(map.tileOrigin.x);
            var tileY= Std.int((relativeY + pitch / 2) / pitch) + ASCompat.toInt(map.tileOrigin.y);
            return contains(map, tileX, tileY) ? {x:tileX, y:tileY} : null;
        }

        public static function worldToTileCoordinate(world:Int):Int
        {
            if (world < -(SnowStormMath.WORLD_UNITS_PER_TILE / 2)) return 0;
            return SnowStormMath.directorDiv(Std.int(world + SnowStormMath.WORLD_UNITS_PER_TILE / 2),
                SnowStormMath.WORLD_UNITS_PER_TILE);
        }

        public static function toWorldX(map:ASObject, tileX:Int):Int
        { return ASCompat.toInt(map.worldOrigin.x) + (tileX - ASCompat.toInt(map.tileOrigin.x)) * ASCompat.toInt(map.worldUnitsPerTile); }

        public static function toWorldY(map:ASObject, tileY:Int):Int
        { return ASCompat.toInt(map.worldOrigin.y) + (tileY - ASCompat.toInt(map.tileOrigin.y)) * ASCompat.toInt(map.worldUnitsPerTile); }

        public static function projectileCollisionHeight(map:ASObject, tileX:Int, tileY:Int):Int
        {
            if (map == null || map.__collisionHeights == null) return 0;
            var value:ASObject = map.__collisionHeights[Std.string(tileX) + ":" + Std.string(tileY)];
            return value == null ? 0 : ASCompat.toInt(value);
        }

        static function ensureLoaded()
        {
var map:ASObject  = null, heights:ASObject  = null, collision:ASObject  = null, tile:Array<ASAny>  = null, key:String  = null, mapId = 0;            if (_maps != null) return;
            var root:ASObject = haxe.Json.parse(SnowStormGeneratedMapData.jsonData);
            if (root == null || ASCompat.toInt(root.schemaVersion) != SnowStormGeneratedMapData.SCHEMA_VERSION ||
                ASCompat.toInt(root.revision) != SnowStormGeneratedMapData.REVISION ||
                ASCompat.toInt(root.canonicalChecksum) != SnowStormGeneratedMapData.CANONICAL_CHECKSUM)
                throw new ASError("SnowStorm generated map contract is invalid");
            _maps = {};
            final _iter_:ASAny = root.maps; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
map = _tmp_;
heights= {};
                final _iter_:ASAny = map.collisionObjects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
collision = _tmp_;
                    final _iter_:ASAny = collision.footprintTiles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
tile = _tmp_;
key= Std.string(ASCompat.toInt(tile[0])) + ":" + Std.string(ASCompat.toInt(tile[1]));
ASCompat.setDynamicProperty(                        heights, key, Math.max(ASCompat.getDynamicProperty(heights, key)== null ? 0 : ASCompat.toInt(ASCompat.getDynamicProperty(heights, key)),
                            ASCompat.toInt(collision.projectileCollisionHeight)));
                    }
                }
                map.__collisionHeights = heights;
                _maps[Std.string(ASCompat.toInt(map.mapId))] = map;
            }
            for (_tmp_ in 1...8)
{mapId= _tmp_;
                if (_maps[Std.string(mapId)] == null) throw new ASError("SnowStorm map " + Std.string(mapId) + " is missing");
};
        }

	public function new() {}
    }

