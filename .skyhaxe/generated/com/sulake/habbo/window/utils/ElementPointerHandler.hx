package com.sulake.habbo.window.utils
;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.habbo.communication.messages.incoming.notifications.ElementPointerMessageEvent;

     class ElementPointerHandler
    {
        var _habboWindowManagerComponent:HabboWindowManagerComponent;
        var _elementPointerMessageEvent:ElementPointerMessageEvent;

        public function new(k:HabboWindowManagerComponent)
        {
            this._habboWindowManagerComponent = k;
            if (this._habboWindowManagerComponent.communication != null)
            {
                this._elementPointerMessageEvent = new ElementPointerMessageEvent(this._Str_23532);
                this._habboWindowManagerComponent.communication.addHabboConnectionMessageEvent(this._elementPointerMessageEvent);
            }
        }

        function _Str_23532(k:ElementPointerMessageEvent)
        {
            var _local_2= k.getParser().key;
            if (((_local_2 == null) || (_local_2 == "")))
            {
                this._habboWindowManagerComponent.hideHint();
            }
            else
            {
                this._habboWindowManagerComponent.showHint(_local_2);
            }
        }

        public function dispose()
        {
            if (this._habboWindowManagerComponent.communication != null)
            {
                this._habboWindowManagerComponent.communication.removeHabboConnectionMessageEvent(this._elementPointerMessageEvent);
            }
            this._habboWindowManagerComponent = null;
        }
    }

