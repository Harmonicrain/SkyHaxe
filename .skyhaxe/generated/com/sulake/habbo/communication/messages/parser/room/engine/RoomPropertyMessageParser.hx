package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomPropertyMessageParser implements IMessageParser
    {
        var _floorType:String = null;
        var _wallType:String = null;
        var _landscapeType:String = null;
        var _animatedLandscapeType:String = null;


        public var floorType(get,never):String;
public function  get_floorType():String
        {
            return this._floorType;
        }

        public var wallType(get,never):String;
public function  get_wallType():String
        {
            return this._wallType;
        }

        public var landscapeType(get,never):String;
public function  get_landscapeType():String
        {
            return this._landscapeType;
        }

        public var animatedLandscapeType(get,never):String;
public function  get_animatedLandscapeType():String
        {
            return this._animatedLandscapeType;
        }

        public function flush():Bool
        {
            this._floorType = null;
            this._wallType = null;
            this._landscapeType = null;
            this._animatedLandscapeType = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readString();
            var _local_3= k.readString();
            switch (_local_2)
            {
                case "floor":
                    this._floorType = _local_3;
                    
                case "wallpaper":
                    this._wallType = _local_3;
                    
                case "landscape":
                    this._landscapeType = _local_3;
                    
                case "landscapeanim":
                    this._animatedLandscapeType = _local_3;
                    
            }
            return true;
        }

	public function new() {}
    }

