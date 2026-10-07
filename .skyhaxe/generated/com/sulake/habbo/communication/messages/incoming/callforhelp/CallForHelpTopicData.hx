package com.sulake.habbo.communication.messages.incoming.callforhelp
;
    import com.sulake.habbo.communication.messages.incoming.moderation.INamed;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CallForHelpTopicData implements INamed
    {
        var _name:String;
        var _id:Int = 0;
        var _consequence:String;

        public function new(k:IMessageDataWrapper)
        {
            this._name = k.readString();
            this._id = k.readInteger();
            this._consequence = k.readString();
            Logger.log([((((("READ CFH TOPIC NAME: " + this._name) + ", ID: ") + Std.string(this._id)) + ", CONSEQUENCE: ") + this._consequence)]);
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var _Str_26337(get,never):String;
public function  get__Str_26337():String
        {
            return this._consequence;
        }
    }

