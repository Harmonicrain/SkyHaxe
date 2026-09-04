package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.room.IAreaHideInfo;

     class AreaHideMessageData implements IAreaHideInfo
    {
        var _furniId:Int = 0;
        var _on:Bool = false;
        var _rootX:Int = 0;
        var _rootY:Int = 0;
        var _width:Int = 0;
        var _length:Int = 0;
        var _invert:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._furniId = k.readInteger();
            this._on = k.readBoolean();
            this._rootX = k.readInteger();
            this._rootY = k.readInteger();
            this._width = k.readInteger();
            this._length = k.readInteger();
            this._invert = k.readBoolean();
        }

        public var furniId(get,never):Int;
function  get_furniId():Int { return this._furniId; }
        public var on(get,never):Bool;
function  get_on():Bool { return this._on; }
        public var rootX(get,never):Int;
function  get_rootX():Int { return this._rootX; }
        public var rootY(get,never):Int;
function  get_rootY():Int { return this._rootY; }
        public var width(get,never):Int;
function  get_width():Int { return this._width; }
        public var length(get,never):Int;
function  get_length():Int { return this._length; }
        public var invert(get,never):Bool;
function  get_invert():Bool { return this._invert; }
    }

