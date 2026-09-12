package com.sulake.habbo.notifications.singular
;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.habbo.window._enum.FrankIllustration;

     class HabboAlertDialogManager 
    {
        var _windowManager:IHabboWindowManager;
        var _localization:IHabboLocalizationManager;
        var _habboHelp:IHabboHelp;

        public function new(k:IHabboWindowManager, _arg_2:IHabboLocalizationManager, _arg_3:IHabboHelp)
        {
            this._windowManager = k;
            this._localization = _arg_2;
            this._habboHelp = _arg_3;
        }

        static function getTimeZeroPadded(k:Int):String
        {
            var _local_2= ("0" + Std.string(k));
            return _local_2.substr((_local_2.length - 2), _local_2.length);
        }


        public function dispose()
        {
            this._windowManager = null;
            this._localization = null;
            this._habboHelp = null;
        }

        public function handleModeratorCaution(k:String, _arg_2:String="")
        {
            this.showModerationMessage(k, _arg_2);
        }

        public function handleModeratorMessage(k:String, _arg_2:String="")
        {
            this.showModerationMessage(k, _arg_2, false);
        }

        public function handleUserBannedMessage(k:String)
        {
            this.showModerationMessage(k, "");
        }

        function showModerationMessage(message:String, url:String, showHabboWay:Bool=true)
        {
            var p= new compat.RegExp("\\\\r", "g");
            message = p.replace(message, "\r");
            this._windowManager.simpleAlert("", "${mod.alert.title}", message, "${mod.alert.link}", url, null, FrankIllustration.NEUTRAL, null, function ()
            {
                if (((!(_habboHelp == null)) && showHabboWay))
                {
                    _habboHelp.showHabboWay();
                }
            });
        }

        public function handleHotelClosingMessage(k:Int)
        {
            this._localization.registerParameter("opening.hours.shutdown", "m", Std.string(k));
            this._windowManager.simpleAlert("", "${opening.hours.title}", "${opening.hours.shutdown}");
        }

        public function handleHotelMaintenanceMessage(k:Int, _arg_2:Int)
        {
            this._localization.registerParameter("maintenance.shutdown", "m", Std.string(k));
            this._localization.registerParameter("maintenance.shutdown", "d", Std.string(_arg_2));
            this._windowManager.simpleAlert("", "${opening.hours.title}", "${maintenance.shutdown}");
        }

        public function handleHotelClosedMessage(openHour:Int, openMinute:Int, userThrownOutAtClose:Bool)
        {
            if (userThrownOutAtClose)
            {
                this._localization.registerParameter("opening.hours.disconnected", "h", getTimeZeroPadded(openHour));
                this._localization.registerParameter("opening.hours.disconnected", "m", getTimeZeroPadded(openMinute));
                this._windowManager.alert("${opening.hours.title}", "${opening.hours.disconnected}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
                {
                    k.dispose();
                });
            }
            else
            {
                this._localization.registerParameter("opening.hours.closed", "h", getTimeZeroPadded(openHour));
                this._localization.registerParameter("opening.hours.closed", "m", getTimeZeroPadded(openMinute));
                this._windowManager.alert("${opening.hours.title}", "${opening.hours.closed}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
                {
                    k.dispose();
                });
            }
        }

        public function handleLoginFailedHotelClosedMessage(openHour:Int, openMinute:Int)
        {
            this._localization.registerParameter("opening.hours.disconnected", "h", getTimeZeroPadded(openHour));
            this._localization.registerParameter("opening.hours.disconnected", "m", getTimeZeroPadded(openMinute));
            this._windowManager.alert("${opening.hours.title}", "${opening.hours.disconnected}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
            {
                k.dispose();
            });
        }
    }

