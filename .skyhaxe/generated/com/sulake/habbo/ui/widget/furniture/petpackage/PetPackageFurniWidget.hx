package com.sulake.habbo.ui.widget.furniture.petpackage
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.components.IFrameWindow;
    import flash.display.BitmapData;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.widget.events._Str_3085;
    import flash.events.IEventDispatcher;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.geom.Point;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetOpenPetPackageMessage;
    import com.sulake.core.window.components.ITextFieldWindow;

     class PetPackageFurniWidget extends RoomWidgetBase
    {
        static inline final _Str_22236= 26;

        var _window:IFrameWindow;
        var _typeId:Int = -1;
        var _objectId:Int = -1;
        var _petImage:BitmapData;
        var _openPetPackageRequested:Bool = false;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        override public function dispose()
        {
            this._Str_2718();
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(_Str_3085.RWOPPUE_OPEN_PET_PACKAGE_REQUESTED, this.onObjectUpdate);
            k.addEventListener(_Str_3085.RWOPPUE_OPEN_PET_PACKAGE_RESULT, this.onObjectUpdate);
            k.addEventListener(_Str_3085.RWOPPUE_OPEN_PET_PACKAGE_UPDATE_PET_IMAGE, this.onObjectUpdate);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(_Str_3085.RWOPPUE_OPEN_PET_PACKAGE_REQUESTED, this.onObjectUpdate);
            k.removeEventListener(_Str_3085.RWOPPUE_OPEN_PET_PACKAGE_RESULT, this.onObjectUpdate);
            k.removeEventListener(_Str_3085.RWOPPUE_OPEN_PET_PACKAGE_UPDATE_PET_IMAGE, this.onObjectUpdate);
            super.unregisterUpdateEvents(k);
        }

        function onObjectUpdate(event:_Str_3085)
        {
            var nameValidationStatus = 0;
            var nameValidationInfo:String = null;
            var error:String = null;
            var resultMessage:String = null;
            switch (event.type)
            {
                case _Str_3085.RWOPPUE_OPEN_PET_PACKAGE_REQUESTED:
                    this._Str_2718();
                    this._objectId = event.objectId;
                    this._petImage = event.image;
                    this._typeId = event.typeId;
                    this.showInterface();
                    this._Str_18625();
                    return;
                case _Str_3085.RWOPPUE_OPEN_PET_PACKAGE_RESULT:
                    if (!this._openPetPackageRequested)
                    {
                        return;
                    }
                    this._openPetPackageRequested = false;
                    nameValidationStatus = event.nameValidationStatus;
                    nameValidationInfo = event.nameValidationInfo;
                    switch (nameValidationStatus)
                    {
                        case 0:
                            this._Str_2718();
                            return;
                        case 1:
                            error = "long";
                            
                        case 2:
                            error = "short";
                            
                        case 3:
                            error = "chars";
                            
                        default:
                            error = "bobba";
                    }
                    resultMessage = this._Str_4902(error, nameValidationInfo);
                    windowManager.alert("${widgets.petpackage.alert.petname.title}", resultMessage, 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:WindowEvent)
                    {
                        k.dispose();
                    });
                    return;
                case _Str_3085.RWOPPUE_OPEN_PET_PACKAGE_UPDATE_PET_IMAGE:
                    if (event.objectId != this._objectId)
                    {
                        return;
                    }
                    this._petImage = event.image;
                    this._Str_18625();
                    return;
            }
        }

        function _Str_4902(k:String, _arg_2:String):String
        {
            var _local_3= ("catalog.alert.petname." + k);
            var _local_4:ASAny = (_local_3 + ".additionalInfo");
            localizations.registerParameter(_local_4, "additional_info", _arg_2);
            var _local_5= localizations.getLocalization(_local_3);
            var _local_6= localizations.getLocalization(_local_4);
            if (((((!(_arg_2 == null)) && (_arg_2.length > 0)) && (!(_local_6 == null))) && (_local_6.length > 0)))
            {
                _local_5 = _local_6;
            }
            return _local_5;
        }

        function _Str_2718()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._objectId = -1;
            this._openPetPackageRequested = false;
            this._petImage = null;
        }

        function showInterface()
        {
            var _local_4:IWindow = null;
            if (this._objectId < 0)
            {
                return;
            }
            var k= ((this._petImage != null) ? assets.getAssetByName("petpackage") : assets.getAssetByName("petpackage_new"));
            var _local_2= cast(k, XmlAsset);
            if (_local_2 == null)
            {
                return;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._window = Std.downcast(windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_local_2.content)) , IFrameWindow);
            this._window.center();
            var _local_3= this._window.header.findChildByTag("close");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onWindowClose);
            }
            _local_4 = this._window.findChildByName("pick_name");
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
            }
            _local_4 = this._window.findChildByName("cancel");
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
            }
            this._window.addEventListener(WindowMouseEvent.CLICK, this.onMouseEvent);
            this._Str_18625();
        }

        function _Str_18625()
        {
            var _local_2:Point = null;
            if (((this._petImage == null) || (this._window == null)))
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("pet_image") , IBitmapWrapperWindow);
            if (k != null)
            {
                k.bitmap = new BitmapData(k.width, k.height, true, 0);
                _local_2 = new Point(((k.width - this._petImage.width) / 2), ((k.height - this._petImage.height) / 2));
                k.bitmap.copyPixels(this._petImage, this._petImage.rect, _local_2);
            }
        }

        function onWindowClose(k:WindowEvent)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._Str_2718();
        }

        function onMouseEvent(k:WindowMouseEvent)
        {
            var _local_2= k.target ;
            var _local_3= _local_2.name;
            switch (_local_3)
            {
                case "pick_name":
                    this._Str_24245();
                    return;
                case "cancel":
                    this._Str_2718();
                    return;
            }
        }

        function _Str_24245()
        {
            var message:RoomWidgetOpenPetPackageMessage = null;
            if ((this._openPetPackageRequested || (this._objectId == -1)))
            {
                return;
            }
            var name= this.getName();
            if (((name == null) || (name.length < 1)))
            {
                windowManager.alert("${widgets.petpackage.alert.petname.title}", "${catalog.alert.petname.short}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:WindowEvent)
                {
                    k.dispose();
                });
                return;
            }
            if (messageListener != null)
            {
                this._openPetPackageRequested = true;
                message = new RoomWidgetOpenPetPackageMessage(RoomWidgetOpenPetPackageMessage.RWOPPM_OPEN_PET_PACKAGE, this._objectId, name);
                messageListener.processWidgetMessage(message);
            }
        }

        function getName():String
        {
            var k:ITextFieldWindow = null;
            if (this._window != null)
            {
                k = Std.downcast(this._window.findChildByName("input") , ITextFieldWindow);
                if (k != null)
                {
                    return k.text;
                }
            }
            return null;
        }
    }

