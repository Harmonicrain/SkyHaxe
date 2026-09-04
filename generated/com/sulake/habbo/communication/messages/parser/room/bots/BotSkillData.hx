package com.sulake.habbo.communication.messages.parser.room.bots
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BotSkillData
    {
        var _id:Int = 0;
        var _data:String;

        public function new(k:IMessageDataWrapper)
        {
            this.parse(k);
        }

        public function parse(k:IMessageDataWrapper)
        {
            this._id = k.readInteger();
            this._data = k.readString();
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var data(get,never):String;
function  get_data():String
        {
            return this._data;
        }
    }

