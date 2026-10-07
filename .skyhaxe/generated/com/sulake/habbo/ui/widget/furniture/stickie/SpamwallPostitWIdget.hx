package com.sulake.habbo.ui.widget.furniture.stickie
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.ui.widget.events.RoomWidgetSpamWallPostItEditEvent;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.ui.widget.events.RoomWidgetStickieDataUpdateEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetSpamWallPostItFinishEditingMessage;

     class SpamwallPostitWIdget extends StickieFurniWidget 
    {
        var _location:String = "";

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null)
        {
            _Str_18958 = "spamwall_postit_container";
            super(k, _arg_2, _arg_3);
        }

        override public function dispose()
        {
            _objectId = -1;
            this._location = "";
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            k.addEventListener(RoomWidgetSpamWallPostItEditEvent.RWSWPUE_OPEN_EDITOR, this._Str_22050);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(RoomWidgetSpamWallPostItEditEvent.RWSWPUE_OPEN_EDITOR, this._Str_22050);
        }

        override function onObjectUpdate(k:RoomWidgetStickieDataUpdateEvent)
        {
        }

        function _Str_22050(k:RoomWidgetSpamWallPostItEditEvent)
        {
            _Str_2718(false);
            _objectId = k.objectId;
            this._location = k.location;
            _objectType = k.objectType;
            _text = "";
            _colorHex = "FFFF33";
            _controller = true;
            showInterface();
        }

        override function sendUpdate()
        {
            var k:RoomWidgetSpamWallPostItFinishEditingMessage = null;
            if (_objectId != -1)
            {
                _Str_9532();
                Logger.log(["Spamwall Post-It Widget Send Update"]);
                if (messageListener != null)
                {
                    k = new RoomWidgetSpamWallPostItFinishEditingMessage(RoomWidgetSpamWallPostItFinishEditingMessage.RWSWPFEE_SEND_POSTIT_DATA, _objectId, this._location, _text, _colorHex);
                    messageListener.processWidgetMessage(k);
                }
                _Str_2718(false);
            }
        }

        override function sendSetColor(k:UInt)
        {
            _Str_9532();
            var _local_2= ASCompat.toRadix(k, 16).toUpperCase();
            if (_local_2.length > 6)
            {
                _local_2 = _local_2.substring((_local_2.length - 6), _local_2.length);
            }
            if (_local_2 == _colorHex)
            {
                return;
            }
            _colorHex = _local_2;
            showInterface();
        }

        override function sendDelete()
        {
            _Str_2718(false);
        }
    }

