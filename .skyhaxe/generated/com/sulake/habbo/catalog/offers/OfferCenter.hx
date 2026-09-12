package com.sulake.habbo.catalog.offers
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import flash.utils.Timer;
    import com.sulake.habbo.communication.messages.incoming.notifications.OfferRewardDeliveredMessageEvent;
    import flash.events.TimerEvent;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.core.window.components.IBitmapWrapperWindow;

     class OfferCenter implements IOfferCenter implements  IDisposable 
    {
        static inline final _Str_16629= 1800000;

        var _disposed:Bool = false;
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _catalog:IHabboCatalog;
        var _offerExtension:IOfferExtension;
        var _window:IWindowContainer;
        var _currentProvider:IOfferProvider;
        var _providers:Vector<IOfferProvider>;
        var _rewards:Vector<OfferReward>;
        var _rewardTemplate:IWindow;
        var _pollTimer:Timer;
        var _offerRewardDeliveredMessageEvent:OfferRewardDeliveredMessageEvent;

        public function new(k:IHabboWindowManager, _arg_2:IAssetLibrary, _arg_3:IHabboCatalog)
        {
            this._windowManager = k;
            this._assets = _arg_2;
            this._catalog = _arg_3;
            this._offerRewardDeliveredMessageEvent = new OfferRewardDeliveredMessageEvent(this._Str_22579);
            this._catalog.connection.addMessageEvent(this._offerRewardDeliveredMessageEvent);
            this._providers = new Vector<IOfferProvider>(0);
            this._providers.push(new SupersonicProvider(this));
            this._providers.push(new SponsorPayProvider(this));
            this._rewards = new Vector<OfferReward>(0);
            this._pollTimer = new Timer(_Str_16629);
            this._pollTimer.addEventListener(TimerEvent.TIMER, (this.onPollTimer : ASAny));
            this._pollTimer.start();
            this.onPollTimer(null);
        }

        function onPollTimer(k:TimerEvent)
        {
            var _local_2:IOfferProvider = null;
            if (this._providers == null)
            {
                return;
            }
            final _iter_ = this._providers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.enabled)
                {
                    _local_2.load();
                }
            }
        }

        function _Str_24957():IOfferProvider
        {
            var k:IOfferProvider = null;
            if (this._providers == null)
            {
                return null;
            }
            final _iter_ = this._providers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if ((k.enabled && k._Str_15510))
                {
                    return k;
                }
            }
            return null;
        }

        function _Str_22579(k:OfferRewardDeliveredMessageEvent)
        {
            var _local_2= k.getParser();
            this._Str_23174(_local_2.name, _local_2.contentType, _local_2.classId);
        }

        public function dispose()
        {
            var k:IOfferProvider = null;
            if (this._disposed)
            {
                return;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._providers != null)
            {
                final _iter_ = this._providers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    k.dispose();
                }
                this._providers = null;
            }
            if (this._pollTimer != null)
            {
                this._pollTimer.stop();
                this._pollTimer = null;
            }
            this._catalog.connection.removeMessageEvent(this._offerRewardDeliveredMessageEvent);
            this._offerRewardDeliveredMessageEvent = null;
            this._rewards = null;
            this._offerExtension = null;
            this._windowManager = null;
            this._catalog = null;
            this._assets = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var _Str_24459(never,set):IOfferExtension;
public function  set__Str_24459(k:IOfferExtension):IOfferExtension        {
            return this._offerExtension = k;
        }

        public function _Str_19222()
        {
            this.hide();
            this._window = Std.downcast(this._windowManager.buildFromXML(((this._assets.getAssetByName("offer_center_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._window.procedure = this.windowProcedure;
            this._window.center();
            this._rewardTemplate = cast(this._window.findChildByName("reward_list"), IItemListWindow).removeListItemAt(0);
            this._Str_22857();
        }

        public function showVideo()
        {
            if (this._currentProvider != null)
            {
                this._currentProvider.showVideo();
            }
        }

        public var _Str_16243(get,never):Bool;
public function  get__Str_16243():Bool
        {
            return (!(this._currentProvider == null)) && this._currentProvider._Str_16897;
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(k.type == WindowMouseEvent.CLICK)) || (!this.visible)))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close":
                    this.hide();
                    return;
            }
        }

        function hide()
        {
            if (this._window != null)
            {
                this._rewardTemplate.dispose();
                this._rewardTemplate = null;
                this._window.dispose();
                this._window = null;
            }
        }

        function _Str_23174(k:String, _arg_2:String, _arg_3:Int)
        {
            var _local_4= new OfferReward(k, _arg_2, _arg_3);
            this._rewards.unshift(_local_4);
            if (this.visible)
            {
                cast(this._window.findChildByName("reward_list"), IItemListWindow).addListItemAt(this._Str_22016(_local_4), 0);
            }
            else
            {
                if (this._offerExtension != null)
                {
                    this._offerExtension._Str_18053();
                }
            }
        }

        public var configuration(get,never):IHabboConfigurationManager;
public function  get_configuration():IHabboConfigurationManager
        {
            return ASCompat.reinterpretAs(this._catalog , IHabboConfigurationManager);
        }

        public function _Str_4988()
        {
            if (this._offerExtension != null)
            {
                this._currentProvider = this._Str_24957();
                this._offerExtension._Str_14237(((!(this._currentProvider == null)) && this._currentProvider._Str_15510));
            }
        }

        function _Str_22857()
        {
            var _local_2:OfferReward = null;
            if (!this.visible)
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("reward_list") , IItemListWindow);
            k.destroyListItems();
            final _iter_ = this._rewards; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k.addListItem(this._Str_22016(_local_2));
            }
        }

        function _Str_22016(k:OfferReward):IWindow
        {
            var _local_2= Std.downcast(this._rewardTemplate.clone() , IWindowContainer);
            _local_2.findChildByName("reward_date").caption = ASCompat.dateToLocaleString(Date.now());
            _local_2.findChildByName("reward_name").caption = k.name;
            this._catalog.displayProductIcon(k.contentType, k.classId, cast(_local_2.findChildByName("reward_icon"), IBitmapWrapperWindow));
            return _local_2;
        }

        var visible(get,never):Bool;
function  get_visible():Bool
        {
            return ((!(this._window == null)) && (!this._window.disposed)) && this._window.visible;
        }

        public function _Str_24469()
        {
        }
    }

