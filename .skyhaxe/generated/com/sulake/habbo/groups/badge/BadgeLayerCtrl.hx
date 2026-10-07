package com.sulake.habbo.groups.badge
;
    import com.sulake.habbo.groups.HabboGroupsManager;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.groups.ColorGridCtrl;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class BadgeLayerCtrl 
    {
        public static var _Str_5392:Int = 0;
        public static var _Str_17304:String = "part_edit_list";

        var _manager:HabboGroupsManager;
        var _parentCtrl:BadgeEditorCtrl;
        var _layerIndex:Int = 0;
        var _layerOptions:BadgeLayerOptions;
        var _layerWindow:IWindowContainer;
        var _colorGridCtrl:ColorGridCtrl;
        var _disposed:Bool = false;
        var _partAddBitmap:BitmapData;
        var _partSelectImage:IBitmapWrapperWindow;
        var _partSelectButton:IButtonWindow;
        var _positionContainer:IWindowContainer;
        var _positionPicker:IBitmapWrapperWindow;
        var _positionGrid:IBitmapWrapperWindow;

        public function new(k:HabboGroupsManager, _arg_2:BadgeEditorCtrl, _arg_3:Int)
        {
            this._manager = k;
            this._parentCtrl = _arg_2;
            this._layerIndex = _arg_3;
            this._layerOptions = new BadgeLayerOptions();
            this._layerOptions._Str_3617 = _arg_3;
            this._partAddBitmap = this._manager.getButtonImage("badge_part_add");
        }

        public function createWindow()
        {
            if (this._layerWindow != null)
            {
                return;
            }
            var k= Std.downcast(this._parentCtrl._Str_23796.findChildByName(_Str_17304) , IItemListWindow);
            this._layerWindow = Std.downcast(this._manager.getXmlWindow("badge_layer") , IWindowContainer);
            var _local_2= Std.downcast(this._layerWindow.findChildByName("preview_container") , IWindowContainer);
            this._partSelectImage = Std.downcast(_local_2.findChildByName("part_preview") , IBitmapWrapperWindow);
            this._partSelectImage.bitmap = this._manager.getButtonImage("badge_part_add");
            this._partSelectButton = Std.downcast(_local_2.findChildByName("part_button") , IButtonWindow);
            this._partSelectButton.procedure = this._Str_24869;
            this._positionContainer = Std.downcast(this._layerWindow.findChildByName("position_container") , IWindowContainer);
            this._positionPicker = Std.downcast(this._positionContainer.findChildByName("position_picker") , IBitmapWrapperWindow);
            this._positionPicker.bitmap = this._manager.getButtonImage("position_picker");
            this._positionGrid = Std.downcast(this._positionContainer.findChildByName("position_grid") , IBitmapWrapperWindow);
            this._positionGrid.bitmap = this._manager.getButtonImage("position_grid");
            if (this._layerIndex == 0)
            {
                this._positionGrid.visible = false;
                this._positionPicker.visible = false;
            }
            else
            {
                this._positionGrid.procedure = this._Str_22712;
            }
            this._colorGridCtrl = new ColorGridCtrl(this._manager, this._Str_24879);
            this._colorGridCtrl._Str_16890(this._layerWindow, "color_selector", this._manager.guildEditorData._Str_9008);
            if (this._layerOptions._Str_3617 == _Str_5392)
            {
                k.addListItem(this._layerWindow);
            }
            else
            {
                k.addListItemAt(this._layerWindow, 0);
            }
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._colorGridCtrl != null)
                {
                    this._colorGridCtrl.dispose();
                    this._colorGridCtrl = null;
                }
                if (this._layerWindow != null)
                {
                    this._layerWindow.dispose();
                    this._layerWindow = null;
                }
                this._partSelectImage = null;
                this._partSelectButton = null;
                this._positionContainer = null;
                this._positionPicker = null;
                this._positionGrid = null;
                this._manager = null;
                this._disposed = true;
            }
        }

        public function setLayerOptions(k:BadgeLayerOptions)
        {
            if (k._Str_3617 != this._layerOptions._Str_3617)
            {
                throw new ASError("Tried to set layer option with invalid layerIndex value");
            }
            var _local_2 = false;
            var _local_3= this._layerOptions;
            this._layerOptions = k.clone();
            if (!this._layerOptions._Str_22335(_local_3))
            {
                this._Str_21129(false);
                _local_2 = true;
            }
            if (_local_3.colorIndex != this._layerOptions.colorIndex)
            {
                this._colorGridCtrl._Str_6965(this._layerOptions.colorIndex, false);
                this._layerOptions.colorIndex = this._colorGridCtrl._Str_4246;
                _local_2 = true;
            }
            if ((_local_2 || (!(_local_3._Str_3324 == this._layerOptions._Str_3324))))
            {
                this.updateSelectedPart();
            }
        }

        public var layerOptions(get,never):BadgeLayerOptions;
public function  get_layerOptions():BadgeLayerOptions
        {
            return this._layerOptions;
        }

        public function updateSelectedPart()
        {
            var k:BitmapData = null;
            if (this._parentCtrl._Str_19999 != null)
            {
                k = this._parentCtrl._Str_19999._Str_21949(this.layerOptions);
            }
            if (k == null)
            {
                k = this._partAddBitmap;
            }
            this._partSelectImage.bitmap.dispose();
            this._partSelectImage.bitmap = new BitmapData(k.width, k.height);
            this._partSelectImage.bitmap.copyPixels(k, k.rect, new Point());
            this._parentCtrl._Str_23517(this);
        }

        function _Str_21129(k:Bool=true)
        {
            this._positionPicker.x = ((this._layerOptions._Str_7460 * 14) + 1);
            this._positionPicker.y = ((this._layerOptions._Str_8051 * 14) + 1);
            if (k)
            {
                this.updateSelectedPart();
            }
        }

        function _Str_22712(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(k.type == WindowMouseEvent.CLICK)) || (!(this._positionPicker != null))))
            {
                return;
            }
            var _local_3= Std.downcast(k , WindowMouseEvent);
            this._layerOptions._Str_7460 = Std.int(Math.min(2, Math.max(0, Math.ffloor((_local_3.localX / 14)))));
            this._layerOptions._Str_8051 = Std.int(Math.min(2, Math.max(0, Math.ffloor((_local_3.localY / 14)))));
            this._Str_21129();
        }

        function _Str_24869(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._parentCtrl._Str_24453(this);
        }

        public function _Str_24879(k:ColorGridCtrl)
        {
            if (this._layerOptions.colorIndex != k._Str_4246)
            {
                this._layerOptions.colorIndex = k._Str_4246;
                this.updateSelectedPart();
            }
        }
    }

