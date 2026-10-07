package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.Vector3d;

     class RoomObjectTileCursorUpdateMessage extends RoomObjectUpdateMessage 
    {
        var _height:Float = Math.NaN;
        var _sourceEventId:String;
        var _visible:Bool = false;
        var _toggleVisibility:Bool = false;

        public function new(k:Vector3d, _arg_2:Float, _arg_3:Bool, _arg_4:String, _arg_5:Bool=false)
        {
            super(k, null);
            this._height = _arg_2;
            this._visible = _arg_3;
            this._sourceEventId = _arg_4;
            this._toggleVisibility = _arg_5;
        }

        public var height(get,never):Float;
public function  get_height():Float
        {
            return this._height;
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            return this._visible;
        }

        public var sourceEventId(get,never):String;
public function  get_sourceEventId():String
        {
            return this._sourceEventId;
        }

        public var toggleVisibility(get,never):Bool;
public function  get_toggleVisibility():Bool
        {
            return this._toggleVisibility;
        }
    }

