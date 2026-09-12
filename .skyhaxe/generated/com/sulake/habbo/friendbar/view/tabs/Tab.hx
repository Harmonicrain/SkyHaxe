package com.sulake.habbo.friendbar.view.tabs
;
    import com.sulake.habbo.friendbar.data.IHabboFriendBarData;
    import com.sulake.habbo.friendlist.IHabboFriendsList;
    import com.sulake.habbo.game.IHabboGameManager;
    import com.sulake.habbo.friendbar.view.IHabboFriendBarView;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.friendbar.view.utils.TextCropper;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.geom.Point;

     class Tab implements ITab 
    {
        public static var WIDTH:Int = 127;
        public static var HEIGHT:Int = 36;
        public static var _Str_2925:IHabboFriendBarData;
        public static var FRIENDS:IHabboFriendsList;
        public static var GAMES:IHabboGameManager;
        public static var _Str_3553:IHabboFriendBarView;
        public static var ASSETS:IAssetLibrary;
        public static var _Str_3684:IHabboWindowManager;
        public static var _Str_3840:IHabboLocalizationManager;
        public static var TRACKING:IHabboTracking;
        public static var _Str_9890:TextCropper;
        static inline final _Str_11139= false;
        static inline final _Str_6722= 80;
        static inline final _Str_6252= 3;

        var _window:IWindowContainer;
        var _Str_2638:Bool = false;
        var _Str_18162:Bool = false;
        var _selected:Bool = false;
        var _disposed:Bool = false;


        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public var selected(get,never):Bool;
public function  get_selected():Bool
        {
            return this._selected;
        }

        public var _Str_6044(get,never):Bool;
public function  get__Str_6044():Bool
        {
            return this._Str_2638;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        var _Str_3341(get,never):Bool;
function  get__Str_3341():Bool
        {
            return this._Str_18162;
        }

        public function select(k:Bool)
        {
            this.conceal();
            this._selected = true;
        }

        public function deselect(k:Bool)
        {
            this._selected = false;
        }

        public function recycle()
        {
            this.conceal();
            this._Str_2638 = true;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._window != null)
                {
                    this._window.dispose();
                    this._window = null;
                }
                this._disposed = true;
            }
        }

        function expose()
        {
            this._Str_18162 = true;
        }

        function conceal()
        {
            this._Str_18162 = false;
        }

        function onMouseClick(k:WindowMouseEvent)
        {
            if ((this.disposed || this._Str_6044))
            {
                return;
            }
            if (this.selected)
            {
                _Str_3553.deSelect(true);
            }
            else
            {
                _Str_3553.selectTab(this, true);
            }
        }

        function onMouseOver(k:WindowMouseEvent)
        {
            if ((this.disposed || this._Str_6044))
            {
                return;
            }
            if (!this.selected)
            {
                this.expose();
            }
        }

        function onMouseOut(k:WindowMouseEvent)
        {
            if (((this.disposed || this._Str_6044) || (this._window == null)))
            {
                return;
            }
            if (!this.selected)
            {
                if (!this._window.hitTestGlobalPoint(new Point(k.stageX, k.stageY)))
                {
                    this.conceal();
                }
            }
        }

	public function new() {}
    }

