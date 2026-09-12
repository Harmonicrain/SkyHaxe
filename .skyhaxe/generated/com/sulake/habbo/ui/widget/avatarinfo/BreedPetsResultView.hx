package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.utils.Map;
    import flash.display.BitmapData;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.inventory.items.IFurnitureItem;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectOperationEnum;
    import com.sulake.habbo.inventory._enum.FurniCategory;

     class BreedPetsResultView implements IDisposable implements  IGetImageListener 
    {
        static inline final ELEMENT_LIST= "element_list";
        static inline final PREVIEW_LIST= "preview_list";
        static inline final PREVIEW_BUTTONLIST= "preview_buttonlist";
        static inline final ELEM_SEED1_ITEMLIST= "seed1_itemlist";
        static inline final ELEM_SEED2_ITEMLIST= "seed2_itemlist";
        static inline final ELEM_SEED1_BUTTONLIST= "seed1_buttonlist";
        static inline final ELEM_SEED2_BUTTONLIST= "seed2_buttonlist";
        static inline final HEADER_BUTTON_CLOSE= "header_button_close";
        static inline final CLOSE_BUTTON= "close_button";
        static inline final SAVE_BUTTON= "save_button";
        static inline final ELEM_PLACE_BUTTON1= "place_button1";
        static inline final ELEM_PLACE_BUTTON2= "place_button2";
        static inline final ELEM_PICK_BUTTON1= "pick_button1";
        static inline final ELEM_PICK_BUTTON2= "pick_button2";
        static inline final PREVIEW_IMAGE= "preview_image";
        static inline final ELEM_PREVIEW_IMAGE2= "preview_image2";
        static inline final PREVIEW_IMAGE_REGION= "preview_image_region";
        static inline final ELEM_PREVIEW_IMAGE_REGION2= "preview_image_region2";
        static inline final BUTTON_LIST= "button_list";
        static inline final DESCRIPTION= "description";
        static inline final DESCRIPTION_SORRY= "description_sorry";
        static inline final INFO= "info";
        static inline final INFO_SORRY= "info_sorry";
        static inline final ELEM_INFO_MUTATE1= "info_mutate1";
        static inline final ELEM_INFO_MUTATE2= "info_mutate2";
        static inline final OK_BUTTON= "ok_button";

        var _window:IFrameWindow;
        var _disposed:Bool = false;
        var _widget:AvatarInfoWidget;
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _Str_2879:Map;
        var _Str_3111:BreedPetsResultData;
        var _resultData2:BreedPetsResultData;
        var _Str_10220:Bool = false;

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

        public function open(k:BreedPetsResultData, _arg_2:BreedPetsResultData)
        {
            this._Str_3111 = k;
            this._resultData2 = _arg_2;
            this._Str_3248();
            this.show();
        }

        function _Str_3993(k:Int, _arg_2:String):BitmapData
        {
            var _local_3:BitmapData = null;
            var _local_5 = 0;
            var _local_4= this._widget.handler.container.roomEngine.getFurnitureImage(k, new Vector3d(90, 0, 0), 64, this, 0, null, -1, -1, null);
            if (_local_4 != null)
            {
                _local_5 = _local_4.id;
                if (_local_5 > 0)
                {
                    this._Str_2879.add(_local_5, _arg_2);
                }
                _local_3 = _local_4.data;
            }
            return _local_3;
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
            var _local_8:String = null;
            var k= this._widget.handler.container.sessionDataManager.getFloorItemData(this._Str_3111.classId);
            var _local_2= this._widget.handler.container.sessionDataManager.getFloorItemData(this._resultData2.classId);
            this._widget.localizations.registerParameter("breedpetsresult.widget.seed1.name", "name", ((k != null) ? k.localizedName : ""));
            this._widget.localizations.registerParameter("breedpetsresult.widget.seed2.name", "name", ((_local_2 != null) ? _local_2.localizedName : ""));
            this._widget.localizations.registerParameter("breedpetsresult.widget.seed1.description", "name", this._Str_3111.userName);
            this._widget.localizations.registerParameter("breedpetsresult.widget.seed2.description", "name", this._resultData2.userName);
            this._widget.localizations.registerParameter("breedpetsresult.widget.seed1.raritylevel", "level", Std.string(this._Str_3111.rarityLevel));
            this._widget.localizations.registerParameter("breedpetsresult.widget.seed2.raritylevel", "level", Std.string(this._resultData2.rarityLevel));
            var _local_3= this._widget.handler.container.sessionDataManager.userId;
            var _local_4:ASAny = (this._Str_3111.userId == _local_3);
            var _local_5:ASAny = (this._resultData2.userId == _local_3);
            var _local_6= (ASCompat.toBool(_local_4) || ASCompat.toBool(_local_5));
            if (!_local_6)
            {
                _local_8 = "";
                if (((!(this._Str_3111.userName == null)) && (!(this._Str_3111.userName == ""))))
                {
                    _local_8 = this._Str_3111.userName;
                }
                else
                {
                    if (((!(this._resultData2.userName == null)) && (!(this._resultData2.userName == ""))))
                    {
                        _local_8 = this._resultData2.userName;
                    }
                }
                this._widget.localization.registerParameter("breedpetsresult.widget.text.sorry", "name", _local_8);
            }
            if (this._window == null)
            {
                this._window = Std.downcast(this._windowManager.buildFromXML(((this._assets.getAssetByName("breed_pets_result_xml").content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
                this.addClickListener(HEADER_BUTTON_CLOSE);
            }
            this._window.center();
            this._window.visible = true;
            this.enableElement(ELEM_SEED1_BUTTONLIST, false);
            this.enableElement(ELEM_SEED2_BUTTONLIST, false);
            this.enableElement(ELEM_PLACE_BUTTON1, false);
            this.enableElement(ELEM_PICK_BUTTON1, false);
            this.enableElement(ELEM_PLACE_BUTTON2, false);
            this.enableElement(ELEM_PICK_BUTTON2, false);
            this.enableElement(CLOSE_BUTTON, false);
            if (_local_4)
            {
                this.enableElement(ELEM_PLACE_BUTTON1, true);
                this.enableElement(ELEM_SEED1_BUTTONLIST, true);
            }
            if (_local_5)
            {
                this.enableElement(ELEM_PLACE_BUTTON2, true);
                this.enableElement(ELEM_SEED2_BUTTONLIST, true);
            }
            if (_local_6)
            {
                this.enableElement(PREVIEW_BUTTONLIST, true);
            }
            this.enableElement(ELEM_SEED2_ITEMLIST, true);
            if (this._resultData2.stuffId == -1)
            {
                this.enableElement(ELEM_SEED2_ITEMLIST, false);
            }
            this.enableElement(DESCRIPTION, true);
            this.enableElement(INFO, true);
            this.enableElement(DESCRIPTION_SORRY, false);
            this.enableElement(INFO, false);
            this.enableElement(BUTTON_LIST, false);
            this.enableElement(CLOSE_BUTTON, false);
            if (!_local_6)
            {
                this.enableElement(PREVIEW_BUTTONLIST, false);
                this.enableElement(DESCRIPTION, false);
                this.enableElement(INFO, false);
                this.enableElement(SAVE_BUTTON, false);
                this.enableElement(ELEM_PLACE_BUTTON1, false);
                this.enableElement(ELEM_PICK_BUTTON1, false);
                this.enableElement(ELEM_PLACE_BUTTON2, false);
                this.enableElement(ELEM_PICK_BUTTON2, false);
                this.enableElement(BUTTON_LIST, true);
                this.enableElement(DESCRIPTION_SORRY, true);
                this.enableElement(INFO_SORRY, true);
                this.enableElement(CLOSE_BUTTON, true);
            }
            this.enableElement(ELEM_INFO_MUTATE1, false);
            this.enableElement(ELEM_INFO_MUTATE2, false);
            if (this._Str_3111._Str_4788)
            {
                this.enableElement(ELEM_INFO_MUTATE1, true);
            }
            if (this._resultData2._Str_4788)
            {
                this.enableElement(ELEM_INFO_MUTATE2, true);
            }
            this.addClickListener(SAVE_BUTTON);
            this.addClickListener(HEADER_BUTTON_CLOSE);
            this.addClickListener(CLOSE_BUTTON);
            this.addClickListener(ELEM_PLACE_BUTTON1);
            this.addClickListener(ELEM_PLACE_BUTTON2);
            this.addClickListener(ELEM_PICK_BUTTON1);
            this.addClickListener(ELEM_PICK_BUTTON2);
            this.addClickListener(PREVIEW_IMAGE_REGION);
            this.addClickListener(ELEM_PREVIEW_IMAGE_REGION2);
            var _local_7= this._Str_3993(k.id, PREVIEW_IMAGE);
            this._Str_3060(((_local_7 != null) ? _local_7 : new BitmapData(10, 10)), PREVIEW_IMAGE);
            _local_7 = this._Str_3993(k.id, ELEM_PREVIEW_IMAGE2);
            this._Str_3060(((_local_7 != null) ? _local_7 : new BitmapData(10, 10)), ELEM_PREVIEW_IMAGE2);
            this.arrangeListItems();
            this._window.invalidate();
        }

        function enableElement(k:String, _arg_2:Bool)
        {
            var _local_3= this._window.findChildByName(k);
            if (_local_3 != null)
            {
                _local_3.visible = _arg_2;
            }
        }

        function arrangeListItems()
        {
            this._Str_3441(ELEM_SEED1_ITEMLIST);
            this._Str_3441(ELEM_SEED2_ITEMLIST);
            this._Str_3441(ELEM_SEED1_BUTTONLIST);
            this._Str_3441(ELEM_SEED2_BUTTONLIST);
            this._Str_3441(PREVIEW_BUTTONLIST);
            this._Str_3441(BUTTON_LIST);
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

        public function close()
        {
            if (this._widget != null)
            {
                this._widget._Str_24769(this);
            }
        }

        public function show()
        {
            this._Str_10220 = false;
            if (this._window != null)
            {
                this._window.visible = true;
            }
        }

        function hide()
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

        function onMouseClick(k:WindowMouseEvent)
        {
            switch (k.target.name)
            {
                case HEADER_BUTTON_CLOSE
                   | CLOSE_BUTTON:
                    this.close();
                    return;
                case ELEM_PLACE_BUTTON1:
                    this._Str_10220 = this._Str_7009(this._Str_3111.stuffId);
                    if (this._Str_10220)
                    {
                        this.close();
                    }
                    return;
                case ELEM_PLACE_BUTTON2:
                    this._Str_10220 = this._Str_7009(this._resultData2.stuffId);
                    if (this._Str_10220)
                    {
                        this.close();
                    }
                    return;
                case ELEM_PICK_BUTTON1:
                    this._Str_19552(this._Str_3111.stuffId);
                    return;
                case ELEM_PICK_BUTTON2:
                    this._Str_19552(this._resultData2.stuffId);
                    return;
                case PREVIEW_IMAGE_REGION:
                    this._Str_21990(this._Str_3111.stuffId);
                    return;
                case ELEM_PREVIEW_IMAGE_REGION2:
                    this._Str_21990(this._resultData2.stuffId);
                    return;
                case OK_BUTTON:
                    this.hide();
                    return;
                case SAVE_BUTTON:
                    this.hide();
                    return;
            }
        }

        function _Str_21990(k:Int):Bool
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_2= this._Str_17630(k);
            if (_local_2 != null)
            {
                this._widget.handler.container.inventory.toggleInventoryPage(InventoryCategory.FURNI);
                return true;
            }
            var _local_3= this._Str_8946(k);
            if (_local_3 != null)
            {
                _local_4 = this._widget.handler.container.roomSession.roomId;
                _local_5 = RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE;
                this._widget.handler.container.roomEngine.selectRoomObject(_local_4, _local_3.getId(), _local_5);
                return true;
            }
            return false;
        }

        function _Str_19552(k:Int):Bool
        {
            var _local_2= this._Str_8946(k);
            if (_local_2 != null)
            {
                this._widget.handler.container.roomEngine.modifyRoomObject(_local_2.getId(), RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE, RoomObjectOperationEnum.OBJECT_PICKUP);
                return true;
            }
            return false;
        }

        function _Str_7009(k:Int):Bool
        {
            var _local_2= this._Str_17630(k);
            return this._Str_5337(_local_2);
        }

        function _Str_8946(k:Int):IRoomObject
        {
            var _local_2= this._widget.handler.container.roomSession.roomId;
            var _local_3= RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE;
            var _local_4= this._widget.handler.container.roomEngine.getRoomObject(_local_2, k, _local_3);
            return _local_4;
        }

        function _Str_17630(k:Int):IFurnitureItem
        {
            if (this._widget == null)
            {
                return null;
            }
            var _local_2= this._widget.handler.container.inventory;
            if (_local_2 == null)
            {
                return null;
            }
            var _local_3= _local_2.getFloorItemById(-k);
            return _local_3;
        }

        function _Str_5337(k:IFurnitureItem):Bool
        {
            if (((k == null) || (this._widget == null)))
            {
                return false;
            }
            var _local_2= this._widget.handler.container.inventory;
            if (_local_2 == null)
            {
                return false;
            }
            var _local_3 = false;
            if ((((k.category == FurniCategory.FLOOR) || (k.category == FurniCategory.WALL_PAPER)) || (k.category == FurniCategory.LANDSCAPE)))
            {
                _local_3 = false;
            }
            else
            {
                _local_3 = _local_2.requestSelectedFurniToMover(k);
            }
            return _local_3;
        }

        public function _Str_17192(k:Int)
        {
            if (((this._Str_3111 == null) || (this._resultData2 == null)))
            {
                return;
            }
            if (((this._Str_3111.stuffId == k) || (this._resultData2.stuffId == k)))
            {
                this._Str_16499();
                this.show();
            }
        }

        public function _Str_23033(k:Int)
        {
            if (((this._Str_3111 == null) || (this._resultData2 == null)))
            {
                return;
            }
            if (((this._Str_3111.stuffId == k) || (this._resultData2.stuffId == k)))
            {
                this._Str_16499();
                this.show();
            }
        }

        public function _Str_16499()
        {
            this._Str_2771(this._Str_3111, ELEM_PLACE_BUTTON1, ELEM_PICK_BUTTON1);
            this._Str_2771(this._resultData2, ELEM_PLACE_BUTTON2, ELEM_PICK_BUTTON2);
            this.arrangeListItems();
        }

        function _Str_2771(k:BreedPetsResultData, _arg_2:String, _arg_3:String)
        {
            var _local_11:IFurnitureItem = null;
            if (((this._window == null) || (k == null)))
            {
                return;
            }
            var _local_4= this._widget.handler.container.sessionDataManager.userId;
            var _local_5:ASAny = (k.userId == _local_4);
            var _local_6 = false;
            var _local_7 = false;
            var _local_8= this._Str_8946(k.stuffId);
            if (_local_8 != null)
            {
                _local_7 = true;
            }
            if (!_local_7)
            {
                _local_11 = this._Str_17630(k.stuffId);
                if (_local_11 != null)
                {
                    _local_6 = true;
                }
            }
            var _local_9= this._window.findChildByName(_arg_2);
            var _local_10= this._window.findChildByName(_arg_3);
            if (_local_9 != null)
            {
                _local_9.visible = false;
                if (_local_5)
                {
                    if (_local_6)
                    {
                        _local_9.visible = true;
                    }
                    if (((!_local_6) && (!_local_7)))
                    {
                        _local_9.visible = true;
                    }
                }
            }
            if (_local_10 != null)
            {
                _local_10.visible = false;
                if (_local_5)
                {
                    if (_local_7)
                    {
                        _local_10.visible = true;
                    }
                }
            }
        }
    }

