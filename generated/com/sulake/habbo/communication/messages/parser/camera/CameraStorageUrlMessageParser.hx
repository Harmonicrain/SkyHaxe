package com.sulake.habbo.communication.messages.parser.camera
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CameraStorageUrlMessageParser implements IMessageParser 
    {
        var _url:String;


        public var url(get,never):String;
function  get_url():String
        {
            return this._url;
        }

        public function flush():Bool
        {
            this._url = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._url = k.readString();
            return true;
        }

	public function new() {}
    }

