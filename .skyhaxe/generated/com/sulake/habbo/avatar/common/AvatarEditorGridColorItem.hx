package com.sulake.habbo.avatar.common
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.avatar.structure.figure.IPartColor;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;

     class AvatarEditorGridColorItem 
    {
        static inline final SELECTED_ASSET= "avatar_editor_editor_clr_13x21_3";
        static inline final UNSELECTED_ASSET= "avatar_editor_editor_clr_13x21_1";
        static inline final COLORIZATION_ASSET= "avatar_editor_editor_clr_13x21_2";

        var _model:IAvatarEditorCategoryModel;
        var _window:IWindowContainer;
        var _partColor:IPartColor;
        var _isSelected:Bool = false;
        var _border:IStaticBitmapWrapperWindow;
        var _isDisabledForWearing:Bool = false;

        public function new(k:IWindowContainer, _arg_2:IAvatarEditorCategoryModel, _arg_3:IPartColor, _arg_4:Bool=false)
        {
            this._model = _arg_2;
            this._window = k;
            this._partColor = _arg_3;
            this._isDisabledForWearing = _arg_4;
            this._border = Std.downcast(this._window.findChildByTag("BORDER") , IStaticBitmapWrapperWindow);
            this.setupColor();
            this.updateThumbData();
            this._window.addEventListener(WindowMouseEvent.OVER, this.onMouseOver);
            this._window.addEventListener(WindowMouseEvent.OUT, this.onMouseOut);
        }

        function onMouseOut(k:WindowMouseEvent)
        {
            this._border.assetUri = (this._isSelected ? SELECTED_ASSET : UNSELECTED_ASSET);
        }

        function onMouseOver(k:WindowMouseEvent)
        {
            this._border.assetUri = SELECTED_ASSET;
        }

        function setupColor()
        {
            var k= Std.downcast(this._model.controller.manager.windowManager.assets.getAssetByName(COLORIZATION_ASSET) , BitmapDataAsset);
            var _local_2= ASCompat.dynamicAs(k.content , BitmapData);
            var _local_3= _local_2.clone();
            var _local_4= Std.downcast(this._window.findChildByTag("COLOR_IMAGE") , IBitmapWrapperWindow);
            _local_4.bitmap = new BitmapData(_local_3.width, _local_3.height, true, 0);
            _local_3.colorTransform(_local_3.rect, this._partColor.colorTransform);
            _local_4.bitmap.copyPixels(_local_3, _local_3.rect, new Point(0, 0));
            _local_3.dispose();
        }

        public function dispose()
        {
            this._model = null;
            if (this._window != null)
            {
                if (!this._window.disposed)
                {
                    this._window.dispose();
                }
            }
            this._window = null;
            this._partColor = null;
        }

        public var view(get,never):IWindowContainer;
public function  get_view():IWindowContainer
        {
            return this._window;
        }

        
        public var isSelected(get,set):Bool;
public function  get_isSelected():Bool
        {
            return this._isSelected;
        }
public function  set_isSelected(k:Bool):Bool        {
            this._isSelected = k;
            this._border.assetUri = (this._isSelected ? SELECTED_ASSET : UNSELECTED_ASSET);
return k;
        }

        function updateThumbData()
        {
            if (this._window == null)
            {
                return;
            }
            if (this._window.disposed)
            {
                return;
            }
            this._border.assetUri = SELECTED_ASSET;
            var k= this._window.findChildByTag("CLUB_ICON");
            if (this._partColor != null)
            {
                k.visible = (this._partColor.clubLevel > 0);
            }
            else
            {
                k.visible = false;
            }
        }

        public var partColor(get,never):IPartColor;
public function  get_partColor():IPartColor
        {
            return this._partColor;
        }

        public var isDisabledForWearing(get,never):Bool;
public function  get_isDisabledForWearing():Bool
        {
            return this._isDisabledForWearing;
        }
    }



