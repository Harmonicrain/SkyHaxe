package com.sulake.habbo.toolbar.extensions.purse
;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.habbo.inventory.events.HabboInventoryHabboClubEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.utils.FriendlyTime;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.core.window.motion.Motions;
    import com.sulake.core.window.motion.DropBounce;

     class PurseClubArea extends CurrencyIndicatorBase 
    {
        static inline final _Str_3591:UInt = 0xFF78746D;
        static inline final _Str_3385:UInt = 0xFF55534E;
        static inline final _Str_5044= 13;
        static inline final _Str_3830= 14;
        static final _Str_8605:Array<ASAny> = ["toolbar_hc_icon_0", "toolbar_hc_icon_1", "toolbar_hc_icon_2", "toolbar_hc_icon_1", "toolbar_hc_icon_0"];

        var _clubDays:Int = -1;
        var _toolbar:HabboToolbar;
        var _clubMinutes:Int = 0;

        public function new(k:HabboToolbar, _arg_2:IWindowContainer)
        {
            super(k.windowManager, k.assets);
            this._toolbar = k;
            _window = _arg_2;
            this._Str_19567 = _Str_3591;
            this._Str_21715 = _Str_3385;
            this._Str_15051 = "days";
            this._Str_23355 = _Str_8605;
            this._Str_22454 = 50;
            this._Str_8446 = this._toolbar.localization.getLocalization("purse.clubdays.zero.amount.text", "Get");
            this._Str_5219(new HabboInventoryHabboClubEvent());
        }

        override function setAmount(k:Int, _arg_2:Int=-1)
        {
            if (k < 1)
            {
                _window.findChildByName("days").visible = false;
                _window.findChildByName("join").visible = true;
                this._Str_15051 = "join";
                this.setText(this._Str_8446);
            }
            else
            {
                _window.findChildByName("days").visible = true;
                _window.findChildByName("join").visible = false;
                this._Str_15051 = "days";
                if (((!(_arg_2 == -1)) && (_arg_2 < (60 * 24))))
                {
                    this.setText(FriendlyTime.shortFormat(this._toolbar.catalog.localization, (_arg_2 * 60)));
                }
                else
                {
                    this.setText(FriendlyTime.shortFormat(this._toolbar.catalog.localization, (k * 86400)));
                }
            }
        }

        function _Str_5997(k:Int)
        {
            var _local_2= Std.downcast(_window.findChildByName("club_icon") , IIconWindow);
            if (_local_2 != null)
            {
                _local_2.style = k;
                _local_2.invalidate();
            }
        }

        override public function dispose()
        {
            this._toolbar = null;
            super.dispose();
        }

        public function _Str_5219(k:HabboInventoryHabboClubEvent=null)
        {
            var _local_4:IWindowContainer = null;
            if (this._toolbar.inventory == null)
            {
                return;
            }
            var _local_2= ((this._toolbar.inventory.clubPeriods * 31) + this._toolbar.inventory.clubDays);
            var _local_3= this._toolbar.inventory.clubMinutesUntilExpiration;
            if (((!(this._clubDays == -1)) && (!(this._toolbar.inventory.clubLevel == HabboClubLevelEnum.NO_CLUB))))
            {
                this.setAmount(_local_2, _local_3);
                _local_4 = Std.downcast(_window.findChildByName("hc_join_button") , IWindowContainer);
                if (Motions._Str_9810(_local_4) == null)
                {
                    Motions._Str_4598(new DropBounce(_local_4, 900, 16));
                }
            }
            this._clubDays = _local_2;
            this._clubMinutes = _local_3;
            switch (this._toolbar.inventory.clubLevel)
            {
                case HabboClubLevelEnum.NO_CLUB:
                    this._Str_5997(_Str_3830);
                    setText(this._Str_8446);
                    return;
                case HabboClubLevelEnum.CLUB:
                    this._Str_5997(_Str_5044);
                    return;
                case HabboClubLevelEnum.VIP:
                    this._Str_5997(_Str_3830);
                    return;
            }
        }
    }

