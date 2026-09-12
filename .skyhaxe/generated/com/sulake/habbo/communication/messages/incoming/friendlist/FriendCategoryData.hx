package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FriendCategoryData
    {
        var _id:Int = 0;
        var _name:String;

        public function new(k:IMessageDataWrapper)
        {
            this._id = k.readInteger();
            this._name = k.readString();
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }
    }

