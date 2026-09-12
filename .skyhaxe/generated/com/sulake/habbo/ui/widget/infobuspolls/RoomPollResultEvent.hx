package com.sulake.habbo.ui.widget.infobuspolls 
;
	import com.sulake.core.communication.messages.IMessageEvent;
	import com.sulake.core.communication.messages.MessageEvent;
	
	 class RoomPollResultEvent extends MessageEvent implements IMessageEvent
	{
		public function new(k:ASFunction)
        {
            super(k, RoomPollResultParser);
        }
		
		public function getParser():RoomPollResultParser
		{
			return Std.downcast(this._parser , RoomPollResultParser);
		}
	}


