package com.sulake.habbo.ui.widget.chooser
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.handler.UserChooserWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomObjectUpdateEvent;
    import com.sulake.habbo.ui.widget.events._Str_3405;
    import com.sulake.habbo.ui.widget.events._Str_4178;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRequestWidgetMessage;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.events.IEventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

     class UserChooserWidget extends ChooserWidgetBase
    {
        static inline final STATE_USER_CHOOSER_CLOSED= 0;
        static inline final STATE_USER_CHOOSER_OPEN= 1;

        var _userChooser:UserChooserView;
        var _items:Array<ASAny>;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary = null, _arg_4:IHabboLocalizationManager = null)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        override public function  get_state():Int
        {
            if (((this._userChooser != null) && this._userChooser.isOpen()))
            {
                return UserChooserWidget.STATE_USER_CHOOSER_OPEN;
            }
            return UserChooserWidget.STATE_USER_CHOOSER_CLOSED;
        }

        public var items(get,never):Array<ASAny>;
public function  get_items():Array<ASAny>
        {
            return this._items;
        }

        override public function initialize(k:Int = 0)
        {
            super.initialize(k);
            var handler=
                Std.downcast(this._handler , UserChooserWidgetHandler);
            if (handler != null && handler.isChooserDisabled())
            {
                return;
            }
            if (k == UserChooserWidget.STATE_USER_CHOOSER_OPEN && messageListener != null)
            {
                messageListener.processWidgetMessage(new RoomWidgetRequestWidgetMessage(RoomWidgetRequestWidgetMessage.RWRWM_USER_CHOOSER));
            }
        }

        override public function dispose()
        {
            if (this._userChooser != null)
            {
                this._userChooser.dispose();
                this._userChooser = null;
            }
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(_Str_4178.RWCCE_USER_CHOOSER_CONTENT, this.onChooserContent);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.USER_REMOVED, this.onUserChooserUpdated);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.USER_ADDED, this.onUserChooserUpdated);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(_Str_4178.RWCCE_USER_CHOOSER_CONTENT, this.onChooserContent);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.USER_REMOVED, this.onUserChooserUpdated);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.USER_ADDED, this.onUserChooserUpdated);
        }

        function onChooserContent(k:_Str_4178)
        {
            var item:_Str_3405 = null;
            if ((k == null) || (k.items == null))
            {
                return;
            }
            if (this._userChooser == null)
            {
                this._userChooser = new UserChooserView(this, "${widget.chooser.user.title}");
            }
            this._items = [];
            final _iter_ = k.items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
item  = _tmp_;
                this._items.push(item);
            }
            ASCompat.ASArray.sort(this._items, this.sortItems);
            this._userChooser.onItemsChanged();
        }

        function onUserChooserUpdated(event:RoomWidgetRoomObjectUpdateEvent)
        {
            if (((this._userChooser == null) || (!this._userChooser.isOpen())))
            {
                return;
            }
            var delayedAction= new Timer(100, 1);
            delayedAction.addEventListener(TimerEvent.TIMER, (function (k:TimerEvent)
            {
                if (disposed)
                {
                    return;
                }
                messageListener.processWidgetMessage(new RoomWidgetRequestWidgetMessage(RoomWidgetRequestWidgetMessage.RWRWM_USER_CHOOSER));
            } : ASAny));
            delayedAction.start();
        }

        function sortItems(k:_Str_3405, _arg_2:_Str_3405):Int
        {
            if ((k == null) || (_arg_2 == null))
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

