package com.sulake.habbo.communication.messages.incoming.catalog 
;
	import com.sulake.core.communication.messages.IMessageDataWrapper;
	import com.sulake.core.communication.messages.IMessageParser;
	/**
	 * ...
	 * @author 
	 */
	 class FireworkChargeDataParser implements IMessageParser
	{
		var _fireworkChargeData:FireworkChargeData;
		
		public function flush():Bool 
		{
			return true;
		}
		
		public function parse(_arg_1:IMessageDataWrapper):Bool 
		{
			this._fireworkChargeData = new FireworkChargeData(_arg_1);
			return true;
		}
		
		public var fireworkChargeData(get,never):FireworkChargeData;
public function  get_fireworkChargeData():FireworkChargeData
		{
			return this._fireworkChargeData;
		}

	public function new() {}
	}


