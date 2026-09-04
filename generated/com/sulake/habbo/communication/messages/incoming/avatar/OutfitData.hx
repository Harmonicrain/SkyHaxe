package com.sulake.habbo.communication.messages.incoming.avatar
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class OutfitData
    {
        var _slotId:Int = 0;
        var _figureString:String;
        var _gender:String;

        public function new(k:IMessageDataWrapper)
        {
            this._slotId = k.readInteger();
            this._figureString = k.readString();
            this._gender = k.readString();
        }

        public var slotId(get,never):Int;
function  get_slotId():Int
        {
            return this._slotId;
        }

        public var figureString(get,never):String;
function  get_figureString():String
        {
            return this._figureString;
        }

        public var gender(get,never):String;
function  get_gender():String
        {
            return this._gender;
        }
    }

