package com.sulake.habbo.ui.widget.crafting.renderer
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.ui.widget.crafting.CraftingWidget;
    import com.sulake.habbo.ui.widget.crafting.utils.CraftingFurnitureItem;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import flash.events.MouseEvent;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class FurniThumbnailRendererBase implements IGetImageListener 
    {
        static inline final _Str_18094:Float = 1;
        static inline final _Str_18535= 0.2;

        var _widget:CraftingWidget;
        var _data:CraftingFurnitureItem;
        var _window:IWindowContainer;

        public function new(k:CraftingFurnitureItem, _arg_2:IWindowContainer, _arg_3:CraftingWidget)
        {
            this._widget = _arg_3;
            this._window = _arg_2;
            this._data = k;
            this._Str_6402(this.furnitureData);
            this.updateItemCount();
            this._window.procedure = this._Str_780;
            var _local_4= Std.downcast(_arg_2.findChildByName("tooltip") , IRegionWindow);
            _local_4.toolTipCaption = k.furnitureData.localizedName;
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.removeEventListener(MouseEvent.MOUSE_DOWN, this._Str_780);
                this._window.dispose();
                this._window = null;
            }
        }

        function _Str_6402(k:IFurnitureData)
        {
            var _local_2:ImageResult = null;
            switch (k.type)
            {
                case ProductTypeEnum.FLOOR:
                    _local_2 = this._widget.handler.container.roomEngine.getFurnitureIcon(k.id, this);
                    
                case ProductTypeEnum.WALL:
                    _local_2 = this._widget.handler.container.roomEngine.getWallItemIcon(k.id, this);
                    
            }
            if (_local_2.data != null)
            {
                this.imageReady(0, _local_2.data);
            }
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_3= Std.downcast(this._window.findChildByTag("BITMAP") , IBitmapWrapperWindow);
            if (((_local_3 != null) && (_arg_2 != null)))
            {
                _local_3.bitmap = _arg_2;
            }
        }

        public function imageFailed(k:Int)
        {
        }

        public function updateItemCount()
        {
        }

        function _Str_22233()
        {
            var k= this._window.findChildByName("number_container");
            if (k != null)
            {
                k.visible = false;
            }
        }

        function _Str_21081(k:Int)
        {
            var _local_3:ITextWindow = null;
            if (((!(this._window != null)) || this._window.disposed))
            {
                return;
            }
            var _local_2= this._window.findChildByName("number_container");
            _local_2.visible = (k > 0);
            if (k > 0)
            {
                _local_3 = Std.downcast(this._window.findChildByName("number") , ITextWindow);
                _local_3.text = Std.string(k);
            }
        }

        function _Str_14878(k:Bool)
        {
            var _local_2= Std.downcast(this._window.findChildByName("bitmap") , IBitmapWrapperWindow);
            if (k)
            {
                _local_2.blend = FurniThumbnailRendererBase._Str_18094;
            }
            else
            {
                _local_2.blend = FurniThumbnailRendererBase._Str_18535;
            }
        }

        function _Str_780(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.DOWN)
            {
                return;
            }
            this.onTriggered();
        }

        function onTriggered()
        {
        }

        public var content(get,never):CraftingFurnitureItem;
public function  get_content():CraftingFurnitureItem
        {
            return this._data;
        }

        var furnitureData(get,never):IFurnitureData;
function  get_furnitureData():IFurnitureData
        {
            return (this.content != null) ? this.content.furnitureData : null;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }
    }

