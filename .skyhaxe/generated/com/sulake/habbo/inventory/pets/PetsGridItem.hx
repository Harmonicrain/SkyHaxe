package com.sulake.habbo.inventory.pets
;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.Pet;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.avatar.pets.PetTypeEnum;
    import flash.display.BitmapData;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;

     class PetsGridItem 
    {
        static inline final _Str_4072= 0xCCCCCC;
        static inline final _Str_4169= 10275685;

        var _petData:Pet;
        var _window:IWindowContainer;
        var _assets:IAssetLibrary;
        var _selectionHighlighter:IWindow;
        var _isSelected:Bool = false;
        var _petsView:PetsView;
        var _imageDownloadId:Int = -1;
        var _isMouseDown:Bool = false;
        var _isUnseen:Bool = false;

        public function new(k:PetsView, _arg_2:Pet, _arg_3:IHabboWindowManager, _arg_4:IAssetLibrary, _arg_5:Bool)
        {
            if (((((k == null) || (_arg_2 == null)) || (_arg_3 == null)) || (_arg_4 == null)))
            {
                return;
            }
            this._assets = _arg_4;
            this._petsView = k;
            this._petData = _arg_2;
            this._isUnseen = _arg_5;
            var _local_6= Std.downcast(_arg_4.getAssetByName("inventory_thumb_xml") , XmlAsset);
            if (((_local_6 == null) || (_local_6.content == null)))
            {
                return;
            }
            this._window = Std.downcast(_arg_3.buildFromXML(((_local_6.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._window.procedure = this.eventHandler;
            var _local_7= 64;
            var _local_8= 3;
            var _local_9 = false;
            var _local_10:String = null;
            if (_arg_2.typeId == PetTypeEnum.HORSE)
            {
                _local_7 = 32;
                _local_8 = 2;
                _local_9 = true;
            }
            else
            {
                if (((_arg_2.typeId == PetTypeEnum.GNOME) || (_arg_2.typeId == PetTypeEnum.LEPRECHAUN)))
                {
                    _local_7 = 32;
                    _local_8 = 3;
                    _local_9 = true;
                }
                else
                {
                    if (_arg_2.typeId == PetTypeEnum.MONSTERPLANT)
                    {
                        _local_7 = 32;
                        _local_8 = 2;
                        _local_9 = true;
                        if (_arg_2.level >= 7)
                        {
                            _local_10 = "std";
                        }
                        else
                        {
                            _local_10 = ("grw" + Std.string(_arg_2.level));
                        }
                    }
                }
            }
            var _local_11= k.getPetImage(_arg_2, _local_8, _local_9, this, _local_7, _local_10);
            this._Str_19232(_local_11);
            this._updateOutline();
        }

        public function dispose()
        {
            this._assets = null;
            this._petsView = null;
            this._petData = null;
            this._selectionHighlighter = null;
            this._imageDownloadId = -1;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function eventHandler(k:WindowEvent, _arg_2:IWindow)
        {
            switch (k.type)
            {
                case WindowMouseEvent.DOWN:
                    this._petsView._Str_7828(this);
                    this._isMouseDown = true;
                    return;
                case WindowMouseEvent.UP:
                    this._isMouseDown = false;
                    return;
                case WindowMouseEvent.OUT:
                    if (this._isMouseDown)
                    {
                        this._isMouseDown = false;
                        this._petsView.placePetToRoom(this._petData.id, true);
                    }
                    return;
            }
        }

        public function _Str_19232(k:BitmapData)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("bitmap") , IBitmapWrapperWindow);
            var _local_3= new BitmapData(_local_2.width, _local_2.height);
            _local_3.fillRect(_local_3.rect, 0);
            _local_3.copyPixels(k, k.rect, new Point(((_local_3.width / 2) - (k.width / 2)), ((_local_3.height / 2) - (k.height / 2))));
            if (_local_2.bitmap != null)
            {
                _local_2.bitmap.dispose();
            }
            _local_2.bitmap = _local_3;
        }

        public function setUnseen(k:Bool)
        {
            if (this._isUnseen != k)
            {
                this._isUnseen = k;
                this._updateOutline();
            }
        }

        public function setSelected(k:Bool)
        {
            if (this._isSelected != k)
            {
                this._isSelected = k;
                if (((!(this._window != null)) || (!(this._selectionHighlighter != null))))
                {
                    return;
                }
                this._updateOutline();
            }
        }

        function _updateOutline()
        {
            var k= this._window.findChildByName("outline");
            if (k != null)
            {
                k.visible = this._isSelected;
            }
            if (this._selectionHighlighter == null)
            {
                this._selectionHighlighter = this._window.findChildByTag("BG_COLOR");
            }
            this._selectionHighlighter.color = (this._isUnseen ? _Str_4169 : _Str_4072);
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return this._window;
        }

        public var pet(get,never):Pet;
public function  get_pet():Pet
        {
            return this._petData;
        }

        
        public var _Str_17747(get,set):Int;
public function  set__Str_17747(k:Int):Int        {
            return this._imageDownloadId = k;
        }
public function  get__Str_17747():Int
        {
            return this._imageDownloadId;
        }
    }

