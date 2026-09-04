package com.sulake.habbo.communication.messages.incoming.room.engine
;
     class AvatarActionMessageData
    {
        var _actionType:String;
        var _actionParameter:String;

        public function new(k:String, _arg_2:String)
        {
            this._actionType = k;
            this._actionParameter = _arg_2;
        }

        public var actionType(get,never):String;
function  get_actionType():String
        {
            return this._actionType;
        }

        public var actionParameter(get,never):String;
function  get_actionParameter():String
        {
            return this._actionParameter;
        }

        public function toString():String
        {
            return (this._actionType + ":") + this._actionParameter;
        }
    }

