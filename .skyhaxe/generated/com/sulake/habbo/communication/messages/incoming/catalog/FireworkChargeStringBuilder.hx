package com.sulake.habbo.communication.messages.incoming.catalog 
;
	import com.sulake.core.localization.ICoreLocalizationManager;
	import com.sulake.core.runtime.IDisposable;
	import com.sulake.habbo.catalog.HabboCatalog;
	/**
	 * ...
	 * @author 
	 */
	 class FireworkChargeStringBuilder implements IDisposable
	{
		
        var _balance:String;
        var _cost:String;
		var _disposed:Bool = false;
		
		public function new(catalog:HabboCatalog, localization:ICoreLocalizationManager, dataWrapper:FireworkChargeDataWrapper)
        {
            if (((dataWrapper._SafeStr_5946 > 0) && (dataWrapper._SafeStr_5944 > 0)))
            {
                this.setWithKey(catalog, localization, dataWrapper, ("catalog.purchase.price.credits_and_activitypoints." + Std.string(dataWrapper._SafeStr_5945)));
            }
            else
            {
                if (dataWrapper._SafeStr_5946 > 0)
                {
                    this.setWithKey(catalog, localization, dataWrapper, "catalog.purchase.price.credits");
                }
                else
                {
                    if (dataWrapper._SafeStr_5944 > 0)
                    {
                        this.setWithKey(catalog, localization, dataWrapper, ("catalog.purchase.price.activitypoints." + Std.string(dataWrapper._SafeStr_5945)));
                    }
                    else
                    {
                        this.setWithKey(catalog, localization, dataWrapper, "catalog.purchase.price.none");
                    }
                }
            }
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._disposed = true;
            this._balance = null;
            this._cost = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function setWithKey(catalog:HabboCatalog, localization:ICoreLocalizationManager, dataWrapper:FireworkChargeDataWrapper, key:String)
        {
            var _local_5= Std.string(catalog.getPurse().credits);
            var _local_6= ((dataWrapper._SafeStr_5945 == 0) ? "pixels" : "activitypoints");
            var _local_7= localization.getLocalizationRaw(key);
            if (_local_7 != null)
            {
                localization.registerParameter(key, "credits", Std.string(dataWrapper._SafeStr_5946));
                localization.registerParameter(key, _local_6, Std.string(dataWrapper._SafeStr_5944));
                this._cost = _local_7.value;
                localization.registerParameter(key, "credits", _local_5);
                localization.registerParameter(key, _local_6, Std.string(catalog.getPurse().getActivityPointsForType(dataWrapper._SafeStr_5945)));
                this._balance = _local_7.value;
            }
        }

        public var balance(get,never):String;
public function  get_balance():String
        {
            return this._balance;
        }

        public var cost(get,never):String;
public function  get_cost():String
        {
            return this._cost;
        }
		
	}


