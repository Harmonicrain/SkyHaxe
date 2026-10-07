package com.sulake.habbo.communication.messages.incoming.catalog 
;
	import com.sulake.core.runtime.IDisposable;
	/**
	 * ...
	 * @author 
	 */
	 class FireworkChargeDataWrapper implements IDisposable
	{
		
        var _fireworksChargeData:FireworkChargeData;
        var _disposed:Bool = false;
		
		public function new(fireworksChargeData:FireworkChargeData) 
		{
			this._fireworksChargeData = fireworksChargeData;
		}
		
		
		/* INTERFACE com.sulake.core.runtime.IDisposable */
		
		public function dispose() 
		{
			if (!this._disposed)
			{
				this._fireworksChargeData = null;
				this._disposed = true;
			}
		}
		
		public var disposed(get,never):Bool;
public function  get_disposed():Bool 
		{
			return _disposed;
		}
		
		public var _SafeStr_5394(get,never):Int;
public function  get__SafeStr_5394():Int
        {
            return 0;
        }

        public var _SafeStr_5944(get,never):Int;
public function  get__SafeStr_5944():Int
        {
            return (this._fireworksChargeData != null) ? this._fireworksChargeData._SafeStr_5944 : 0;
        }

        public var _SafeStr_5945(get,never):Int;
public function  get__SafeStr_5945():Int
        {
            return (this._fireworksChargeData != null) ? this._fireworksChargeData._SafeStr_5945 : 0;
        }

        public var _SafeStr_5946(get,never):Int;
public function  get__SafeStr_5946():Int
        {
            return (this._fireworksChargeData != null) ? this._fireworksChargeData._SafeStr_5946 : 0;
        }
	}


