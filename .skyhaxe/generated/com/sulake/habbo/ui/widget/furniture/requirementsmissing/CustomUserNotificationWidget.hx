package com.sulake.habbo.ui.widget.furniture.requirementsmissing
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.ui.handler.CustomUserNotificationWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.inventory.IAvatarEffect;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.inventory.AvatarEffectSubtypeEnum;
    import com.sulake.habbo.avatar._enum.AvatarEditorInstanceId;
    import com.sulake.habbo.avatar._enum.AvatarEditorFigureCategory;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class CustomUserNotificationWidget extends RoomWidgetBase
    {
        public static inline final VIPHOPPER= "viphopper";
        public static inline final VIPGATE= "vipgate";
        public static inline final COSTUMEHOPPER= "costumehopper";
        public static inline final RESPECTFAILEDSTAGE= "respectfailedstage";
        public static inline final RESPECTFAILEDAUDIENCE= "respectfailedaudience";

        var _window:IFrameWindow;
        var _widgetHandler:CustomUserNotificationWidgetHandler;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            this._widgetHandler = cast(k, CustomUserNotificationWidgetHandler);
            this._widgetHandler.widget = this;
        }

        public function open(k:String="")
        {
            if (this._window == null)
            {
                switch (k)
                {
                    case VIPHOPPER:
                        this._Str_6297("viprequired_xml");
                        this._Str_21325("viphopper");
                        
                    case VIPGATE:
                        this._Str_6297("viprequired_xml");
                        this._Str_21325("gate");
                        
                    case COSTUMEHOPPER:
                        this._Str_6297("costumehopper_costumerequired_xml");
                        
                    case RESPECTFAILEDSTAGE:
                        this._Str_6297("respect_giving_failed_notification_xml");
                        this.setText("stage");
                        this._Str_22240("stage");
                        
                    case RESPECTFAILEDAUDIENCE:
                        this._Str_6297("respect_giving_failed_notification_xml");
                        this.setText("audience");
                        this._Str_22240("audience");
                        
                }
                this._window.center();
                this._window.procedure = this._Str_5162;
            }
        }

        function _Str_6297(k:String)
        {
            this._window = cast(windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(assets.getAssetByName(k).content)), IFrameWindow);
        }

        function _Str_21325(k:String)
        {
            this._window.findChildByName("title").caption = (("${" + k) + ".viprequired.title}");
            this._window.findChildByName("bodytext").caption = (("${" + k) + ".viprequired.bodytext}");
        }

        function setText(k:String)
        {
            var _local_2= ("respect.giving.failed.no." + k);
            var _local_3= this._widgetHandler.container.localization.getLocalization(_local_2);
            var _local_4= this._widgetHandler.container.config.getProperty("respect.talent.show.min.audience");
            if (ASCompat.stringAsBool(_local_4))
            {
                _local_3 = ASCompat.stringReplace(_local_3, "%users%", _local_4);
            }
            this._window.findChildByName("body_txt").caption = _local_3;
        }

        function _Str_22240(k:String)
        {
            var _local_2:ASAny = (("${image.library.url}notifications/habbo_talent_show_" + k) + ".png");
            var _local_3= Std.downcast(this._window.content.getChildByName("respectFailedNotificationBitmap") , IStaticBitmapWrapperWindow);
            _local_3.assetUri = _local_2;
        }

        public function close()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function _Str_5162(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:Array<ASAny> = null;
            var _local_4 = false;
            var _local_5:IAvatarEffect = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "buy_vip":
                        if (((!(this._widgetHandler == null)) && (!(this._widgetHandler.container == null))))
                        {
                            this._widgetHandler.container.catalog.openClubCenter();
                        }
                        this.close();
                        
                    case "vip_benefits":
                        this._widgetHandler.container.catalog.showVipBenefits();
                        
                    case "buy_costumes":
                        _local_3 = this._widgetHandler.container.inventory.getAvatarEffects();
                        _local_4 = false;
                        if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
                        {
_local_5  = _tmp_;
                            if (_local_5.subType == AvatarEffectSubtypeEnum.COSTUME)
                            {
                                _local_4 = true;
                                break;
                            }
                        }
                        if (_local_4)
                        {
                            this._widgetHandler.container.avatarEditor.openEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR, null, null, true, null, AvatarEditorFigureCategory.EFFECTS);
                            this._widgetHandler.container.avatarEditor.loadOwnAvatarInEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR);
                        }
                        else
                        {
                            this._widgetHandler.container.catalog.openCatalogPage("costumes");
                        }
                        this.close();
                        
                    case "close":
                        this.close();
                        
                }
                if (_arg_2.tags.indexOf("close") != -1)
                {
                    this.close();
                }
            }
        }
    }

