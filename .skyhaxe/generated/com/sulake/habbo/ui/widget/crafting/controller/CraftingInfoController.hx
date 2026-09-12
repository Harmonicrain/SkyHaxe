package com.sulake.habbo.ui.widget.crafting.controller
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.ui.widget.crafting.CraftingWidget;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.ui.widget.crafting.utils.CraftingViewStateEnum;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.IWindowContainer;

     class CraftingInfoController implements IGetImageListener 
    {
        static inline final _Str_19505= false;

        var _widget:CraftingWidget;
        var _progressBar:CraftingProgressBarController;

        public function new(k:CraftingWidget)
        {
            this._widget = k;
            this._progressBar = new CraftingProgressBarController(k);
        }

        public function dispose()
        {
            this._widget = null;
            if (this._progressBar != null)
            {
                this._progressBar.dispose();
                this._progressBar = null;
            }
        }

        public function setState(k:Int,  _args:Array<ASAny> = null)
        {
if (_args == null) _args = [];
            var _local_5 = 0;
            var _local_6:Vector<String> = null;
            var _local_7:Array<ASAny> = null;
            var _local_8:IFurnitureData = null;
            var _local_10:ITextWindow = null;
            var _local_3= "";
            var _local_4= "";
            if (((Std.is(_args , Array) && (_args.length != 0)) && Std.is(_args[0] , Array)))
            {
                _local_7 = _args[0];
            }
            else
            {
                _local_7 = _args;
            }
            var _local_9= this._widget.handler.container.localization;
            switch (k)
            {
                case CraftingViewStateEnum._Str_15900:
                    _local_3 = "${crafting.info.start}";
                    this._Str_6691(false);
                    
                case CraftingViewStateEnum._Str_8764:
                    this._Str_9627();
                    _local_3 = "${crafting.info.mixer.empty}";
                    this._Str_15106("${crafting.status.mixer.notavailable}");
                    
                case CraftingViewStateEnum._Str_13644:
                    this._Str_9627();
                    _local_3 = "${crafting.info.product.empty}";
                    this._Str_6691(false);
                    
                case CraftingViewStateEnum._Str_15210:
                    this._Str_9627();
                    _local_3 = "${crafting.info.mixer.hit}";
                    this._Str_8735();
                    
                case CraftingViewStateEnum._Str_13163:
                    this._Str_9627();
                    _local_5 = ASCompat.asInt(_local_7[0] );
                    _local_3 = _local_9.getLocalization("crafting.info.mixer.hit.plus.others", "crafting.info.mixer.hit.plus.others");
                    _local_3 = ASCompat.stringReplace(_local_3, "%number%", _local_5);
                    this._Str_8735();
                    
                case CraftingViewStateEnum._Str_15076:
                    this._Str_9627();
                    _local_5 = ASCompat.asInt(_local_7[0] );
                    _local_3 = _local_9.getLocalization("crafting.info.mixer.others");
                    _local_3 = ASCompat.stringReplace(_local_3, "%number%", _local_5);
                    this._Str_15106("${crafting.status.mixer.notavailable}");
                    
                case CraftingViewStateEnum._Str_12563:
                    this._Str_9627();
                    _local_3 = "${crafting.info.mixer.nohit}";
                    this._Str_15106("${crafting.status.mixer.notavailable}");
                    
                case CraftingViewStateEnum._Str_15345:
                    _local_8 = ASCompat.dynamicAs(_local_7[0] , IFurnitureData);
                    if (_local_8 == null)
                    {
                        return;
                    }
                    this._Str_6402(_local_8);
                    _local_3 = _local_9.getLocalization("crafting.info.product.complete", "crafting.info.product.complete");
                    _local_4 = _local_8.localizedName;
                    this._Str_8735();
                    
                case CraftingViewStateEnum._Str_9812:
                    _local_8 = ASCompat.dynamicAs(_local_7[0] , IFurnitureData);
                    if (_local_8 == null)
                    {
                        return;
                    }
                    this._Str_6402(_local_8);
                    _local_6 = ASCompat.asVector(_local_7[1] , (_ : String));
                    _local_3 = _local_9.getLocalization("crafting.info.product.incomplete", "crafting.info.product.incomplete");
                    _local_4 = _local_8.localizedName;
                    this._Str_15106("${crafting.status.recipe.incomplete}");
                    
                case CraftingViewStateEnum._Str_15827:
                    _local_8 = ASCompat.dynamicAs(_local_7[0] , IFurnitureData);
                    if (_local_8 == null)
                    {
                        return;
                    }
                    this._Str_6402(_local_8);
                    _local_3 = _local_9.getLocalization("crafting.info.mixer.notininventory", "crafting.info.mixer.notininventory");
                    _local_3 = ASCompat.stringReplace(_local_3, "%product%", _local_8.localizedName);
                    
                case CraftingViewStateEnum._Str_13842:
                    _local_8 = ASCompat.dynamicAs(_local_7[0] , IFurnitureData);
                    if (_local_8 == null)
                    {
                        return;
                    }
                    this._Str_6402(_local_8);
                    _local_3 = _local_9.getLocalization("crafting.info.result.ok", "crafting.info.result.ok");
                    _local_4 = _local_8.localizedName;
                    this._Str_6691(false);
                    
                case CraftingViewStateEnum._Str_9671:
                    _local_3 = "${crafting.info.working}";
                    this._Str_6691(false);
                    
            }
            _local_10 = Std.downcast(this.mainWindow.findChildByName("info_text1") , ITextWindow);
            if (_local_10 != null)
            {
                _local_10.text = _local_3;
            }
            _local_10 = Std.downcast(this.mainWindow.findChildByName("info_text2") , ITextWindow);
            if (_local_10 != null)
            {
                _local_10.text = _local_4;
            }
        }

        function _Str_8735()
        {
            this._Str_6691(true);
            var k:IButtonWindow = ((this.mainWindow != null) ? Std.downcast(this.mainWindow.findChildByName("btn_craft") , IButtonWindow) : null);
            if (this._widget.handler.isOwner)
            {
                k.caption = "${crafting.btn.craft}";
                k.enable();
                k.procedure = this._Str_25448;
            }
            else
            {
                k.caption = "${crafting.btn.notowner}";
                k.disable();
            }
        }

        function _Str_15106(k:String)
        {
            this._Str_6691(true);
            var _local_2:IButtonWindow = ((this.mainWindow != null) ? Std.downcast(this.mainWindow.findChildByName("btn_craft") , IButtonWindow) : null);
            if (this._widget.handler.isOwner)
            {
                _local_2.caption = k;
            }
            else
            {
                _local_2.caption = "${crafting.btn.notowner}";
            }
            _local_2.disable();
        }

        public function _Str_25724(k:Int, _arg_2:Bool)
        {
            if (_arg_2)
            {
                if (k == 0)
                {
                    this.setState(CraftingViewStateEnum._Str_15210);
                }
                else
                {
                    this.setState(CraftingViewStateEnum._Str_13163, [k]);
                }
            }
            else
            {
                if (k > 0)
                {
                    this.setState(CraftingViewStateEnum._Str_15076, [k]);
                }
                else
                {
                    this.setState(CraftingViewStateEnum._Str_12563);
                }
            }
        }

        function _Str_25448(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.DOWN)
            {
                return;
            }
            this._Str_23676();
        }

        function _Str_9627()
        {
            this._Str_18264(null);
            this._Str_17514();
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
            this._Str_18264(_arg_2);
            this._Str_17514();
        }

        public function imageFailed(k:Int)
        {
            this._Str_18264(null);
            this._Str_17514();
        }

        function _Str_17514()
        {
        }

        function _Str_23676()
        {
            this._widget.handler.craftingInProgress = true;
            this._Str_6691(false);
            this._progressBar.show();
        }

        public function _Str_19691()
        {
            this._widget.handler.craftingInProgress = false;
            this._progressBar.hide();
            this._Str_6691(true);
        }

        public function _Str_25541()
        {
            this._progressBar.hide();
            this._widget._Str_24348();
        }

        function _Str_18264(k:BitmapData)
        {
            var _local_2:IBitmapWrapperWindow = ((this.mainWindow != null) ? cast(this.mainWindow.findChildByName("furniture_icon"), IBitmapWrapperWindow) : null);
            if (_local_2 == null)
            {
                return;
            }
            _local_2.bitmap = k;
        }

        function _Str_6691(k:Bool)
        {
            var _local_2:IWindow = ((this.mainWindow != null) ? this.mainWindow.findChildByName("btn_craft") : null);
            if (_local_2 != null)
            {
                _local_2.visible = k;
            }
        }

        public var mainWindow(get,never):IWindowContainer;
public function  get_mainWindow():IWindowContainer
        {
            return this._widget.window;
        }
    }

