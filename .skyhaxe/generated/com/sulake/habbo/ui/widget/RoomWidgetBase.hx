package com.sulake.habbo.ui.widget
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import flash.events.IEventDispatcher;
    import com.sulake.core.window.IWindow;

     class RoomWidgetBase implements IRoomWidget
    {
        var _disposed:Bool = false;
        var _events:EventDispatcherWrapper;
        var _messageListener:IRoomWidgetMessageListener;
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _localizations:IHabboLocalizationManager;
        var _handler:IRoomWidgetHandler;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null, _arg_4:IHabboLocalizationManager=null)
        {
            this._handler = k;
            this._windowManager = _arg_2;
            this._assets = _arg_3;
            this._localizations = _arg_4;
        }

        public var state(get,never):Int;
public function  get_state():Int
        {
            return 0;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function initialize(k:Int=0)
        {
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._messageListener = null;
            this._windowManager = null;
            if (((!(this._events == null)) && (!this._events.disposed)))
            {
                this.unregisterUpdateEvents(this._events);
            }
            if (this._handler != null)
            {
                this._handler.dispose();
                this._handler = null;
            }
            this._events = null;
            this._assets = null;
            this._localizations = null;
            this._disposed = true;
        }

        
        public var messageListener(get,set):IRoomWidgetMessageListener;
public function  set_messageListener(k:IRoomWidgetMessageListener):IRoomWidgetMessageListener        {
            return this._messageListener = k;
        }
public function  get_messageListener():IRoomWidgetMessageListener
        {
            return this._messageListener;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var assets(get,never):IAssetLibrary;
public function  get_assets():IAssetLibrary
        {
            return this._assets;
        }

        public var localizations(get,never):IHabboLocalizationManager;
public function  get_localizations():IHabboLocalizationManager
        {
            return this._localizations;
        }

        public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (Std.is(k , EventDispatcherWrapper))
            {
                this._events = Std.downcast(k , EventDispatcherWrapper);
            }
        }

        public function unregisterUpdateEvents(k:IEventDispatcher)
        {
        }

        public var mainWindow(get,never):IWindow;
public function  get_mainWindow():IWindow
        {
            return null;
        }
    }

