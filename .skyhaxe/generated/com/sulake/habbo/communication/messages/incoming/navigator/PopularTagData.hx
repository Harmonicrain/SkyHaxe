package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PopularTagData
    {
        var _tagName:String;
        var _userCount:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._tagName = k.readString();
            this._userCount = k.readInteger();
        }

        public var tagName(get,never):String;
public function  get_tagName():String
        {
            return this._tagName;
        }

        public var userCount(get,never):Int;
public function  get_userCount():Int
        {
            return this._userCount;
        }
    }

