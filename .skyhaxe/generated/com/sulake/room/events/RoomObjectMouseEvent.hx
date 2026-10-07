package com.sulake.room.events
;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectMouseEvent extends RoomObjectEvent 
    {
        public static inline final ROE_MOUSE_CLICK= "ROE_MOUSE_CLICK";
        public static inline final ROE_MOUSE_ENTER= "ROE_MOUSE_ENTER";
        public static inline final ROE_MOUSE_MOVE= "ROE_MOUSE_MOVE";
        public static inline final ROE_MOUSE_LEAVE= "ROE_MOUSE_LEAVE";
        public static inline final ROE_MOUSE_DOUBLE_CLICK= "ROE_MOUSE_DOUBLE_CLICK";
        public static inline final ROE_MOUSE_DOWN= "ROE_MOUSE_DOWN";

        var _eventId:String = "";
        var _altKey:Bool = false;
        var _ctrlKey:Bool = false;
        var _shiftKey:Bool = false;
        var _buttonDown:Bool = false;
        var _localX:Int = 0;
        var _localY:Int = 0;
        var _spriteOffsetX:Int = 0;
        var _spriteOffsetY:Int = 0;

        public function new(k:String, _arg_2:IRoomObject, _arg_3:String, _arg_4:Bool=false, _arg_5:Bool=false, _arg_6:Bool=false, _arg_7:Bool=false, _arg_8:Bool=false, _arg_9:Bool=false)
        {
            super(k, _arg_2, _arg_8, _arg_9);
            this._eventId = _arg_3;
            this._altKey = _arg_4;
            this._ctrlKey = _arg_5;
            this._shiftKey = _arg_6;
            this._buttonDown = _arg_7;
        }

        public var eventId(get,never):String;
public function  get_eventId():String
        {
            return this._eventId;
        }

        public var altKey(get,never):Bool;
public function  get_altKey():Bool
        {
            return this._altKey;
        }

        public var ctrlKey(get,never):Bool;
public function  get_ctrlKey():Bool
        {
            return this._ctrlKey;
        }

        public var shiftKey(get,never):Bool;
public function  get_shiftKey():Bool
        {
            return this._shiftKey;
        }

        public var buttonDown(get,never):Bool;
public function  get_buttonDown():Bool
        {
            return this._buttonDown;
        }

        
        public var localX(get,set):Int;
public function  get_localX():Int
        {
            return this._localX;
        }

        
        public var localY(get,set):Int;
public function  get_localY():Int
        {
            return this._localY;
        }

        
        public var spriteOffsetX(get,set):Int;
public function  get_spriteOffsetX():Int
        {
            return this._spriteOffsetX;
        }

        
        public var spriteOffsetY(get,set):Int;
public function  get_spriteOffsetY():Int
        {
            return this._spriteOffsetY;
        }
public function  set_localX(k:Int):Int        {
            return this._localX = k;
        }
public function  set_localY(k:Int):Int        {
            return this._localY = k;
        }
public function  set_spriteOffsetX(k:Int):Int        {
            return this._spriteOffsetX = k;
        }
public function  set_spriteOffsetY(k:Int):Int        {
            return this._spriteOffsetY = k;
        }
    }

