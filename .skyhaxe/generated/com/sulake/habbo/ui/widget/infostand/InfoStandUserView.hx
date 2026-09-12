package com.sulake.habbo.ui.widget.infostand
;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUserInfoUpdateEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetGetBadgeDetailsMessage;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.room.preview.RoomPreviewer;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import flash.display.DisplayObject;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRoomTagSearchMessage;
    import com.sulake.habbo.communication.messages.incoming.users.RelationshipStatusInfo;
    import com.sulake.habbo.friendlist.RelationshipStatusEnum;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetChangeMottoMessage;
    import com.sulake.core.window.components.ITextFieldWindow;
    import flash.ui.Keyboard;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUserActionMessage;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetOpenProfileMessage;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.ITextLinkWindow;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;

     class InfoStandUserView 
    {
        static inline final _Str_6292:UInt = 0xFFFFFF;
        static inline final _Str_6801:UInt = 9552639;

        static inline final _Str_4882= 5;
        static inline final _Str_14702= 3;
        static inline final _Str_17178= 0xAAAAAA;
        static inline final _Str_18971= 0xFFFFFF;
        static inline final _Str_25347= 2000;
        static inline final _Str_14746= 50;
        static inline final _Str_13324= 23;
        static inline final _Str_26389= 100;

        var _widget:InfoStandWidget;
        var _window:IItemListWindow;
        var _infoElements:IItemListWindow;
        var _Str_20844:IItemListWindow;
        var _border:IBorderWindow;
        var _tagRenderer:TagListRenderer;
        var _Str_2919:IBorderWindow;
        var _Str_19966:Int = 0;
        var _Str_4966:IRegionWindow;

        static inline final PREVIEW_OFFSET_X= 0;
        static inline final PREVIEW_CANVAS_HEIGHT= 170;
        static inline final PREVIEW_CANVAS_OFFSET_Y= 8;
        static inline final PREVIEW_VIEW_OFFSET_Y= 0;
        // Fixed preview-room ordinal (not an incrementing counter): each infostand open
        // re-inits the same shared-engine preview room instead of leaking a fresh one.
        // 1000 keeps it clear of the catalog (id 1) and the figure editor (ids from 2).
        static inline final PREVIEW_ROOM_ORDINAL= 1000;
        var _roomPreviewer:RoomPreviewer;
        var _previewCanvas:IDisplayObjectWrapper;
        var _previewFigure:String;

        public function new(k:InfoStandWidget, _arg_2:String)
        {
            this._widget = k;
            this.createWindow(_arg_2);
            this._tagRenderer = new TagListRenderer(k, this._Str_25162);
        }

        public function dispose()
        {
            this.disposePreviewer();
            if (this._Str_4966 != null)
            {
                this._Str_4966.dispose();
                this._Str_4966 = null;
            }
            this._widget = null;
            this._window.dispose();
            this._window = null;
            this._tagRenderer.dispose();
            this._tagRenderer = null;
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
            var _local_4:IWindow = null;
            var _local_7:BitmapDataAsset = null;
            var _local_8:BitmapData = null;
            this._window = Std.downcast(this._widget.getXmlWindow("user_view") , IItemListWindow);
            if (this._window == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            this._border = Std.downcast(this._window.getListItemByName("info_border") , IBorderWindow);
            if (this._border != null)
            {
                this._infoElements = Std.downcast(this._border.findChildByName("infostand_element_list") , IItemListWindow);
                this._Str_20844 = Std.downcast(this._border.findChildByName("relationship_status_container") , IItemListWindow);
                this._Str_20844.visible = this._widget.config.getBoolean("relationship.status.enabled");
                this._border.findChildByName("heart_randomusername").procedure = this._Str_18506;
                this._border.findChildByName("smile_randomusername").procedure = this._Str_18506;
                this._border.findChildByName("bobba_randomusername").procedure = this._Str_18506;
            }
            this._window.name = k;
            var _local_2= Std.downcast(this._border.findChildByName("home_icon") , IBitmapWrapperWindow);
            if (_local_2 != null)
            {
                _local_2.bitmap = new BitmapData(_local_2.width, _local_2.height, true, 0);
                _local_7 = Std.downcast(this._widget.assets.getAssetByName("icon_home") , BitmapDataAsset);
                _local_8 = ASCompat.dynamicAs(_local_7.content , BitmapData);
                _local_2.bitmap = new BitmapData(_local_2.width, _local_2.height, true, 0);
                _local_2.bitmap.copyPixels(_local_8, _local_8.rect, new Point(0, 0));
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
            }
            this._widget.mainContainer.addChild(this._window);
            var _local_3= this._border.findChildByTag("close");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            }
            var _local_5 = 0;
            while (_local_5 < 5)
            {
                _local_4 = this._border.findChildByName(("badge_" + Std.string(_local_5)));
                if (_local_4 == null)
                {
                }
                else
                {
                    _local_4.addEventListener(WindowMouseEvent.OVER, this._Str_18818);
                    _local_4.addEventListener(WindowMouseEvent.OUT, this._Str_16035);
                }
                _local_5++;
            }
            _local_4 = this._border.findChildByName("badge_group");
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_23155);
                _local_4.addEventListener(WindowMouseEvent.OVER, this.showGroupBadgeInfo);
                _local_4.addEventListener(WindowMouseEvent.OUT, this._Str_23279);
            }
            var _local_6= this._border.findChildByName("avatar_image_profile_link");
            if (_local_6 != null)
            {
                _local_6.procedure = this._Str_21251;
            }
            if (this._widget.handler.isActivityDisplayEnabled)
            {
                this._border.findChildByName("score_spacer").visible = true;
                this._border.findChildByName("score_value").visible = true;
                this._border.findChildByName("score_text").visible = true;
            }
        }

        function _Str_23155(k:WindowMouseEvent)
        {
            if (this._widget.userData.groupId < 0)
            {
                return;
            }
            var _local_2:ASAny = (this._widget.userData.type == RoomWidgetUserInfoUpdateEvent.OWN_USER);
            var _local_3= new RoomWidgetGetBadgeDetailsMessage(_local_2, this._widget.userData.groupId);
            this._widget.messageListener.processWidgetMessage(_local_3);
        }

        function showGroupBadgeInfo(k:WindowMouseEvent)
        {
            if (this._widget.userData.groupId < 0)
            {
                return;
            }
            this._Str_13311();
            if (k.window == null)
            {
                return;
            }
            this._Str_2919.findChildByName("name").caption = this._widget.userData.groupName;
            this._Str_2919.findChildByName("description").caption = "${group.badgepopup.body}";
            var _local_2= new Rectangle();
            k.window.getGlobalRectangle(_local_2);
            this._Str_2919.x = Std.int(_local_2.left - this._Str_2919.width);
            this._Str_2919.y = Std.int(_local_2.top + ((_local_2.height - this._Str_2919.height) / 2));
        }

        function _Str_23279(k:WindowMouseEvent)
        {
            this._Str_9682();
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
            _local_5 = Std.downcast(this._Str_2919.getChildByName("name") , ITextWindow);
            if (_local_5 != null)
            {
                _local_5.text = this._widget.localizations.getBadgeName(_local_4);
            }
            _local_5 = Std.downcast(this._Str_2919.getChildByName("description") , ITextWindow);
            if (_local_5 != null)
            {
                _local_5.text = this._widget.localizations.getBadgeDesc(_local_4);
            }
            var _local_6= new Rectangle();
            k.window.getGlobalRectangle(_local_6);
            this._Str_2919.x = Std.int(_local_6.left - this._Str_2919.width);
            this._Str_2919.y = Std.int(_local_6.top + ((_local_6.height - this._Str_2919.height) / 2));
        }

        function _Str_16035(k:WindowMouseEvent)
        {
            this._Str_9682();
        }

        function _Str_13311()
        {
            if (this._Str_2919 != null)
            {
                return;
            }
            var k= Std.downcast(this._widget.assets.getAssetByName("badge_details") , XmlAsset);
            if (k == null)
            {
                return;
            }
            this._Str_2919 = Std.downcast(this._widget.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IBorderWindow);
            if (this._Str_2919 == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
        }

        function _Str_9682()
        {
            if (this._Str_2919 != null)
            {
                this._Str_2919.dispose();
                this._Str_2919 = null;
            }
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this._widget.close();
        }

        public var name(never,set):String;
public function  set_name(k:String):String        {
            if (this._Str_4966 == null)
            {
                this._Str_4966 = Std.downcast(this._infoElements.getListItemByName("profile_link") , IRegionWindow);
                if (this._Str_4966 == null)
                {
                    return k;
                }
                this._Str_4966.procedure = this._Str_21251;
                this._Str_4966.visible = true;
            }
            var _local_2= Std.downcast(this._Str_4966.findChildByName("name_text") , ITextWindow);
            if (_local_2 == null)
            {
                return k;
            }
            _local_2.text = k;
            _local_2.visible = true;
return k;
        }

        public var realName(never,set):String;
public function  set_realName(k:String):String        {
            var _local_2= Std.downcast(this._infoElements.getListItemByName("realname_text") , ITextWindow);
            if (_local_2 == null)
            {
                return k;
            }
            if (k.length == 0)
            {
                _local_2.text = "";
            }
            else
            {
                this._widget.localizations.registerParameter("infostand.text.realname", "realname", k);
                _local_2.text = this._widget.localizations.getLocalization("infostand.text.realname");
            }
            _local_2.height = Std.int(_local_2.textHeight + InfoStandUserView._Str_4882);
            _local_2.visible = (k.length > 0);
return k;
        }

        public function _Str_7907(k:String)
        {
            var _local_3:IWindow = null;
            var _local_4:IAvatarImageWidget = null;
            var _local_2= this._border.findChildByName("avatar_image");
            // Try the live, engine-animated avatar (clothing/hat/blink/idle); fall back to the static image.
            if (this.showAnimatedAvatar(k))
            {
                if (_local_2 != null)
                {
                    _local_2.visible = false;
                }
                return;
            }
            this.disposePreviewer();
            if (_local_2 != null)
            {
                _local_2.visible = true;
                _local_4 = Std.downcast(cast(_local_2, IWidgetWindow).widget , IAvatarImageWidget);
                if (_local_4 != null)
                {
                    _local_4.figure = k;
                }
            }
        }

        // Lazily spins up a RoomPreviewer (room hidden) only while an avatar infostand is shown, then
        // disposes it on close. Never created during room init, so it can't collide with the live room.
        function showAnimatedAvatar(k:String):Bool
        {
            var engine:IRoomEngine = null;
            var canvas:DisplayObject = null;
            var w = 0;
            var h = 0;
            if (((this._widget == null) || (this._border == null)))
            {
                return false;
            }
            if (this._previewCanvas == null)
            {
                this._previewCanvas = Std.downcast(this._border.findChildByName("avatar_preview") , IDisplayObjectWrapper);
            }
            if (this._previewCanvas == null)
            {
                return false;
            }
            if (this._roomPreviewer == null)
            {
                engine = this._widget.handler.container.roomEngine;
                if (engine == null)
                {
                    return false;
                }
                this._roomPreviewer = new RoomPreviewer(engine, PREVIEW_ROOM_ORDINAL);
                if (!this._roomPreviewer.isRoomEngineReady)
                {
                    this.disposePreviewer();
                    return false;
                }
                w = this._previewCanvas.width;
                h = PREVIEW_CANVAS_HEIGHT;
                canvas = this._roomPreviewer.getRoomCanvas(w, h);
                if (canvas == null)
                {
                    this.disposePreviewer();
                    return false;
                }
                this._previewCanvas.setDisplayObject(canvas);
                this._roomPreviewer.modifyRoomCanvas(w, h);
                canvas.x = PREVIEW_OFFSET_X;
                canvas.y = PREVIEW_CANVAS_OFFSET_Y;
                this._previewCanvas.visible = true;
                this._roomPreviewer.updateRoomWallsAndFloorVisibility(false, false);
            }
            if (!this._roomPreviewer.isRoomEngineReady)
            {
                return false;
            }
            this._roomPreviewer.addViewOffset = new Point(PREVIEW_OFFSET_X, PREVIEW_VIEW_OFFSET_Y);
            this._roomPreviewer.addAvatarIntoRoom(k, 0);
            this._roomPreviewer.updateAvatarDirection(4, 4);
            this._roomPreviewer.updatePreviewRoomView(true);
            this._roomPreviewer.updateRoomEngine();
            this._previewCanvas.visible = true;
            this._previewFigure = k;
            return true;
        }

        public function hidePreview()
        {
            this.disposePreviewer();
        }

        function disposePreviewer()
        {
            if (this._previewCanvas != null)
            {
                this._previewCanvas.visible = false;
            }
            if (this._roomPreviewer != null)
            {
                this._roomPreviewer.dispose();
                this._roomPreviewer = null;
            }
            this._previewFigure = null;
        }

        public function _Str_12782(k:String, _arg_2:Bool)
        {
            var _local_3= Std.downcast(this._infoElements.getListItemByName("motto_container") , IWindowContainer);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= _local_3.findChildByName("changemotto.image");
            var _local_5= Std.downcast(_local_3.findChildByName("motto_text") , ITextWindow);
            var _local_6= Std.downcast(this._infoElements.getListItemByName("motto_spacer") , IWindowContainer);
            if (((_local_5 == null) || (_local_6 == null)))
            {
                return;
            }
            if (k == null)
            {
                k = "";
            }
            if (_arg_2)
            {
                _local_4.visible = true;
                if (k == "")
                {
                    k = this._widget.localizations.getLocalization("infostand.motto.change");
                    _local_5.textColor = InfoStandUserView._Str_17178;
                }
                else
                {
                    _local_5.textColor = InfoStandUserView._Str_18971;
                }
                _local_5.enable();
            }
            else
            {
                _local_4.visible = false;
                _local_5.textColor = InfoStandUserView._Str_18971;
                _local_5.disable();
            }
            if (!this._widget.config.getBoolean("infostand.motto.change.enabled"))
            {
                _local_5.disable();
            }
            _local_5.text = k;
            _local_5.height = Std.int(Math.min((_local_5.textHeight + InfoStandUserView._Str_4882), InfoStandUserView._Str_14746));
            _local_5.height = Std.int(Math.max(_local_5.height, InfoStandUserView._Str_13324));
            _local_3.height = (_local_5.height + InfoStandUserView._Str_14702);
            if (_arg_2)
            {
                _local_5.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this._Str_23735);
                _local_5.addEventListener(WindowMouseEvent.CLICK, this._Str_20920);
            }
            else
            {
                _local_5.removeEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this._Str_20920);
            }
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
            _local_2.height = Std.int(_local_2.textHeight + InfoStandUserView._Str_4882);
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

        public var xp(never,set):Int;
