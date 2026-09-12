package com.sulake.habbo.room.object.visualization.avatar.additions
;
    import com.sulake.habbo.snowstorm.SnowStormAssets;
    import com.sulake.room.object._enum.AlphaTolerance;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import flash.display.BitmapData;

    /** The recovered r26 team-coloured floor diamond shown beneath a hovered SnowStorm avatar. */
     final class SnowStormTargetHighlight implements IAvatarAddition
    {
        static inline final ASSET_PREFIX=
            "hh_game_snowwar_room_sw_avatar_hilite_team_";
        static final REGISTRATION_X:Array<ASAny> = [16, 15, 16, 15];
        static inline final REGISTRATION_Y= 8;
        /** Positive depth places the diamond behind the uniform and avatar body. */
        static inline final RELATIVE_DEPTH= 0.03;

        var _id:Int = 0;
        var _assets:SnowStormAssets;
        var _teamId:Int = 0;
        var _bitmap:BitmapData;
        var _disposed:Bool = false;

        public function new(id:Int, assets:SnowStormAssets, teamId:Int)
        {
            this._id = id;
            this._assets = assets;
            this.teamId = teamId;
        }

        public var id(get,never):Int;
public function  get_id():Int { return this._id; }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }

        public var teamId(never,set):Int;
public function  set_teamId(value:Int):Int        {
            value = Std.int(Math.max(0, Math.min(3, value)));
            if (this._teamId == value && this._bitmap != null) return value;
            this._teamId = value;
            this._bitmap = this._assets == null ? null
                : this._assets.bitmapData(ASSET_PREFIX + Std.string(value));
return value;
        }

        public function update(sprite:IRoomObjectSprite, scale:Float)
        {
            this.apply(sprite);
        }

        public function animate(sprite:IRoomObjectSprite):Bool
        {
            this.apply(sprite);
            return false;
        }

        function apply(sprite:IRoomObjectSprite)
        {
            if (this._disposed || sprite == null) return;
            sprite.visible = this._bitmap != null;
            sprite.asset = this._bitmap;
            sprite.offsetX = -ASCompat.toInt(REGISTRATION_X[this._teamId]);
            sprite.offsetY = -REGISTRATION_Y;
            sprite.relativeDepth = RELATIVE_DEPTH;
            sprite.alpha = 255;
            sprite.alphaTolerance = AlphaTolerance.MATCH_ALL_PIXELS;
            // This is presentation only; it must not retain or expand the avatar hover target.
            sprite.skipMouseHandling = true;
        }

        public function dispose()
        {
            if (this._disposed) return;
            this._bitmap = null;
            this._assets = null;
            this._disposed = true;
        }
    }

