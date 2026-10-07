package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.session.RoomUserData;
    import flash.display.BitmapData;
    import com.sulake.habbo.avatar.pets.PetFigureData;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;

     class BreedMonsterPlantsConfirmationView implements IDisposable implements  IGetImageListener 
    {
        static inline final _Str_13053= 0;
        static inline final _Str_15445= 1;
        static inline final ELEMENT_LIST= "element_list";
        static inline final PREVIEW_LIST= "preview_list";
        static inline final ELEM_PLANT1_ITEMLIST= "plant1_itemlist";
        static inline final ELEM_PLANT2_ITEMLIST= "plant2_itemlist";
        static inline final DESCRIPTION= "description";
        static inline final REQUEST= "request";
        static inline final HEADER_BUTTON_CLOSE= "header_button_close";
        static inline final SAVE_BUTTON= "save_button";
        static inline final ACCEPT_BUTTON= "accept_button";
        static inline final CANCEL_BUTTON= "cancel_button";
        static inline final OK_BUTTON= "ok_button";
        static inline final BUTTON_LIST= "button_list";

        var _window:IFrameWindow;
        var _disposed:Bool = false;
        var _widget:AvatarInfoWidget;
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _Str_2879:Map;
        var _Str_3748:Int = 0;
        var _Str_4105:Int = 0;
        var _roomUserData:RoomUserData;
        var _petData2:RoomUserData;
        var _state:Int = 0;

        public function new(k:AvatarInfoWidget)
        {
            this._widget = k;
            this._windowManager = k.windowManager;
            this._assets = this._widget.assets;
            this._Str_2879 = new Map();
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._Str_2879 != null)
            {
                this._Str_2879.dispose();
            }
            this._Str_2879 = null;
        }

        public var _Str_3710(get,never):Int;
public function  get__Str_3710():Int
        {
            return this._Str_3748;
        }

        public var _Str_5563(get,never):Int;
