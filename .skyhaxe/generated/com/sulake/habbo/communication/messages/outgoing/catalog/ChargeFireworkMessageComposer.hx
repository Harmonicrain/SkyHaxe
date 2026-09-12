package com.sulake.habbo.communication.messages.outgoing.catalog 
;
	import com.sulake.core.communication.messages.IMessageComposer;
	/**
	 * ...
	 * @author 
	 */
	 class ChargeFireworkMessageComposer  implements IMessageComposer 
	{
        var _data:Array<ASAny>;
		
		public function new(spriteId:Int, type:Int) 
		{
			this._data = new Array<ASAny>();
			this._data.push(spriteId);
			this._data.push(type);
		}
		
		
		/* INTERFACE com.sulake.core.runtime.IDisposable */
		
		public function dispose() 
		{
			this._data = null;
		}
		
		
		/* INTERFACE com.sulake.core.communication.messages.IMessageComposer */
		
		public function getMessageArray():Array<ASAny> 
		{
			return this._data;
		}
		
	}


