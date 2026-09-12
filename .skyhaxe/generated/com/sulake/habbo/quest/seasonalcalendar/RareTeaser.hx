package com.sulake.habbo.quest.seasonalcalendar
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.quest.HabboQuestEngine;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;

     class RareTeaser implements IDisposable 
    {
        var _questEngine:HabboQuestEngine;
        var _window:IWindowContainer;
        var _unlockDays:Array<ASAny>;
        var _furniPicks:Array<ASAny>;
        var _pages:Array<ASAny>;

        public function new(k:HabboQuestEngine)
        {
            this._questEngine = k;
        }

        public function dispose()
        {
            this._questEngine = null;
            this._window = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._questEngine == null;
        }

        public function prepare(k:IFrameWindow)
        {
            this._unlockDays = this._Str_24095("quests.seasonalcalendar.rareteaser.days");
            this._furniPicks = this._Str_21705("quests.seasonalcalendar.rareteaser.images");
            this._pages = this._Str_21705("quests.seasonalcalendar.rareteaser.pages");
            this._window = cast(k.findChildByName("rare_teaser_cont"), IWindowContainer);
            var _local_2= 1;
            while (_local_2 <= this._unlockDays.length)
            {
                this._Str_20885(_local_2).assetUri = ((this._questEngine._Str_3398._Str_13628._Str_22087() + this._furniPicks[(_local_2 - 1)]) + ".png");
                _local_2++;
            }
            this._Str_15018(1).procedure = this._Str_22390;
            this._Str_15018(2).procedure = this._Str_25053;
            this._Str_15018(3).procedure = this._Str_24683;
        }

        function _Str_24095(k:String):Array<ASAny>
        {
            var _local_5:String = null;
            var _local_2= this._questEngine.localization.getLocalization(k, "");
            var _local_3:Array<ASAny> = (cast _local_2.split(","));
            var _local_4= new Array<ASAny>();
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_5  = _tmp_;
                if (!Math.isNaN(ASCompat.toNumber(_local_5)))
                {
                    _local_4.push(ASCompat.toInt(_local_5));
                }
            }
            return _local_4;
        }

        function _Str_21705(k:String):Array<ASAny>
        {
            var _local_5:String = null;
            var _local_2= this._questEngine.localization.getLocalization(k, "");
            var _local_3:Array<ASAny> = (cast _local_2.split(","));
            var _local_4= new Array<ASAny>();
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_5  = _tmp_;
                if (_local_5 != "")
                {
                    _local_4.push(_local_5);
                }
            }
            return _local_4;
        }

        function _Str_20885(k:Int):IStaticBitmapWrapperWindow
        {
            return Std.downcast(this._Str_11531(k).findChildByName("furni_pic") , IStaticBitmapWrapperWindow);
        }

        function _Str_25809(k:Int):IWindow
        {
            return this._Str_11531(k).findChildByName("locked_icon");
        }

        function _Str_25153(k:Int):IWindow
        {
            return this._Str_11531(k).findChildByName("locked_bg");
        }

        function _Str_25052(k:Int):IWindow
        {
            return this._Str_11531(k).findChildByName("open_bg");
        }

        function _Str_15018(k:Int):IWindow
        {
            return this._Str_11531(k).findChildByName("click_region");
        }

        function _Str_11531(k:Int):IWindowContainer
        {
            return cast(this._window.findChildByName(("rare_cont_" + Std.string(k))), IWindowContainer);
        }

        public function refresh()
        {
            var _local_4 = false;
            var k= this._questEngine._Str_3398._Str_13628._Str_5472;
            var _local_2= -1;
            var _local_3= 1;
            while (_local_3 <= this._unlockDays.length)
            {
                _local_4 = (this._unlockDays[(_local_3 - 1)] > k);
                this._Str_20885(_local_3).visible = (!_local_4);
                this._Str_25809(_local_3).visible = _local_4;
                this._Str_25052(_local_3).visible = (!_local_4);
                this._Str_25153(_local_3).visible = _local_4;
                this._Str_15018(_local_3).visible = (!_local_4);
                if ((_local_4 && (_local_2 == -1)))
                {
                    _local_2 = ASCompat.toInt(ASCompat.toNumber(this._unlockDays[(_local_3 - 1)]) - k);
                }
                _local_3++;
            }
            this._window.findChildByName("teaser_info").visible = (!(_local_2 == -1));
            this._questEngine.localization.registerParameter("quests.seasonalcalendar.rareteaser.info", "days", ("" + Std.string(_local_2)));
        }

        function _Str_22390(k:WindowEvent, _arg_2:IWindow)
        {
            this._Str_18319(k, 0);
        }

        function _Str_25053(k:WindowEvent, _arg_2:IWindow)
        {
            this._Str_18319(k, 1);
        }

        function _Str_24683(k:WindowEvent, _arg_2:IWindow)
        {
            this._Str_18319(k, 2);
        }

        function _Str_18319(k:WindowEvent, _arg_2:Int)
        {
            if (((k.type == WindowMouseEvent.CLICK) && (!(this._pages[_arg_2] == null))))
            {
                this._questEngine.catalog.openCatalogPage(this._pages[_arg_2]);
            }
        }
    }