public function  get__Str_5563():Int
        {
            return this._Str_4105;
        }

        public function open(k:Int, _arg_2:Int, _arg_3:Bool)
        {
            this._Str_3748 = k;
            this._Str_4105 = _arg_2;
            this._roomUserData = this._widget.handler.roomSession.userDataManager.getUserDataByIndex(k);
            this._petData2 = this._widget.handler.roomSession.userDataManager.getUserDataByIndex(_arg_2);
            this._state = (_arg_3 ? _Str_15445 : _Str_13053);
            this._Str_3248();
            this._window.visible = true;
        }

        function _Str_3993(k:String, _arg_2:String):BitmapData
        {
            var _local_4:BitmapData = null;
            var _local_7 = 0;
            var _local_3= new PetFigureData(k);
            var _local_5= "std";
            var _local_6= this._widget.handler.roomEngine.getPetImage(_local_3.typeId, _local_3.paletteId, _local_3.color, new Vector3d(90), 64, this, true, 0, _local_3._Str_3542, _local_5);
            if (_local_6 != null)
            {
                _local_7 = _local_6.id;
                if (_local_7 > 0)
                {
                    this._Str_2879.add(_local_7, _arg_2);
                }
                _local_4 = _local_6.data;
            }
            return _local_4;
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if (this.disposed)
            {
                return;
            }
            var _local_3:String = this._Str_2879.getValue(k);
            if (_local_3 != null)
            {
                this._Str_3060(_arg_2, _local_3);
            }
        }

        public function imageFailed(k:Int)
        {
        }

        function _Str_3248()
        {
            this._widget.localizations.registerParameter("breedpets.widget.title", "name", this._roomUserData.name);
            this._widget.localizations.registerParameter("breedpets.widget.plant1.name", "name", this._roomUserData.name);
            this._widget.localizations.registerParameter("breedpets.widget.plant2.name", "name", this._petData2.name);
            this._widget.localizations.registerParameter("breedpets.widget.plant1.description", "name", this._roomUserData.ownerName);
            this._widget.localizations.registerParameter("breedpets.widget.plant2.description", "name", this._petData2.ownerName);
            this._widget.localizations.registerParameter("breedpets.widget.plant1.raritylevel", "level", Std.string(this._roomUserData.rarityLevel));
            this._widget.localizations.registerParameter("breedpets.widget.plant2.raritylevel", "level", Std.string(this._petData2.rarityLevel));
            this._widget.localizations.registerParameter("breedpets.widget.request", "name", this._petData2.ownerName);
            if (this._window == null)
            {
                this._window = Std.downcast(this._windowManager.buildFromXML(((this._assets.getAssetByName("breed_pets_confirmation_xml").content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
                this.addClickListener(HEADER_BUTTON_CLOSE);
            }
            this._window.center();
            this._window.visible = true;
            this.addClickListener(SAVE_BUTTON);
            this.addClickListener(ACCEPT_BUTTON);
            this.addClickListener(CANCEL_BUTTON);
            this.enableElement(DESCRIPTION, false);
            this.enableElement(REQUEST, false);
            this.enableElement(SAVE_BUTTON, false);
            this.enableElement(SAVE_BUTTON, false);
            this.enableElement(ACCEPT_BUTTON, false);
            this.enableElement(CANCEL_BUTTON, true);
            this.enableElement(CANCEL_BUTTON, true);
            switch (this._state)
            {
                case _Str_13053:
                    this.enableElement(DESCRIPTION, true);
                    this.enableElement(SAVE_BUTTON, true);
                    
                case _Str_15445:
                    this.enableElement(REQUEST, true);
                    this.enableElement(ACCEPT_BUTTON, true);
                    
            }
            var k= this._Str_3993(this._roomUserData.figure, "preview_image");
            this._Str_3060(((k != null) ? k : new BitmapData(10, 10)), "preview_image");
            k = this._Str_3993(this._petData2.figure, "preview_image2");
            this._Str_3060(((k != null) ? k : new BitmapData(10, 10)), "preview_image2");
            this.arrangeListItems();
            this._window.invalidate();
        }

        function arrangeListItems()
        {
            this._Str_3441(BUTTON_LIST);
            this._Str_3441(ELEM_PLANT1_ITEMLIST);
            this._Str_3441(ELEM_PLANT2_ITEMLIST);
            this._Str_3441(PREVIEW_LIST);
            this._Str_3441(ELEMENT_LIST);
            this._window._Str_5665();
        }

        function _Str_3441(k:String)
        {
            var _local_2= Std.downcast(this._window.findChildByName(k) , IItemListWindow);
            if (_local_2 != null)
            {
                _local_2.arrangeListItems();
            }
        }

        function _Str_3060(k:BitmapData, _arg_2:String)
        {
            var _local_6:BitmapData = null;
            if (((!(this._window != null)) || (!(k != null))))
            {
                return;
            }
            var _local_3= Std.downcast(this._window.findChildByName(_arg_2) , IBitmapWrapperWindow);
            _local_3.bitmap = new BitmapData(_local_3.width, _local_3.height);
            var _local_4= this._assets.getAssetByName("breed_pets_preview_bg_png") ;
            if (_local_4 != null)
            {
                _local_6 = ASCompat.dynamicAs(_local_4.content , BitmapData);
                _local_3.bitmap.copyPixels(_local_6, _local_6.rect, new Point(0, 0));
            }
            var _local_5= new Point(((_local_3.width - k.width) / 2), ((_local_3.height - k.height) / 2));
            _local_3.bitmap.copyPixels(k, k.rect, _local_5, null, null, true);
        }

        function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        function addClickListener(k:String)
        {
            var _local_2= this._window.findChildByName(k);
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.onMouseClick);
            }
        }

        function enableElement(k:String, _arg_2:Bool)
        {
            var _local_3= this._window.findChildByName(k);
            if (_local_3 != null)
            {
                _local_3.visible = _arg_2;
            }
        }

        function onMouseClick(k:WindowMouseEvent)
        {
            switch (k.target.name)
            {
                case HEADER_BUTTON_CLOSE
                   | CANCEL_BUTTON:
                    this._widget._Str_19339(this._Str_3748, this._Str_4105);
                    this.close();
                    return;
                case OK_BUTTON:
                    this.close();
                    return;
                case ACCEPT_BUTTON:
                    this.close();
                    this._widget._Str_24933(this._Str_3748, this._Str_4105);
                    return;
                case SAVE_BUTTON:
                    this._widget._Str_22619(this._Str_3748, this._Str_4105);
                    if (this._roomUserData.ownerId != this._petData2.ownerId)
                    {
                        this._widget.showBreedingPetsWaitingConfirmationAlert(this._Str_3710, this._Str_4105);
                    }
                    this.close();
                    return;
            }
        }
    }

