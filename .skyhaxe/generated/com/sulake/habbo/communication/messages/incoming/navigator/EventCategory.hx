package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class EventCategory
    {
        var _categoryId:Int = 0;
        var _Str_19340:String;
        var _visible:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._categoryId = k.readInteger();
            this._Str_19340 = k.readString();
            this._visible = k.readBoolean();
        }

        public var categoryId(get,never):Int;
public function  get_categoryId():Int
        {
            return this._categoryId;
        }

        public var _Str_26101(get,never):String;
public function  get__Str_26101():String
        {
            return this._Str_19340;
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            return this._visible;
        }
    }

