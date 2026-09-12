package com.sulake.habbo.communication.messages.incoming.notifications 
;
	import com.sulake.core.communication.messages.IMessageEvent;
	import com.sulake.core.communication.messages.MessageEvent;
	/**
	 * ...
	 * @author 
	 */
	 class SimpleAlertMessageEvent extends MessageEvent implements IMessageEvent
	{
		
		public function new(k:ASFunction)
		{
			super(k, SimpleAlertMessageParser);
		}
		
		public function getParser():SimpleAlertMessageParser
        {
            return Std.downcast(_parser , SimpleAlertMessageParser);
        }
	}

