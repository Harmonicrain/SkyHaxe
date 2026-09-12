package com.sulake.habbo.notifications.feed.view.content
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.notifications.feed.NotificationController;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.assets.IAsset;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;

     class FeedEntity implements IFeedEntity 
    {
        public static var _Str_4669:IWindowContainer;
        public static var _Str_11723:IHabboLocalizationManager;
        public static var ASSETS:IAssetLibrary;
        public static var _Str_11726:NotificationController;
        static final _POOL:Vector<FeedEntity> = new Vector();
        static inline final CONTENT_LIST= "content_list";
        static inline final TITLE= "title";
        static inline final MESSAGE= "message";
        static inline final TIME= "time";
        static inline final ICON= "icon";
        static inline final DECORATION= "decoration";
        static inline final ACTION_BUTTON= "action_button";
        static inline final MINUTES= "minutes";
        static inline final HOURS= "hours";
        static inline final DAYS= "days";
        static inline final _Str_4468= 25;

        var _window:IWindowContainer;
        var _disposed:Bool = false;
        var _Str_2638:Bool = false;
        var _id:Int = -1;
        var _Str_15818:Int = 0;
        var _Str_10954:String;
        var _Str_8852:String;
        var _Str_9283:String;

        public function new()        {
            this._window = Std.downcast(_Str_4669.clone() , IWindowContainer);
        }

        public static function _Str_23222(k:IHabboWindowManager, _arg_2:IAssetLibrary, _arg_3:IHabboLocalizationManager, _arg_4:NotificationController)
        {
            _Str_4669 = Std.downcast(k.buildFromXML(((_arg_2.getAssetByName("feed_entity_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            ASSETS = _arg_2;
            _Str_11723 = _arg_3;
            _Str_11726 = _arg_4;
        }

        public static function _Str_23840()
        {
            if (_Str_4669 != null)
            {
                _Str_4669.dispose();
                _Str_4669 = null;
            }
            ASSETS = null;
            _Str_11723 = null;
            _Str_11726 = null;
        }

        public static function _Str_2363():FeedEntity
        {
            var k= ((_POOL.length > 0) ? _POOL.pop() : Type.createInstance(FeedEntity, []));
            k._Str_2638 = false;
            return k;
        }


        
        public var id(get,set):Int;
public function  set_id(k:Int):Int        {
            return this._id = k;
        }
public function  get_id():Int
        {
            return this._id;
        }

        
        public var title(get,set):String;
public function  set_title(k:String):String        {
            this._window.findChildByName(TITLE).caption = (ASCompat.stringAsBool(k) ? k : "");
return k;
        }
public function  get_title():String
        {
            return (this._window != null) ? this._window.findChildByName(TITLE).caption : null;
        }

        
        public var message(get,set):String;
public function  set_message(k:String):String        {
            this._window.findChildByName(MESSAGE).caption = (ASCompat.stringAsBool(k) ? k : "");
return k;
        }
public function  get_message():String
        {
            return (this._window != null) ? this._window.findChildByName(MESSAGE).caption : null;
        }

        public function _Str_24362(k:String, _arg_2:String)
        {
            if (this._window == null)
            {
                return;
            }
            this._Str_9283 = k;
            var _local_3= Std.downcast(this._window.findChildByName(ACTION_BUTTON) , IButtonWindow);
            if (this._Str_9283 == null)
            {
                _local_3.height = 0;
            }
            else
            {
                _local_3.height = _Str_4468;
                _local_3.caption = _arg_2;
                _local_3.addEventListener(WindowMouseEvent.CLICK, this._Str_21462);
            }
        }

        public var _Str_26144(never,set):String;
public function  set__Str_26144(k:String):String        {
            var _local_2:IAsset = null;
            if (!ASCompat.stringAsBool(k))
            {
                return k;
            }
            if (k != this._Str_10954)
            {
                this._Str_10954 = k;
                _local_2 = ASSETS.getAssetByName(k);
                if (_local_2 != null)
                {
                    this.icon = ASCompat.dynamicAs(_local_2.content , BitmapData);
                }
                else
                {
                    this._Str_20851(k);
                }
            }
return k;
        }

        public var _Str_26226(never,set):String;
public function  set__Str_26226(k:String):String        {
            var _local_2:IAsset = null;
            if (!ASCompat.stringAsBool(k))
            {
                return k;
            }
            if (k != this._Str_8852)
            {
                this._Str_8852 = k;
                _local_2 = ASSETS.getAssetByName(k);
                if (_local_2 != null)
                {
                    this.decoration = ASCompat.dynamicAs(_local_2.content , BitmapData);
                }
                else
                {
                    this._Str_20851(k);
                }
            }
return k;
        }

        public var icon(never,set):BitmapData;
public function  set_icon(k:BitmapData):BitmapData        {
            if ((this.disposed || (!(this._window != null))))
            {
                return k;
            }
            var _local_2= Std.downcast(this._window.findChildByName(ICON) , IBitmapWrapperWindow);
            this._Str_4497(_local_2, k);
            this._Str_10954 = null;
return k;
        }

        public var decoration(never,set):BitmapData;
public function  set_decoration(k:BitmapData):BitmapData        {
            if ((this.disposed || (!(this._window != null))))
            {
                return k;
            }
            var _local_2= Std.downcast(this._window.findChildByName(DECORATION) , IBitmapWrapperWindow);
            this._Str_4497(_local_2, k);
            this._Str_8852 = null;
return k;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var _Str_6044(get,never):Bool;
public function  get__Str_6044():Bool
        {
            return this._Str_2638;
        }

        
        public var _Str_19059(get,set):Int;
public function  set__Str_19059(k:Int):Int        {
            var _local_2= Std.downcast(this._window.findChildByName(TIME) , ITextWindow);
            if (k < 0)
            {
                _local_2.height = 0;
                return k;
            }
            this._Str_15818 = k;
            var _local_3= MINUTES;
            if (this._Str_15818 >= (24 * 60))
            {
                _local_3 = DAYS;
                k = Std.int(k / (24 * 60));
            }
            else
            {
                if (this._Str_15818 >= 60)
                {
                    _local_3 = HOURS;
                    k = Std.int(k / 60);
                }
            }
            var _local_4= _Str_11723.getLocalizationRaw((("friendbar.stream." + _local_3) + ".ago"));
            _local_2.caption = ((_local_4 != null) ? ASCompat.stringReplace(_local_4.raw, "%value%", Std.string(k)) : "...?");
return k;
        }
public function  get__Str_19059():Int
        {
            return this._Str_15818;
        }

        public function _Str_21184()
        {
            if (((!(this._window != null)) || this.disposed))
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName(CONTENT_LIST) , IItemListWindow);
            var _local_2= k.getListItemAt((k.numListItems - 1)) ;
            k.height = ((_local_2 != null) ? (_local_2.y + _local_2.height) : 0);
        }

        public function recycle()
        {
            if (!this._Str_2638)
            {
                if (!this._disposed)
                {
                    this._window.parent = null;
                    cast(this._window.findChildByName(DECORATION), IBitmapWrapperWindow).bitmap = null;
                    cast(this._window.findChildByName(ICON), IBitmapWrapperWindow).bitmap = null;
                    Std.downcast(this._window.findChildByName(ACTION_BUTTON) , IButtonWindow).removeEventListener(WindowMouseEvent.CLICK, this._Str_21462);
                    this._Str_8852 = null;
                    this._Str_2638 = true;
                    _POOL.push(this);
                }
            }
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
                if (this._Str_2638)
                {
                    _POOL.splice(_POOL.indexOf(this), 1);
                    this._Str_2638 = false;
                }
                this._disposed = true;
            }
        }

        function _Str_21462(k:WindowMouseEvent)
        {
            _Str_11726.executeAction(this._Str_9283);
        }

        function _Str_4497(k:IBitmapWrapperWindow, _arg_2:BitmapData)
        {
            if (_arg_2 == null)
            {
                k.bitmap = null;
                k.height = 0;
                return;
            }
            var _local_3= (k.x + (k.width / 2));
            var _local_4= (k.y + (k.height / 2));
            k.bitmap = _arg_2;
            k.x = Std.int(_local_3 - (_arg_2.width / 2));
            k.y = Std.int(_local_4 - (_arg_2.height / 2));
            k.width = _arg_2.width;
            k.height = _arg_2.height;
        }

        function _Str_20851(k:String)
        {
            var _local_2= ASSETS.loadAssetFromFile(k, new URLRequest(k));
            _local_2.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this._Str_20557);
            _local_2.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this._Str_20557);
        }

        function _Str_20557(k:AssetLoaderEvent)
        {
            var _local_2:AssetLoaderStruct = null;
            var _local_3:IAsset = null;
            if (k.type == AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE)
            {
                _local_2 = ASCompat.dynamicAs(k.target , AssetLoaderStruct);
                if (_local_2.assetName == this._Str_8852)
                {
                    _local_3 = ASSETS.getAssetByName(this._Str_8852);
                    if (_local_3 != null)
                    {
                        this.decoration = ASCompat.dynamicAs(_local_3.content , BitmapData);
                    }
                }
                else
                {
                    if (_local_2.assetName == this._Str_10954)
                    {
                        _local_3 = ASSETS.getAssetByName(this._Str_10954);
                        if (_local_3 != null)
                        {
                            this.icon = ASCompat.dynamicAs(_local_3.content , BitmapData);
                        }
                    }
                }
                this._Str_21184();
            }
        }
    }

