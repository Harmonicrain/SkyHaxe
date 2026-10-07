package com.sulake.habbo.communication.messages.parser.camera
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CompetitionStatusMessageParser implements IMessageParser 
    {
        var _ok:Bool = false;
        var _errorReason:String = null;


        public function isOk():Bool
        {
            return this._ok;
        }

        public function getErrorReason():String
        {
            return this._errorReason;
        }

        public function flush():Bool
        {
            this._ok = false;
            this._errorReason = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._ok = k.readBoolean();
            this._errorReason = k.readString();
            return true;
        }

	public function new() {}
    }

