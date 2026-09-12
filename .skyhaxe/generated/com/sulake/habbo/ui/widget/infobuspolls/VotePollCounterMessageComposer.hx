package com.sulake.habbo.ui.widget.infobuspolls 
;
	import com.sulake.core.communication.messages.IMessageComposer;
	/**
	 * ...
	 * @author 
	 */
	 class VotePollCounterMessageComposer implements IMessageComposer
	{
		var _data:Array<ASAny>;

		public function new(counter:Int) 
		{
			this._data = [];
            this._data = [counter];
		}
		
		
		public function getMessageArray():Array<ASAny> 
		{
			return this._data;
		}
		
		public function dispose() 
		{
			
            this._data = null;
		}
		
	}


