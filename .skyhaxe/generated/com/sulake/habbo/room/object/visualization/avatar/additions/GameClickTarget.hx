package com.sulake.habbo.room.object.visualization.avatar.additions
;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.room.object._enum.AlphaTolerance;

     class GameClickTarget implements IAvatarAddition 
    {
        static inline final WIDTH= 46;
        static inline final HEIGHT= 60;
        static inline final OFFSET_X= -23;
        static inline final OFFSET_Y= -48;

        var _id:Int = -1;
        var _bitmap:BitmapData;
        var _disposed:Bool = false;

        public function new(k:Int)
        {
            this._id = k;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._bitmap = null;
                this._disposed = true;
            }
        }

        public function animate(k:IRoomObjectSprite):Bool
        {
            return false;
        }

        public function update(k:IRoomObjectSprite, _arg_2:Float)
        {
            if (k == null)
            {
                return;
            }
            if (this._bitmap == null)
            {
                this._bitmap = new BitmapData(WIDTH, HEIGHT, true, 0);
            }
            k.visible = true;
            k.asset = this._bitmap;
            k.offsetX = OFFSET_X;
            k.offsetY = OFFSET_Y;
            k.alphaTolerance = AlphaTolerance.MATCH_ALL_PIXELS;
        }
    }

