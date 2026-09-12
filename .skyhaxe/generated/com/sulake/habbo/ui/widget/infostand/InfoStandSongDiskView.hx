package com.sulake.habbo.ui.widget.infostand
;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.ui.widget.events.RoomWidgetFurniInfostandUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetSongUpdateEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnumItemExtradataParameter;

     class InfoStandSongDiskView extends InfoStandFurniView 
    {
        var _songId:Int = -1;

        public function new(k:InfoStandWidget, _arg_2:String, _arg_3:IHabboCatalog)
        {
            super(k, _arg_2, _arg_3);
        }

        override public function dispose()
        {
            super.dispose();
        }

        override public function update(k:RoomWidgetFurniInfostandUpdateEvent)
        {
            super.update(k);
            this._songId = this._Str_24806(k.extraParam);
        }

        public function _Str_17571(k:RoomWidgetSongUpdateEvent)
        {
            if (((k.type == RoomWidgetSongUpdateEvent.DATA_RECEIVED) && (k.songId == this._songId)))
            {
                this._Str_8410 = k.songName;
                this._Str_6415 = k._Str_20860;
            }
        }

        override function createWindow(k:String)
        {
            var _local_4:IWindow = null;
            var _local_5:BitmapDataAsset = null;
            var _local_6:BitmapData = null;
            var _local_10 = 0;
            var _local_2= Std.downcast(_widget.assets.getAssetByName("songdisk_view") , XmlAsset);
            _window = Std.downcast(_widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IItemListWindow);
            if (window == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            _border = Std.downcast(window.getListItemByName("info_border") , IBorderWindow);
            _buttons = Std.downcast(window.getListItemByName("button_list") , IItemListWindow);
            if (_border != null)
            {
                _infoElements = Std.downcast(_border.findChildByName("infostand_element_list") , IItemListWindow);
            }
            window.name = k;
            _widget.mainContainer.addChild(window);
            var _local_3= _border.findChildByTag("close");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, onCloseHandler);
            }
            if (_buttons != null)
            {
                _local_10 = 0;
                while (_local_10 < _buttons.numListItems)
                {
                    _local_4 = _buttons.getListItemAt(_local_10);
                    _local_4.addEventListener(WindowMouseEvent.CLICK, onButtonClicked);
                    _local_10++;
                }
            }
            _Str_3793 = _border.findChildByTag("catalog");
            if (_Str_3793 != null)
            {
                _Str_3793.addEventListener(WindowMouseEvent.CLICK, _Str_12960);
            }
            _Str_3823 = _border.findChildByName("rent_button");
            if (_Str_3823 != null)
            {
                _Str_3823.addEventListener(WindowMouseEvent.CLICK, _Str_12518);
            }
            _Str_3747 = _border.findChildByName("extend_button");
            if (_Str_3747 != null)
            {
                _Str_3747.addEventListener(WindowMouseEvent.CLICK, _Str_15302);
            }
            _Str_3810 = _border.findChildByName("buyout_button");
            if (_Str_3810 != null)
            {
                _Str_3810.addEventListener(WindowMouseEvent.CLICK, _Str_15887);
            }
            var _local_7= Std.downcast(_border.findChildByName("icon_disc") , IBitmapWrapperWindow);
            if (_local_7 != null)
            {
                _local_5 = Std.downcast(_widget.assets.getAssetByName("jb_icon_disc") , BitmapDataAsset);
                _local_6 = ASCompat.dynamicAs(_local_5.content , BitmapData);
                _local_7.bitmap = _local_6.clone();
            }
            var _local_8= Std.downcast(_border.findChildByName("icon_composer") , IBitmapWrapperWindow);
            if (_local_8 != null)
            {
                _local_5 = Std.downcast(_widget.assets.getAssetByName("jb_icon_composer") , BitmapDataAsset);
                _local_6 = ASCompat.dynamicAs(_local_5.content , BitmapData);
                _local_8.bitmap = _local_6.clone();
            }
            var _local_9= Std.downcast(_infoElements.getListItemByName("owner_region") , IRegionWindow);
            if (_local_9 != null)
            {
                _local_9.addEventListener(WindowMouseEvent.CLICK, _Str_4711);
                _local_9.addEventListener(WindowMouseEvent.OVER, _Str_4711);
                _local_9.addEventListener(WindowMouseEvent.OUT, _Str_4711);
            }
        }

        var _Str_8410(never,set):String;
function  set__Str_8410(k:String):String        {
            var _local_2= Std.downcast(_infoElements.getListItemByName("trackname_container") , IWindowContainer);
            if (_local_2 == null)
            {
                return k;
            }
            var _local_3= Std.downcast(_local_2.getChildByName("track_name_text") , ITextWindow);
            if (_local_3 == null)
            {
                return k;
            }
            _local_3.text = k;
            _local_3.visible = true;
            _local_3.height = Std.int(_local_3.textHeight + 5);
            updateWindow();
return k;
        }

        var _Str_6415(never,set):String;
function  set__Str_6415(k:String):String        {
            var _local_2= Std.downcast(_infoElements.getListItemByName("creatorname_container") , IWindowContainer);
            if (_local_2 == null)
            {
                return k;
            }
            var _local_3= Std.downcast(_local_2.getChildByName("track_creator_text") , ITextWindow);
            if (_local_3 == null)
            {
                return k;
            }
            _local_3.text = k;
            _local_3.visible = true;
            _local_3.height = Std.int(_local_3.textHeight + 5);
            updateWindow();
return k;
        }

        function _Str_24806(k:String):Int
        {
            var _local_2:String = null;
            if (k != null)
            {
                _local_2 = k.substr(RoomWidgetEnumItemExtradataParameter.SONGDISK.length, k.length);
                return ASCompat.parseInt(_local_2);
            }
            return -1;
        }
    }

