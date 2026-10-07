package com.sulake.habbo.friendlist
;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.Event;

     class _Str_9313 
    {
        var _habboFriendList:HabboFriendList;
        var _Str_3245:IWindowContainer;
        var _timer:Timer;

        public function new(k:HabboFriendList)
        {
            this._habboFriendList = k;
        }

        public function show(k:Int, _arg_2:Int)
        {
            if (this._Str_3245 != null)
            {
                this.close(null);
            }
            this._Str_3245 = this._Str_23551();
            if (this._timer != null)
            {
                this._timer.stop();
            }
            this._timer = new Timer(2000, 1);
            this._timer.addEventListener(TimerEvent.TIMER, (this.close : ASAny));
            this._timer.start();
            this._Str_3245.x = k;
            this._Str_3245.y = _arg_2;
        }

        function close(k:Event)
        {
            this._Str_3245.destroy();
            this._Str_3245 = null;
        }

        function _Str_23551():IWindowContainer
        {
            var k= cast(this._habboFriendList.getXmlWindow("opened_to_web_popup"), IWindowContainer);
            this._habboFriendList.refreshButton(k, "opened_to_web", true, null, 0);
            return k;
        }
    }

