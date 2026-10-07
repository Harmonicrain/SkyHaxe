package com.sulake.habbo.notifications.singular
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.assets.IAssetLibrary;
	import com.sulake.habbo.notifications.singular.HabboNotificationItem;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.notifications.HabboNotifications;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.toolbar.events.ExtensionViewEvent;
    import com.sulake.habbo.session.events.BadgeImageReadyEvent;
    import flash.events.Event;

     class HabboNotificationViewManager implements IUpdateReceiver 
    {
        static inline final _Str_2942= 4;

        var _assetLibrary:IAssetLibrary;
        var _windowManager:IHabboWindowManager;
        var _toolbar:IHabboToolbar;
        var _notifications:HabboNotifications;
        var _styleConfig:Map;
        var _viewConfig:Map;
        var _disposed:Bool = false;
        var _viewItems:Array<ASAny>;

        public function new(k:HabboNotifications, _arg_2:IAssetLibrary, _arg_3:IHabboWindowManager, _arg_4:IHabboToolbar, _arg_5:Map, _arg_6:Map)
        {
            this._notifications = k;
            this._assetLibrary = _arg_2;
            this._windowManager = _arg_3;
            this._toolbar = _arg_4;
            this._styleConfig = _arg_5;
            this._viewConfig = _arg_6;
            this._viewItems = new Array<ASAny>();
            if (this._toolbar != null)
            {
                this._toolbar.events.addEventListener(ExtensionViewEvent.EVE_EXTENSION_VIEW_RESIZED, this._Str_22079);
            }
            this._notifications.registerUpdateReceiver(this, 2);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function replaceIcon(k:BadgeImageReadyEvent)
        {
            var _local_2:HabboNotificationItemView = null;
            final _iter_ = this._viewItems; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2.replaceIcon(k);
            }
        }

        public function dispose()
        {
            var k= this._viewItems.length;
            var _local_2 = 0;
            while (_local_2 < k)
            {
                ASCompat.dynamicAs(this._viewItems.pop() , HabboNotificationItemView).dispose();
                _local_2++;
            }
            this._assetLibrary = null;
            this._windowManager = null;
            if (this._styleConfig != null)
            {
                this._styleConfig.dispose();
                this._styleConfig = null;
            }
            if (this._viewConfig != null)
            {
                this._viewConfig.dispose();
                this._viewConfig = null;
            }
            if (this._toolbar != null)
            {
                this._toolbar.events.removeEventListener(ExtensionViewEvent.EVE_EXTENSION_VIEW_RESIZED, this._Str_22079);
                this._toolbar = null;
            }
            if (this._notifications != null)
            {
                this._notifications.removeUpdateReceiver(this);
                this._notifications = null;
            }
            this._disposed = true;
        }

        public function showItem(k:HabboNotificationItem):Bool
        {
            if (!this._Str_19647())
            {
                return false;
            }
            var layoutName= k.style.customLayout == null ? "layout_notification_xml" : k.style.customLayout;
            var viewName= k.style.customView;
            var viewConfig:Map = viewName == null ? this._viewConfig.getValue("view"): this._viewConfig.getValue(viewName);
            var _local_2= new HabboNotificationItemView(this._assetLibrary.getAssetByName(layoutName), this._windowManager, this._styleConfig, viewConfig, k);
            _local_2.reposition(this._Str_22218());
            this._viewItems.push(_local_2);
            ASCompat.ASArray.sortOn(this._viewItems, "verticalPosition", ASCompat.ASArray.NUMERIC);
            return true;
        }

        public function hasNotificationById(id:String):Bool
        {
var item:HabboNotificationItemView  = null;            if (id == null)
            {
                return false;
            }
            final _iter_ = this._viewItems; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item = _tmp_;
                if (item.notificationId == id && !item.ready)
                {
                    return true;
                }
            }
            return false;
        }

        public function removeNotificationById(id:String)
        {
var item:HabboNotificationItemView  = null;            if (id == null)
            {
                return;
            }
            final _iter_ = this._viewItems; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item = _tmp_;
                if (item.notificationId == id)
                {
                    item.remove();
                }
            }
        }

        public function _Str_19647():Bool
        {
            return (this._Str_22218() + HabboNotificationItemView.ITEM_HEIGHT) < this._windowManager.getDesktop(0).height;
        }

        public function update(k:UInt)
        {
            var _local_3:HabboNotificationItemView = null;
            var _local_2 = 0;
            _local_2 = 0;
            while (_local_2 < this._viewItems.length)
            {
                ASCompat.dynamicAs(this._viewItems[_local_2] , HabboNotificationItemView).update(k);
                _local_2++;
            }
            _local_2 = 0;
            while (_local_2 < this._viewItems.length)
            {
                _local_3 = ASCompat.dynamicAs(this._viewItems[_local_2] , HabboNotificationItemView);
                if (_local_3.ready)
                {
                    _local_3.dispose();
                    this._viewItems.splice(_local_2, 1);
                    _local_2--;
                }
                _local_2++;
            }
        }

        function _Str_22218():Int
        {
            var _local_4:HabboNotificationItemView = null;
            if (this._toolbar == null)
            {
                return _Str_2942;
            }
            if (this._toolbar.extensionView == null)
            {
                return _Str_2942;
            }
            var k= ASCompat.toInt(this._toolbar.extensionView.screenHeight + _Str_2942);
            if (this._viewItems.length == 0)
            {
                return k;
            }
            var _local_2= k;
            var _local_3 = 0;
            while (_local_3 < this._viewItems.length)
            {
                _local_4 = ASCompat.dynamicAs(this._viewItems[_local_3] , HabboNotificationItemView);
                if ((_local_2 + HabboNotificationItemView.ITEM_HEIGHT) < _local_4.verticalPosition)
                {
                    return _local_2;
                }
                _local_2 = ((_local_4.verticalPosition + HabboNotificationItemView.ITEM_HEIGHT) + _Str_2942);
                _local_3++;
            }
            return _local_2;
        }

        public function _Str_22079(k:Event)
        {
            var _local_4:HabboNotificationItemView = null;
            var _local_2= ASCompat.toInt(this._toolbar.extensionView.screenHeight + _Str_2942);
            var _local_3 = 0;
            while (_local_3 < this._viewItems.length)
            {
                _local_4 = ASCompat.dynamicAs(this._viewItems[_local_3] , HabboNotificationItemView);
                _local_4.reposition(_local_2);
                _local_2 = ((_local_4.verticalPosition + HabboNotificationItemView.ITEM_HEIGHT) + _Str_2942);
                _local_3++;
            }
        }
    }

