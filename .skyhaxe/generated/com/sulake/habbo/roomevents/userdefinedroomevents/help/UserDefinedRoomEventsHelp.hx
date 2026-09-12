package com.sulake.habbo.roomevents.userdefinedroomevents.help
;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.localization.ILocalization;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;

     class UserDefinedRoomEventsHelp 
    {
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _helpContainer:IWindowContainer;
        var _window:IFrameWindow;
        var _view:IWindowContainer;
        var _currentPage:Int = 0;
        var _localizations:Array<ASAny>;
        var _buttonNext:IContainerButtonWindow;
        var _buttonPrevious:IContainerButtonWindow;

        public function new(k:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = k;
        }

        public function dispose()
        {
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this.requestLocalizationInit();
            this._window = cast(this._roomEvents.getXmlWindow("ude_help"), IFrameWindow);
            this._helpContainer = cast(this.find(this._window, "help_container"), IWindowContainer);
            this._buttonPrevious = Std.downcast(this._helpContainer.findChildByName("button_previous") , IContainerButtonWindow);
            if (this._buttonPrevious != null)
            {
                this._buttonPrevious.procedure = this._Str_3369;
            }
            this._buttonNext = Std.downcast(this._helpContainer.findChildByName("button_next") , IContainerButtonWindow);
            if (this._buttonNext != null)
            {
                this._buttonNext.procedure = this._Str_3369;
            }
            var k= this._window.findChildByTag("close");
            k.procedure = this.onWindowClose;
            this._window.center();
        }

        public function open(k:Int=-1, _arg_2:Int=-1)
        {
            this.prepareWindow();
            this.openPage();
            this._window.visible = true;
            if (k >= 0)
            {
                this._window.x = k;
            }
            if (_arg_2 >= 0)
            {
                this._window.y = _arg_2;
            }
        }

        function onWindowClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.close();
            }
        }

        public function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        function find(k:IWindowContainer, _arg_2:String):IWindow
        {
            var _local_3= k.findChildByName(_arg_2);
            if (_local_3 == null)
            {
                throw new ASError((("Window element with name: " + _arg_2) + " cannot be found!"));
            }
            return _local_3;
        }

        public function toggle()
        {
            this._window.visible = (!this._window.visible);
        }

        function openPage()
        {
            this._Str_19940();
            this._Str_25855();
        }

        function _Str_25855()
        {
            if (this._currentPage >= (this._localizations.length - 1))
            {
                this._buttonNext.disable();
            }
            else
            {
                this._buttonNext.enable();
            }
            if (this._currentPage <= 0)
            {
                this._buttonPrevious.disable();
            }
            else
            {
                this._buttonPrevious.enable();
            }
        }

        function _Str_24548()
        {
            this._currentPage++;
            this._currentPage = Std.int(Math.min(this._currentPage, (this._localizations.length - 1)));
            this.openPage();
        }

        function _Str_23595()
        {
            this._currentPage--;
            this._currentPage = Std.int(Math.max(this._currentPage, 0));
            this.openPage();
        }

        function requestLocalizationInit()
        {
            var _local_2:ILocalization = null;
            var _local_3:ILocalization = null;
            var _local_4:ILocalization = null;
            this._localizations = [];
            var k= 1;
            while (this._roomEvents.localization.getLocalizationRaw((("wiredfurni.help." + Std.string(k)) + ".title")) != null)
            {
                _local_2 = this._roomEvents.localization.getLocalizationRaw((("wiredfurni.help." + Std.string(k)) + ".title"));
                _local_3 = this._roomEvents.localization.getLocalizationRaw((("wiredfurni.help." + Std.string(k)) + ".img"));
                _local_4 = this._roomEvents.localization.getLocalizationRaw((("wiredfurni.help." + Std.string(k)) + ".text"));
                this._localizations.push(([_local_2, _local_3, _local_4] : Array<Dynamic>));
                k++;
            }
        }

        function _Str_3369(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "button_previous":
                        this._Str_23595();
                        return;
                    case "button_next":
                        this._Str_24548();
                        return;
                }
            }
        }

        function _Str_19940()
        {
            var k:ILocalization = null;
            var _local_5:String = null;
            var _local_2= Std.downcast(this.find(this._window, "help_title") , ITextWindow);
            var _local_3= Std.downcast(this.find(this._window, "help_text") , ITextWindow);
            var _local_4= Std.downcast(this.find(this._window, "help_image") , IBitmapWrapperWindow);
            if (((this._localizations == null) || (this._localizations.length == 0)))
            {
                return;
            }
            if (_local_2 != null)
            {
                k = cast(this._localizations[this._currentPage][0], ILocalization);
                if (k != null)
                {
                    _local_2.text = k.value;
                }
            }
            if (_local_3 != null)
            {
                k = cast(this._localizations[this._currentPage][2], ILocalization);
                if (k != null)
                {
                    _local_2.text = k.value;
                }
            }
            if (_local_4 != null)
            {
                k = cast(this._localizations[this._currentPage][1], ILocalization);
                if (k != null)
                {
                    _local_5 = k.value;
                    this._Str_6504(_local_5);
                }
            }
        }

        function setElementImage(k:IBitmapWrapperWindow, _arg_2:BitmapData)
        {
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
            var _local_3= Std.int((k.width - _arg_2.width) / 2);
            var _local_4= Std.int((k.height - _arg_2.height) / 2);
            if (k.bitmap == null)
            {
                k.bitmap = new BitmapData(k.width, k.height, true, 0xFFFFFF);
            }
            k.bitmap.fillRect(k.bitmap.rect, 0xFFFFFF);
            k.bitmap.copyPixels(_arg_2, _arg_2.rect, new Point(_local_3, _local_4), null, null, false);
            k.invalidate();
        }

        function _Str_6504(k:String)
        {
            if ((((!ASCompat.stringAsBool(k)) || (!(this._roomEvents != null))) || (!(this._roomEvents.assets != null))))
            {
                return;
            }
            var _local_2= Std.downcast(this._roomEvents.assets.getAssetByName(k) , BitmapDataAsset);
            if (_local_2 == null)
            {
                this.retrievePreviewAsset(k);
                return;
            }
            var _local_3= Std.downcast(this.find(this._window, "help_image") , IBitmapWrapperWindow);
            if (_local_3 != null)
            {
                this.setElementImage(_local_3, ASCompat.dynamicAs(_local_2.content , BitmapData));
            }
        }

        function retrievePreviewAsset(k:String)
        {
            if ((((!ASCompat.stringAsBool(k)) || (!(this._roomEvents != null))) || (!(this._roomEvents.assets != null))))
            {
                return;
            }
            var _local_2= this._roomEvents.getProperty("image.library.catalogue.url");
            var _local_3:ASAny = ((_local_2 + k) + ".gif");
            Logger.log([("[ProductViewCatalogWidget] Retrieve Product Preview Asset: " + _local_3)]);
            var _local_4= new URLRequest(_local_3);
            var _local_5= this._roomEvents.assets.loadAssetFromFile(k, _local_4, "image/gif");
            if (_local_5 == null)
            {
                return;
            }
            _local_5.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this._Str_6676);
        }

        function _Str_6676(k:AssetLoaderEvent)
        {
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            if (_local_2 != null)
            {
                this._Str_6504(_local_2.assetName);
            }
        }
    }




