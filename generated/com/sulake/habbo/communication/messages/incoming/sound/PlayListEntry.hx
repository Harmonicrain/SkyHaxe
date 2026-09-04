package com.sulake.habbo.communication.messages.incoming.sound
;
     class PlayListEntry
    {
        var _id:Int = 0;
        var _length:Int = 0;
        var _name:String;
        var _creator:String;
        var _startPlayHead:Float = 0;

        public function new(id:Int, length:Int, name:String, creator:String)
        {
            this._id = id;
            this._length = length;
            this._name = name;
            this._creator = creator;
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var length(get,never):Int;
function  get_length():Int
        {
            return this._length;
        }

        public var name(get,never):String;
function  get_name():String
        {
            return this._name;
        }

        public var creator(get,never):String;
function  get_creator():String
        {
            return this._creator;
        }

        
        public var startPlayHeadPos(get,set):Float;
function  get_startPlayHeadPos():Float
        {
            return this._startPlayHead;
        }
function  set_startPlayHeadPos(k:Float):Float        {
            return this._startPlayHead = k;
        }
    }

