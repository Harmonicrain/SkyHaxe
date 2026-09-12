package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.core.utils.Map;
    import flash.display.BitmapData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.avatar.pets.PetFigureData;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;

     class NestBreedingSuccessView implements IDisposable implements  IGetImageListener 
    {
        static inline final HEADER_BUTTON_CLOSE= "header_button_close";
        static inline final CANCEL_BUTTON= "cancel_button";
        static inline final BUTTON_OK= "button.ok";

        var _window:IFrameWindow;
        var _isDisposed:Bool = false;
        var _widget:AvatarInfoWidget;
        var _windowManager:IHabboWindowManager;
        var _assets:IAssetLibrary;
        var _petData:RoomUserData;
        var _petId:Int = 0;
        var _imageCallbackIds:Map;
        var _rarityCategory:Int = 0;

        public function new(k:AvatarInfoWidget)
        {
            this._widget = k;
            this._windowManager = k.windowManager;
            this._assets = this._widget.assets;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._isDisposed = true;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public function open(k:Int, _arg_2:Int)
        {
            this._petId = k;
            this._petData = this._widget.handler.roomSession.userDataManager.getUserDataByIndex(k);
            if (this._petData == null)
            {
                Logger.log(["Couldn't find the correct pet."]);
                return;
            }
            this._rarityCategory = _arg_2;
            this._Str_3248();
            this._window.visible = true;
        }

        function _Str_3248()
        {
            if (this._window == null)
            {
                this._window = Std.downcast(this._windowManager.buildFromXML(((this._assets.getAssetByName("nestBreedingSuccess_xml").content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
                this.addClickListener(HEADER_BUTTON_CLOSE);
            }
            this._window.center();
            this._window.visible = true;
            this.addClickListener(BUTTON_OK);
            this._window.findChildByName("pet.name").caption = this._petData.name;
            this._window.findChildByName("pet.raritycategory").caption = (("${breedpets.nestbreeding.success.raritycategory." + Std.string(this._rarityCategory)) + "}");
            var k= this._Str_3993(this._petData.figure, "pet_image");
            this._Str_3060(((k != null) ? k : new BitmapData(10, 10)), "pet_image");
            this._window.invalidate();
        }

        public function close()
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
                   | CANCEL_BUTTON:
                    this.close();
                    return;
                case BUTTON_OK:
                    this.close();
                    return;
            }
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
                    this._imageCallbackIds.add(_local_8, _arg_2);
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
            var _local_3:String = this._imageCallbackIds.getValue(k);
            if (_local_3 != null)
            {
                this._Str_3060(_arg_2, _local_3);
            }
        }

        public function imageFailed(k:Int)
        {
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
    }

