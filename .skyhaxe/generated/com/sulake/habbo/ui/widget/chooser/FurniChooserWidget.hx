package com.sulake.habbo.ui.widget.chooser
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.widget.events._Str_4178;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomObjectUpdateEvent;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRequestWidgetMessage;
    import com.sulake.habbo.ui.widget.events._Str_3405;

     class FurniChooserWidget extends ChooserWidgetBase
    {
        var _furniChooser:FurniChooserView;
        var _items:Array<ASAny>;
        var _itemIds:ASDictionary<ASAny,ASAny>;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null, _arg_4:IHabboLocalizationManager=null)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        override public function dispose()
        {
            if (this._furniChooser != null)
            {
                this._furniChooser.dispose();
                this._furniChooser = null;
            }
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(_Str_4178.RWCCE_FURNI_CHOOSER_CONTENT, this.onChooserContent);
            k.addEventListener(_Str_4178.RWCCE_FURNI_CHOOSER_CONTENT_ADD, this.onChooserContentAdded);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_REMOVED, this.onFurniUpdated);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_ADDED, this.onFurniUpdated);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(_Str_4178.RWCCE_FURNI_CHOOSER_CONTENT, this.onChooserContent);
            k.removeEventListener(_Str_4178.RWCCE_FURNI_CHOOSER_CONTENT_ADD, this.onChooserContentAdded);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_REMOVED, this.onFurniUpdated);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_ADDED, this.onFurniUpdated);
        }

        function onChooserContent(k:_Str_4178)
        {
            if (k == null || k.items == null)
            {
                return;
            }
            if (this._furniChooser == null)
            {
                this._furniChooser = new FurniChooserView(this);
            }
            this._items = [];
            this._itemIds = new ASDictionary<ASAny,ASAny>();
            var _local_2:_Str_3405 = null;
            final _iter_ = k.items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.id != 0)
                {
                    this._items.push(_local_2);
                    this._itemIds[(Std.string(_local_2.category) + "_" + Std.string(_local_2.id))] = true;
                }
            }
            ASCompat.ASArray.sort(this._items, this._Str_22274);
            this._furniChooser.onItemsChanged();
        }

        function onChooserContentAdded(k:_Str_4178)
        {
            var _local_3:_Str_3405 = null;
            var _local_2 = false;
            if (((((k == null) || (k.items == null)) || (this._furniChooser == null)) || (this._items == null)))
            {
                return;
            }
            _local_2 = false;
            final _iter_ = k.items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (((_local_3.id != 0) && (!this._itemIds[(Std.string(_local_3.category) + "_" + Std.string(_local_3.id))])))
                {
                    this._items.push(_local_3);
                    this._itemIds[(Std.string(_local_3.category) + "_" + Std.string(_local_3.id))] = true;
                    _local_2 = true;
                }
            }
            if (_local_2)
            {
                ASCompat.ASArray.sort(this._items, this._Str_22274);
                this._furniChooser.onItemsChanged();
            }
        }

        function onFurniUpdated(k:RoomWidgetRoomObjectUpdateEvent)
        {
            var _local_2 = 0;
            var _local_3:_Str_3405 = null;
            if (this._furniChooser == null || !this._furniChooser.isOpen())
            {
                return;
            }
            if (k.type == RoomWidgetRoomObjectUpdateEvent.FURNI_REMOVED)
            {
                if (this._items == null)
                {
                    return;
                }
                _local_2 = 0;
                while (_local_2 < this._items.length)
                {
                    _local_3 = ASCompat.dynamicAs(this._items[_local_2] , _Str_3405);
                    if (((_local_3.id == k.id) && (_local_3.category == k.category)))
                    {
                        this._items.splice(_local_2, 1);
                        this._itemIds.remove((Std.string(_local_3.category) + "_" + Std.string(_local_3.id)));
                        this._furniChooser.onItemsChanged();
                        return;
                    }
                    _local_2++;
                }
                return;
            }
            if (k.type == RoomWidgetRoomObjectUpdateEvent.FURNI_ADDED)
            {
                messageListener.processWidgetMessage(new RoomWidgetRequestWidgetMessage(RoomWidgetRequestWidgetMessage.RWRWM_FURNI_CHOOSER_ADD, k.id, k.category));
            }
        }

        public var items(get,never):Array<ASAny>;
public function  get_items():Array<ASAny>
        {
            return this._items;
        }

        function _Str_22274(k:_Str_3405, _arg_2:_Str_3405):Int
        {
            if (((k == null) || (_arg_2 == null)))
            {
                return 0;
            }
            if (k.lowerCaseName < _arg_2.lowerCaseName)
            {
                return -1;
            }
            if (k.lowerCaseName > _arg_2.lowerCaseName)
            {
                return 1;
            }
            if (k.id < _arg_2.id)
            {
                return -1;
            }
            if (k.id > _arg_2.id)
            {
                return 1;
            }
            return 0;
        }
    }

