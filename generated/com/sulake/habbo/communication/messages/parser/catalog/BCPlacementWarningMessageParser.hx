package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BCPlacementWarningMessageParser implements IMessageParser
    {
        public static inline final TYPE_FLOOR= 0;
        public static inline final TYPE_WALL= 1;

        var _typeCode:Int = 0;
        var _pageId:Int = 0;
        var _offerId:Int = 0;
        var _extraParam:String;
        var _x:Int = 0;
        var _y:Int = 0;
        var _direction:Int = 0;
        var _wallLocation:String;

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            _typeCode   = k.readInteger();
            _pageId     = k.readInteger();
            _offerId    = k.readInteger();
            _extraParam = k.readString();
            if (_typeCode == TYPE_FLOOR)
            {
                _x         = k.readInteger();
                _y         = k.readInteger();
                _direction = k.readInteger();
            }
            else
            {
                _wallLocation = k.readString();
            }
            return true;
        }

        public var typeCode(get,never):Int;
function  get_typeCode():Int         { return _typeCode; }
        public var pageId(get,never):Int;
function  get_pageId():Int           { return _pageId; }
        public var offerId(get,never):Int;
function  get_offerId():Int          { return _offerId; }
        public var extraParam(get,never):String;
function  get_extraParam():String    { return _extraParam; }
        public var x(get,never):Int;
function  get_x():Int               { return _x; }
        public var y(get,never):Int;
function  get_y():Int               { return _y; }
        public var direction(get,never):Int;
function  get_direction():Int        { return _direction; }
        public var wallLocation(get,never):String;
function  get_wallLocation():String  { return _wallLocation; }

	public function new() {}
    }

