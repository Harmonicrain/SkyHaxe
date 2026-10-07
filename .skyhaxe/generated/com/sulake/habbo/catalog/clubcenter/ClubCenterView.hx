package com.sulake.habbo.catalog.clubcenter
;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.widgets.IRoomPreviewerWidget;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.catalog.clubcenter.util.ClubStatus;
    import com.sulake.habbo.communication.messages.incoming.users.ScrKickbackData;
    import com.sulake.habbo.catalog.purse.IPurse;
    import flash.display.BitmapData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.utils.FriendlyTime;

     class ClubCenterView implements IAvatarImageListener 
    {
        var _controller:HabboClubCenter;
        var _window:IWindowContainer;
        var _widget:IRoomPreviewerWidget;
        var _figure:String;

        public function new(k:HabboClubCenter, _arg_2:IHabboWindowManager, _arg_3:String)
        {
            this._controller = k;
            this._window = Std.downcast(_arg_2.buildFromXML(new com.sulake.core.utils.xml.XML(this._controller.assets.getAssetByName("club_center_xml").content)) , IWindowContainer);
            if (this.container == null)
            {
                return;
            }
            if (!this._controller._Str_21512())
            {
                this._Str_1397("special_breakdown_link");
                this._Str_1397("special_content");
                this._Str_1397("special_content_postit");
                this.container.invalidate();
            }
            else
            {
                this._Str_4219("special_amount_icon", false);
                this._Str_4219("special_amount_title", false);
                this._Str_4219("special_amount_content", false);
                this._Str_4219("special_breakdown_link", false);
                this._Str_4219("special_time_content", false);
            }
            this._Str_4219("btn_earn", false);
            this._controller._Str_16489();
            this._window.center();
            this._window.addEventListener(WindowEvent.WINDOW_EVENT_RELOCATE, this._Str_19257);
            this._figure = _arg_3;
            this._widget = Std.downcast(cast(this._window.findChildByName("avatar"), IWidgetWindow).widget , IRoomPreviewerWidget);
            var _local_4= this._controller.avatarRenderManager.createAvatarImage(_arg_3, AvatarScaleType.LARGE, null, this);
            if (_local_4 != null)
            {
                _local_4.setDirection(AvatarSetType.FULL, 4);
this._widget.showPreview(_local_4.getCroppedImage(AvatarSetType.FULL));
            }
            this.container.procedure = this.onInput;
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.removeEventListener(WindowEvent.WINDOW_EVENT_RELOCATE, this._Str_19257);
                this._window.dispose();
                this._window = null;
            }
            this._controller = null;
        }

        public function _Str_22518(k:ScrKickbackData, _arg_2:IPurse, _arg_3:Int, _arg_4:BitmapData)
        {
            var _local_8:IButtonWindow = null;
            var _local_9 = 0;
            var _local_5= this._controller._Str_24259();
            this.setElementText("status_title", (("${hccenter.status." + _local_5) + "}"));
            if (((!(k != null)) || (!(_arg_2 != null))))
            {
                this._Str_4219("gift_content", false);
                this._Str_4219("special_container", false);
                return;
            }
            this._Str_4219("gift_content", true);
            var _local_6= this.getLocalization((("hccenter.status." + _local_5) + ".info"));
            _local_6 = ASCompat.stringReplace(_local_6, "%timeleft%", this._Str_21064(_arg_2.minutesUntilExpiration));
            _local_6 = ASCompat.stringReplace(_local_6, "%joindate%", k.firstSubscriptionDate);
            _local_6 = ASCompat.stringReplace(_local_6, "%streakduration%", this._Str_22787(k.currentHcStreak));
            this.setElementText("status_info", _local_6);
            var _local_7= Std.downcast(this.container.findChildByName("hc_badge") , IBitmapWrapperWindow);
            if (((_local_7 != null) && (_arg_4 != null)))
            {
                _local_7.bitmap = _arg_4;
            }
            if (this._controller._Str_21512())
            {
                if (k.timeUntilPayday < 60)
                {
                    this.setElementText("special_time_content", this.getLocalization("hccenter.special.time.soon"));
                }
                else
                {
                    this.setElementText("special_time_content", this._Str_21064(k.timeUntilPayday));
                }
                this._Str_4219("special_time_content", true);
                _local_9 = (k.creditRewardForMonthlySpent + k.creditRewardForStreakBonus);
                if (_local_9 > 0)
                {
                    this._Str_4219("special_amount_icon", true);
                    this._Str_4219("special_amount_title", true);
                    this._Str_4219("special_amount_content", true);
                    this._Str_4219("special_breakdown_link", true);
                    this.setElementText("special_amount_content", ASCompat.stringReplace(this.getLocalization("hccenter.special.sum"), "%credits%", _local_9));
                }
            }
            _local_8 = Std.downcast(this.container.findChildByName("btn_gift") , IButtonWindow);
            if (((_local_5 == ClubStatus.ACTIVE) && (_arg_3 > 0)))
            {
                if (_local_8 != null)
                {
                    _local_8.caption = "${hccenter.btn.gifts.redeem}";
                }
                this.setElementText("gift_info", ASCompat.stringReplace(this.getLocalization("hccenter.unclaimedgifts"), "%unclaimedgifts%", _arg_3));
            }
            else
            {
                if (_local_8 != null)
                {
                    _local_8.caption = "${hccenter.btn.gifts.view}";
                }
                this.setElementText("gift_info", this.getLocalization("hccenter.gift.info"));
            }
            _local_8 = Std.downcast(this.container.findChildByName("btn_buy") , IButtonWindow);
            if (_local_5 == ClubStatus.ACTIVE)
            {
                if (_local_8 != null)
                {
                    _local_8.caption = "${hccenter.btn.extend}";
                }
            }
            else
            {
                if (_local_8 != null)
                {
                    _local_8.caption = "${hccenter.btn.buy}";
                }
            }
        }

        public function avatarImageReady(k:String)
        {
            var _local_2:IAvatarImage = null;
            if (k == this._figure)
            {
                _local_2 = this._controller.avatarRenderManager.createAvatarImage(this._figure, AvatarScaleType.LARGE, null, this);
                _local_2.setDirection(AvatarSetType.FULL, 4);
this._widget.showPreview(_local_2.getCroppedImage(AvatarSetType.FULL));
            }
        }

        function onInput(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(k.type == WindowMouseEvent.DOWN)) || (!(this._controller != null))))
            {
                return;
            }
            k.stopImmediatePropagation();
            k.stopPropagation();
            switch (_arg_2.name)
            {
                case "header_button_close":
                    this._controller.removeView();
                    return;
                case "special_infolink":
                    this._controller._Str_21087();
                    return;
                case "special_breakdown_link":
                    this._controller._Str_23974();
                    return;
                case "general_infolink":
                    this._controller.openHelpPage();
                    return;
                case "btn_gift":
                    this._controller._Str_22271();
                    this._controller.removeView();
                    return;
                case "btn_buy":
                    this._controller._Str_24472();
                    this._controller.removeView();
                    return;
                case "btn_earn":
                    if (this._controller._Str_19407 != null)
                    {
                        this._controller._Str_19407.showVideo();
                    }
                    return;
                default:
                    return;
            }
        }

        function _Str_19257(k:WindowEvent)
        {
            this._controller.removeBreakdown();
        }

        var container(get,never):IWindowContainer;
