package com.sulake.habbo.ui.widget.infostand
;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ITextWindow;
    import flash.geom.Rectangle;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUserInfoUpdateEvent;

     class InfoStandBotView 
    {
        static inline final _Str_4882= 5;
        static inline final _Str_14702= 3;
        static inline final _Str_14746= 50;
        static inline final _Str_13324= 23;

        var _widget:InfoStandWidget;
        var _window:IItemListWindow;
        var _infoElements:IItemListWindow;
        var _border:IBorderWindow;
        var _badgeDetails:IBorderWindow;

        public function new(k:InfoStandWidget, _arg_2:String)
        {
            this._widget = k;
            this.createWindow(_arg_2);
        }

        public function dispose()
        {
            this._widget = null;
            this._window.dispose();
            this._window = null;
            this._Str_9682();
        }

        public var window(get,never):IItemListWindow;
public function  get_window():IItemListWindow
        {
            return this._window;
        }

        function updateWindow()
        {
            if (((this._infoElements == null) || (this._border == null)))
            {
                return;
            }
            this._infoElements.height = Std.int(this._infoElements.scrollableRegion.height);
            this._border.height = (this._infoElements.height + 20);
            this._window.width = this._border.width;
            this._window.height = Std.int(this._window.scrollableRegion.height);
            this._widget._Str_10301();
        }

        function createWindow(k:String)
        {
            var _local_3:IWindow = null;
            this._window = Std.downcast(this._widget.getXmlWindow("bot_view") , IItemListWindow);
            if (this._window == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            this._border = Std.downcast(this._window.getListItemByName("info_border") , IBorderWindow);
            this._infoElements = Std.downcast(this._border.findChildByName("infostand_element_list") , IItemListWindow);
            if (this._border != null)
            {
                this._infoElements = Std.downcast(this._border.findChildByName("infostand_element_list") , IItemListWindow);
            }
            this._window.name = k;
            this._widget.mainContainer.addChild(this._window);
            var _local_2= this._border.findChildByTag("close");
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            }
            var _local_4 = 0;
            while (_local_4 < 5)
            {
                _local_3 = this._border.findChildByName(("badge_" + Std.string(_local_4)));
                if (_local_3 == null)
                {
                }
                else
                {
                    _local_3.addEventListener(WindowMouseEvent.OVER, this._Str_18818);
                    _local_3.addEventListener(WindowMouseEvent.OUT, this._Str_16035);
                }
                _local_4++;
            }
        }

        function _Str_18818(k:WindowMouseEvent)
        {
            var _local_5:ITextWindow = null;
            if (k.window == null)
            {
                return;
            }
            var _local_2= ASCompat.toInt(ASCompat.stringReplace(k.window.name, "badge_", ""));
            if (_local_2 < 0)
            {
                return;
            }
            var _local_3= this._widget.userData.badges;
            if (_local_3 == null)
            {
                return;
            }
            if (_local_2 >= _local_3.length)
            {
                return;
            }
            var _local_4:String = this._widget.userData.badges[_local_2];
            if (_local_4 == null)
            {
                return;
            }
            this._Str_13311();
            _local_5 = Std.downcast(this._badgeDetails.getChildByName("name") , ITextWindow);
            if (_local_5 != null)
            {
                _local_5.text = this._widget.localizations.getBadgeName(_local_4);
            }
            _local_5 = Std.downcast(this._badgeDetails.getChildByName("description") , ITextWindow);
            if (_local_5 != null)
            {
                _local_5.text = this._widget.localizations.getBadgeDesc(_local_4);
            }
            var _local_6= new Rectangle();
            k.window.getGlobalRectangle(_local_6);
            this._badgeDetails.x = Std.int(_local_6.left - this._badgeDetails.width);
            this._badgeDetails.y = Std.int(_local_6.top + ((_local_6.height - this._badgeDetails.height) / 2));
        }

        function _Str_16035(k:WindowMouseEvent)
        {
            this._Str_9682();
        }

        function _Str_13311()
        {
            if (this._badgeDetails != null)
            {
                return;
            }
            var k= Std.downcast(this._widget.assets.getAssetByName("badge_details") , XmlAsset);
            if (k == null)
            {
                return;
            }
            this._badgeDetails = Std.downcast(this._widget.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IBorderWindow);
            if (this._badgeDetails == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
        }

        function _Str_9682()
        {
            if (this._badgeDetails != null)
            {
                this._badgeDetails.dispose();
                this._badgeDetails = null;
            }
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this._widget.close();
        }

        public function _Str_7907(k:String)
        {
            var _local_2= Std.downcast(cast(this._border.findChildByName("avatar_image"), IWidgetWindow).widget , IAvatarImageWidget);
            _local_2.figure = k;
        }

        public var name(never,set):String;
public function  set_name(k:String):String        {
            var _local_2= Std.downcast(this._infoElements.getListItemByName("name_text") , ITextWindow);
            if (_local_2 == null)
            {
                return k;
            }
            _local_2.text = k;
            _local_2.visible = true;
return k;
        }

        public function _Str_12782(k:String)
        {
            var _local_2= Std.downcast(this._infoElements.getListItemByName("motto_container") , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(_local_2.findChildByName("motto_text") , ITextWindow);
            var _local_4= Std.downcast(this._infoElements.getListItemByName("motto_spacer") , IWindowContainer);
            if (((_local_3 == null) || (_local_4 == null)))
            {
                return;
            }
            if (k == null)
            {
                k = "";
            }
            _local_3.text = k;
            _local_3.height = Std.int(Math.min((_local_3.textHeight + InfoStandBotView._Str_4882), InfoStandBotView._Str_14746));
            _local_3.height = Std.int(Math.max(_local_3.height, InfoStandBotView._Str_13324));
            _local_2.height = (_local_3.height + InfoStandBotView._Str_14702);
            this.updateWindow();
        }

        public var activityPoints(never,set):Int;
public function  set_activityPoints(k:Int):Int        {
            if (!this._widget.handler.isActivityDisplayEnabled)
            {
                return k;
            }
            var _local_2= Std.downcast(this._infoElements.getListItemByName("score_value") , ITextWindow);
            if (_local_2 == null)
            {
                return k;
            }
            _local_2.text = new compat.RegExp("\\B(?=(\\d{3})+(?!\\d))", "g").replace(Std.string(k), " ");
return k;
        }

        public var carryItem(never,set):Int;
public function  set_carryItem(k:Int):Int        {
            var _local_6:String = null;
            var _local_2= Std.downcast(this._infoElements.getListItemByName("handitem_txt") , ITextWindow);
            var _local_3= Std.downcast(this._infoElements.getListItemByName("handitem_spacer") , IWindowContainer);
            if (((_local_2 == null) || (_local_3 == null)))
            {
                return k;
            }
            if (((k > 0) && (k < 999999)))
            {
                _local_6 = this._widget.localizations.getLocalization(("handitem" + Std.string(k)), ("handitem" + Std.string(k)));
                this._widget.localizations.registerParameter("infostand.text.handitem", "item", _local_6);
            }
            _local_2.height = Std.int(_local_2.textHeight + InfoStandBotView._Str_4882);
            var _local_4= _local_2.visible;
            var _local_5= ((k > 0) && (k < 999999));
            _local_2.visible = _local_5;
            _local_3.visible = _local_5;
            if (_local_5 != _local_4)
            {
                this._infoElements.arrangeListItems();
            }
            this.updateWindow();
return k;
        }

        public function _Str_5605(k:Int, _arg_2:String)
        {
            var _local_3= Std.downcast(cast(this._border.findChildByName(("badge_" + Std.string(k))), IWidgetWindow).widget , IBadgeImageWidget);
            _local_3.badgeId = _arg_2;
        }

        public function _Str_10630()
        {
            var _local_2:IBadgeImageWidget = null;
            var k = 0;
            while (k < 5)
            {
                _local_2 = Std.downcast(cast(this._border.findChildByName(("badge_" + Std.string(k))), IWidgetWindow).widget , IBadgeImageWidget);
                _local_2.badgeId = "";
                k++;
            }
        }

        public function update(k:RoomWidgetUserInfoUpdateEvent)
        {
            this._Str_10630();
            this._Str_11602(k);
        }

        function _Str_11602(k:RoomWidgetUserInfoUpdateEvent)
        {
            this.name = k.name;
            this._Str_12782(k.motto);
            this.activityPoints = k.activityPoints;
            this.carryItem = k.carryItem;
            this._Str_7907(k.figure);
            this._Str_25101(k.badges);
        }

        function _Str_25101(k:Array<ASAny>)
        {
            if (k == null)
            {
                return;
            }
            var _local_2 = 0;
            while (_local_2 < k.length)
            {
                this._Str_5605(_local_2, k[_local_2]);
                _local_2++;
            }
        }
    }

