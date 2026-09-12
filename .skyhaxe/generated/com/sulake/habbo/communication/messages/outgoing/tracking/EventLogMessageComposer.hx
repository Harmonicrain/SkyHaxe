package com.sulake.habbo.communication.messages.outgoing.tracking
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class EventLogMessageComposer implements IMessageComposer 
    {
        var _category:String;
        var _type:String;
        var _action:String;
        var _extraString:String;
        var _extraInt:Int = 0;

        public function new(category:String, type:String, action:String, extraString:String="", extraInt:Int=0)
        {
            this._category = (ASCompat.stringAsBool(category) ? category : "");
            this._type = (ASCompat.stringAsBool(type) ? type : "");
            this._action = (ASCompat.stringAsBool(action) ? action : "");
            this._extraString = (ASCompat.stringAsBool(extraString) ? extraString : "");
            this._extraInt = ((extraInt != 0) ? extraInt : 0);
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._category, this._type, this._action, this._extraString, this._extraInt];
        }
    }

