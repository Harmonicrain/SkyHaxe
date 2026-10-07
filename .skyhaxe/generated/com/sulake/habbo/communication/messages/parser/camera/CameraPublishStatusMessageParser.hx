package com.sulake.habbo.communication.messages.parser.camera
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CameraPublishStatusMessageParser implements IMessageParser 
    {
        var _ok:Bool = false;
        var _secondsToWait:Int = 0;
        var _extraDataId:String;


        public function isOk():Bool
        {
            return this._ok;
        }

        public function getSecondsToWait():Int
        {
            return this._secondsToWait;
        }

        public function getExtraDataId():String
        {
            return this._extraDataId;
        }

        public function flush():Bool
        {
            this._ok = false;
            this._secondsToWait = 0;
            this._extraDataId = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._ok = k.readBoolean();
            this._secondsToWait = k.readInteger();
            if ((this._ok && (k.bytesAvailable != 0)))
            {
                this._extraDataId = k.readString();
            }
            return true;
        }

	public function new() {}
    }

