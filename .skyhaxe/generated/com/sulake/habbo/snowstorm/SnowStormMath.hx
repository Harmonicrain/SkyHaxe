package com.sulake.habbo.snowstorm
;
    import com.sulake.habbo.snowstorm.data.SnowStormGeneratedRuntimeTables;

    /** Signed-32-bit r26 primitives used by the client checksum and presentation mirror. */
     final class SnowStormMath
    {
        public static inline final TURN_MS= 300;
        public static inline final SUBTURN_MS= 60;
        public static inline final WORLD_UNITS_PER_TILE= 3200;
        public static inline final AVATAR_STEP= 640;
        public static inline final PROJECTILE_VELOCITY= 2000;

        public static function add32(left:Int, right:Int):Int
        { return Std.int(left + right); }

        public static function multiply32(left:Int, right:Int):Int
        { return Std.int(left * right); }

        public static function directorDiv(numerator:Int, denominator:Int):Int
        {
            if (denominator == 0) throw new ArgumentError("SnowStorm integer division by zero");
            return Std.int(numerator / denominator);
        }

        public static function directorMod(value:Int, divisor:Int):Int
        { return value - directorDiv(value, divisor) * divisor; }

        public static function iterateSeed(seed:Int):Int
        {
            if (seed == 0) seed = -1;
            seed ^= seed << 13;
            seed ^= seed >> 17;
            seed ^= seed << 5;
            return seed;
        }

        public static function validateDirection360(value:Int):Int
        {
            if (value > 359) value = directorMod(value, 360);
            else if (value < 0) value = 360 + directorMod(value, 360);
            return value;
        }

        public static function validateDirection8(value:Int):Int
        {
            if (value > 7) value = directorMod(value, 8);
            else if (value < 0) value = directorMod(8 + directorMod(value, 8), 8);
            return value;
        }

        public static function direction360To8(value:Int):Int
        { return validateDirection8(directorDiv(validateDirection360(value - 22), 45) + 1); }

        public static function fastSquareRoot(value:Int):Int
        {
            if (value < 0) return -1;
            if (value >= 1073741824) return SnowStormGeneratedRuntimeTables.squareRoot(Std.int(value / 16777216)) * 256;
            if (value >= 268435456) return SnowStormGeneratedRuntimeTables.squareRoot(Std.int(value / 4194304)) * 128;
            if (value >= 67108864) return SnowStormGeneratedRuntimeTables.squareRoot(Std.int(value / 1048576)) * 64;
            if (value >= 16777216) return SnowStormGeneratedRuntimeTables.squareRoot(Std.int(value / 262144)) * 32;
            if (value >= 4194304) return SnowStormGeneratedRuntimeTables.squareRoot(Std.int(value / 65536)) * 16;
            if (value >= 1048576) return SnowStormGeneratedRuntimeTables.squareRoot(Std.int(value / 16384)) * 8;
            if (value >= 262144) return SnowStormGeneratedRuntimeTables.squareRoot(Std.int(value / 4096)) * 4;
            if (value >= 65536) return SnowStormGeneratedRuntimeTables.squareRoot(Std.int(value / 1024)) * 2;
            if (value >= 16384) return SnowStormGeneratedRuntimeTables.squareRoot(Std.int(value / 256));
            if (value >= 4096) return Std.int(SnowStormGeneratedRuntimeTables.squareRoot(Std.int(value / 64)) / 2);
            if (value >= 1024) return Std.int(SnowStormGeneratedRuntimeTables.squareRoot(Std.int(value / 16)) / 4);
            if (value >= 256) return Std.int(SnowStormGeneratedRuntimeTables.squareRoot(Std.int(value / 4)) / 8);
            return Std.int(SnowStormGeneratedRuntimeTables.squareRoot(value) / 16);
        }

        public static function componentAngle(xComponent:Int, yComponent:Int):Int
        {
            var x= xComponent;
            var y= yComponent;
            var scaled = 0;
            var index = 0;
            var angle = 0;
            if (Math.abs(x) <= Math.abs(y))
            {
                if (y == 0) y = 1;
                scaled = Std.int(x * 256);
                index = Std.int(Math.min(Math.abs(directorDiv(scaled, y)), 255));
                angle = SnowStormGeneratedRuntimeTables.componentAngle(index);
                if (y < 0) return scaled > 0 ? angle : 360 - angle;
                return scaled > 0 ? 180 - angle : 180 + angle;
            }
            if (x == 0) x = 1;
            scaled = Std.int(y * 256);
            index = Std.int(Math.min(Math.abs(directorDiv(scaled, x)), 255));
            angle = SnowStormGeneratedRuntimeTables.componentAngle(index);
            if (scaled < 0) return x > 0 ? 90 - angle : 270 + angle;
            return x > 0 ? 90 + angle : 270 - angle;
        }

        public static function velocityX(direction:Int):Int
        { return SnowStormGeneratedRuntimeTables.velocityX(validateDirection360(direction)); }

        public static function velocityY(direction:Int):Int
        { return SnowStormGeneratedRuntimeTables.velocityY(validateDirection360(direction)); }

        public static function stepAxis(current:Int, target:Int):Int
        {
            var delta= target - current;
            if (-AVATAR_STEP < delta && delta < AVATAR_STEP) return target;
            if (delta < 0) return current - AVATAR_STEP;
            if (delta > 0) return current + AVATAR_STEP;
            return current;
        }

        public static function checksum(turnNumber:Int, objects:ASObject):Int
        {
var key:String  = null, id = 0, object:ASObject  = null, values:Array<ASAny>  = null,                 index = 0;            var result= iterateSeed(turnNumber);
            var ids:Array<ASAny> = [];
            if (checkNullIteratee(objects)) for (_tmp_ in objects.___keys()) {key = _tmp_;
ids.push(ASCompat.toInt(key));
};
            ASCompat.ASArray.sortWithOptions(ids, ASCompat.ASArray.NUMERIC);
            if (checkNullIteratee(ids)) for (_tmp_ in ids)
            {
id = ASCompat.toInt(_tmp_);
object= objects[Std.string(id)];
values= checksumValues(object);
                result = add32(multiply32(result, 31), ASCompat.toInt(object.type));
                result = add32(multiply32(result, 31), id);
                index= 0;while (index < values.length)
                    {result = add32(multiply32(result, 31), ASCompat.toInt(values[index]));
index++;
};
            }
            return result;
        }

        public static function checksumValues(object:ASObject):Array<ASAny>
        {
var goalX = 0, goalY = 0;            if (object == null) throw new ArgumentError("SnowStorm checksum object is missing");
            if (object.type == SnowStormProtocol.OBJECT_AVATAR)
            {
goalX= object.nextGoalActive ? ASCompat.toInt(object.nextGoalTileX)
                    : SnowStormMapCatalog.worldToTileCoordinate(ASCompat.toInt(object.worldX));
goalY= object.nextGoalActive ? ASCompat.toInt(object.nextGoalTileY)
                    : SnowStormMapCatalog.worldToTileCoordinate(ASCompat.toInt(object.worldY));
                return [ASCompat.toInt(object.worldX), ASCompat.toInt(object.worldY), ASCompat.toInt(object.direction), ASCompat.toInt(object.health),
                    ASCompat.toInt(object.snowballs), object.bot ? 1 : 0, ASCompat.toInt(object.activityTimer), ASCompat.toInt(object.activity),
                    goalX, goalY, ASCompat.toInt(object.moveTargetX), ASCompat.toInt(object.moveTargetY), ASCompat.toInt(object.score),
                    ASCompat.toInt(object.userId), ASCompat.toInt(object.teamId), ASCompat.toInt(object.objectId),
                    ASCompat.toInt(object.standingDirection), ASCompat.toInt(object.fallPose)];
            }
            if (object.type == SnowStormProtocol.OBJECT_SNOWBALL)
                return [ASCompat.toInt(object.worldX), ASCompat.toInt(object.worldY), ASCompat.toInt(object.height), ASCompat.toInt(object.direction),
                    ASCompat.toInt(object.trajectory), ASCompat.toInt(object.timeToLive), ASCompat.toInt(object.throwerObjectId),
                    ASCompat.toInt(object.parabolaOffset)];
            if (object.type == SnowStormProtocol.OBJECT_MACHINE)
                return [ASCompat.toInt(object.worldX), ASCompat.toInt(object.worldY), ASCompat.toInt(object.snowballs)];
            throw new ArgumentError("Unsupported SnowStorm checksum object type");
        }

	public function new() {}
    }

