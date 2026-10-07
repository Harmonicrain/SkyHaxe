package com.sulake.habbo.friendbar.view.tabs.tokens
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.game.IHabboGameManager;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.friendbar.data.IFriendNotification;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window._enum.WindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.motion.Motions;
    import com.sulake.core.window.motion.DropBounce;

     class Token implements IDisposable 
    {
        static var _Str_12043:IHabboWindowManager;
        static var _ASSET_LIBRARY:IAssetLibrary;
        static var _Str_9155:IHabboGameManager;
        static inline final TITLE= "title";
        static inline final MESSAGE= "message";
        static final ICON_RECTANGLE:Rectangle = new Rectangle(0, 0, 25, 25);

        var _icon:IRegionWindow;
        var window:IWindowContainer;
        var _disposed:Bool = false;
        var _Str_4287:IFriendNotification;

        public function new(k:IFriendNotification)
        {
            this._Str_4287 = k;
        }

        public static var _Str_3684(never,set):IHabboWindowManager;
public static function  set__Str_3684(k:IHabboWindowManager):IHabboWindowManager        {
            return _Str_12043 = k;
        }

        public static var ASSETS(never,set):IAssetLibrary;
public static function  set_ASSETS(k:IAssetLibrary):IAssetLibrary        {
            return _ASSET_LIBRARY = k;
        }

        public static var GAMES(never,set):IHabboGameManager;
public static function  set_GAMES(k:IHabboGameManager):IHabboGameManager        {
            return _Str_9155 = k;
        }


        public var typeCode(get,never):Int;
public function  get_typeCode():Int
        {
            return this._Str_4287.typeCode;
        }

        public var viewOnce(get,never):Bool;
public function  get_viewOnce():Bool
        {
            return this._Str_4287.viewOnce;
        }

        public var notification(get,never):IFriendNotification;
public function  get_notification():IFriendNotification
        {
            return this._Str_4287;
        }

        public var _Str_3614(get,never):IWindow;
public function  get__Str_3614():IWindow
        {
            return this._icon;
        }

        public var _Str_21233(get,never):IWindow;
public function  get__Str_21233():IWindow
        {
            return this.window;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (this.window != null)
            {
                this.window.dispose();
                this.window = null;
            }
            if (this._icon != null)
            {
                this._icon.dispose();
                this._icon = null;
            }
            this._Str_4287 = null;
            this._disposed = true;
        }

        function prepare(k:String, _arg_2:String, _arg_3:String, _arg_4:String)
        {
            this.window = Std.downcast(_Str_12043.buildFromXML(((_ASSET_LIBRARY.getAssetByName(_arg_3).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this.window.findChildByName(TITLE).caption = k;
            this.window.findChildByName(MESSAGE).caption = (ASCompat.stringAsBool(_arg_2) ? _arg_2 : "");
            this._icon = Std.downcast(_Str_12043.create(("ICON_" + Std.string(this.typeCode)), WindowType.WINDOW_TYPE_REGION, WindowStyle.WINDOW_STYLE_DEFAULT, WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, Token.ICON_RECTANGLE) , IRegionWindow);
            this._icon.mouseThreshold = 0;
            var _local_5= Std.downcast(_Str_12043.create(("BITMAP_" + Std.string(this.typeCode)), WindowType.WINDOW_TYPE_STATIC_BITMAP_WRAPPER, WindowStyle.WINDOW_STYLE_DEFAULT, WindowParam.WINDOW_PARAM_NULL, Token.ICON_RECTANGLE) , IStaticBitmapWrapperWindow);
            _local_5.assetUri = _arg_4;
            this._icon.addChild(_local_5);
            if (Motions._Str_9810(this._icon) == null)
            {
                Motions._Str_4598(new DropBounce(this._icon, 600, 32));
            }
        }
    }

