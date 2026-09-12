package com.sulake.habbo.ui.widget.camera
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.widget.camera.CameraWidget;
    import flash.display.BitmapData;
    import flash.utils.Timer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.utils.TextWindowUtils;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import flash.geom.Matrix;
    import com.sulake.core.assets.loaders.BitmapFileLoader;
    import flash.net.URLRequest;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.display.Bitmap;
    import flash.events.TimerEvent;
    import com.sulake.habbo.communication.messages.incoming.camera.CameraPublishStatusMessageEvent;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.habbo.window._enum.HabboAlertDialogFlag;
    import com.sulake.habbo.window.utils.AlertDialogCaption;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.camera.CompetitionStatusMessageEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.utils.StringUtil;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.habbo.utils.HabboWebTools;

    /*internal*/ class PhotoPurchaseConfirmationDialog 
    {
        static inline final LOADING_IMAGE= "loading_image";
        static inline final IMAGE_LOADED= "image_loaded";
        static inline final WAITING_PURCHASE_TO_COMPLETE= "waiting_purchase_to_complete";
        static inline final WAITING_PUBLISH_TO_COMPLETE= "waiting_publish_to_complete";
        static inline final WAITING_COMPETITION_SUBMIT_TO_COMPLETE= "waiting_competition_submit_to_complete";
        static inline final RENDERING_FAILED= "rendering_failed";

        var _state:String;
        var _window:IWindowContainer;
        var _widget:CameraWidget;
        var _image:BitmapData;
        var _caption:String;
        var _disclaimerAccepted:Bool = false;
        var _competitionSubmitted:Bool = false;
        var _published:Bool = false;
        var _extraDataId:String = null;
        var _publishButtonEnablerTimer:Timer;
        var _purchaseCount:Int = 0;

        public function new(k:CameraWidget, caption:String)
        {
            this._widget = k;
            this._caption = caption;
            this._window = Std.downcast(this._widget.getXmlWindow("photo_purchase_confirmation") , IWindowContainer);
            var _local_3= Std.downcast(Std.downcast(this._window , IFrameWindow).content.getChildByName("contentlist") , IItemListWindow);
            if (k.component.getBoolean("camera.competition.enabled"))
            {
                TextWindowUtils._Str_20340(Std.downcast(this._window.findChildByName("competition_info") , ITextWindow), 0xFFFFFF, 0xFFFFFF, 0xFFFFFF);
            }
            else
            {
                _local_3.removeListItem(_local_3.getListItemByName("competition_wrapper"));
            }
            if (k.component.getBoolean("disclaimer.credit_spending.enabled"))
            {
                this._Str_3515(false);
            }
            else
            {
                _local_3.removeListItem(_local_3.getListItemByName("disclaimer"));
                this._Str_3515(true);
            }
            if (!k.component.getBoolean("camera.photo.publishing.enabled"))
            {
                _local_3.removeListItem(_local_3.getListItemByName("publish_wrapper"));
            }
            Std.downcast(this._window , IFrameWindow)._Str_5665();
            this.setState(LOADING_IMAGE);
            this._window.center();
            this._window.procedure = this._Str_3545;
        }


        function _Str_22012(k:Int, _arg_2:Int):Bool
        {
            var _local_3= this._widget.catalog.getPurse();
            if (_local_3.credits < k)
            {
                this._widget.catalog.showNotEnoughCreditsAlert();
                return false;
            }
            if (_local_3.getActivityPointsForType(ActivityPointTypeEnum.DUCKET) < _arg_2)
            {
                this._widget.catalog.showNotEnoughActivityPointsAlert(ActivityPointTypeEnum.DUCKET);
                return false;
            }
            return true;
        }

        function _Str_12069(k:Bool)
        {
            var _local_2= cast(this._window.findChildByName("buy_button"), IButtonWindow);
            var _local_3= cast(this._window.findChildByName("publish_button"), IButtonWindow);
            var _local_4= cast(this._window.findChildByName("competition_button"), IButtonWindow);
            if (_local_2 != null)
            {
                _local_2.disable();
            }
            if (_local_3 != null)
            {
                _local_3.disable();
            }
            if (_local_4 != null)
            {
                _local_4.disable();
            }
            if (k)
            {
                cast(this._window.findChildByName("cancel_button"), IButtonWindow).caption = this._widget.localizations.getLocalization("generic.close");
                this._window.findChildByName("status_info").caption = this._widget.localizations.getLocalization("camera.purchase.pleasewait");
            }
        }

        function setState(k:String)
        {
            if (this._window == null)
            {
                return;
            }
            this._state = k;
            var _local_2= cast(this._window.findChildByName("buy_button"), IButtonWindow);
            var _local_3= cast(this._window.findChildByName("publish_button"), IButtonWindow);
            var _local_4= cast(this._window.findChildByName("competition_button"), IButtonWindow);
            switch (k)
            {
                case LOADING_IMAGE:
                    this._Str_12069(false);
                    return;
                case IMAGE_LOADED:
                    if (this._disclaimerAccepted)
                    {
                        _local_2.enable();
                    }
                    if (!this._published)
                    {
                        if (_local_3 != null)
                        {
                            _local_3.enable();
                        }
                    }
                    if (((!this._competitionSubmitted) && (_local_4 != null)))
                    {
                        _local_4.enable();
                    }
                    return;
                case WAITING_PURCHASE_TO_COMPLETE:
                    this._Str_12069(true);
                    if (this._widget.component.getBoolean("disclaimer.credit_spending.enabled"))
                    {
                        this._Str_3515(false);
                    }
                    return;
                case WAITING_PUBLISH_TO_COMPLETE:
                    this._published = true;
                    this._Str_12069(true);
                    return;
                case WAITING_COMPETITION_SUBMIT_TO_COMPLETE:
                    this._competitionSubmitted = true;
                    this._Str_12069(true);
                    return;
                case RENDERING_FAILED:
                    this._Str_12069(false);
                    this._window.findChildByName("status_info").caption = "";
                    return;
            }
        }

        public function _Str_22361()
        {
            if (this._window == null)
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("product_image") , IBitmapWrapperWindow);
            var _local_2= new Point();
            k.getGlobalPosition(_local_2);
            var _local_3= HabboToolbarIconEnum.INVENTORY;
            var _local_4= new BitmapData(120, 120);
            var _local_5= (_local_4.width / this._image.width);
            var _local_6= new Matrix(_local_5, 0, 0, _local_5, 0, 0);
            _local_4.draw(this._image, _local_6);
            this._widget.component.toolbar.createTransitionToIcon(_local_3, _local_4, Std.int(_local_2.x), Std.int(_local_2.y));
            this._window.findChildByName("status_info").caption = this._widget.localizations.getLocalization("camera.purchase.successful");
            this._window.findChildByName("buy_button").caption = this._widget.localizations.getLocalization("camera.buy.another.button.text");
            this._window.findChildByName("inventory_link_area").visible = true;
            this._purchaseCount++;
            this._window.findChildByName("purchase_count").caption = "";
            this._window.findChildByName("purchase_count").caption = Std.string(this._purchaseCount);
            this.setState(IMAGE_LOADED);
        }

        public function _Str_24775(k:String)
        {
            var _local_2:BitmapFileLoader = null;
            if (this._widget == null)
            {
                return;
            }
            if ((ASCompat.stringAsBool(k) && (k.length > 0)))
            {
                if (((!(k.indexOf("http://") == 0)) && (!(k.indexOf("https://") == 0))))
                {
                    k = (this._widget.component.context.configuration.getProperty("stories.image_url_base") + k);
                }
                _local_2 = new BitmapFileLoader("image/png", new URLRequest(k));
                _local_2.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onImageLoaded);
            }
            else
            {
                this._Str_19543();
                this._widget.windowManager.alert("${generic.alert.title}", "${camera.render.count.info}", 0, null);
            }
        }

        function onImageLoaded(k:AssetLoaderEvent)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_2= ASCompat.dynamicAs(cast(k.target, BitmapFileLoader).content , Bitmap);
            if (_local_2 != null)
            {
                this.setImage(_local_2.bitmapData);
            }
            this._window.findChildByName("status_info").caption = this._widget.localizations.getLocalization("camera.confirm_phase.info");
            this.setState(IMAGE_LOADED);
        }

        function setImage(k:BitmapData)
        {
            if (((this._window == null) || (k == null)))
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("product_image") , IBitmapWrapperWindow);
            if (_local_2 == null)
            {
                return;
            }
            if (_local_2.bitmap != null)
            {
                _local_2.bitmap.dispose();
                _local_2.bitmap = null;
            }
            if (_local_2.bitmap == null)
            {
                _local_2.bitmap = new BitmapData(_local_2.width, _local_2.height, true, 0);
            }
            var _local_3= (_local_2.width / k.width);
            _local_2.bitmap.draw(k, new Matrix(_local_3, 0, 0, _local_3, 0, 0), null, null, null, true);
            this._image = k;
        }

        public function _Str_19543()
        {
            if (this._window == null)
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("product_image") , IBitmapWrapperWindow);
            if (k != null)
            {
                this._image = new BitmapData(k.width, k.height, false, 0);
                if (k.bitmap == null)
                {
                    k.bitmap = this._image;
                }
                else
                {
                    k.bitmap.dispose();
                    k.bitmap.draw(this._image);
                }
            }
            this.setState(RENDERING_FAILED);
        }

        public function _Str_12205(k:CameraPublishStatusMessageEvent)
        {
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4:String = null;
            if (this._window == null)
            {
                return;
            }
            if (k.getParser().isOk())
            {
                this._extraDataId = k.getParser().getExtraDataId();
                this._window.findChildByName("status_info").caption = this._widget.localizations.getLocalization("camera.publish.successful");
                this._window.findChildByName("publish_explanation").caption = this._widget.localizations.getLocalization("camera.publish.successful");
                this._window.findChildByName("publish_detailed_explanation").caption = this._widget.localizations.getLocalization("camera.publish.success.short.info");
                this._window.findChildByName("publish_button").visible = false;
                this._window.findChildByName("publish_price_area").visible = false;
                this._window.findChildByName("publish_link_area").visible = true;
                if (this._publishButtonEnablerTimer != null)
                {
                    this._publishButtonEnablerTimer.reset();
                }
            }
            else
            {
                _local_2 = k.getParser().getSecondsToWait();
                _local_3 = Std.int((_local_2 / 60) + 1);
                _local_4 = this._widget.localizations.registerParameter("camera.publish.wait", "minutes", Std.string(_local_3));
                this._widget.windowManager.alert("${generic.alert.title}", _local_4, 0, null);
                this._window.findChildByName("status_info").caption = "";
                if (this._publishButtonEnablerTimer == null)
                {
                    this._publishButtonEnablerTimer = new Timer((_local_2 * 1000), 1);
                    this._publishButtonEnablerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimer : ASAny));
                }
                else
                {
                    this._publishButtonEnablerTimer.reset();
                    this._publishButtonEnablerTimer.delay = (_local_2 * 1000);
                }
                this._publishButtonEnablerTimer.start();
            }
            this.setState(IMAGE_LOADED);
        }

        function onTimer(k:TimerEvent)
        {
            var _local_2:IButtonWindow = null;
            this._published = false;
            this._publishButtonEnablerTimer = null;
            if (this._state == IMAGE_LOADED)
            {
                _local_2 = cast(this._window.findChildByName("publish_button"), IButtonWindow);
                _local_2.enable();
            }
        }

        public function competitionStatus(k:CompetitionStatusMessageEvent)
        {
            var _local_3:IConfirmDialog = null;
            if (((this._window == null) || (this._window.findChildByName("competition_wrapper") == null)))
            {
                return;
            }
            if (k.getParser().isOk())
            {
                this._window.findChildByName("status_info").caption = this._widget.localizations.getLocalization("camera.competition.submitted.status");
                this._window.findChildByName("competition_name").caption = this._widget.localizations.getLocalization("camera.competition.submitted.info");
            }
            else
            {
                if (k.getParser().getErrorReason() == "too-many-submits")
                {
                    this._window.findChildByName("status_info").caption = this._widget.localizations.getLocalization("generic.failed");
                    this._window.findChildByName("competition_name").caption = this._widget.localizations.getLocalization("camera.competition.limit.info");
                }
                else
                {
                    if (k.getParser().getErrorReason() == "email-not-verified")
                    {
                        this._competitionSubmitted = false;
                        this._window.findChildByName("status_info").caption = this._widget.localizations.getLocalization("generic.failed");
                        _local_3 = this._widget.windowManager.confirm("${generic.alert.title}", "${camera.competition.email.not.verified}", (HabboAlertDialogFlag.BUTTON_OK | HabboAlertDialogFlag.BUTTON_CANCEL), this._Str_22568);
                        _local_3.setButtonCaption(HabboAlertDialogFlag.BUTTON_OK, new AlertDialogCaption(this._widget.localizations.getLocalization("email.settings"), "", true));
                        _local_3.setButtonCaption(HabboAlertDialogFlag.BUTTON_CANCEL, new AlertDialogCaption(this._widget.localizations.getLocalization("groupforum.settings.cancel"), "", true));
                    }
                }
            }
            this.setState(IMAGE_LOADED);
            var _local_2= this._window.findChildByName("competition_button");
            if (((!(_local_2 == null)) && (_local_2.y < 10)))
            {
                _local_2.y = 10;
            }
        }

        function _Str_22568(k:IConfirmDialog, _arg_2:WindowEvent)
        {
            var _local_3:String = null;
            var _local_4:String = null;
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
            {
                _local_3 = this._widget.component.context.configuration.getProperty("email.verification.url");
                if (!StringUtil.isEmpty(_local_3))
                {
                    _local_4 = ((this._widget.component.getInteger("spaweb", 0) == 1) ? "" : "_blank");
                    flash.Lib.getURL(new URLRequest(_local_3), _local_4);
                }
            }
            k.dispose();
        }

        public function _Str_24882(k:Int, _arg_2:Int, _arg_3:Int)
        {
            var _local_4= Std.downcast(this._window.findChildByName("purchase_credit_cost_text") , ITextWindow);
            _local_4.text = Std.string(k);
            var _local_5= Std.downcast(this._window.findChildByName("purchase_ducket_cost_text") , ITextWindow);
            if (_arg_2 > 0)
            {
                _local_5.text = Std.string(_arg_2);
            }
            else
            {
                _local_5.visible = false;
                this._window.findChildByName("ducket_icon").visible = false;
            }
            var _local_6= Std.downcast(this._window.findChildByName("publish_ducket_cost_text") , ITextWindow);
            if (_local_6 != null)
            {
                _local_6.text = Std.string(_arg_3);
            }
        }

        function _Str_3545(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:String = null;
            var _local_4:String = null;
            if (((!(k != null)) || (!(_arg_2 != null))))
            {
                return;
            }
            if (((!(k.type == WindowMouseEvent.CLICK)) && (!(k.type == WindowMouseEvent.DOUBLE_CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "spending_disclaimer":
                    this._Str_3515(cast(_arg_2, ICheckBoxWindow).Selected);
                    return;
                case "competition_button":
                    if (this._state == IMAGE_LOADED)
                    {
                        this.setState(WAITING_COMPETITION_SUBMIT_TO_COMPLETE);
                        this._widget.handler.confirmPhotoCompetitionSubmit();
                    }
                    return;
                case "buy_button":
                    if ((((this._state == IMAGE_LOADED) && this._disclaimerAccepted) && this._Str_22012(this._widget.handler.creditPrice, this._widget.handler.ducketPrice)))
                    {
                        this.setState(WAITING_PURCHASE_TO_COMPLETE);
                        this._widget.handler.confirmPhotoPurchase();
                    }
                    return;
                case "publish_button":
                    if (((this._state == IMAGE_LOADED) && this._Str_22012(0, this._widget.handler.publishDucketPrice)))
                    {
                        this.setState(WAITING_PUBLISH_TO_COMPLETE);
                        this._widget.handler.confirmPhotoPublish();
                    }
                    return;
                case "inventory_link":
                    this._widget.component.context.createLinkEvent("inventory/open/furni");
                    return;
                case "publish_link":
                    _local_3 = this._widget.container.sessionDataManager.userName;
                    _local_4 = ((("/profile/" + _local_3) + "/photo/") + this._extraDataId);
                    HabboWebTools.openPage(_local_4);
                    return;
                case "header_button_close"
                   | "cancel_button":
                    this._widget.startTakingPhoto("photoPurchaseCancel");
                    this.hide();
                    return;
            }
        }

        function _Str_3515(k:Bool)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_2= this._window.findChildByName("buy_button");
            if (_local_2 == null)
            {
                return;
            }
            this._disclaimerAccepted = k;
            if ((k && (this._state == IMAGE_LOADED)))
            {
                _local_2.enable();
            }
            else
            {
                _local_2.disable();
            }
        }

        public function hide()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._image = null;
            this._widget = null;
            if (this._publishButtonEnablerTimer != null)
            {
                this._publishButtonEnablerTimer.stop();
                this._publishButtonEnablerTimer = null;
            }
        }
    }

