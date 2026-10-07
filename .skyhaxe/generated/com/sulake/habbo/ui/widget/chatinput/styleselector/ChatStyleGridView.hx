package com.sulake.habbo.ui.widget.chatinput.styleselector
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindowContainer;
    import flash.geom.Point;

     class ChatStyleGridView implements IDisposable 
    {
        static inline final _Str_14727= 92;

        var _window:IBorderWindow;
        var _selector:ChatStyleSelector;

        public function new(k:ChatStyleSelector, _arg_2:ISessionDataManager)
        {
            this._selector = k;
            var _local_3= k._Str_20286.widget.assets;
            var _local_4= Std.downcast(_local_3.getAssetByName("styleselector_menu_new_xml") , XmlAsset);
            this._window = (((_local_4 == null) || (_local_4.content == null)) ? null : cast(k._Str_20286.widget.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_local_4.content)), IBorderWindow));
            if (this._window == null)
            {
                return;
            }
            this._window.visible = false;
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.dispose();
            }
            this._window = null;
            this._selector = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._window == null;
        }

        public var grid(get,never):IItemGridWindow;
public function  get_grid():IItemGridWindow
        {
            if (this._window == null)
            {
                return null;
            }
            return cast(this._window.findChildByName("itemgrid"), IItemGridWindow);
        }

        public var fontSizeList(get,never):IItemListWindow;
public function  get_fontSizeList():IItemListWindow
        {
            if (this._window == null)
            {
                return null;
            }
            return cast(this._window.findChildByName("font_size_list"), IItemListWindow);
        }

        public var window(get,never):IBorderWindow;
public function  get_window():IBorderWindow
        {
            return this._window;
        }

        public function _Str_25385(k:IWindowContainer)
        {
            var _local_5 = 0;
            if (((this._window == null) || (k == null)) || (this._window.parent == null))
            {
                return;
            }
            var _local_2= new Rectangle();
            k.getGlobalRectangle(_local_2);
            var _local_3= cast(this._window.parent, IWindowContainer);
            _local_3.x = Std.int(_local_2.right - this._window.width);
            _local_3.y = Std.int(_local_2.bottom - this._window.height);
            var _local_4= new Point();
            _local_3.getGlobalPosition(_local_4);
            if (_local_4.x < _Str_14727)
            {
                _local_5 = Std.int(_Str_14727 - _local_4.x);
                _local_3.x = (_local_3.x + _local_5);
            }
            _local_3.x = Std.int(_local_2.x);
            _local_3.y = Std.int((_local_2.bottom - 35) - this._window.height);
        }
    }

