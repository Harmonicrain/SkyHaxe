package com.sulake.habbo.catalog.targetedoffers
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.targetedoffers.data.TargetedOffer;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.habbo.catalog.targetedoffers.util.RemainingTimeFormatter;
    import com.sulake.core.window.components.ITextWindow;

     class OfferView implements IDisposable 
    {
        var _window:IWindowContainer;
        var _controller:OfferController;
        var _offer:TargetedOffer;
        var _Str_2788:Timer;
        var _disposed:Bool = false;
        var _Str_5181:String;

        public function new(k:OfferController, _arg_2:TargetedOffer)
        {
            this._controller = k;
            this._offer = _arg_2;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._Str_2788 != null)
            {
                this._Str_2788.stop();
                this._Str_2788 = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function _Str_13550()
        {
            this._Str_2788 = new Timer(1000);
            this._Str_2788.addEventListener(TimerEvent.TIMER, (this._Str_11704 : ASAny));
            this._Str_2788.start();
            this._Str_20163();
        }

        function _Str_11704(k:TimerEvent)
        {
            this._Str_20163();
        }

        function _Str_20163()
        {
            this.setTimeLeft(RemainingTimeFormatter._Str_25649(this._controller.catalog.localization, this._offer._Str_18165()));
            if (this._offer._Str_18165() == 0)
            {
                this._controller._Str_6602();
            }
        }

        function setTimeLeft(k:String)
        {
            var _local_2= cast(this._window.findChildByName("txt_time_left"), ITextWindow);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.text = ((this._Str_5181 != "") ? ASCompat.stringReplace(this._Str_5181, "%timeleft%", k) : k);
        }

        function getLocalization(k:String, _arg_2:String=null):String
        {
            var _local_3= this._controller.catalog.localization.getLocalization(k, (if (ASCompat.stringAsBool(_arg_2)) _arg_2; else k));
            if (!ASCompat.stringAsBool(_local_3))
            {
                return null;
            }
            if (this._offer != null)
            {
                _local_3 = ASCompat.stringReplace(_local_3, "%itemsleft%", this._offer.purchaseLimit);
            }
            return _local_3;
        }
    }

