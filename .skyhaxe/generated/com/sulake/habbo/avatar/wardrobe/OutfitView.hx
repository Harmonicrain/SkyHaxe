package com.sulake.habbo.avatar.wardrobe
;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.XmlAsset;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class OutfitView
    {
        var _windowManager:IHabboWindowManager;
        var _assetLibrary:IAssetLibrary;
        var _window:IWindowContainer;
        var _imageContainer:IBitmapWrapperWindow;

        public function new(k:IHabboWindowManager, _arg_2:IAssetLibrary, _arg_3:Bool)
        {
            this._windowManager = k;
            this._assetLibrary = _arg_2;
            var _local_4= Std.downcast(this._assetLibrary.getAssetByName("Outfit") , XmlAsset);
            this._window = cast(this._windowManager.buildFromXML(((_local_4.content : com.sulake.core.utils.xml.XML) )), IWindowContainer);
            if (this._window != null)
            {
                this._imageContainer = Std.downcast(this._window.findChildByName("bitmap") , IBitmapWrapperWindow);
            }
            if (!_arg_3)
            {
                this._window.findChildByName("button").disable();
            }
        }

        public function dispose()
        {
            this._windowManager = null;
            this._assetLibrary = null;
            if (this._window != null)
            {
                this._window.dispose();
            }
            this._window = null;
            if (this._imageContainer != null)
            {
                this._imageContainer.dispose();
            }
            this._imageContainer = null;
        }

        public function _Str_25268(k:BitmapData)
        {
            this._imageContainer.bitmap = new BitmapData(this._imageContainer.width, this._imageContainer.height, true, 0xFFFFFF);
            var _local_2= Std.int((this._imageContainer.width - k.width) / 2);
            var _local_3= (this._imageContainer.height - k.height);
            this._imageContainer.bitmap.copyPixels(k, k.rect, new Point(_local_2, _local_3));
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        function windowEventProc(k:WindowEvent, _arg_2:IWindow=null)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
            }
            else
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    this._window.color = 0xCCCCCC;
                }
                else
                {
                    if (k.type == WindowMouseEvent.OUT)
                    {
                        this._window.color = 0x666666;
                    }
                }
            }
        }
    }

