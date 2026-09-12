package com.sulake.habbo.catalog.viewer
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IInteractiveWindow;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window._enum.MouseCursorType;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.habbo.avatar.IAvatarImageListener;

     class ProductGridItem implements IGridItem 
    {
        public static inline final BG= "bg";

        var _view:IWindowContainer;
        var _grid:_Str_4311;
        var _icon:IBitmapWrapperWindow;
        var _disposed:Bool = false;
        var _Str_3737:ASObject;
        var _habboCatalog:HabboCatalog;

        public function new(k:HabboCatalog)
        {
            this._habboCatalog = k;
        }

        
        public var view(get,set):IWindowContainer;
public function  get_view():IWindowContainer
        {
            return this._view;
        }

        public var grid(never,set):_Str_4311;
public function  set_grid(k:_Str_4311):_Str_4311        {
            return this._grid = k;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._grid = null;
            this._icon = null;
            this._habboCatalog = null;
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        var catalog(get,never):HabboCatalog;
function  get_catalog():HabboCatalog
        {
            return this._habboCatalog;
        }

        public function activate()
        {
            if (this._view == null)
            {
                return;
            }
            if (this._view.findChildByTag("ITEM_HILIGHT") != null)
            {
                this._view.findChildByTag("ITEM_HILIGHT").visible = true;
            }
            else
            {
                this._view.getChildByName(BG).style = HabboWindowStyle.DEFAULT;
            }
        }

        public function deactivate()
        {
            if (this._view == null)
            {
                return;
            }
            if (this._view.findChildByTag("ITEM_HILIGHT") != null)
            {
                this._view.findChildByTag("ITEM_HILIGHT").visible = false;
            }
            else
            {
                this._view.getChildByName(BG).style = 3;
            }
        }
public function  set_view(k:IWindowContainer):IWindowContainer        {
            if (k == null)
            {
                return k;
            }
            this._view = k;
            this._view.procedure = this._Str_5162;
            this._icon = Std.downcast(this._view.findChildByName("image") , IBitmapWrapperWindow);
            if (this._view.findChildByTag("ITEM_HILIGHT") != null)
            {
                this._view.findChildByTag("ITEM_HILIGHT").visible = false;
            }
            var _local_2= this._view.findChildByName("multiContainer");
            if (_local_2 != null)
            {
                _local_2.visible = false;
            }
return k;
        }

        public function _Str_16497(k:Bool)
        {
            if (((ASCompat.reinterpretAs(this._view , IInteractiveWindow) != null) && k))
            {
                ASCompat.reinterpretAs(this._view , IInteractiveWindow).setMouseCursorForState(WindowState.HOVERING, MouseCursorType.DRAG);
                ASCompat.reinterpretAs(this._view , IInteractiveWindow).setMouseCursorForState((ASCompat.toInt(WindowState.HOVERING )| ASCompat.toInt(WindowState.ACTIVE)), MouseCursorType.DRAG);
            }
        }

        function _Str_5162(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = false;
            if (k.type == WindowMouseEvent.UP)
            {
                this._Str_3737 = null;
            }
            else
            {
                if (k.type == WindowMouseEvent.DOWN)
                {
                    if (_arg_2 == null)
                    {
                        return;
                    }
                    this._grid.select(this, true);
                    this._Str_3737 = _arg_2;
                }
                else
                {
                    if ((((k.type == WindowMouseEvent.OUT) && (!(this._Str_3737 == null))) && (this._Str_3737 == _arg_2)))
                    {
                        _local_3 = this._grid._Str_9974(this);
                        if (_local_3)
                        {
                            this._Str_3737 = null;
                        }
                    }
                    else
                    {
                        if (k.type == WindowMouseEvent.UP)
                        {
                            this._Str_3737 = null;
                        }
                        else
                        {
                            if (k.type == WindowMouseEvent.CLICK)
                            {
                                this._Str_3737 = null;
                            }
                            else
                            {
                                if (k.type == WindowMouseEvent.DOUBLE_CLICK)
                                {
                                    this._Str_3737 = null;
                                }
                            }
                        }
                    }
                }
            }
        }

        public function setIconImage(k:BitmapData, _arg_2:Bool)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            if (k == null)
            {
                return;
            }
            if (((!(this._icon == null)) && (!this._icon.disposed)))
            {
                _local_3 = Std.int((this._icon.width - k.width) / 2);
                _local_4 = Std.int((this._icon.height - k.height) / 2);
                if (this._icon.bitmap == null)
                {
                    this._icon.bitmap = new BitmapData(this._icon.width, this._icon.height, true, 0xFFFFFF);
                }
                else
                {
                    this._icon.bitmap.fillRect(this._icon.bitmap.rect, 0xFFFFFF);
                }
                this._icon.bitmap.copyPixels(k, k.rect, new Point(_local_3, _local_4), null, null, false);
                this._icon.invalidate();
            }
            if (_arg_2)
            {
                k.dispose();
            }
        }

        function _Str_12672(k:String, _arg_2:IAvatarImageListener):BitmapData
        {
            var _local_3= this._habboCatalog.avatarRenderManager.createAvatarImage(k, AvatarScaleType.LARGE, null, _arg_2);
var _local_4= _local_3.getCroppedImage(AvatarSetType.HEAD, 0.5);
            _local_3.dispose();
            return _local_4;
        }
    }

