package com.sulake.habbo.ui.widget.memenu
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.perk.PerkAllowancesEvent;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window._enum._Str_12232;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.habbo.ui.widget.enums.AvatarExpressionEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetDanceMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetAvatarExpressionMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRequestWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetShowOwnRoomsMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetOpenInventoryMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetAvatarEditorMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetOpenCatalogMessage;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habboclient.ExternalVariables;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetOpenProfileMessage;
    import com.sulake.habbo.communication.messages.outgoing.talent.GetTalentTrackMessageComposer;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.core.window.events.WindowEvent;

     class MeMenuMainView implements IMeMenuView 
    {
        public static inline final MINIMAIL= "minimail";

        var _widget:MeMenuWidget;
        var _window:IWindowContainer;
        var _icons:ASDictionary<ASAny,ASAny>;
        var _perkAllowancesMessageEvent:PerkAllowancesEvent;
        var _config:IHabboConfigurationManager;

        public function new(k:IHabboConfigurationManager)
        {
            this._config = k;
        }

        public function init(k:MeMenuWidget, _arg_2:String)
        {
            this._icons = new ASDictionary<ASAny,ASAny>();
            this._icons["rooms_icon"] = (["gohome_white", "gohome_color"] : Array<Dynamic>);
            this._icons["dance_icon"] = (["dance_white", "dance_color"] : Array<Dynamic>);
            this._icons["clothes_icon"] = (["clothes_white", "clothes_color"] : Array<Dynamic>);
            this._icons["effects_icon"] = (["effects_white", "effects_color"] : Array<Dynamic>);
            this._icons["badges_icon"] = (["badges_white", "badges_color"] : Array<Dynamic>);
            this._icons["wave_icon"] = (["wave_white", "wave_color"] : Array<Dynamic>);
            this._icons["hc_icon"] = (["_white", "_color"] : Array<Dynamic>);
            this._icons["settings_icon"] = (["settings_white", "settings_color"] : Array<Dynamic>);
            this._icons["credits_icon"] = (["credits_white", "credits_color"] : Array<Dynamic>);
            this._icons["minimail_icon"] = (["minimail_white", "minimail_color"] : Array<Dynamic>);
            this._icons["profile_icon"] = (["profile_white", "profile_color"] : Array<Dynamic>);
            this._icons["achievements_icon"] = (["achievements_white", "achievements_color"] : Array<Dynamic>);
            this._icons["talents_icon"] = (["compass_white", "compass_color"] : Array<Dynamic>);
            this._icons["guide_icon"] = (["lighthouse_white", "lighthouse_color"] : Array<Dynamic>);
            this._widget = k;
            this._perkAllowancesMessageEvent = new PerkAllowancesEvent(this.onPerkAllowances);
            this._widget.handler.container.connection.addMessageEvent(this._perkAllowancesMessageEvent);
            this.createWindow(_arg_2);
        }

        public function dispose()
        {
            if (this._perkAllowancesMessageEvent != null)
            {
                this._widget.handler.container.connection.removeMessageEvent(this._perkAllowancesMessageEvent);
                this._perkAllowancesMessageEvent = null;
            }
            this._widget = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public function _Str_25524(k:String, _arg_2:String, _arg_3:String=null, _arg_4:String=null)
        {
            if (this._icons[k] == null)
            {
                return;
            }
            if (_arg_3 != null)
            {
                this._icons[k][0] = _arg_3;
            }
            if (_arg_4 != null)
            {
                this._icons[k][1] = _arg_4;
            }
            this.setElementImage(k, _arg_3);
        }

        function createWindow(k:String)
        {
var _local_5:String  = null;            var _local_5:String = null;
            var _local_6:IWindow = null;
            var _local_7 = 0;
            var _local_8:Array<ASAny> = null;
            var _local_9:String = null;
            var _local_10 = Math.NaN;
            var _local_11:String = null;
            var _local_12 = 0;
            if (this._widget == null)
            {
                return;
            }
            var _local_2= "memenu_main";
            var _local_3 = false;
            if (this._widget.config.getBoolean("simple.memenu.enabled"))
            {
                _local_2 = (_local_2 + "_simple");
                _local_3 = true;
            }
            var _local_4= Std.downcast(this._widget.assets.getAssetByName(_local_2) , XmlAsset);
            this._window = Std.downcast(this._widget.windowManager.buildFromXML(((_local_4.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (this._window == null)
            {
                throw new ASError("Failed to construct me menu main window from XML!");
            }
            this._window.name = k;
            if (((!this._widget.config.getBoolean("talent.track.enabled")) && _local_3))
            {
                this._window.findChildByName("guide").rectangle = this._window.findChildByName("talents").rectangle;
                this._window.findChildByName("talents").visible = false;
            }
            if (this._widget.config.getBoolean("guides.enabled"))
            {
                this._Str_8899(this._widget.handler.container.sessionDataManager.isPerkAllowed(PerkEnum.USE_GUIDE_TOOL));
            }
            final _iter_ = this._icons; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_5 = _tmp_;
                _local_8 = this._icons[_local_5];
                if (!((_local_8 == null) || (_local_8.length == 0)))
                {
                    _local_9 = _local_8[0];
                    _local_10 = 1;
                    switch (_local_5)
                    {
                        case "dance_icon"
                           | "wave_icon":
                            if (this._widget.hasEffectOn)
                            {
                                _local_10 = 0.5;
                            }
                            
                        case "effects_icon":
                            if (this._widget.isDancing)
                            {
                                _local_10 = 0.5;
                            }
                            
                        case "hc_icon":
                            _local_9 = (this._Str_22145() + _local_9);
                            if (!this._widget._Str_22242)
                            {
                                this.setElementText("hc_text", this._widget.localizations.getLocalization("widget.memenu.hc.join"));
                            }
                            else
                            {
                                if (this._widget._Str_21502 == HabboClubLevelEnum.VIP)
                                {
                                    _local_11 = "widget.memenu.vip";
                                }
                                else
                                {
                                    _local_11 = "widget.memenu.hc";
                                }
                                if (this._widget._Str_21813 > 0)
                                {
                                    _local_11 = (_local_11 + ".long");
                                }
                                this._widget.localizations.registerParameter(_local_11, "days", Std.string(this._widget._Str_22596));
                                this._widget.localizations.registerParameter(_local_11, "months", Std.string(this._widget._Str_21813));
                                this.setElementText("hc_text", this._widget.localizations.getLocalization(_local_11));
                            }
                            
                        case "minimail_icon":
                            if (!this._widget._Str_16873)
                            {
                                _local_10 = 0.5;
                            }
                            else
                            {
                                _local_12 = this._widget._Str_21527;
                                if (((_local_12 == -1) || (_local_12 > 0)))
                                {
                                    this._Str_20243("minimail", _local_12);
                                }
                            }
                            
                    }
                    this.setElementImage(_local_5, _local_9, _local_10);
                }
            }
            _local_7 = 0;
            while (_local_7 < this._window.numChildren)
            {
                _local_6 = this._window.getChildAt(_local_7);
                _local_6.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                _local_6.addEventListener(WindowMouseEvent.OVER, this._Str_21994);
                _local_6.addEventListener(WindowMouseEvent.OUT, this._Str_21994);
                _local_7++;
            }
        }

        function _Str_20243(k:String, _arg_2:Int)
        {
            var _local_3= Std.downcast(this._window.findChildByName(k) , IWindowContainer);
            var _local_4= Std.downcast(_local_3.findChildByName("unseen_counter") , IWindowContainer);
            if (_arg_2 == 0)
            {
                if (_local_4 != null)
                {
                    _local_3.removeChild(_local_4);
                    _local_3.invalidate();
                }
                return;
            }
            if (_local_4 == null)
            {
                _local_4 = this._widget.windowManager.createUnseenItemCounter();
                _local_4.name = "unseen_counter";
                _local_3.addChild(_local_4);
            }
            Std.downcast(_local_4.findChildByName(_Str_12232.COUNT) , ITextWindow).text = ((_arg_2 > 0) ? Std.string(_arg_2) : " ");
            _local_4.x = ((_local_3.width - _local_4.width) - 5);
            _local_4.y = 5;
        }

        function _Str_22145():String
        {
            switch (this._widget._Str_21502)
            {
                case HabboClubLevelEnum.NO_CLUB
                   | HabboClubLevelEnum.CLUB:
                    return "club";
                case HabboClubLevelEnum.VIP:
                    return "vip";
            }
            return null;
        }

        function setElementImage(k:String, _arg_2:String, _arg_3:Float=1)
        {
            var _local_4= Std.downcast(this._window.findChildByName(k) , IBitmapWrapperWindow);
            var _local_5= Std.downcast(this._widget.assets.getAssetByName(_arg_2) , BitmapDataAsset);
            if (_local_4 == null)
            {
                Logger.log([("Could not find element: " + k)]);
                return;
            }
            if (((_local_5 == null) || (_local_5.content == null)))
            {
                Logger.log([("Could not find asset: " + _arg_2)]);
                return;
            }
            var _local_6= ASCompat.dynamicAs(_local_5.content , BitmapData);
            _local_4.bitmap = new BitmapData(_local_4.width, _local_4.height, true, 0);
            var _local_7= Std.int((_local_4.width - _local_6.width) / 2);
            var _local_8= Std.int((_local_4.height - _local_6.height) / 2);
            _local_4.bitmap.copyPixels(_local_6, _local_6.rect, new Point(_local_7, _local_8));
            _local_4.blend = _arg_3;
        }

        function setElementText(k:String, _arg_2:String)
        {
            var _local_3= Std.downcast(this._window.findChildByName(k) , ITextWindow);
            if (_local_3 != null)
            {
                _local_3.text = _arg_2;
            }
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            var _local_4:AvatarExpressionEnum = null;
            var _local_5:String = null;
            var _local_2= k.target ;
            var _local_3= _local_2.name;
            switch (_local_3)
            {
                case "dance":
                    if (this._widget.hasEffectOn)
                    {
                        return;
                    }
                    this._widget._Str_4568(MeMenuWidget.ME_MENU_DANCE_MOVES_VIEW);
                    
                case "wave"
                   | "blow":
                    if (this._widget.hasEffectOn)
                    {
                        return;
                    }
                    if (this._widget.isDancing)
                    {
                        this._widget.messageListener.processWidgetMessage(new RoomWidgetDanceMessage(RoomWidgetDanceMessage._Str_13814));
                        this._widget.isDancing = false;
                    }
                    _local_4 = AvatarExpressionEnum.WAVE;
                    if (_local_3 == "blow")
                    {
                        _local_4 = AvatarExpressionEnum.BLOW;
                    }
                    this._widget.messageListener.processWidgetMessage(new RoomWidgetAvatarExpressionMessage(_local_4));
                    this._widget.hide();
                    
                case "effects":
                    if (this._widget.isDancing)
                    {
                        return;
                    }
                    this._widget.messageListener.processWidgetMessage(new RoomWidgetRequestWidgetMessage(RoomWidgetRequestWidgetMessage.RWRWM_EFFECTS));
                    this._widget.hide();
                    
                case "rooms":
                    this._widget.messageListener.processWidgetMessage(new RoomWidgetShowOwnRoomsMessage());
                    this._widget.hide();
                    
                case "badges":
                    this._widget.messageListener.processWidgetMessage(new RoomWidgetOpenInventoryMessage(RoomWidgetOpenInventoryMessage.INVENTORY_BADGES));
                    this._widget.hide();
                    
                case "clothes":
                    this._widget.messageListener.processWidgetMessage(new RoomWidgetAvatarEditorMessage(RoomWidgetAvatarEditorMessage.RWCM_OPEN_AVATAR_EDITOR));
                    this._widget.hide();
                    
                case "hc":
                    this._widget.messageListener.processWidgetMessage(new RoomWidgetOpenCatalogMessage(RoomWidgetOpenCatalogMessage.RWOCM_CLUB_MAIN));
                    this._widget.hide();
                    
                case "settings":
                    this._widget._Str_4568(MeMenuWidget.ME_MENU_SETTINGS_VIEW);
                    
                case "minimail":
                    if (this._widget._Str_16873)
                    {
                        HabboWebTools.openMinimail("#mail/inbox/");
                        this._widget.hide();
                    }
                    
                case "credits":
                    HabboWebTools.openWebPageAndMinimizeClient(this._config.getProperty(ExternalVariables.WEB_SHOP_RELATIVE_URL));
                    this._widget.hide();
                    
                case "profile":
                    this._widget.messageListener.processWidgetMessage(new RoomWidgetOpenProfileMessage(RoomWidgetOpenProfileMessage.RWOPEM_OPEN_USER_PROFILE, this._widget.userId, "me_menu"));
                    this._widget.hide();
                    
                case "achievements":
                    this._widget.handler.container.questEngine.showAchievements();
                    this._widget.hide();
                    
                case "guide":
                    this._widget.handler.container.toolbar.toggleWindowVisibility("GUIDE");
                    this._widget.hide();
                    
                case "talents":
                    _local_5 = this._widget.handler.container.sessionDataManager.currentTalentTrack;
                    this._widget.handler.container.habboTracking.trackTalentTrackOpen(_local_5, "memenu");
                    this._widget.handler.container.connection.send(new GetTalentTrackMessageComposer(_local_5));
                    
                default:
                    Logger.log([("Me Menu Main View: unknown button: " + _local_3)]);
            }
            HabboTracking.getInstance().trackEventLog("MeMenu", "click", _local_3);
        }

        function _Str_26302(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
        }

        function _Str_21994(k:WindowMouseEvent)
        {
            var _local_5:Array<ASAny> = null;
            var _local_6:String = null;
            var _local_2= k.target ;
            var _local_3= _local_2.name;
            var _local_4:ASAny = (_local_3 + "_icon");
            var _local_7= "";
            var _local_8= ((k.type == WindowMouseEvent.OVER) ? 1 : 0);
            switch (_local_3)
            {
                case "dance":
                    if (this._widget.hasEffectOn)
                    {
                        return;
                    }
                    
                case "minimail":
                    if (!this._widget._Str_16873)
                    {
                        return;
                    }
                    
                case "wave":
                    if (this._widget.hasEffectOn)
                    {
                        return;
                    }
                    
                case "effects":
                    if (this._widget.isDancing)
                    {
                        return;
                    }
                    
                case "hc":
                    _local_7 = this._Str_22145();
                    
            }
            _local_4 = (_local_3 + "_icon");
            _local_5 = this._icons[_local_4];
            if (_local_5 != null)
            {
                _local_6 = (_local_7 + _local_5[_local_8]);
                this.setElementImage(_local_4, _local_6);
            }
        }

        function onPerkAllowances(k:PerkAllowancesEvent)
        {
            var _local_2= k.getParser();
            this._Str_8899(_local_2.isPerkAllowed(PerkEnum.USE_GUIDE_TOOL));
        }

        function _Str_8899(k:Bool)
        {
            var _local_2:IWindow = null;
            var _local_3:IWindow = null;
            if (((this._window != null) && (this._widget != null)))
            {
                _local_2 = this._window.findChildByName("guide");
                _local_3 = this._window.findChildByName("achievements");
                if (_local_2 != null)
                {
                    _local_2.visible = k;
                    this._window.height = (k ? _local_2.bottom : _local_3.bottom);
                    this._widget._Str_19324();
                }
            }
        }

        public function _Str_6111(k:String, _arg_2:Int)
        {
            var _local_3 = 0;
            switch (k)
            {
                case MINIMAIL:
                    _local_3 = this._widget._Str_21527;
                    this._Str_20243("minimail", _local_3);
                    return;
            }
        }
    }

