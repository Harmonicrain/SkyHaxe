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
    import com.sulake.habbo.ui.widget.events._Str_5914;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;

     class ConfirmPetBreedingView implements IDisposable implements  IGetImageListener 
    {
        static inline final ELEMENT_LIST= "element_list";
        static inline final PREVIEW_LIST= "preview_list";
        static inline final ELEM_PET1_ITEMLIST= "pet1_itemlist";
        static inline final ELEM_PET2_ITEMLIST= "pet2_itemlist";
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
        var _Str_25917:Bool = false;
        var _Str_2595:Int = 0;
        var _rarityCategories:Array<ASAny>;
        var _resultPetTypeId:Int = 0;

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

        public function open(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Array<ASAny>, _arg_5:Int, _arg_6:Int, _arg_7:Int)
        {
            this._Str_3748 = k;
            this._Str_4105 = _arg_2;
            this._roomUserData = this._widget.handler.roomSession.userDataManager.getUserDataByIndex(k);
            this._petData2 = this._widget.handler.roomSession.userDataManager.getUserDataByIndex(_arg_2);
            this._roomUserData.petLevel = _arg_6;
            this._petData2.petLevel = _arg_7;
            this._rarityCategories = _arg_4;
            this._resultPetTypeId = _arg_5;
            this._Str_2595 = _arg_3;
            this._Str_3248();
            this._window.visible = true;
        }

        function _Str_3993(k:String, _arg_2:String, _arg_3:Int=64):BitmapData
        {
            var _local_5:BitmapData = null;
            var _local_8 = 0;
            var _local_4= new PetFigureData(k);
            var _local_6= "std";
            var _local_7= this._widget.handler.roomEngine.getPetImage(_local_4.typeId, _local_4.paletteId, _local_4.color, new Vector3d(90), _arg_3, this, true, 0, _local_4._Str_3542, _local_6);
            if (_local_7 != null)
            {
                _local_8 = _local_7.id;
                if (_local_8 > 0)
                {
                    this._Str_2879.add(_local_8, _arg_2);
                }
                _local_5 = _local_7.data;
            }
            return _local_5;
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
            var _local_4:_Str_5914 = null;
            var _local_5:IItemListWindow = null;
            var _local_6 = 0;
            var _local_7:PetFigureData = null;
            var _local_8:IBitmapWrapperWindow = null;
            this._widget.localizations.registerParameter("breedpets.widget.title", "name", this._roomUserData.name);
            this._widget.localizations.registerParameter("breedpets.widget.pet1.name", "name", this._roomUserData.name);
            this._widget.localizations.registerParameter("breedpets.widget.pet2.name", "name", this._petData2.name);
            this._widget.localizations.registerParameter("breedpets.widget.pet1.description", "name", this._roomUserData.ownerName);
            this._widget.localizations.registerParameter("breedpets.widget.pet2.description", "name", this._petData2.ownerName);
            this._widget.localizations.registerParameter("breedpets.widget.pet1.level", "level", Std.string(this._roomUserData.petLevel));
            this._widget.localizations.registerParameter("breedpets.widget.pet2.level", "level", Std.string(this._petData2.petLevel));
            this._widget.localizations.registerParameter("breedpets.widget.request", "name", this._petData2.ownerName);
            if (this._window == null)
            {
                this._window = Std.downcast(this._windowManager.buildFromXML(((this._assets.getAssetByName("confirm_pet_breeding_xml").content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
                this.addClickListener(HEADER_BUTTON_CLOSE);
            }
            this._window.center();
            this._window.visible = true;
            this.addClickListener(SAVE_BUTTON);
            this.addClickListener(CANCEL_BUTTON);
            this.enable();
            var k= this._Str_3993(this._roomUserData.figure, "preview_image");
            this._Str_3060(((k != null) ? k : new BitmapData(10, 10)), "preview_image");
            k = this._Str_3993(this._petData2.figure, "preview_image2");
            this._Str_3060(((k != null) ? k : new BitmapData(10, 10)), "preview_image2");
            var _local_2= Std.downcast(this._windowManager.buildFromXML(((this._assets.getAssetByName("pet_breeding_pet_preview_xml").content : com.sulake.core.utils.xml.XML) )) , IBitmapWrapperWindow);
            var _local_3= 1;
            final _iter_ = this._rarityCategories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                this._widget.localizations.registerParameter(("breedpets.confirmation.widget.raritycategory." + Std.string(_local_3)), "percent", Std.string(_local_4._Str_12554));
                _local_5 = Std.downcast(this._window.findChildByName(("breeds" + Std.string(_local_3))) , IItemListWindow);
                _local_5.removeListItems();
                final _iter_ = _local_4.breeds; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_6  = ASCompat.toInt(_tmp_);
                    _local_7 = new PetFigureData(([this._resultPetTypeId, _local_6] : Array<Dynamic>).join(" "));
                    _local_8 = Std.downcast(_local_2.clone() , IBitmapWrapperWindow);
                    _local_8.name = ("breed." + Std.string(_local_6));
                    _local_8.bitmap = new BitmapData(_local_8.width, _local_8.height, true, 0xFFFFFF);
                    if (_local_5 != null)
                    {
                        _local_5.addListItem(_local_8);
                    }
                    k = this._Str_3993(_local_7.figureString, _local_8.name, 64);
                    this._Str_3060(((k != null) ? k : new BitmapData(25, 25, true, 0xFFFFFF)), _local_8.name);
                }
                _local_3++;
            }
            this.arrangeListItems();
            Std.downcast(this._window.findChildByName("puppy.name.input") , ITextFieldWindow).setSelection(0, 0);
            this._window.invalidate();
        }

        function arrangeListItems()
        {
            this._Str_3441(BUTTON_LIST);
            this._Str_3441(ELEM_PET1_ITEMLIST);
            this._Str_3441(ELEM_PET2_ITEMLIST);
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
            if (((!(this._window != null)) || (!(k != null))))
            {
                return;
            }
            var _local_3= Std.downcast(this._window.findChildByName(_arg_2) , IBitmapWrapperWindow);
            _local_3.bitmap = new BitmapData(_local_3.width, _local_3.height, true, 0xFFFFFF);
            var _local_4= new Point(((_local_3.width - k.width) / 2), ((_local_3.height - k.height) / 2));
            _local_3.bitmap.copyPixels(k, k.rect, _local_4, null, null, true);
        }

        public function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        function disable()
        {
            this.enableElement(DESCRIPTION, false, false);
            this.enableElement(REQUEST, false, false);
            this.enableElement(CANCEL_BUTTON, false, true);
            this.enableElement(DESCRIPTION, false, true);
            this.enableElement(SAVE_BUTTON, false, true);
        }

        public function enable()
        {
            this.enableElement(DESCRIPTION, false, false);
            this.enableElement(REQUEST, false, false);
            this.enableElement(CANCEL_BUTTON, true, true);
            this.enableElement(DESCRIPTION, true, true);
            this.enableElement(SAVE_BUTTON, true, true);
        }

        function addClickListener(k:String)
        {
            var _local_2= this._window.findChildByName(k);
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.onMouseClick);
            }
        }

        function enableElement(k:String, _arg_2:Bool, _arg_3:Bool)
        {
            var _local_4= this._window.findChildByName(k);
            if (_local_4 != null)
            {
                _local_4.visible = _arg_3;
                if (_arg_2)
                {
                    _local_4.enable();
                }
                else
                {
                    _local_4.disable();
                }
            }
        }

        function onMouseClick(k:WindowMouseEvent)
        {
            var _local_2:String = null;
            switch (k.target.name)
            {
                case HEADER_BUTTON_CLOSE
                   | CANCEL_BUTTON:
                    this._widget._Str_24617(this._Str_2595);
                    this.close();
                    return;
                case OK_BUTTON:
                    this.disable();
                    return;
                case SAVE_BUTTON:
                    _local_2 = this._window.findChildByName("puppy.name.input").caption;
                    if (_local_2.length == 0)
                    {
                        this._windowManager.simpleAlert("${breedpets.confirmation.alert.title}", "${breedpets.confirmation.alert.name.required.head}", "${breedpets.confirmation.alert.name.required.desc}");
                    }
                    else
                    {
                        this._widget._Str_23246(this._Str_2595, _local_2, this._roomUserData.id, this._petData2.id);
                        this.disable();
                    }
                    return;
            }
        }
    }