public function  set_xp(k:Int):Int        {
            var _local_2= Std.downcast(this._infoElements.getListItemByName("xp_text") , ITextWindow);
            var _local_3= Std.downcast(this._infoElements.getListItemByName("xp_spacer") , IWindowContainer);
            if (((_local_2 == null) || (_local_3 == null)))
            {
                return k;
            }
            this._widget.localizations.registerParameter("infostand.text.xp", "xp", Std.string(k));
            _local_2.height = Std.int(_local_2.textHeight + InfoStandUserView._Str_4882);
            var _local_4= _local_2.visible;
            var _local_5:ASAny = (k > 0);
            _local_2.visible = _local_5;
            _local_3.visible = _local_5;
            if (_local_5 != _local_4)
            {
                this._infoElements.arrangeListItems();
            }
            this.updateWindow();
return k;
        }

        public function _Str_17290(k:Array<ASAny>, _arg_2:Array<ASAny>=null)
        {
            var _local_3= Std.downcast(this._infoElements.getListItemByName("tags_container") , IWindowContainer);
            var _local_4= Std.downcast(this._infoElements.getListItemByName("tags_spacer") , IWindowContainer);
            if (((_local_3 == null) || (_local_4 == null)))
            {
                return;
            }
            if (k.length != 0)
            {
                _local_3.height = this._tagRenderer._Str_23731(k, _local_3, _arg_2);
                _local_4.height = 1;
            }
            else
            {
                _local_3.height = 0;
                _local_4.height = 0;
            }
            this.updateWindow();
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

        public function _Str_21116()
        {
            var k= Std.downcast(cast(this._border.findChildByName("badge_group"), IWidgetWindow).widget , IBadgeImageWidget);
            k.badgeId = "";
        }

        public function _Str_16673(k:String)
        {
            var _local_2= Std.downcast(cast(this._border.findChildByName("badge_group"), IWidgetWindow).widget , IBadgeImageWidget);
            _local_2.badgeId = k;
        }

        function _Str_25162(k:WindowMouseEvent)
        {
            var _local_2= Std.downcast(k.target , ITextWindow);
            if (_local_2 == null)
            {
                return;
            }
            this._widget.messageListener.processWidgetMessage(new RoomWidgetRoomTagSearchMessage(_local_2.text));
        }

        public function update(k:RoomWidgetUserInfoUpdateEvent)
        {
            this._Str_10630();
            this._Str_21116();
            this._Str_16673(k.groupBadgeId);
            this._Str_17290([]);
            this._Str_11602(k);
        }

        public function _Str_25662(k:Map)
        {
            var _local_2 = 0;
            var _local_3:String = null;
            var _local_4:IWindow = null;
            var _local_5:RelationshipStatusInfo = null;
            var _local_6:String = null;
            var _local_7:IWindow = null;
            if (((!(this._border != null)) || (!(this._widget != null))))
            {
                return;
            }
            final _iter_ = RelationshipStatusEnum._Str_15184; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = ASCompat.toInt(_tmp_);
                _local_3 = RelationshipStatusEnum._Str_7401(_local_2);
                _local_4 = this._border.findChildByName(("relationship_" + _local_3));
                _local_5 = k.getValue(_local_2);
                if (_local_5 != null)
                {
                    _local_4.visible = (_local_5.friendCount > 0);
                    _local_6 = (_local_3 + "_randomusername");
                    _local_7 = this._border.findChildByName(_local_6);
                    if (_local_7 != null)
                    {
                        _local_7.caption = _local_5._Str_20359;
                        _local_7.id = _local_5._Str_21077;
                    }
                    this._border.findChildByName((_local_3 + "_others")).visible = (_local_5.friendCount > 1);
                    this._widget.localizations.registerParameter((("infostand.relstatus." + _local_3) + ".others"), "amount", Std.string((_local_5.friendCount - 1)));
                }
                else
                {
                    _local_4.visible = false;
                }
            }
        }

        function _Str_11602(k:RoomWidgetUserInfoUpdateEvent)
        {
            this.name = k.name;
            this._Str_12782(k.motto, (k.type == RoomWidgetUserInfoUpdateEvent.OWN_USER));
            this.activityPoints = k.activityPoints;
            this.carryItem = k.carryItem;
            this.xp = k.xp;
            this._Str_7907(k.figure);
        }

        function _Str_23735(k:WindowKeyboardEvent)
        {
            var _local_5:RoomWidgetChangeMottoMessage = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_2= Std.downcast(this._infoElements.getListItemByName("motto_container") , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(_local_2.findChildByName("motto_text") , ITextFieldWindow);
            var _local_4= _local_3.text;
            if (k.keyCode == Keyboard.ENTER)
            {
                _local_6 = flash.Lib.getTimer();
                if ((((_local_6 - this._Str_19966) > InfoStandUserView._Str_25347) && (!(_local_4 == this._widget.localizations.getLocalization("infostand.motto.change")))))
                {
                    _local_7 = this._widget.userData.userId;
                    _local_5 = new RoomWidgetChangeMottoMessage(_local_4);
                    this._widget.messageListener.processWidgetMessage(_local_5);
                    this._Str_19966 = _local_6;
                    _local_3.textColor = InfoStandUserView._Str_18971;
                    _local_3.unfocus();
                }
            }
            else
            {
                _local_3.textColor = InfoStandUserView._Str_17178;
            }
            _local_3.height = Std.int(Math.min((_local_3.textHeight + InfoStandUserView._Str_4882), InfoStandUserView._Str_14746));
            _local_3.height = Std.int(Math.max(_local_3.height, InfoStandUserView._Str_13324));
            _local_2.height = (_local_3.height + InfoStandUserView._Str_14702);
        }

        function _Str_20920(k:WindowMouseEvent)
        {
            var _local_2= Std.downcast(this._infoElements.getListItemByName("motto_container") , IWindowContainer);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(_local_2.findChildByName("motto_text") , ITextWindow);
            if (_local_3.text == this._widget.localizations.getLocalization("infostand.motto.change"))
            {
                _local_3.text = "";
            }
            _local_3.textColor = InfoStandUserView._Str_17178;
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            var _local_2:RoomWidgetMessage = null;
            var _local_3:String = null;
            var _local_4= k.target ;
            switch (_local_4.name)
            {
                case "home_icon":
                    _local_3 = RoomWidgetUserActionMessage.RWUAM_OPEN_HOME_PAGE;
                    
            }
            if (_local_3 != null)
            {
                _local_2 = new RoomWidgetUserActionMessage(_local_3, this._widget.userData.userId);
                HabboTracking.getInstance().trackEventLog("InfoStand", "click", _local_3);
            }
            if (_local_2 != null)
            {
                this._widget.messageListener.processWidgetMessage(_local_2);
            }
            this.updateWindow();
        }

        function _Str_21251(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:ITextWindow = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._widget.messageListener.processWidgetMessage(new RoomWidgetOpenProfileMessage(RoomWidgetOpenProfileMessage.RWOPEM_OPEN_USER_PROFILE, this._widget.userData.userId, "infoStand_userView"));
            }
            if (_arg_2.name == "profile_link")
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    _local_3 = Std.downcast(this._Str_4966.findChildByName("name_text") , ITextWindow);
                    _local_3.textColor = _Str_6801;
                }
                if (k.type == WindowMouseEvent.OUT)
                {
                    _local_3 = Std.downcast(this._Str_4966.findChildByName("name_text") , ITextWindow);
                    _local_3.textColor = _Str_6292;
                }
            }
        }

        function _Str_18506(k:WindowEvent, _arg_2:IWindow)
        {
            if (((k.type == WindowMouseEvent.CLICK) && Std.is(_arg_2 , ITextLinkWindow)))
            {
                this._widget.handler.container.connection.send(new GetExtendedProfileMessageComposer(_arg_2.id));
            }
        }
    }

