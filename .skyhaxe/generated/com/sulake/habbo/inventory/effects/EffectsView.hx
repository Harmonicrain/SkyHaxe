package com.sulake.habbo.inventory.effects
;
    import com.sulake.habbo.inventory.IInventoryView;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.inventory.common.ThumbListManager;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.inventory.common.IThumbListDataProvider;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.ITextWindow;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class EffectsView implements IInventoryView 
    {
        var _windowManager:IHabboWindowManager;
        var _assetLibrary:IAssetLibrary;
        var _view:IWindowContainer;
        var _model:EffectsModel;
        var _listManagerActive:ThumbListManager;
        var _listManagerInactive:ThumbListManager;
        var _disposed:Bool = false;

        public function new(k:EffectsModel, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager, _arg_5:IThumbListDataProvider, _arg_6:IThumbListDataProvider)
        {
            this._model = k;
            this._assetLibrary = _arg_3;
            this._windowManager = _arg_2;
            var _local_7= this._assetLibrary.getAssetByName("inventory_effects_xml");
            var _local_8= cast(_local_7, XmlAsset);
            this._view = cast(this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_local_8.content)), IWindowContainer);
            this._view.visible = false;
            this._view.procedure = this.windowEventProc;
            this._listManagerActive = new ThumbListManager(this._assetLibrary, _arg_5, "thumb_bg_png", "thumb_bg_selected_png", this._Str_20128(), this._Str_21763());
            this._listManagerInactive = new ThumbListManager(this._assetLibrary, _arg_6, "thumb_bg_png", "thumb_bg_selected_png", this._Str_20128(), this._Str_21763());
            var _local_9= Std.downcast(this._view.findChildByName("active_items_image") , IBitmapWrapperWindow);
            _local_9.procedure = this._Str_22937;
            var _local_10= Std.downcast(this._view.findChildByName("inactive_items_image") , IBitmapWrapperWindow);
            _local_10.procedure = this._Str_25828;
            this._view.procedure = this.windowEventProc;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._windowManager = null;
                this._model = null;
                this._view = null;
                if (this._listManagerActive != null)
                {
                    this._listManagerActive.dispose();
                    this._listManagerActive = null;
                }
                if (this._listManagerInactive != null)
                {
                    this._listManagerInactive.dispose();
                    this._listManagerInactive = null;
                }
                this._disposed = true;
            }
        }

        public function _Str_20128():Int
        {
            var k= Std.downcast(this._view.findChildByName("active_items_image") , IBitmapWrapperWindow);
            if (k == null)
            {
                return 0;
            }
            return k.width;
        }

        public function _Str_21763():Int
        {
            var k= Std.downcast(this._view.findChildByName("active_items_image") , IBitmapWrapperWindow);
            if (k == null)
            {
                return 0;
            }
            return k.height;
        }

        public function _Str_26236():Int
        {
            var k= Std.downcast(this._view.findChildByName("inactive_items_image") , IBitmapWrapperWindow);
            if (k == null)
            {
                return 0;
            }
            return k.width;
        }

        public function _Str_25954():Int
        {
            var k= Std.downcast(this._view.findChildByName("inactive_items_image") , IBitmapWrapperWindow);
            if (k == null)
            {
                return 0;
            }
            return k.height;
        }

        public function getWindowContainer():IWindowContainer
        {
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

        public function _Str_13242()
        {
            if (this._view == null)
            {
                return;
            }
            if (this._view.disposed)
            {
                return;
            }
            this._listManagerInactive._Str_20886();
            this._listManagerActive._Str_20886();
            var k= Std.downcast(this._view.findChildByName("inactive_items_image") , IBitmapWrapperWindow);
            var _local_2= this._listManagerInactive._Str_21400();
            k.bitmap = _local_2;
            k.width = _local_2.width;
            k.height = _local_2.height;
            k.invalidate();
            var _local_3= Std.downcast(this._view.findChildByName("active_items_image") , IBitmapWrapperWindow);
            var _local_4= this._listManagerActive._Str_21400();
            _local_3.bitmap = _local_4;
            _local_3.width = _local_4.width;
            _local_3.height = _local_4.height;
            _local_3.invalidate();
        }

        public function _Str_2944()
        {
            if (this._view == null)
            {
                return;
            }
            if (this._view.disposed)
            {
                return;
            }
            var k= Std.downcast(this._view.findChildByName("activateEffect_button") , IButtonWindow);
            var _local_2= Std.downcast(this._view.findChildByName("effectDescriptionText") , ITextWindow);
            if (k == null)
            {
                return;
            }
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._model._Str_21540(-1);
            if (_local_3 == null)
            {
                k.disable();
                this._Str_15925(null);
                _local_2.text = "${inventory.effects.defaultdescription}";
            }
            else
            {
                if (_local_3.isActive)
                {
                    k.disable();
                    this._Str_15925(_local_3.icon);
                    _local_2.text = "${inventory.effects.active}";
                    this._windowManager.registerLocalizationParameter("inventory.effects.active", "timeleft", this._Str_9437(_local_3.secondsRemaining));
                    this._windowManager.registerLocalizationParameter("inventory.effects.active", "duration", this._Str_9437(_local_3.duration));
                    this._windowManager.registerLocalizationParameter("inventory.effects.active", "itemcount", Std.string(_local_3.amount));
                }
                else
                {
                    k.enable();
                    this._Str_15925(_local_3.icon);
                    _local_2.text = "${inventory.effects.inactive}";
                    this._windowManager.registerLocalizationParameter("inventory.effects.inactive", "duration", this._Str_9437(_local_3.duration));
                    this._windowManager.registerLocalizationParameter("inventory.effects.inactive", "itemcount", Std.string(_local_3.amount));
                }
            }
        }

        function _Str_15925(k:BitmapData)
        {
            if (this._view == null)
            {
                return;
            }
            if (this._view.disposed)
            {
                return;
            }
            var _local_2= Std.downcast(this._view.findChildByName("effectDescriptionImage") , IBitmapWrapperWindow);
            if (_local_2 == null)
            {
                return;
            }
            if (_local_2.bitmap == null)
            {
                _local_2.bitmap = new BitmapData(_local_2.width, _local_2.height, false);
            }
            if (k == null)
            {
                k = new BitmapData(_local_2.width, _local_2.height);
            }
            var _local_3= new Point(((_local_2.width - k.width) / 2), ((_local_2.height - k.height) / 2));
            _local_2.bitmap.copyPixels(k, k.rect, _local_3, null, null, false);
            _local_2.invalidate();
        }

        function _Str_9437(k:Int):String
        {
            var _local_2= Std.int(Math.ffloor(((k / 60) / 60)));
            var _local_3= Std.int(Math.ffloor(((k - ((_local_2 * 60) * 60)) / 60)));
            var _local_4= ((k - ((_local_2 * 60) * 60)) - (_local_3 * 60));
            var _local_5= "";
            if (_local_2 > 0)
            {
                _local_5 = (Std.string(_local_2) + ":");
            }
            _local_5 = ((_local_3 < 10) ? ((_local_5 + "0") + Std.string(_local_3)) : (_local_5 + Std.string(_local_3)));
            _local_5 = (_local_5 + ":");
            _local_5 = ((_local_4 < 10) ? ((_local_5 + "0") + Std.string(_local_4)) : (_local_5 + Std.string(_local_4)));
            return _local_5;
        }

        function _Str_22937(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:Point = null;
            var _local_4 = 0;
            var _local_5:Effect = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = new Point(cast(k, WindowMouseEvent).localX, cast(k, WindowMouseEvent).localY);
                _local_4 = this._listManagerActive._Str_21083(_local_3);
                _local_5 = this._model._Str_11080(_local_4, 1);
                if (_local_5 != null)
                {
                    this._model._Str_19804(_local_5.type);
                }
            }
        }

        function _Str_25828(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:Point = null;
            var _local_4 = 0;
            var _local_5:Effect = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = new Point(cast(k, WindowMouseEvent).localX, cast(k, WindowMouseEvent).localY);
                _local_4 = this._listManagerInactive._Str_21083(_local_3);
                _local_5 = this._model._Str_11080(_local_4, 0);
                if (_local_5 != null)
                {
                    this._model._Str_19804(_local_5.type);
                }
            }
        }

        function windowEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:Effect = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (_arg_2.name == "activateEffect_button")
                {
                    _local_3 = this._model._Str_21540(0);
                    if (_local_3 != null)
                    {
                        this._model.requestEffectActivated(_local_3.type);
                    }
                }
            }
        }
    }