function  get_container():IWindowContainer
        {
            return this._window;
        }

        function setElementText(k:String, _arg_2:String)
        {
            if (this.container == null)
            {
                return;
            }
            var _local_3= Std.downcast(this.container.findChildByName(k) , ITextWindow);
            if (_local_3 != null)
            {
                _local_3.text = _arg_2;
            }
        }

        function _Str_4219(k:String, _arg_2:Bool)
        {
            if (this.container == null)
            {
                return;
            }
            var _local_3= this.container.findChildByName(k);
            if (_local_3 != null)
            {
                _local_3.visible = _arg_2;
            }
        }

        public function _Str_23883():IWindow
        {
            return (this.container != null) ? this.container.findChildByName("special_content_postit") : null;
        }

        function _Str_1397(k:ASAny)
        {
            if (this.container == null)
            {
                return;
            }
            var _local_2= this.container.findChildByName(k);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(_local_2.parent , IWindowContainer);
            _local_3.removeChild(_local_2);
        }

        function getLocalization(k:String):String
        {
            if (((!(this._controller != null)) || (!(this._controller.localization != null))))
            {
                return "";
            }
            return this._controller.localization.getLocalization(k, k);
        }

        public function _Str_21064(k:Int):String
        {
            return FriendlyTime.shortFormat(this._controller.localization, (k * 60));
        }

        public function _Str_22787(k:Int):String
        {
            return FriendlyTime.shortFormat(this._controller.localization, (k * 86400));
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._controller == null;
        }

        public function _Str_24836(k:Bool, _arg_2:Bool)
        {
            var _local_3= this._window.findChildByName("btn_earn");
            if (_local_3 != null)
            {
                _local_3.visible = k;
                if (_arg_2)
                {
                    _local_3.enable();
                    _local_3.alpha = 0;
                }
                else
                {
                    _local_3.disable();
                    _local_3.alpha = Std.int(0.2 * 0xFF);
                }
            }
        }
    }

