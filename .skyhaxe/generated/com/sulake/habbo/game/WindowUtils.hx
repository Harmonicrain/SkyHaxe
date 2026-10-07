package com.sulake.habbo.game
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.display.Bitmap;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.components.ITextWindow;

     class WindowUtils 
    {
        static var _assets:IAssetLibrary;
        static var _windowManager:IHabboWindowManager;


        public static function _Str_4180(k:IWindow, _arg_2:String)
        {
            var _local_3:IWindow = null;
            k.caption = _arg_2;
            if (Std.is(k.parent , IWindowContainer))
            {
                _local_3 = Std.downcast(k.parent , IWindowContainer).findChildByName((k.name + "_stroke"));
            }
            if (Std.is(k.parent , IItemListWindow))
            {
                _local_3 = Std.downcast(k.parent , IItemListWindow).getListItemByName((k.name + "_stroke"));
            }
            if (Std.is(k.parent , IItemGridWindow))
            {
                _local_3 = Std.downcast(k.parent , IItemGridWindow).getGridItemByName((k.name + "_stroke"));
            }
            if (_local_3 != null)
            {
                if (_local_3.caption != _arg_2)
                {
                    _local_3.caption = _arg_2;
                }
            }
        }

        public static function init(k:IAssetLibrary, _arg_2:IHabboWindowManager)
        {
            _assets = k;
            _windowManager = _arg_2;
        }

        public static function setElementImage(k:IWindow, _arg_2:BitmapData, _arg_3:Int=0, _arg_4:Int=0, _arg_5:Int=0)
        {
            var _local_9:IBitmapWrapperWindow = null;
            var _local_10:IDisplayObjectWrapper = null;
            if (_arg_2 == null)
            {
                return;
            }
            if (k == null)
            {
                return;
            }
            if (k.disposed)
            {
                return;
            }
            var _local_6= ((_arg_3 > 0) ? _arg_3 : k.height);
            var _local_7= Std.int(((k.width - _arg_2.width) / 2) + _arg_4);
            var _local_8= Std.int(((_local_6 - _arg_2.height) / 2) + _arg_5);
            if (Std.downcast(k , IBitmapWrapperWindow) != null)
            {
                _local_9 = cast(k, IBitmapWrapperWindow);
                if (((_local_9.bitmap == null) || (_arg_3 > 0)))
                {
                    _local_9.bitmap = new BitmapData(k.width, _local_6, true, 0xFFFFFF);
                }
                _local_9.bitmap.fillRect(_local_9.bitmap.rect, 0xFFFFFF);
                _local_9.bitmap.copyPixels(_arg_2, _arg_2.rect, new Point(_local_7, _local_8), null, null, false);
                k.invalidate();
            }
            else
            {
                if (Std.downcast(k , IDisplayObjectWrapper) != null)
                {
                    _local_10 = cast(k, IDisplayObjectWrapper);
                    _local_10.setDisplayObject(new Bitmap(_arg_2));
                }
            }
        }

        public static function createWindow(k:String, _arg_2:Int=2):IWindow
        {
            var _local_6:IWindow = null;
            var _local_7:IBitmapWrapperWindow = null;
            HabboGamesCom.log([("CreateWindow: " + k)]);
            if (((!(_assets != null)) || (!(_windowManager != null))))
            {
                return null;
            }
            var _local_3= Std.downcast(_assets.getAssetByName(k) , XmlAsset);
            if (_local_3 == null)
            {
                HabboGamesCom.log([("CreateWindow() could not find the asset for window: " + k)]);
                return null;
            }
            var _local_4= _windowManager.buildFromXML(((_local_3.content : com.sulake.core.utils.xml.XML) ), _arg_2);
            var _local_5:Array<ASAny> = [];
            if (Std.is(_local_4 , IWindowContainer))
            {
                Std.downcast(_local_4 , IWindowContainer).groupChildrenWithTag("bitmap", _local_5, -1);
            }
            else
            {
                if (Std.is(_local_4 , IItemListWindow))
                {
                    Std.downcast(_local_4 , IItemListWindow).groupListItemsWithTag("bitmap", _local_5, -1);
                }
                else
                {
                    if (Std.is(_local_4 , IItemGridWindow))
                    {
                    }
                }
            }
            if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
            {
_local_6  = _tmp_;
                HabboGamesCom.log([("Found child: " + _local_6.name)]);
            }
            if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
            {
_local_7  = _tmp_;
                if (_local_7 == null)
                {
                }
                else
                {
                    _Str_21499(_local_7, false);
                }
            }
            return _local_4;
        }

        static function _Str_21499(bmpWindow:IBitmapWrapperWindow, active:Bool)
        {
            var asset:IAsset = null;
            var assetName:String = null;
            var src:BitmapData = null;
            if (_assets == null)
            {
                return;
            }
            if (bmpWindow == null)
            {
                return;
            }
            var result= ASCompat.ASArray.filter(bmpWindow.properties, function (k:ASAny, _arg_2:Int, _arg_3:Array<ASAny>):Bool
            {
                return cast(k, PropertyStruct).key == "bitmap_asset_name";
            });
            var offset= new Point();
            if (((result != null) && (result.length != 0)))
            {
                assetName = ASCompat.asString(cast(result[0], PropertyStruct).value );
                HabboGamesCom.log([((("Found Image: " + bmpWindow.name) + " : ") + assetName)]);
                if (active)
                {
                    assetName = ASCompat.stringReplace(assetName, "_on", "");
                }
                asset = _assets.getAssetByName(assetName);
                if (((asset != null) && Std.is(asset , BitmapDataAsset)))
                {
                    bmpWindow.bitmap = new BitmapData(bmpWindow.width, bmpWindow.height, true, 0);
                    src = ASCompat.dynamicAs(asset.content , BitmapData);
                    offset.x = ((bmpWindow.width - src.width) / 2);
                    offset.y = ((bmpWindow.height - src.height) / 2);
                    bmpWindow.bitmap.copyPixels(src, src.rect, offset);
                }
            }
        }

        public static function _Str_26294(k:IWindowContainer, _arg_2:String)
        {
            var _local_3= k.findChildByName(_arg_2);
            if (_local_3 != null)
            {
                _local_3.visible = false;
            }
            var _local_4= k.findChildByName((_arg_2 + "_stroke"));
            if (_local_4 != null)
            {
                _local_4.visible = false;
            }
        }

        public static function _Str_26442(k:IWindow, _arg_2:UInt)
        {
            var _local_4:ITextWindow = null;
            var _local_3:Array<ASAny> = [];
            if (Std.is(k , IWindowContainer))
            {
                Std.downcast(k , IWindowContainer).groupChildrenWithTag("stroke", _local_3, 10);
            }
            else
            {
                if (Std.is(k , IItemListWindow))
                {
                    Std.downcast(k , IItemListWindow).groupListItemsWithTag("stroke", _local_3, 10);
                }
                else
                {
                    if (Std.is(k , IItemGridWindow))
                    {
                    }
                }
            }
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_4  = _tmp_;
                if (_local_4 == null)
                {
                }
                else
                {
                    _local_4.textColor = _arg_2;
                }
            }
        }

        public static function _Str_26291(k:IWindowContainer, _arg_2:String)
        {
            var _local_3= k.findChildByName(_arg_2);
            if (_local_3 != null)
            {
                _local_3.visible = true;
            }
            var _local_4= k.findChildByName((_arg_2 + "_stroke"));
            if (_local_4 != null)
            {
                _local_4.visible = true;
            }
        }

	public function new() {}
    }

