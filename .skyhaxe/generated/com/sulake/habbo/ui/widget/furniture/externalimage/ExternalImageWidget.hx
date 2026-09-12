package com.sulake.habbo.ui.widget.furniture.externalimage
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IHTMLTextWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ILabelWindow;
    import flash.text.TextField;
    import com.sulake.core.assets.loaders.BitmapFileLoader;
    import flash.display.Bitmap;
    import com.sulake.habbo.inventory.IHabboInventory;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.core.window.events.WindowLinkEvent;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.handler.ExternalImageWidgetHandler;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.core.window.components.ITextWindow;
    import flash.display.BitmapData;
    import adobe.serialization.json.JSONDecoder;
    import flash.net.URLRequest;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.geom.Matrix;
    import flash.geom.ColorTransform;
    import flash.net.URLLoader;
    import flash.events.HTTPStatusEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window._enum.HabboAlertDialogFlag;
    import com.sulake.habbo.window.utils.AlertDialogCaption;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import org.openvideoads.util.StringUtils;
    import com.sulake.core.window.components.ISelectableWindow;
    import com.sulake.habbo.window.widgets.IIlluminaInputWidget;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.components.IWidgetWindow;

     class ExternalImageWidget extends RoomWidgetBase
    {
        static inline final PHOTO_POSTER= "photo_poster";
        static inline final SELFIE= "selfie";
        static inline final LEGACY= "legacy";
        static inline final HORIZONTAL_ITEM_SPACING= 10;
        static inline final VERTICAL_SPACE= 71;

        var _window:IWindowContainer;
        var _imageContainer:IBitmapWrapperWindow;
        var _moderationText:IHTMLTextWindow;
        var _makeOwnButton:IWindow;
        var _closeButton:IWindow;
        var _deleteButton:IWindowContainer;
        var _bgBorder:IWindow;
        var _buttonContainer:IWindowContainer;
        var _shareArea:IWindowContainer;
        var _shareButton:IWindow;
        var _senderNameButton:IRegionWindow;
        var _senderNameText:ILabelWindow;
        var _nameCopyField:TextField;
        var _creationDateText:ILabelWindow;
        var _bitmapLoader:BitmapFileLoader;
        var _currentImage:Bitmap;
        var _inventory:IHabboInventory;
        var _roomObjectID:Int = 0;
        var _extraDataID:String;
        var _caption:String;
        var _senderId:Int = 0;
        var _shareUrl:String;
        var _reportImagebutton:IWindowContainer;
        var _roomObjectType:String;
        var _Str_26327:IBitmapWrapperWindow;
        var _help:IHabboHelp;
        var _roomEngine:IRoomEngine;
        var _reportImageContainer:IWindowContainer;
        var _currentRoomObjectListIndex:Int = 0;
        var _openedFromInventory:Bool = false;
        var _component:Component;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager, _arg_5:IHabboInventory, _arg_6:IHabboHelp, _arg_7:IRoomEngine, _arg_8:Component)
        {
            var _local_9:IDisplayObjectWrapper = null;
            super(k, _arg_2, _arg_3, _arg_4);
            this._window = Std.downcast(_arg_2.buildFromXML(((_arg_3.getAssetByName("stories_image_widget_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this.ownHandler.widget = this;
            this._closeButton = this._window.findChildByName("closebutton") ;
            this._imageContainer = Std.downcast(this._window.findChildByName("imageLoader") , IBitmapWrapperWindow);
            this._moderationText = Std.downcast(this._window.findChildByName("moderationText") , IHTMLTextWindow);
            this._moderationText.addEventListener(WindowLinkEvent.WINDOW_EVENT_LINK, this.onClickModerationInfoLink);
            this._shareArea = Std.downcast(this._window.findChildByName("shareArea") , IWindowContainer);
            this._deleteButton = Std.downcast(this._window.findChildByName("removeButtonContainer") , IWindowContainer);
            this._makeOwnButton = this._window.findChildByName("makeOwnButton") ;
            this._shareButton = this._window.findChildByName("shareButtonContainer") ;
            this._bgBorder = this._window.findChildByName("bgBorder") ;
            this._senderNameButton = Std.downcast(this._window.findChildByName("senderNameButton") , IRegionWindow);
            this._senderNameText = Std.downcast(this._window.findChildByName("senderName") , ILabelWindow);
            this._nameCopyField = new TextField();
            if (this.ownHandler.container.roomSession.roomControllerLevel == RoomControllerLevel.MODERATOR)
            {
                _local_9 = Std.downcast(this._window.findChildByName("name_copy_wrapper") , IDisplayObjectWrapper);
                this._nameCopyField.textColor = 10061943;
                this._nameCopyField.text = "";
                _local_9.setDisplayObject(this._nameCopyField);
            }
            this._creationDateText = Std.downcast(this._window.findChildByName("creationDate") , ILabelWindow);
            this._buttonContainer = Std.downcast(this._window.findChildByName("buttonContainer") , IWindowContainer);
            this._inventory = _arg_5;
            this._help = _arg_6;
            this._roomEngine = _arg_7;
            this._reportImagebutton = Std.downcast(this._window.findChildByName("reportButtonContainer") , IWindowContainer);
            this._window.procedure = this.onWindowEvent;
            this._window.center();
            this._shareArea.visible = false;
            this._component = _arg_8;
            this.hide();
        }

        var ownHandler(get,never):ExternalImageWidgetHandler;
function  get_ownHandler():ExternalImageWidgetHandler
        {
            return Std.downcast(_handler , ExternalImageWidgetHandler);
        }

        public function showWithRoomObject(k:IRoomObject)
        {
            this._roomObjectID = k.getId();
            this._roomObjectType = k.getType();
            this._openedFromInventory = false;
            this._deleteButton.visible = this.ownHandler.hasRightsToRemove();
            if (this.getType() == PHOTO_POSTER)
            {
                this._reportImagebutton.visible = true;
            }
            else
            {
                this._reportImagebutton.visible = this.ownHandler.isSelfieReportingEnabled();
            }
            this.show(k.getModel().getString("furniture_data"));
            var _local_2= this.getWallItemsOfCurrentTypeInRoom();
            if (_local_2.indexOf(k) != -1)
            {
                this._currentRoomObjectListIndex = _local_2.indexOf(k);
            }
        }

        public function showWithFurniID(k:Int)
        {
            var _local_2= this._inventory.getWallItemById(k);
            if (_local_2 != null)
            {
                this._roomObjectID = k;
                this._roomObjectType = this._roomEngine.getWallItemType(_local_2.type);
                this._openedFromInventory = true;
                this._deleteButton.visible = false;
                this._reportImagebutton.visible = false;
                this.show(_local_2.stuffData.getLegacyString());
            }
        }

        function show(k:String)
        {
            if (this.ownHandler.storiesImageUrlBase == "disabled")
            {
                return;
            }
            this.clearImage();
            if (k != null)
            {
                this.readFurniJson(k);
            }
        }

        function showNext()
        {
            var k= this.getWallItemsOfCurrentTypeInRoom();
            if (k.length > 0)
            {
                this._currentRoomObjectListIndex++;
                if (this._currentRoomObjectListIndex > (k.length - 1))
                {
                    this._currentRoomObjectListIndex = 0;
                }
                this.showWithRoomObject(k[this._currentRoomObjectListIndex]);
            }
        }

        function showPrevious()
        {
            var k= this.getWallItemsOfCurrentTypeInRoom();
            if (k.length > 0)
            {
                this._currentRoomObjectListIndex--;
                if (this._currentRoomObjectListIndex < 0)
                {
                    this._currentRoomObjectListIndex = (k.length - 1);
                }
                this.showWithRoomObject(k[this._currentRoomObjectListIndex]);
            }
        }

        function getWallItemsOfCurrentTypeInRoom():Vector<IRoomObject>
        {
            var _local_3:IRoomObject = null;
            var k= new Vector<IRoomObject>();
            var _local_2= this._roomEngine.getObjectsByCategory(RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = _tmp_;
                if (_local_3.getType() == this._roomObjectType)
                {
                    k.push(_local_3);
                }
            }
            return k;
        }

        function clearImage()
        {
            this._extraDataID = null;
            this._caption = "";
            var k= Std.downcast(this._window.findChildByName("captionText") , ITextWindow);
            k.text = "";
            this._senderNameButton.visible = false;
            this._senderId = 0;
            this._senderNameText.caption = "";
            this._nameCopyField.text = "";
            this._creationDateText.caption = "";
            this._shareUrl = null;
            this._moderationText.visible = false;
            this.drawImage(new Bitmap(new BitmapData((this._imageContainer.width - 2), (this._imageContainer.height - 2), false, 0)));
        }

        function readFurniJson(k:String)
        {
            try
            {
                this._extraDataID = new JSONDecoder(k, false).getValue().id;
                if (ASCompat.stringAsBool(this._extraDataID))
                {
                    this.loadExternalData();
                    return;
                }
                this.loadPhoto(k, this.getImageUrl(new JSONDecoder(k, false).getValue()));
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
            }
 }        }

        function getImageUrl(k:ASObject):String
        {
            var _local_3:String = null;
            var _local_2= this.getJsonValue(k, "w", "url");
            if (_local_2.indexOf("http") != 0)
            {
                _local_3 = "postcards/selfie/";
                if (this.getType() == PHOTO_POSTER)
                {
                    _local_3 = "";
                }
                if (_local_2.indexOf(".png") == -1)
                {
                    _local_2 = (_local_2 + ".png");
                }
                _local_2 = ((this.ownHandler.storiesImageUrlBase + _local_3) + _local_2);
            }
            return _local_2;
        }

        function loadPhoto(photoJsonString:String, imageUrl:String)
        {
            var jsonObject:ASObject = null;
            var shareUrlText:IWindow = null;
            var finalUrl:String = null;
            var captionText:ITextWindow = null;
            try
            {
                jsonObject = new JSONDecoder(photoJsonString, false).getValue();
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                return;
            }
 }            if (!ASCompat.stringAsBool(imageUrl))
            {
                imageUrl = this.getImageUrl(jsonObject);
            }
            this._bitmapLoader = new BitmapFileLoader("image/png", new URLRequest(imageUrl));
            this._bitmapLoader.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onImageLoaded);
            var senderName= this.getJsonValue(jsonObject, "n", "creator_name");
            var senderId= this.getJsonValue(jsonObject, "s", "creator_id");
            var uniqueId= this.getJsonValue(jsonObject, "u", "unique_id");
            var creationTime= this.getJsonValue(jsonObject, "t", "time");
            var creationDate= Date.fromTime(ASCompat.toNumber(creationTime));
            if (ASCompat.stringAsBool(senderName))
            {
                this._senderNameText.caption = senderName;
                this._senderNameButton.visible = true;
                this._nameCopyField.text = senderName;
                this._senderId = ASCompat.toInt(senderId);
                this._creationDateText.caption = ((((Std.string(creationDate.getDate()) + "-") + Std.string(creationDate.getMonth() + 1)) + "-") + Std.string(creationDate.getFullYear()));
            }
            if ((ASCompat.stringAsBool(this.ownHandler.storiesImageShareUrl) && (this.ownHandler.storiesImageShareUrl.length > 4)))
            {
                shareUrlText = this._window.findChildByName("urlField") ;
                finalUrl = ASCompat.stringReplace(this.ownHandler.storiesImageShareUrl, "%id%", uniqueId);
                shareUrlText.caption = finalUrl;
                this._shareUrl = finalUrl;
            }
            this._caption = this.getJsonValue(jsonObject, "m", "caption");
            if (ASCompat.stringAsBool(this._caption))
            {
                captionText = Std.downcast(this._window.findChildByName("captionText") , ITextWindow);
                captionText.text = this._caption;
            }
        }

        function getJsonValue(k:ASObject, _arg_2:String, _arg_3:String=null):String
        {
            var _local_4:String = null;
            _local_4 = ASCompat.getDynamicProperty(k, _arg_2);
            if (((!ASCompat.stringAsBool(_local_4)) && ASCompat.stringAsBool(_arg_3)))
            {
                _local_4 = ASCompat.getDynamicProperty(k, _arg_3);
            }
            return _local_4;
        }

        function onImageLoaded(k:AssetLoaderEvent)
        {
            var _local_2:Bitmap = null;
            if (this._bitmapLoader != null)
            {
                _local_2 = ASCompat.dynamicAs(this._bitmapLoader.content , Bitmap);
                if (_local_2 != null)
                {
                    this._imageContainer.width = Std.int(_local_2.width + 2);
                    this._imageContainer.height = Std.int(_local_2.height + 2);
                    this.drawImage(_local_2);
                }
            }
        }

        function drawImage(k:Bitmap)
        {
            this._currentImage = k;
            this._imageContainer.bitmap = new BitmapData(this._imageContainer.width, this._imageContainer.height, true, 0);
            this._window.visible = true;
            var _local_2= this._window.findChildByName("previousButton");
            var _local_3= this._window.findChildByName("nextButton");
            _local_2.x = HORIZONTAL_ITEM_SPACING;
            this._bgBorder.y = (this._bgBorder.x = 0);
            this._imageContainer.x = ((HORIZONTAL_ITEM_SPACING * 2) + _local_2.width);
            this._imageContainer.y = VERTICAL_SPACE;
            this._bgBorder.height = (this._window.height = (this._imageContainer.height + (VERTICAL_SPACE * 2)));
            this._bgBorder.width = (this._window.width = ((this._imageContainer.width + (HORIZONTAL_ITEM_SPACING * 4)) + (_local_2.width * 2)));
            this._senderNameButton.x = ((this._imageContainer.right - this._senderNameButton.width) - 3);
            this._senderNameButton.y = (this._imageContainer.bottom + 3);
            this._creationDateText.x = (this._imageContainer.x + 3);
            this._creationDateText.y = (this._senderNameButton.y = this._imageContainer.bottom);
            this._buttonContainer.y = 0;
            this._buttonContainer.x = (this._bgBorder.right - this._buttonContainer.width);
            _local_3.x = (this._imageContainer.right + HORIZONTAL_ITEM_SPACING);
            if (this._openedFromInventory)
            {
                _local_3.visible = (_local_2.visible = false);
            }
            else
            {
                _local_3.visible = (_local_2.visible = (this.getWallItemsOfCurrentTypeInRoom().length > 1));
            }
            var _local_4= new Matrix();
            var _local_5= new ColorTransform();
            _local_5.color = 0;
            _local_4.ty = (_local_4.ty + 1);
            this._imageContainer.bitmap.draw(k, _local_4, _local_5);
            _local_4.tx = (_local_4.tx + 1);
            _local_4.ty--;
            this._imageContainer.bitmap.draw(k, _local_4, _local_5);
            _local_4.ty = (_local_4.ty + 2);
            this._imageContainer.bitmap.draw(k, _local_4, _local_5);
            _local_4.ty--;
            _local_4.tx = (_local_4.tx + 1);
            this._imageContainer.bitmap.draw(k, _local_4, _local_5);
            _local_4.tx--;
            this._imageContainer.bitmap.draw(k, _local_4);
            this._window.activate();
            this.updateWindowPosition();
        }

        function loadExternalData()
        {
            var k= (this.ownHandler.extraDataServiceUrl + this._extraDataID);
            var _local_2= new URLLoader(new URLRequest(k));
            _local_2.addEventListener(HTTPStatusEvent.HTTP_STATUS, (this.onExternalDataHttpStatus : ASAny));
            _local_2.addEventListener(Event.COMPLETE, (this.onExternalDataLoaded : ASAny));
            _local_2.addEventListener(IOErrorEvent.IO_ERROR, (this.onExternalDataError : ASAny));
        }

        function onExternalDataHttpStatus(k:HTTPStatusEvent)
        {
            if (((k.status == 403) && this.ownHandler.hasRightsToRemove()))
            {
                this._moderationText.visible = true;
            }
        }

        function onExternalDataError(k:Event)
        {
            if (!this._moderationText.visible)
            {
                Logger.log([("Extra data loading failed: " + k.toString())]);
            }
        }

        function onExternalDataLoaded(k:Event)
        {
            var _local_2:String = cast(k.target, URLLoader).data;
            if (_local_2.length == 0)
            {
                return;
            }
            this.loadPhoto(_local_2, null);
        }

        override public function dispose()
        {
            if (this._window == null)
            {
                return;
            }
            this._imageContainer = null;
            this._closeButton = null;
            this._bgBorder = null;
            this._makeOwnButton = null;
            this._deleteButton = null;
            this._bitmapLoader = null;
            this._inventory = null;
            this._help = null;
            this._roomEngine = null;
            this._senderId = 0;
            this._senderNameButton = null;
            this._nameCopyField = null;
            this._buttonContainer = null;
            this._shareArea = null;
            this._window.procedure = null;
            this._window.dispose();
            this._component = null;
            super.dispose();
            if (this._reportImageContainer != null)
            {
                this._reportImageContainer.destroy();
            }
        }

        public function hide()
        {
            this._window.visible = false;
        }

        function updateWindowPosition()
        {
            if (this._currentImage == null)
            {
                this._window.center();
                return;
            }
            var k= this._component.context.displayObjectContainer.stage;
            var _local_2= ((k.stageWidth - 100) / this._currentImage.width);
            var _local_3= ((k.stageHeight - 200) / this._currentImage.height);
            if (_local_2 < 1)
            {
                this._window.x = 50;
            }
            else
            {
                this._window.x = Std.int((k.stageWidth - this._window.width) * 0.5);
            }
            if (_local_3 < 1)
            {
                this._window.y = 50;
            }
            else
            {
                this._window.y = Std.int((k.stageHeight - this._window.height) * 0.5);
            }
            var _local_4= this._window.findChildByName("previousButton");
            var _local_5= this._window.findChildByName("nextButton");
            var _local_6= this._component.context.displayObjectContainer.stage.stageHeight;
            if (this._bgBorder.height > _local_6)
            {
                _local_4.y = (_local_5.y = Std.int((_local_6 / 2) - (_local_4.height / 2)));
            }
            else
            {
                _local_4.y = (_local_5.y = Std.int((this._bgBorder.height / 2) - (_local_4.height / 2)));
            }
        }

        function onWindowEvent(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:IConfirmDialog = null;
            var _local_4:ITextFieldWindow = null;
            var _local_5:HabboToolbarEvent = null;
            if ((_arg_2 : ASAny) == (this._window : ASAny))
            {
                switch (k.type)
                {
                    case WindowEvent.WINDOW_EVENT_PARENT_RESIZED:
                        this.updateWindowPosition();
                        
                }
            }
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "closebutton":
                    this.hide();
                    return;
                case "removebutton":
                    _local_3 = windowManager.confirm(_localizations.getLocalization("inventory.remove.external_image_wallitem_header"), _localizations.getLocalization("inventory.remove.external_image_wallitem_body"), 0, this.onDeleteConfirm);
                    _local_3.setButtonCaption(HabboAlertDialogFlag.BUTTON_OK, new AlertDialogCaption(_localizations.getLocalization("inventory.remove.external_image_wallitem_delete"), "", true));
                    return;
                case "makeOwnButton":
                    if (this.getType() == PHOTO_POSTER)
                    {
                        _local_5 = new HabboToolbarEvent(HabboToolbarEvent.HTE_ICON_CAMERA);
                        _local_5.iconName = HabboToolbarEvent.IMAGEWIDGETMAKEOWN;
                        this.ownHandler.container.toolbar.events.dispatchEvent(_local_5);
                        this.hide();
                    }
                    else
                    {
                        if (this._component.getInteger("spaweb", 0) == 1)
                        {
                            HabboWebTools.openPage("/stories/cards/selfie/edit");
                        }
                        else
                        {
                            this._component.context.createLinkEvent("games/play/elisa_habbo_stories?ref=btn_selfie_myo");
                        }
                    }
                    return;
                case "shareButton":
                    this._shareArea.visible = true;
                    HabboTracking.getInstance().trackEventLog("Stories", "shareopened", "stories.share.clicked", this._roomObjectType);
                    return;
                case "twitterShare":
                    flash.Lib.getURL(new URLRequest(("http://www.twitter.com/share?url=" + this._shareUrl)), "_blank");
                    HabboTracking.getInstance().trackEventLog("Stories", "twitter", "stories.share.clicked", this._roomObjectType);
                    return;
                case "fbShare":
                    flash.Lib.getURL(new URLRequest(("https://www.facebook.com/sharer/sharer.php?u=" + this._shareUrl)), "_blank");
                    HabboTracking.getInstance().trackEventLog("Stories", "facebook", "stories.share.clicked", this._roomObjectType);
                    return;
                case "senderNameButton":
                    this.ownHandler.sendMessage(new GetExtendedProfileMessageComposer(this._senderId));
                    return;
                case "urlField":
                    _local_4 = Std.downcast(this._window.findChildByName("urlField") , ITextFieldWindow);
                    _local_4.setSelection(0, _local_4.length);
                    HabboTracking.getInstance().trackEventLog("Stories", "fieldselected", "stories.share.clicked", this._roomObjectType);
                    return;
                case "reportButton":
                    this.openReportImage();
                    return;
                case "nextButton":
                    this.showNext();
                    return;
                case "previousButton":
                    this.showPrevious();
                    return;
            }
        }

        function onClickModerationInfoLink(k:WindowLinkEvent)
        {
            if (((!(k == null)) && (!StringUtils.isEmpty(k.link))))
            {
                flash.Lib.getURL(new URLRequest(k.link), "_blank");
            }
        }

        function openReportImage()
        {
            this._help.startPhotoReportingInNewCfhFlow(this._senderId, this._senderNameText.caption, this._extraDataID, this._roomObjectID);
        }

        function getType():String
        {
            switch (this._roomObjectType)
            {
                case "external_image_wallitem_poster"
                   | "external_image_wallitem_poster_small":
                    return PHOTO_POSTER;
                case "external_image_wallitem":
                    return SELFIE;
            }
            return LEGACY;
        }

        function onReportWindowEvent(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            var _local_4:IWindow = null;
            var _local_5:String = null;
            var _local_6:IWindow = null;
            var _local_7 = false;
            var _local_8:ISelectableWindow = null;
            var _local_9:IIlluminaInputWidget = null;
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close":
                    this._reportImageContainer.destroy();
                    return;
                case "report_confirm":
                    _local_3 = 0;
                    _local_4 = this._reportImageContainer.findChildByName("reporting_reason");
                    if (_local_4 != null)
                    {
                        _local_8 = cast(_local_4, ISelectorWindow).getSelected();
                        if (_local_8 != null)
                        {
                            _local_3 = ASCompat.toInt(_local_8.name);
                        }
                    }
                    _local_5 = null;
                    _local_6 = this._reportImageContainer.findChildByName("input_widget");
                    if (_local_6 != null)
                    {
                        _local_9 = Std.downcast(Std.downcast(_local_6 , IWidgetWindow).widget , IIlluminaInputWidget);
                        _local_5 = _local_9.message;
                    }
                    if (!ASCompat.stringAsBool(this._shareUrl))
                    {
                        this._shareUrl = "url not available";
                    }
                    if (this.getType() == PHOTO_POSTER)
                    {
                        _local_7 = this._help.reportPhoto(this._extraDataID, _local_3, this._roomEngine.activeRoomId, this._senderId, this._roomObjectID);
                    }
                    else
                    {
                        _local_7 = this._help.reportSelfie(this._shareUrl, _local_5, this._roomEngine.activeRoomId, this._senderId, this._roomObjectID);
                    }
                    if (_local_7)
                    {
                        this._reportImageContainer.destroy();
                    }
                    return;
            }
        }

        function onDeleteConfirm(k:IConfirmDialog, _arg_2:WindowEvent)
        {
            k.dispose();
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
            {
                this.ownHandler.deleteCard(this._roomObjectID);
            }
        }
    }

