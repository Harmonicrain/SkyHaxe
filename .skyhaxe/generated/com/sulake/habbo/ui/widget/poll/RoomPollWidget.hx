package com.sulake.habbo.ui.widget.poll
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.widget.events.RoomWidgetPollUpdateEvent;
    import flash.events.IEventDispatcher;
    import flash.events.Event;

     class RoomPollWidget extends RoomWidgetBase
    {
        var _Str_4484:Map;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null, _arg_4:IHabboLocalizationManager=null)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._Str_4484 = new Map();
        }

        override public function dispose()
        {
            var k = 0;
            var _local_2 = 0;
            var _local_3:PollSession = null;
            if (disposed)
            {
                return;
            }
            if (this._Str_4484 != null)
            {
                k = ASCompat.toInt(this._Str_4484.length);
                _local_2 = 0;
                while (_local_2 < k)
                {
                    _local_3 = ASCompat.dynamicAs(this._Str_4484.getWithIndex(0) , PollSession);
                    if (_local_3 != null)
                    {
                        _local_3.dispose();
                    }
                    _local_2++;
                }
                this._Str_4484.dispose();
                this._Str_4484 = null;
            }
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(RoomWidgetPollUpdateEvent.RWPUW_OFFER, this._Str_21632);
            k.addEventListener(RoomWidgetPollUpdateEvent.ERROR, this._Str_21733);
            k.addEventListener(RoomWidgetPollUpdateEvent.RWPUW_CONTENT, this._Str_21584);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(RoomWidgetPollUpdateEvent.RWPUW_OFFER, this._Str_21632);
            k.removeEventListener(RoomWidgetPollUpdateEvent.ERROR, this._Str_21733);
            k.removeEventListener(RoomWidgetPollUpdateEvent.RWPUW_CONTENT, this._Str_21584);
        }

        function _Str_21632(k:Event)
        {
            var _local_2= cast(k, RoomWidgetPollUpdateEvent).id;
            var _local_3= ASCompat.dynamicAs(this._Str_4484.getValue(_local_2) , PollSession);
            var _local_4= cast(k, RoomWidgetPollUpdateEvent).summary;
            var _local_5= cast(k, RoomWidgetPollUpdateEvent).headline;
            if (_local_3 == null)
            {
                _local_3 = new PollSession(_local_2, this);
                this._Str_4484.add(_local_2, _local_3);
                _local_3._Str_6059(_local_5, _local_4);
            }
            else
            {
                Logger.log(["Poll with given id already exists!"]);
                _local_3._Str_6059(_local_5, _local_4);
            }
        }

        function _Str_21733(e:Event)
        {
            windowManager.alert("${win_error}", cast(e, RoomWidgetPollUpdateEvent).summary, 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
            {
                k.dispose();
            });
        }

        function _Str_21584(k:Event)
        {
            var _local_3 = 0;
            var _local_4:PollSession = null;
            var _local_2= Std.downcast(k , RoomWidgetPollUpdateEvent);
            if (_local_2 != null)
            {
                _local_3 = _local_2.id;
                _local_4 = ASCompat.dynamicAs(this._Str_4484.getValue(_local_3) , PollSession);
                if (_local_4 != null)
                {
                    _local_4._Str_24948(_local_2._Str_6013, _local_2._Str_5838, _local_2._Str_5643, _local_2._Str_6196);
                }
            }
        }

        public function _Str_24255(k:Int)
        {
            var _local_2= ASCompat.dynamicAs(this._Str_4484.getValue(k) , PollSession);
            if (_local_2 != null)
            {
                _local_2._Str_24541();
                _local_2.dispose();
                this._Str_4484.remove(k);
            }
        }

        public function _Str_12823(k:Int)
        {
            var _local_2= ASCompat.dynamicAs(this._Str_4484.getValue(k) , PollSession);
            if (_local_2 != null)
            {
                _local_2.dispose();
                this._Str_4484.remove(k);
            }
        }
    }

