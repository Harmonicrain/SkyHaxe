package com.sulake.habbo.inventory.pets
;
    import com.sulake.habbo.inventory.IInventoryView;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.Pet;
    import flash.display.BitmapData;
    import com.sulake.habbo.avatar.pets.PetCustomPart;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import com.sulake.habbo.avatar.pets.PetTypeEnum;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IButtonWindow;

     class PetsView implements IInventoryView implements  IGetImageListener 
    {
        static inline final _Str_12387= 4;

        static inline final _Str_12512= 0;
        static inline final _Str_4299= 1;
        static inline final _Str_5391= 2;
        static inline final _Str_4660= 3;

        var _windowManager:IHabboWindowManager;
        var _assetLibrary:IAssetLibrary;
        var _view:IWindowContainer;
        var _model:PetsModel;
        var _disposed:Bool = false;
        var _grid:IItemGridWindow;
        var _roomEngine:IRoomEngine;
        var _gridItems:Map;
        var _selectedGridItem:PetsGridItem;
        var _currentState:Int = 0;
        var _previewImageDownloadId:Int = 0;
        var _isInitialized:Bool = false;

        public function new(k:PetsModel, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IRoomEngine)
        {
            this._model = k;
            this._assetLibrary = _arg_3;
            this._windowManager = _arg_2;
            this._roomEngine = _arg_4;
            this._gridItems = new Map();
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var isVisible(get,never):Bool;
public function  get_isVisible():Bool
        {
            return ((this._view != null) && (!(this._view.parent == null))) && this._view.visible;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._windowManager = null;
                this._model = null;
                this._view = null;
                this._disposed = true;
            }
        }

        public function update()
        {
            if (!this._isInitialized)
            {
                return;
            }
            this._Str_7044();
            this.updatePreview(this._selectedGridItem);
            this.updateContainerVisibility();
        }

        public function _Str_12321(k:Int)
        {
            if (!this._isInitialized)
            {
                return;
            }
            var _local_2= ASCompat.dynamicAs(this._gridItems.remove(k) , PetsGridItem);
            if (_local_2 == null)
            {
                return;
            }
            this._grid.removeGridItem(_local_2.window);
            if (this._selectedGridItem == _local_2)
            {
                this._selectedGridItem = null;
                this._Str_9010();
            }
        }

        public function _Str_9947(k:Pet)
        {
            if (!this._isInitialized)
            {
                return;
            }
            if (k == null)
            {
                return;
            }
            if (this._gridItems.getValue(k.id) != null)
            {
                return;
            }
            var _local_2= new PetsGridItem(this, k, this._windowManager, this._assetLibrary, this._model.isUnseen(k.id));
            if (_local_2 != null)
            {
                this._grid.addGridItem(_local_2.window);
                this._gridItems.add(k.id, _local_2);
                if (this._selectedGridItem == null)
                {
                    this._Str_9010();
                }
            }
        }

        public function placePetToRoom(k:Int, _arg_2:Bool=false)
        {
            this._model.placePetToRoom(k, _arg_2);
        }

        public function getWindowContainer():IWindowContainer
        {
            if (!this._isInitialized)
            {
                this.init();
            }
            if (this._view == null)
            {
                return null;
            }
            if (this._view.disposed)
            {
                return null;
            }
            return this._view;
        }

        public function _Str_7828(k:PetsGridItem)
        {
            if (!this._isInitialized)
            {
                return;
            }
            if (this._selectedGridItem != null)
            {
                this._selectedGridItem.setSelected(false);
            }
            this._selectedGridItem = k;
            if (this._selectedGridItem != null)
            {
                this._selectedGridItem.setSelected(true);
            }
            this.updatePreview(k);
        }

        public function _Str_3820()
        {
            var _local_2 = 0;
            if (!this._isInitialized)
            {
                return;
            }
            var k= this._model.pets;
            if (!this._model._Str_18819())
            {
                _local_2 = PetsView._Str_4299;
            }
            else
            {
                if (((!(k != null)) || (k.length == 0)))
                {
                    _local_2 = PetsView._Str_5391;
                }
                else
                {
                    _local_2 = PetsView._Str_4660;
                }
            }
            if (this._currentState == _local_2)
            {
                return;
            }
            this._currentState = _local_2;
            this.updateContainerVisibility();
            if (this._currentState == PetsView._Str_4660)
            {
                this._Str_7044();
                this.updatePreview();
            }
        }

        public function getPetImage(k:Pet, _arg_2:Int, _arg_3:Bool, _arg_4:PetsGridItem=null, _arg_5:Int=64, _arg_6:String=null):BitmapData
        {
            var _local_7= k.figureData;
            var _local_8:BitmapData = null;
            var _local_9:UInt = ASCompat.parseInt(_local_7.color, 16);
            var _local_10:UInt = 0;
            var _local_11:Array<ASAny> = [];
            var _local_12 = 0;
            while (_local_12 < (_local_7.customPartCount * 3))
            {
                _local_11.push(new PetCustomPart(ASCompat.toInt(_local_7._Str_3542[_local_12]), ASCompat.toInt(_local_7._Str_3542[(_local_12 + 1)]), ASCompat.toInt(_local_7._Str_3542[(_local_12 + 2)])));
                _local_12 = (_local_12 + 3);
            }
            var _local_13= this._roomEngine.getPetImage(_local_7.typeId, _local_7.paletteId, ASCompat.toInt(_local_9), new Vector3d((_arg_2 * 45)), _arg_5, this, _arg_3, _local_10, _local_11, _arg_6);
            if (_local_13 != null)
            {
                _local_8 = _local_13.data;
                if (_arg_4 != null)
                {
                    _arg_4._Str_17747 = _local_13.id;
                }
                else
                {
                    if (_arg_3)
                    {
                        this._previewImageDownloadId = _local_13.id;
                    }
                }
            }
            if (_local_8 == null)
            {
                _local_8 = new BitmapData(30, 30, false, 0xFFAAAAAA);
            }
            return _local_8;
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            var _local_3:PetsGridItem = null;
            if (k == this._previewImageDownloadId)
            {
                this.updatePreview(this._selectedGridItem);
                return;
            }
            final _iter_ = this._gridItems; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_3  = _tmp_;
                if (_local_3._Str_17747 == k)
                {
                    _local_3._Str_19232(_arg_2);
                    return;
                }
            }
        }

        public function imageFailed(k:Int)
        {
        }

        function _Str_9010()
        {
            if (((this._gridItems == null) || (this._gridItems.length == 0)))
            {
                this.updatePreview();
                return;
            }
            this._Str_7828(this._gridItems.getWithIndex(0));
        }

        public function _Str_16613(k:Int)
        {
            this._Str_7828(this._gridItems.getValue(k));
        }

        function _Str_7044()
        {
            var _local_3 = 0;
            var _local_4:PetsGridItem = null;
            if (this._view == null)
            {
                return;
            }
            var k= this._gridItems.getKeys();
            var _local_2= ((this._model.pets != null) ? this._model.pets.getKeys() : new Array<ASAny>());
            this._grid.lock();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = ASCompat.toInt(_tmp_);
                if (_local_2.indexOf(_local_3) == -1)
                {
                    this._Str_12321(_local_3);
                }
            }
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = ASCompat.toInt(_tmp_);
                if (k.indexOf(_local_3) == -1)
                {
                    this._Str_9947(this._model.pets.getValue(_local_3));
                }
                _local_4 = this._gridItems.getValue(_local_3);
                _local_4.setUnseen(this._model.isUnseen(_local_3));
            }
            this._grid.unlock();
        }

        function _Str_9841(k:WindowMouseEvent)
        {
            if (this._selectedGridItem == null)
            {
                return;
            }
            var _local_2= this._selectedGridItem.pet;
            if (_local_2 == null)
            {
                return;
            }
            this.placePetToRoom(_local_2.id);
        }

        function updateContainerVisibility()
        {
            if (this._model.controller._Str_9777 != InventoryCategory.PETS)
            {
                return;
            }
            var k= this._model.controller.view._Str_10034;
            var _local_2= this._model.controller.view._Str_11062;
            var _local_3= this._view.findChildByName("grid");
            var _local_4= this._view.findChildByName("preview_container");
            switch (this._currentState)
            {
                case PetsView._Str_4299:
                    if (k != null)
                    {
                        k.visible = true;
                    }
                    if (_local_2 != null)
                    {
                        _local_2.visible = false;
                    }
                    _local_3.visible = false;
                    _local_4.visible = false;
                    return;
                case PetsView._Str_5391:
                    if (k != null)
                    {
                        k.visible = false;
                    }
                    if (_local_2 != null)
                    {
                        _local_2.visible = true;
                    }
                    _local_3.visible = false;
                    _local_4.visible = false;
                    return;
                case PetsView._Str_4660:
                    if (k != null)
                    {
                        k.visible = false;
                    }
                    if (_local_2 != null)
                    {
                        _local_2.visible = false;
                    }
                    _local_3.visible = true;
                    _local_4.visible = true;
                    return;
            }
        }

        function updatePreview(k:PetsGridItem=null)
        {
            var _local_2:BitmapData = null;
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5 = false;
            var _local_16:Pet = null;
            var _local_17:BitmapData = null;
            if (this._view == null)
            {
                return;
            }
            var _local_6= 64;
            var _local_7= 4;
            var _local_8= true;
            var _local_9:String = null;
            this._previewImageDownloadId = -1;
            if (((k == null) || (k.pet == null)))
            {
                _local_2 = new BitmapData(1, 1);
                _local_3 = "";
                _local_4 = "";
                _local_5 = false;
            }
            else
            {
                _local_16 = k.pet;
                _local_3 = _local_16.name;
                if (_local_16.typeId == PetTypeEnum.MONSTERPLANT)
                {
                    _local_7 = 2;
                    _local_8 = true;
                    if (_local_16.level >= 7)
                    {
                        _local_9 = "std";
                    }
                    else
                    {
                        _local_9 = ("grw" + Std.string(_local_16.level));
                    }
                }
                _local_2 = this.getPetImage(_local_16, _local_7, _local_8, null, _local_6, _local_9);
                _local_5 = true;
            }
            var _local_10= Std.downcast(this._view.findChildByName("preview_image") , IBitmapWrapperWindow);
            if (_local_10 != null)
            {
                _local_17 = new BitmapData(_local_10.width, _local_10.height);
                _local_17.fillRect(_local_17.rect, 0);
                _local_17.copyPixels(_local_2, _local_2.rect, new Point(((_local_17.width / 2) - (_local_2.width / 2)), ((_local_17.height / 2) - (_local_2.height / 2))));
                _local_10.bitmap = _local_17;
            }
            _local_2.dispose();
            var _local_11= Std.downcast(this._view.findChildByName("preview_text") , ITextWindow);
            if (_local_11 != null)
            {
                _local_11.caption = _local_3;
            }
            _local_11 = Std.downcast(this._view.findChildByName("preview_description") , ITextWindow);
            if (_local_11 != null)
            {
                _local_11.caption = _local_4;
            }
            var _local_12 = false;
            var _local_13 = false;
            if (this._model.roomSession != null)
            {
                _local_12 = this._model.roomSession.arePetsAllowed;
                _local_13 = this._model.roomSession.isRoomOwner;
            }
            var _local_14= "";
            if (!_local_13)
            {
                if (_local_12)
                {
                    _local_14 = "${inventory.pets.allowed}";
                }
                else
                {
                    _local_14 = "${inventory.pets.forbidden}";
                }
            }
            _local_11 = Std.downcast(this._view.findChildByName("preview_info") , ITextWindow);
            if (_local_11 != null)
            {
                _local_11.caption = _local_14;
            }
            var _local_15= Std.downcast(this._view.findChildByName("place_button") , IButtonWindow);
            if (_local_15 != null)
            {
                if ((_local_5 && (_local_13 || _local_12)))
                {
                    _local_15.enable();
                }
                else
                {
                    _local_15.disable();
                }
            }
        }

        function init()
        {
            var k:IButtonWindow = null;
            this._view = this._model.controller.view._Str_9043(InventoryCategory.PETS);
            this._view.visible = false;
            this._grid = Std.downcast(this._view.findChildByName("grid") , IItemGridWindow);
            k = Std.downcast(this._view.findChildByName("place_button") , IButtonWindow);
            if (k != null)
            {
                k.addEventListener(WindowMouseEvent.CLICK, this._Str_9841);
            }
            var _local_2= Std.downcast(this._view.findChildByName("preview_image") , IBitmapWrapperWindow);
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.DOWN, this._Str_9841);
            }
            this.updatePreview();
            this._Str_3820();
            this._isInitialized = true;
        }
    }

