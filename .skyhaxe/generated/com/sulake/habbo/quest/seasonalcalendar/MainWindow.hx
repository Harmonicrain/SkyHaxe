package com.sulake.habbo.quest.seasonalcalendar
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.quest.HabboQuestEngine;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.utils._Str_3942;
    import com.sulake.habbo.quest.events.QuestsListEvent;
    import com.sulake.habbo.quest.events.QuestCompletedEvent;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class MainWindow implements IDisposable 
    {
        var _questEngine:HabboQuestEngine;
        var _window:IFrameWindow;
        var _toggle:_Str_3942;
        var _calendar:Calendar;
        var _catalogPromo:CatalogPromo;
        var _rareTeaser:RareTeaser;
        var _seasonalQuestsRequested:Bool = false;
        var _currentDay:Int = 0;

        public function new(k:HabboQuestEngine)
        {
            this._questEngine = k;
            this._calendar = new Calendar(this._questEngine, this);
            this._catalogPromo = new CatalogPromo(this._questEngine, this);
            this._rareTeaser = new RareTeaser(this._questEngine);
            this._questEngine.events.addEventListener(QuestsListEvent.QE_QUESTS_SEASONAL, this._Str_12986);
            this._questEngine.events.addEventListener(QuestCompletedEvent.QCE_SEASONAL, this._Str_21252);
        }

        public function dispose()
        {
            if (this._questEngine != null)
            {
                this._questEngine.events.removeEventListener(QuestsListEvent.QE_QUESTS_SEASONAL, this._Str_12986);
                this._questEngine.events.removeEventListener(QuestCompletedEvent.QCE_SEASONAL, this._Str_21252);
                this._questEngine = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._toggle != null)
            {
                this._toggle.dispose();
                this._toggle = null;
            }
            if (this._calendar != null)
            {
                this._calendar.close();
                this._calendar.dispose();
                this._calendar = null;
            }
            if (this._catalogPromo != null)
            {
                this._catalogPromo.dispose();
                this._catalogPromo = null;
            }
            if (this._rareTeaser != null)
            {
                this._rareTeaser.dispose();
                this._rareTeaser = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._questEngine == null;
        }

        public function isVisible():Bool
        {
            return (this._window != null) && this._window.visible;
        }

        public function close()
        {
            if (this._calendar != null)
            {
                this._calendar.close();
            }
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        public function onRoomExit()
        {
            this.close();
        }

        public function onToolbarClick()
        {
            if (this._window == null)
            {
                this._questEngine.requestSeasonalQuests();
                return;
            }
            if (((!(this._toggle != null)) || this._toggle.disposed))
            {
                this._toggle = new _Str_3942(this._window, this._window.desktop, this._questEngine.requestSeasonalQuests, this.close);
            }
            this._toggle.toggle();
        }

        public function _Str_22087():String
        {
            var k= this._questEngine._Str_9628();
            return (this._questEngine.configuration.getProperty("image.library.url") + k) + "_quest_calendar/";
        }

        public function _Str_8212(k:Array<ASAny>, _arg_2:Bool)
        {
            if (((!this.isVisible()) && (!_arg_2)))
            {
                return;
            }
            this._currentDay = this._Str_22256(k);
            this._calendar._Str_8212(k);
            this.refresh();
            if (_arg_2)
            {
                this._window.visible = true;
                this._window.activate();
            }
        }

        function _Str_12986(k:QuestsListEvent)
        {
            this._Str_8212(k.quests, true);
        }

        function _Str_21252(k:QuestCompletedEvent)
        {
            this._questEngine._Str_3398._Str_20198._Str_24904();
            this._questEngine.requestSeasonalQuests();
        }

        public function onActivityPoints(k:Int, _arg_2:Int)
        {
            this._catalogPromo.onActivityPoints(k, _arg_2);
        }

        function _Str_22256(k:Array<ASAny>):Int
        {
            var _local_3:QuestMessageData = null;
            var _local_2 = 0;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                if (this._questEngine._Str_7575(_local_3))
                {
                    _local_2 = Std.int(Math.max(_local_2, _local_3.sortOrder));
                }
            }
            return _local_2;
        }

        function refresh()
        {
            this.prepareWindow();
            this._calendar.refresh();
            this._catalogPromo.refresh();
            this._rareTeaser.refresh();
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._questEngine.getXmlWindow("SeasonalCalendar"), IFrameWindow);
            var k:ASAny = (("quests." + this._questEngine._Str_9628()) + ".title");
            this._window.caption = this._questEngine.localization.getLocalizationWithParams(k, k);
            this._window.findChildByTag("close").procedure = this.onWindowClose;
            this._calendar.prepare(this._window);
            this._catalogPromo.prepare(this._window);
            this._rareTeaser.prepare(this._window);
            this._window.center();
        }

        function onWindowClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.close();
            }
        }

        public var _Str_5472(get,never):Int;
public function  get__Str_5472():Int
        {
            return this._currentDay;
        }

        public var _Str_26402(get,never):CatalogPromo;
public function  get__Str_26402():CatalogPromo
        {
            return this._catalogPromo;
        }

        public function update(k:UInt)
        {
            if (((((!(this._questEngine.configuration == null)) && this._questEngine._Str_18128) && (!this._seasonalQuestsRequested)) && this._questEngine._Str_19304()))
            {
                this._questEngine.requestSeasonalQuests();
                this._seasonalQuestsRequested = true;
            }
        }
    }

