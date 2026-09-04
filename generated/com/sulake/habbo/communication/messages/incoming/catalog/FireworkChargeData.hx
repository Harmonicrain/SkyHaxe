package com.sulake.habbo.communication.messages.incoming.catalog 
;
	import com.sulake.core.communication.messages.IMessageDataWrapper;
	/**
	 * ...
	 * @author 
	 */
	 class FireworkChargeData 
	{
		
		var _SafeStr_7873:Int = 0;
        var _sex:Int = 0;
        var _SafeStr_6935:Int = 0;
        var _SafeStr_6936:Int = 0;
        var _SafeStr_6518:Int = 0;
        var _SafeStr_7875:Int = 0;
		
		public function new(buffer:IMessageDataWrapper) 
		{
			
			this._SafeStr_7873 = buffer.readInteger();
            this._sex = buffer.readInteger();
            this._SafeStr_6935 = buffer.readInteger();
            this._SafeStr_6936 = buffer.readInteger();
            this._SafeStr_6518 = buffer.readInteger();
            this._SafeStr_7875 = buffer.readInteger();
		}
		
        public var stuffId(get,never):Int;
function  get_stuffId():Int
        {
            return this._SafeStr_7873;
        }

        public var charges(get,never):Int;
function  get_charges():Int
        {
            return this._sex;
        }

        public var _SafeStr_5946(get,never):Int;
function  get__SafeStr_5946():Int
        {
            return this._SafeStr_6935;
        }

        public var _SafeStr_5944(get,never):Int;
function  get__SafeStr_5944():Int
        {
            return this._SafeStr_6936;
        }

        public var _SafeStr_7876(get,never):Int;
function  get__SafeStr_7876():Int
        {
            return this._SafeStr_7875;
        }

        public var _SafeStr_5945(get,never):Int;
function  get__SafeStr_5945():Int
        {
            return this._SafeStr_6518;
        }
	}


