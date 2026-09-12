package snowwar._str_267
;
	import com.sulake.core.runtime.IDisposable;
	import com.sulake.habbo.localization.IHabboLocalizationManager;
	import com.sulake.habbo.avatar._enum.AvatarSetType;
	import com.sulake.habbo.avatar._enum.AvatarScaleType;
	import com.sulake.habbo.game.WindowUtils;
	import com.sulake.habbo.avatar.IAvatarImageListener;
	import com.sulake.habbo.communication.messages.parser.game.score.LeaderboardEntry;
	import com.sulake.core.utils.Map;
	import com.sulake.core.window.IWindow;
	import com.sulake.core.window.IWindowContainer;
	import com.sulake.core.window.components.IBitmapWrapperWindow;
	import com.sulake.core.window.components.IItemListWindow;
	import com.sulake.core.window.components.IRegionWindow;
	import com.sulake.core.window.components.ITextWindow;
	import com.sulake.core.window.components.ITextLinkWindow;
	import com.sulake.core.window.events.WindowMouseEvent;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import snowwar.SnowWarEngine;

     class LeaderboardViewController implements IDisposable implements  IAvatarImageListener 
    {
        static inline final _SafeStr_18604= 0;
        static inline final _SafeStr_18605= 1;
        static inline final _SafeStr_18606= 2;
        static inline final _SafeStr_18607= 3;

        var _SafeStr_18579:SnowWarEngine;
        var _SafeStr_6445:IHabboLocalizationManager;
        var _SafeStr_9274:IWindowContainer;
        var _disposed:Bool = false;
        var _SafeStr_5998:Int = 0;
        var _SafeStr_5552:IItemListWindow;
        var _SafeStr_18608:IWindow;
        var _SafeStr_18609:ITextLinkWindow;
        var _SafeStr_18610:IBitmapWrapperWindow;
        var _SafeStr_18611:ITextWindow;
        var _SafeStr_18612:IBitmapWrapperWindow;
        var _SafeStr_18613:ITextWindow;
        var _SafeStr_18614:IRegionWindow;
        var _SafeStr_18615:IRegionWindow;
        var _SafeStr_18616:IRegionWindow;
        var _SafeStr_18617:IRegionWindow;
        var _SafeStr_18618:String;
        var _SafeStr_18619:Int = 0;
        var _SafeStr_18620:Timer;
        var _SafeStr_18621:Map;
        var _SafeStr_18622:LeaderboardTable;
        var _SafeStr_18623:_SafeStr_4664;
        var _SafeStr_18624:_SafeStr_4665;
        var _SafeStr_18625:_SafeStr_4663;
        var _SafeStr_18626:Bool = false;
        var _SafeStr_18482:Int = 0;

        public function new(k:SnowWarEngine)
        {
            this._SafeStr_18579 = k;
            this._SafeStr_6445 = k.localization;
            this._SafeStr_18621 = new Map();
            this._SafeStr_18626 = this._SafeStr_18579.config.getBoolean("games.highscores.scrolling.enabled");
            this._SafeStr_18622 = new LeaderboardTable(this._SafeStr_18579);
            this._SafeStr_18623 = new _SafeStr_4664(this._SafeStr_18579);
            this._SafeStr_18624 = new _SafeStr_4665(this._SafeStr_18579);
            this._SafeStr_18625 = new _SafeStr_4663(this._SafeStr_18579);
            this._SafeStr_18638();
        }

        public var _SafeStr_13281(never,set):Int;
public function  set__SafeStr_13281(k:Int):Int        {
            return this._SafeStr_18482 = k;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._SafeStr_18579 = null;
            this._SafeStr_5552 = null;
            this._SafeStr_18608 = null;
            this._SafeStr_18609 = null;
            this._SafeStr_18610 = null;
            this._SafeStr_18611 = null;
            this._SafeStr_18612 = null;
            this._SafeStr_18613 = null;
            this._SafeStr_18614 = null;
            this._SafeStr_18615 = null;
            this._SafeStr_18616 = null;
            this._SafeStr_18617 = null;
            this._SafeStr_18618 = null;
            this._SafeStr_18621.dispose();
            if (this._SafeStr_9274 != null)
            {
                this._SafeStr_9274.dispose();
                this._SafeStr_9274 = null;
            }
            if (this._SafeStr_18622 != null)
            {
                this._SafeStr_18622.dispose();
                this._SafeStr_18622 = null;
            }
            if (this._SafeStr_18623 != null)
            {
                this._SafeStr_18623.dispose();
                this._SafeStr_18623 = null;
            }
            if (this._SafeStr_18624 != null)
            {
                this._SafeStr_18624.dispose();
                this._SafeStr_18624 = null;
            }
            if (this._SafeStr_18625 != null)
            {
                this._SafeStr_18625.dispose();
                this._SafeStr_18625 = null;
            }
            this._SafeStr_18627();
            this._disposed = true;
        }

        function _SafeStr_18627()
        {
            if (this._SafeStr_18620 != null)
            {
                this._SafeStr_18620.removeEventListener(TimerEvent.TIMER, (this._SafeStr_18589 : ASAny));
                this._SafeStr_18620.stop();
                this._SafeStr_18620 = null;
            }
        }

        function _SafeStr_18628(k:Int)
        {
            this._SafeStr_18620 = new Timer(60000, k);
            this._SafeStr_18620.addEventListener(TimerEvent.TIMER, (this._SafeStr_18589 : ASAny));
            this._SafeStr_18620.start();
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function _SafeStr_18629()
        {
            this._SafeStr_18611.textColor = 0;
            this._SafeStr_18613.textColor = 0xFFFFFF;
            WindowUtils.setElementImage(this._SafeStr_18610, this._SafeStr_12987("left_blue"));
            WindowUtils.setElementImage(this._SafeStr_18612, this._SafeStr_12987("right_black"));
        }

        function _SafeStr_18630()
        {
            this._SafeStr_18611.textColor = 0xFFFFFF;
            this._SafeStr_18613.textColor = 0;
            WindowUtils.setElementImage(this._SafeStr_18610, this._SafeStr_12987("left_black"));
            WindowUtils.setElementImage(this._SafeStr_18612, this._SafeStr_12987("right_blue"));
        }

        public function _SafeStr_13282()
        {
            this._SafeStr_5998 = _SafeStr_18604;
            this._SafeStr_18638();
            this.visible = true;
            this._SafeStr_9274.caption = "${snowwar.leaderboard.friends}";
            this._SafeStr_18609.caption = "${snowwar.leaderboard.all}";
            this._SafeStr_18629();
            this._SafeStr_18652();
            this._SafeStr_18658();
        }

        public function _SafeStr_18631()
        {
            this._SafeStr_5998 = _SafeStr_18605;
            this._SafeStr_18639();
            this.visible = true;
            this._SafeStr_9274.caption = "${snowwar.leaderboard.all}";
            this._SafeStr_18609.caption = "${snowwar.leaderboard.friends}";
            this._SafeStr_18629();
            this._SafeStr_18652();
            this._SafeStr_18658();
        }

        public function _SafeStr_18632()
        {
            this._SafeStr_5998 = _SafeStr_18606;
            this._SafeStr_18624.offset = 0;
            this._SafeStr_18640(0);
            this.visible = true;
            this._SafeStr_9274.caption = "${snowwar.leaderboard.all}";
            this._SafeStr_18609.caption = "${snowwar.leaderboard.friends}";
            this._SafeStr_18630();
            this._SafeStr_18652();
            this._SafeStr_18658();
        }

        public function _SafeStr_18633()
        {
            this._SafeStr_5998 = _SafeStr_18607;
            this._SafeStr_18625.offset = 0;
            this._SafeStr_18641(0);
            this.visible = true;
            this._SafeStr_9274.caption = "${snowwar.leaderboard.friends}";
            this._SafeStr_18609.caption = "${snowwar.leaderboard.all}";
            this._SafeStr_18630();
            this._SafeStr_18652();
            this._SafeStr_18658();
        }

        public function _SafeStr_18634(k:Array<ASAny>, _arg_2:Int)
        {
            this._SafeStr_18623.addEntries(k, _arg_2);
            if (((this._SafeStr_5998 == _SafeStr_18605) && this.visible))
            {
                this._SafeStr_18658();
            }
            this._SafeStr_18652();
        }

        public function _SafeStr_18635(k:Int, _arg_2:Int, _arg_3:Array<ASAny>, _arg_4:Int, _arg_5:Int, _arg_6:Int)
        {
            this._SafeStr_18627();
            this._SafeStr_18619 = _arg_6;
            this._SafeStr_18618 = ((Std.string(k) + "/") + Std.string(_arg_2));
            this._SafeStr_18624.maxOffset = _arg_5;
            this._SafeStr_18624.addEntries(_arg_3, _arg_4);
            if (((this._SafeStr_5998 == _SafeStr_18606) && this.visible))
            {
                this._SafeStr_18658();
            }
            this._SafeStr_18652();
        }

        public function _SafeStr_18636(k:Array<ASAny>, _arg_2:Int)
        {
            this._SafeStr_18622.addEntries(k, _arg_2);
            if (((this._SafeStr_5998 == _SafeStr_18604) && this.visible))
            {
                this._SafeStr_18658();
            }
            this._SafeStr_18652();
        }

        public function _SafeStr_18637(k:Int, _arg_2:Int, _arg_3:Array<ASAny>, _arg_4:Int, _arg_5:Int, _arg_6:Int)
        {
            this._SafeStr_18627();
            this._SafeStr_18619 = _arg_6;
            this._SafeStr_18618 = ((Std.string(k) + "/") + Std.string(_arg_2));
            this._SafeStr_18625.maxOffset = _arg_5;
            this._SafeStr_18625.addEntries(_arg_3, _arg_4);
            if (((this._SafeStr_5998 == _SafeStr_18607) && this.visible))
            {
                this._SafeStr_18658();
            }
            this._SafeStr_18652();
        }

        public function hide()
        {
            this.visible = false;
        }

        public function avatarImageReady(k:String)
        {
            if (this._disposed)
            {
                return;
            }
            var _local_2:IBitmapWrapperWindow = this._SafeStr_18621.remove(k);
            if (((_local_2 != null) && (!_local_2.disposed)))
            {
                this._SafeStr_18526(_local_2, k);
            }
        }

        function _SafeStr_18638()
        {
            this._SafeStr_18622._SafeStr_18662(this._SafeStr_18482);
        }

        function _SafeStr_18639()
        {
            this._SafeStr_18623._SafeStr_18662(this._SafeStr_18482);
        }

        function _SafeStr_18640(k:Int)
        {
            this._SafeStr_18624.offset = k;
            this._SafeStr_18624._SafeStr_18662(this._SafeStr_18482);
        }

        function _SafeStr_18641(k:Int)
        {
            this._SafeStr_18625.offset = k;
            this._SafeStr_18625._SafeStr_18662(this._SafeStr_18482);
        }

        
        var visible(get,set):Bool;
function  get_visible():Bool
        {
            return (this._SafeStr_9274 != null) && this._SafeStr_9274.visible;
        }
function  set_visible(k:Bool):Bool        {
            if ((k && (!(this._SafeStr_9274 != null))))
            {
                this._SafeStr_6656();
            }
            if (k)
            {
                this._SafeStr_9274.visible = true;
                this._SafeStr_9274.activate();
            }
            else
            {
                if (this._SafeStr_9274 != null)
                {
                    this._SafeStr_9274.visible = false;
                }
            }
return k;
        }

        function _SafeStr_6656()
        {
            var k:IWindow = null;
            var _local_2:IWindow = null;
            if (this._SafeStr_9274 == null)
            {
                this._SafeStr_9274 = Std.downcast(WindowUtils.createWindow("snowwar_leaderboard", 1) , IWindowContainer);
                this._SafeStr_9274.center();
                this._SafeStr_9274.findChildByTag("close").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_9859);
                this._SafeStr_5552 = Std.downcast(this._SafeStr_9274.findChildByName("list") , IItemListWindow);
                this._SafeStr_18608 = this._SafeStr_9274.findChildByName("listBorder");
                this._SafeStr_18609 = Std.downcast(this._SafeStr_9274.findChildByName("changeView") , ITextLinkWindow);
                this._SafeStr_18609.addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18642);
                k = this._SafeStr_9274.findChildByName("all_time_region");
                k.addEventListener(WindowMouseEvent.DOWN, this._SafeStr_18643);
                _local_2 = this._SafeStr_9274.findChildByName("this_week_region");
                _local_2.addEventListener(WindowMouseEvent.DOWN, this._SafeStr_18644);
                this._SafeStr_18612 = Std.downcast(this._SafeStr_9274.findChildByName("all_time_image") , IBitmapWrapperWindow);
                this._SafeStr_18610 = Std.downcast(this._SafeStr_9274.findChildByName("this_week_image") , IBitmapWrapperWindow);
                this._SafeStr_18613 = Std.downcast(this._SafeStr_9274.findChildByName("all_time_text") , ITextWindow);
                this._SafeStr_18611 = Std.downcast(this._SafeStr_9274.findChildByName("this_week_text") , ITextWindow);
                this._SafeStr_18614 = Std.downcast(this._SafeStr_9274.findChildByName("scrollUp") , IRegionWindow);
                this._SafeStr_18647(this._SafeStr_18614);
                WindowUtils.setElementImage(this._SafeStr_18614.getChildAt(0), this._SafeStr_12987("scroll_up_normal"));
                this._SafeStr_18615 = Std.downcast(this._SafeStr_9274.findChildByName("scrollDown") , IRegionWindow);
                this._SafeStr_18647(this._SafeStr_18615);
                WindowUtils.setElementImage(this._SafeStr_18615.getChildAt(0), this._SafeStr_12987("scroll_down_normal"));
                this._SafeStr_18616 = Std.downcast(this._SafeStr_9274.findChildByName("nextWeek") , IRegionWindow);
                this._SafeStr_18616.addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18645);
                this._SafeStr_18616.visible = false;
                this._SafeStr_18617 = Std.downcast(this._SafeStr_9274.findChildByName("previousWeek") , IRegionWindow);
                this._SafeStr_18617.addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18646);
                this._SafeStr_18617.visible = false;
                this._SafeStr_18660();
                this._SafeStr_18652();
            }
        }

        function _SafeStr_18647(k:IWindow)
        {
            k.addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18648);
            k.addEventListener(WindowMouseEvent.OVER, this._SafeStr_18648);
            k.addEventListener(WindowMouseEvent.OUT, this._SafeStr_18648);
            k.addEventListener(WindowMouseEvent.DOWN, this._SafeStr_18648);
            k.addEventListener(WindowMouseEvent.UP, this._SafeStr_18648);
        }

        function _SafeStr_9859(k:WindowMouseEvent)
        {
            this.hide();
        }

        function _SafeStr_18642(k:WindowMouseEvent)
        {
            switch (this._SafeStr_5998)
            {
                case _SafeStr_18604:
                    this._SafeStr_18631();
                    return;
                case _SafeStr_18605:
                    this._SafeStr_13282();
                    return;
                case _SafeStr_18606:
                    this._SafeStr_18633();
                    return;
                case _SafeStr_18607:
                    this._SafeStr_18632();
                    return;
            }
        }

        function _SafeStr_18643(k:WindowMouseEvent)
        {
            switch (this._SafeStr_5998)
            {
                case _SafeStr_18606:
                    this._SafeStr_18631();
                    return;
                case _SafeStr_18607:
                    this._SafeStr_13282();
                    return;
            }
        }

        function _SafeStr_18644(k:WindowMouseEvent)
        {
            switch (this._SafeStr_5998)
            {
                case _SafeStr_18604:
                    this._SafeStr_18633();
                    return;
                case _SafeStr_18605:
                    this._SafeStr_18632();
                    return;
            }
        }

        function _SafeStr_18649():LeaderboardTable
        {
            var k:LeaderboardTable = null;
            switch (this._SafeStr_5998)
            {
                case _SafeStr_18604:
                    k = this._SafeStr_18622;
                    
                case _SafeStr_18605:
                    k = this._SafeStr_18623;
                    
                case _SafeStr_18606:
                    k = this._SafeStr_18624;
                    
                case _SafeStr_18607:
                    k = this._SafeStr_18625;
                    
                default:
                    HabboGamesCom.log([("Invalid state " + Std.string(this._SafeStr_5998))]);
            }
            return k;
        }

        function _SafeStr_18650()
        {
            var k= this._SafeStr_18649();
            if (((k != null) && k.scrollUp()))
            {
                this._SafeStr_18658();
            }
        }

        function _SafeStr_18651()
        {
            var k= this._SafeStr_18649();
            if (((k != null) && k.scrollDown()))
            {
                this._SafeStr_18658();
            }
        }

        function _SafeStr_18648(k:WindowMouseEvent)
        {
            var _local_3:String = null;
            var _local_2= (((k.window : ASAny) == (this._SafeStr_18614 : ASAny)) ? "up" : "down");
            switch (k.type)
            {
                case WindowMouseEvent.CLICK:
                    if (((k.window : ASAny) == (this._SafeStr_18614 : ASAny)))
                    {
                        this._SafeStr_18650();
                    }
                    else
                    {
                        this._SafeStr_18651();
                    }
                    return;
                case WindowMouseEvent.OUT:
                    _local_3 = "normal";
                    
                case WindowMouseEvent.OVER:
                    _local_3 = "hilite";
                    
                case WindowMouseEvent.DOWN:
                    _local_3 = "click";
                    
                case WindowMouseEvent.UP:
                    _local_3 = "normal";
                    
            }
            var _local_4= ((("scroll_" + _local_2) + "_") + _local_3);
            var _local_5= Std.downcast(k.window , IWindowContainer);
            WindowUtils.setElementImage(_local_5.getChildAt(0), this._SafeStr_12987(_local_4));
        }

        function _SafeStr_18645(k:WindowMouseEvent)
        {
            if (this._SafeStr_18616.visible)
            {
                switch (this._SafeStr_5998)
                {
                    case _SafeStr_18606:
                        this._SafeStr_18640((this._SafeStr_18624.offset - 1));
                        return;
                    case _SafeStr_18607:
                        this._SafeStr_18641((this._SafeStr_18625.offset - 1));
                        return;
                }
            }
        }

        function _SafeStr_18646(k:WindowMouseEvent)
        {
            if (this._SafeStr_18617.visible)
            {
                switch (this._SafeStr_5998)
                {
                    case _SafeStr_18606:
                        this._SafeStr_18640((this._SafeStr_18624.offset + 1));
                        return;
                    case _SafeStr_18607:
                        this._SafeStr_18641((this._SafeStr_18625.offset + 1));
                        return;
                }
            }
        }

        function _SafeStr_18652()
        {
            var k:String = null;
            switch (this._SafeStr_5998)
            {
                case _SafeStr_18606:
                    if (this._SafeStr_18624.offset <= 0)
                    {
                        this._SafeStr_18616.visible = false;
                    }
                    else
                    {
                        this._SafeStr_18616.visible = true;
                    }
                    if (this._SafeStr_18624.offset >= this._SafeStr_18624.maxOffset)
                    {
                        this._SafeStr_18617.visible = false;
                    }
                    else
                    {
                        this._SafeStr_18617.visible = true;
                    }
                    
                case _SafeStr_18607:
                    if (this._SafeStr_18625.offset <= 0)
                    {
                        this._SafeStr_18616.visible = false;
                    }
                    else
                    {
                        this._SafeStr_18616.visible = true;
                    }
                    if (this._SafeStr_18625.offset >= this._SafeStr_18625.maxOffset)
                    {
                        this._SafeStr_18617.visible = false;
                    }
                    else
                    {
                        this._SafeStr_18617.visible = true;
                    }
                    
                default:
                    this._SafeStr_18616.visible = false;
                    this._SafeStr_18617.visible = false;
            }
            if (this._SafeStr_18616.visible)
            {
                this._SafeStr_18611.caption = this._SafeStr_18618;
            }
            else
            {
                this._SafeStr_18611.caption = "${snowwar.leaderboard.this_week}";
            }
            switch (this._SafeStr_5998)
            {
                case _SafeStr_18606
                   | _SafeStr_18607:
                    if (!this._SafeStr_18616.visible)
                    {
                        this._SafeStr_18653();
                        if (this._SafeStr_18620 == null)
                        {
                            this._SafeStr_18628(this._SafeStr_18619);
                        }
                        return;
                    }
                    WindowUtils._Str_26294(this._SafeStr_9274, "reset_text");
                    this._SafeStr_18627();
                default:
                    WindowUtils._Str_26294(this._SafeStr_9274, "reset_text");
                    this._SafeStr_18627();
            }
        }

        function _SafeStr_18653()
        {
            WindowUtils._Str_26291(this._SafeStr_9274, "reset_text");
            var k= "snowwar.leaderboard.weekly_reset";
            var _local_2= this._SafeStr_18654(this._SafeStr_18619);
            var _local_3= this._SafeStr_18655(this._SafeStr_18619);
            var _local_4= this._SafeStr_18656(this._SafeStr_18619);
            this._SafeStr_6445.registerParameter(k, "days", ("" + Std.string(this._SafeStr_18654(this._SafeStr_18619))));
            this._SafeStr_6445.registerParameter(k, "hours", ("" + Std.string(this._SafeStr_18655(this._SafeStr_18619))));
            this._SafeStr_6445.registerParameter(k, "minutes", ("" + Std.string(this._SafeStr_18656(this._SafeStr_18619))));
            WindowUtils._Str_4180(this._SafeStr_9274.findChildByName("reset_text"), (("${" + k) + "}"));
        }

        function _SafeStr_18589(k:TimerEvent)
        {
            if (((!this._SafeStr_18616.visible) && ((this._SafeStr_5998 == _SafeStr_18606) || (this._SafeStr_5998 == _SafeStr_18607))))
            {
                if (this._SafeStr_18619 > 0)
                {
                    this._SafeStr_18619--;
                }
                this._SafeStr_18653();
            }
        }

        function _SafeStr_18654(k:Int):Int
        {
            return Std.int(Math.ffloor(((k / 60) / 24)));
        }

        function _SafeStr_18655(k:Int):Int
        {
            var _local_2= this._SafeStr_18654(k);
            return Std.int(Math.ffloor(((k - ((_local_2 * 24) * 60)) / 60)));
        }

        function _SafeStr_18656(k:Int):Int
        {
            var _local_2= this._SafeStr_18654(k);
            var _local_3= this._SafeStr_18655(k);
            return (k - ((_local_2 * 24) * 60)) - (_local_3 * 60);
        }

        function _SafeStr_18657():Array<ASAny>
        {
            switch (this._SafeStr_5998)
            {
                case _SafeStr_18604:
                    return this._SafeStr_18622.getVisibleEntries();
                case _SafeStr_18605:
                    return this._SafeStr_18623.getVisibleEntries();
                case _SafeStr_18606:
                    return this._SafeStr_18624.getVisibleEntries();
                case _SafeStr_18607:
                    return this._SafeStr_18625.getVisibleEntries();
                default:
                    return null;
            }
        }

        function _SafeStr_18658()
        {
            var _local_5:LeaderboardEntry = null;
            var _local_6:IWindowContainer = null;
            var _local_7:IWindowContainer = null;
            var _local_8:IWindow = null;
            var _local_9 = 0;
            var _local_10:IWindowContainer = null;
            var _local_11:IWindowContainer = null;
            var k= this._SafeStr_18657();
            var _local_2= this._SafeStr_18579.sessionDataManager.userId;
            if (((!(k != null)) || (k.length == 0)))
            {
                this._SafeStr_5552.visible = false;
                this._SafeStr_18608.visible = false;
                return;
            }
            var _local_3 = 0;
            this._SafeStr_5552.destroyListItems();
            var _local_4= Std.downcast(WindowUtils.createWindow("snowwar_leaderboard_entry") , IWindowContainer);
            while (_local_3 < k.length)
            {
                _local_5 = k[_local_3];
                if (_local_5 == null)
                {
                }
                else
                {
                    _local_6 = Std.downcast(_local_4.clone() , IWindowContainer);
                    _local_6.findChildByName("rank").caption = Std.string(_local_5.rank);
                    _local_6.findChildByName("score").caption = Std.string(_local_5.score);
                    _local_6.findChildByName("name").caption = _local_5.name;
                    this._SafeStr_18526(Std.downcast(_local_6.findChildByName("avatarImage") , IBitmapWrapperWindow), _local_5.figure, _local_5.gender);
                    if (((!(_local_5.userId == this._SafeStr_18579.sessionDataManager.userId)) || (((this._SafeStr_5998 == _SafeStr_18605) && (_local_5.userId == _local_2)) && (_local_3 < (k.length - 1)))))
                    {
                        _local_6.findChildByName("highlight").visible = false;
                        _local_6.findChildByName("divider").visible = false;
                        _local_7 = Std.downcast(this._SafeStr_5552.getListItemAt((this._SafeStr_5552.numListItems - 1)) , IWindowContainer);
                        if (_local_7 != null)
                        {
                            _local_7.findChildByName("divider").visible = false;
                        }
                    }
                    _local_6.findChildByName("imageRegion").id = _local_5.userId;
                    _local_6.findChildByName("imageRegion").addEventListener(WindowMouseEvent.CLICK, this._SafeStr_18659);
                    this._SafeStr_5552.addListItem(_local_6);
                }
                _local_3++;
            }
            if (((this._SafeStr_5998 == _SafeStr_18605) || (this._SafeStr_5998 == _SafeStr_18606)))
            {
                if ((_local_3 % this._SafeStr_18622.viewSize) != 0)
                {
                    _local_8 = this._SafeStr_5552.getListItemAt((this._SafeStr_5552.numListItems - 1));
                    _local_9 = 0;
                    while (_local_9 < ((_local_3 % this._SafeStr_18622.viewSize) - 1))
                    {
                        _local_10 = Std.downcast(_local_4.clone() , IWindowContainer);
                        _local_10.findChildByName("rank").caption = "";
                        _local_10.findChildByName("score").caption = "";
                        _local_10.findChildByName("name").caption = "";
                        _local_10.findChildByName("highlight").visible = false;
                        _local_10.findChildByName("divider").visible = false;
                        _local_11 = Std.downcast(this._SafeStr_5552.getListItemAt((this._SafeStr_5552.numListItems - 1)) , IWindowContainer);
                        if (_local_11 != null)
                        {
                            _local_11.findChildByName("divider").visible = false;
                        }
                        _local_10.removeChild(_local_10.findChildByName("imageRegion"));
                        this._SafeStr_5552.addListItem(_local_10);
                        _local_9++;
                    }
                    this._SafeStr_5552.addListItem(_local_8);
                }
            }
            _local_4.dispose();
            _local_4 = Std.downcast(this._SafeStr_5552.getListItemAt((this._SafeStr_5552.numListItems - 1)) , IWindowContainer);
            if (_local_4 != null)
            {
                _local_4.findChildByName("divider").visible = false;
            }
            this._SafeStr_5552.visible = true;
            this._SafeStr_18608.visible = true;
            this._SafeStr_18660();
            this._SafeStr_9274.invalidate();
        }

        function _SafeStr_18526(k:IBitmapWrapperWindow, _arg_2:String, _arg_3:String=null)
        {
            var _local_4:BitmapData = null;
            var _local_5= this._SafeStr_18579.avatarRenderManager.createAvatarImage(_arg_2, AvatarScaleType.LARGE, _arg_3, this);
            if (_local_5 != null)
            {
                _local_5.setDirection(AvatarSetType.FULL, 2);
_local_4 = _local_5.getCroppedImage(AvatarSetType.HEAD);
                if (_local_5.isPlaceholder())
                {
                    this._SafeStr_18621.remove(_arg_2);
                    this._SafeStr_18621.add(_arg_2, k);
                }
                _local_5.dispose();
            }
            WindowUtils.setElementImage(k, _local_4);
            _local_4.dispose();
        }

        function _SafeStr_18659(k:WindowMouseEvent)
        {
            this._SafeStr_18579.groupsManager.showExtendedProfile(k.window.id);
        }

        function _SafeStr_18660()
        {
            var k= this._SafeStr_18649();
            if (((k != null) && this._SafeStr_18626))
            {
                this._SafeStr_18614.visible = k._SafeStr_18663();
                this._SafeStr_18615.visible = k._SafeStr_18664();
            }
        }

        function _SafeStr_12987(k:String):BitmapData
        {
            var _local_2= this._SafeStr_18579.assets.getAssetByName(k);
            if (_local_2 != null)
            {
                return ASCompat.dynamicAs(_local_2.content , BitmapData);
            }
            return null;
        }
    }

