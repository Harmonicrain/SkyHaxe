package com.sulake.habbo.communication.messages.incoming.notifications 
;
	import com.sulake.core.communication.messages.IMessageDataWrapper;
	import com.sulake.core.communication.messages.IMessageParser;
	/**
	 * ...
	 * @author 
	 */
	 class SimpleAlertMessageParser implements IMessageParser
	{
		var _alertMessage:String;
		var _titleMessage:String;
		
		public function flush():Bool
        {
            this._alertMessage = null;
            return true;
        }
		
		public function parse(k:IMessageDataWrapper):Bool
		{
			this._alertMessage = k.readString();
			
			if (k.bytesAvailable != 0)
			{
				this._titleMessage = k.readString();
			}
			
			return true;
		}
		
		public var alertMessage(get,never):String;
public function  get_alertMessage():String
		{
			return this._alertMessage;
		}
		
		public var titleMessage(get,never):String;
public function  get_titleMessage():String
		{
			return this._titleMessage;
		}

	public function new() {}
		
	}


