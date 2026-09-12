package com.sulake.habbo.communication.messages.incoming.catalog 
;
	import com.sulake.core.communication.messages.IMessageEvent;
	import com.sulake.core.communication.messages.MessageEvent;
	/**
	 * ...
	 * @author 
	 */
	 class FireworkChargeDataEvent extends MessageEvent implements IMessageEvent
	{
		
		public function new(k:ASFunction)
        {
            super(k, FireworkChargeDataParser);
        }

        public function getParser():FireworkChargeDataParser
        {
            return Std.downcast(this._parser , FireworkChargeDataParser);
        }

		
	}


