package com.sulake.habbo.catalog.clubcenter
;
    import com.sulake.habbo.communication.messages.incoming.users.ScrKickbackData;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import flash.geom.Point;
    import com.sulake.core.window.components.IBubbleWindow;
    import com.sulake.core.window.components.ITextWindow;

     class ClubSpecialInfoBubbleView 
    {
        static inline final MARGIN= 8;

        var _data:ScrKickbackData;
        var _controller:HabboClubCenter;
        var _window:IWindowContainer;
        var _activateTimer:Timer;

        public function new(k:HabboClubCenter, _arg_2:IHabboWindowManager, _arg_3:ScrKickbackData, _arg_4:IWindow)        {
            this._data = _arg_3;
            this._controller = k;
            this._window = Std.downcast(_arg_2.buildFromXML(new com.sulake.core.utils.xml.XML(this._controller.assets.getAssetByName("club_center_special_info_xml").content)) , IWindowContainer);
            if (this._window == null)
            {
                return;
            }
            this._window.procedure = this.onInput;
            this.positionWindow(_arg_4);
            this.setElementText("info_creditsspent", ASCompat.stringReplace(this.getLocalization("hccenter.breakdown.creditsspent"), "%credits%", this._data.totalCreditsSpent));
            var _local_5= Std.int((this._data.kickbackPercentage * 100));
            this.setElementText("info_factor", ASCompat.stringReplace(ASCompat.stringReplace(this.getLocalization("hccenter.breakdown.paydayfactor"), "%percent%", _local_5), "%multiplier%", this._data.kickbackPercentage));
            _local_5 = Std.int((this._data.kickbackPercentage * 100));
            var _local_6= this._controller.localization.getLocalization("hccenter.breakdown.paydayfactor.percent");
            if ((ASCompat.stringAsBool(_local_6) && (_local_6.length > 0)))
            {
                _local_6 = ASCompat.stringReplace(ASCompat.stringReplace(_local_6, "%percent%", _local_5), "%multiplier%", this._data.kickbackPercentage);
            }
            else
            {
                _local_6 = ASCompat.stringReplace(this.getLocalization("hccenter.breakdown.paydayfactor"), "%percent%", this._data.kickbackPercentage);
            }
            this.setElementText("info_factor", _local_6);
            this.setElementText("info_streakbonus", ASCompat.stringReplace(this.getLocalization("hccenter.breakdown.streakbonus"), "%credits%", this._data.creditRewardForStreakBonus));
            var _local_7= (Std.int((((this._data.kickbackPercentage * this._data.totalCreditsSpent) + this._data.creditRewardForStreakBonus) * 100)) / 100);
            var _local_8= Std.int(((this._data.creditRewardForMonthlySpent + this._data.creditRewardForStreakBonus) * 100) / 100);
            this.setElementText("info_total", ASCompat.stringReplace(ASCompat.stringReplace(this.getLocalization("hccenter.breakdown.total"), "%credits%", _local_8), "%actual%", _local_7));
            this._window.activate();
            this._activateTimer = new Timer(80, 1);
            this._activateTimer.addEventListener(TimerEvent.TIMER, (this.onTimerEvent : ASAny));
            this._activateTimer.start();
            if (this._controller.stage != null)
            {
                this._controller.stage.addEventListener(MouseEvent.CLICK, (this.onStageClick : ASAny));
            }
        }

        function onTimerEvent(k:TimerEvent)
        {
            this._activateTimer.stop();
            this._activateTimer.removeEventListener(TimerEvent.TIMER, (this.onTimerEvent : ASAny));
            this._activateTimer = null;
            this._window.activate();
        }

        public function dispose()
        {
            if (((this._controller != null) && (this._controller.stage != null)))
            {
                this._controller.stage.removeEventListener(MouseEvent.CLICK, (this.onStageClick : ASAny));
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._controller = null;
        }

        function onInput(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(k.type == WindowMouseEvent.DOWN)) || (!(this._controller != null))))
            {
                return;
            }
            k.stopImmediatePropagation();
            switch (_arg_2.name)
            {
                case "special_infolink":
                    this._controller._Str_21087();
                    
            }
            this._controller.removeBreakdown();
        }

        function onStageClick(k:MouseEvent)
        {
            if (this._controller != null)
            {
                this._controller.removeBreakdown();
            }
        }

        function positionWindow(k:IWindow)
        {
            if (((((!(k != null)) || (!(this._window != null))) || (!(this._controller != null))) || (!(this._controller.stage != null))))
            {
                return;
            }
            var _local_2= new Point();
            k.getGlobalPosition(_local_2);
            if (((this._controller.stage.stageWidth < (((_local_2.x + k.width) + this._window.width) + MARGIN)) && (_local_2.x > (this._window.width + MARGIN))))
            {
                Std.downcast(this._window , IBubbleWindow).direction = "right";
                _local_2.x = (_local_2.x - (this._window.width + MARGIN));
            }
            else
            {
                _local_2.x = (_local_2.x + (k.width + MARGIN));
            }
            _local_2.y = (_local_2.y + ((k.height * 0.5) - (this._window.height * 0.5)));
            this._window.position = _local_2;
        }

        function setElementText(k:String, _arg_2:String)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_3= Std.downcast(this._window.findChildByName(k) , ITextWindow);
            if (_local_3 != null)
            {
                _local_3.text = _arg_2;
            }
        }

        function getLocalization(k:String):String
        {
            if (((!(this._controller != null)) || (!(this._controller.localization != null))))
            {
                return "";
            }
            return this._controller.localization.getLocalization(k, k);
        }
    }

