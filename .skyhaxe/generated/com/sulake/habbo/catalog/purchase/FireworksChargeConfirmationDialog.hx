package com.sulake.habbo.catalog.purchase 
;
	import com.sulake.core.window.IWindow;
	import com.sulake.core.assets.XmlAsset;
	import com.sulake.core.localization.ICoreLocalizationManager;
	import com.sulake.core.runtime.IDisposable;
	import com.sulake.core.window.components.IFrameWindow;
	import com.sulake.core.window.events.WindowEvent;
	import com.sulake.core.window.events.WindowMouseEvent;
	import com.sulake.habbo.catalog.HabboCatalog;
	import com.sulake.habbo.communication.messages.incoming.catalog.FireworkChargeData;
	import com.sulake.habbo.communication.messages.incoming.catalog.FireworkChargeDataWrapper;
	import com.sulake.habbo.communication.messages.incoming.catalog.FireworkChargeStringBuilder;
	import com.sulake.habbo.communication.messages.outgoing.catalog.ChargeFireworkMessageComposer;
	/**
	 * ...
	 * @author 
	 */
	 class FireworksChargeConfirmationDialog implements IDisposable
	{
		var _disposed:Bool = false;
				
		var _catalog:HabboCatalog;
        var _localization:ICoreLocalizationManager;
        var _fireworkChargeData:FireworkChargeData;
        var _window:IFrameWindow;

		
		public function new(_arg_1:HabboCatalog, _arg_2:ICoreLocalizationManager) 
		{
            this._catalog = _arg_1;
            this._localization = _arg_2;
		}

        public function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        public function _SafeStr_3550()
        {
            if (((!(this._window == null)) && this._window.visible))
            {
                this._SafeStr_8412(this._fireworkChargeData);
            }
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._disposed = true;
            this._catalog = null;
            this._localization = null;
            this._fireworkChargeData = null;
            if (this._window != null)
            {
                this._window.dispose();
            }
            this._window = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function _SafeStr_8412(_arg_1:FireworkChargeData)
        {
            var _local_4:IWindow = null;
            var _local_5:IWindow = null;
            this._fireworkChargeData = _arg_1;
            if (this._window == null)
            {
                this._window = Std.downcast(this.createWindow("charge_confirmation") , IFrameWindow);
                _local_4 = this._window.findChildByName("charge_button");
                _local_4.addEventListener(WindowMouseEvent.CLICK, this.chargeFireworkHandler);
                _local_5 = this._window.findChildByTag("close");
                _local_5.addEventListener(WindowMouseEvent.CLICK, this._SafeStr_4896);
                this._window.center();
            }
            this._catalog.windowManager.registerLocalizationParameter("catalog.charge.currentamount", "charges", ("" + Std.string(this._fireworkChargeData.charges)));
            var dataWrapper= new FireworkChargeDataWrapper(this._fireworkChargeData);
            var stringBuilder= new FireworkChargeStringBuilder(this._catalog, this._localization, dataWrapper);
            this._catalog.windowManager.registerLocalizationParameter("catalog.charge.info", "cost", stringBuilder.cost);
            this._catalog.windowManager.registerLocalizationParameter("catalog.charge.info", "balance", stringBuilder.balance);
            this._catalog.windowManager.registerLocalizationParameter("catalog.charge.info", "patch_size", ("" + Std.string(this._fireworkChargeData._SafeStr_7876)));
            this._window.visible = true;
            this._window.activate();
            stringBuilder.dispose();
            dataWrapper.dispose();
        }

        function createWindow(_arg_1:String):IWindow
        {
            var _local_2= Std.downcast(this._catalog.assets.getAssetByName(_arg_1) , XmlAsset);
            return Std.downcast(this._catalog.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
        }

        function chargeFireworkHandler(_arg_1:WindowEvent)
        {
            this._catalog.connection.send(new ChargeFireworkMessageComposer(this._fireworkChargeData.stuffId, 2));
        }

        function _SafeStr_4896(_arg_1:WindowEvent)
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }
	}


