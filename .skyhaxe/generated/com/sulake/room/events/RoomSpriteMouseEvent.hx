package com.sulake.room.events
;
     class RoomSpriteMouseEvent 
    {
        var _type:String = "";
        var _eventId:String = "";
        var _canvasId:String = "";
        var _spriteTag:String = "";
        var _screenX:Float = 0;
        var _screenY:Float = 0;
        var _localX:Float = 0;
        var _localY:Float = 0;
        var _ctrlKey:Bool = false;
        var _altKey:Bool = false;
        var _shiftKey:Bool = false;
        var _buttonDown:Bool = false;
        var _spriteOffsetX:Int = 0;
        var _spriteOffsetY:Int = 0;

        public function new(k:String, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:Float, _arg_6:Float, _arg_7:Float=0, _arg_8:Float=0, _arg_9:Bool=false, _arg_10:Bool=false, _arg_11:Bool=false, _arg_12:Bool=false)
        {
            this._type = k;
            this._eventId = _arg_2;
            this._canvasId = _arg_3;
            this._spriteTag = _arg_4;
            this._screenX = _arg_5;
            this._screenY = _arg_6;
            this._localX = _arg_7;
            this._localY = _arg_8;
            this._ctrlKey = _arg_9;
            this._altKey = _arg_10;
            this._shiftKey = _arg_11;
            this._buttonDown = _arg_12;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var eventId(get,never):String;
public function  get_eventId():String
        {
            return this._eventId;
        }

        public var canvasId(get,never):String;
public function  get_canvasId():String
        {
            return this._canvasId;
        }

        public var spriteTag(get,never):String;
public function  get_spriteTag():String
        {
            return this._spriteTag;
        }

        public var screenX(get,never):Float;
public function  get_screenX():Float
        {
            return this._screenX;
        }

        public var screenY(get,never):Float;
public function  get_screenY():Float
        {
            return this._screenY;
        }

        public var localX(get,never):Float;
public function  get_localX():Float
        {
            return this._localX;
        }

        public var localY(get,never):Float;
public function  get_localY():Float
        {
            return this._localY;
        }

        public var ctrlKey(get,never):Bool;
public function  get_ctrlKey():Bool
        {
            return this._ctrlKey;
        }

        public var altKey(get,never):Bool;
public function  get_altKey():Bool
        {
            return this._altKey;
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

        
        public var spriteOffsetX(get,set):Int;
public function  get_spriteOffsetX():Int
        {
            return this._spriteOffsetX;
        }
public function  set_spriteOffsetX(k:Int):Int        {
            return this._spriteOffsetX = k;
        }

        
        public var spriteOffsetY(get,set):Int;
public function  get_spriteOffsetY():Int
        {
            return this._spriteOffsetY;
        }
public function  set_spriteOffsetY(k:Int):Int        {
            return this._spriteOffsetY = k;
        }
    }

