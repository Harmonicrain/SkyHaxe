package com.sulake.habbo.friendbar.data
;
     class FriendRequest implements IFriendRequest 
    {
        var _id:Int = 0;
        var _name:String;
        var _figure:String;

        public function new(k:Int, _arg_2:String, _arg_3:String)
        {
            this._id = k;
            this._name = _arg_2;
            this._figure = _arg_3;
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

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }
    }

