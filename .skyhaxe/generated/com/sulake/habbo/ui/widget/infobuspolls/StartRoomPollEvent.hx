package com.sulake.habbo.ui.widget.infobuspolls 
;
	import com.sulake.core.communication.messages.IMessageEvent;
	import com.sulake.core.communication.messages.MessageEvent;
	/**
	 * ...
	 * @author 
	 */
	 class StartRoomPollEvent extends MessageEvent implements IMessageEvent
	{
		public function new(k:ASFunction)
        {
            super(k, RoomPollDataParser);
        }
		
		public function getParser():RoomPollDataParser
		{
			return Std.downcast(this._parser , RoomPollDataParser);
		}
	}


