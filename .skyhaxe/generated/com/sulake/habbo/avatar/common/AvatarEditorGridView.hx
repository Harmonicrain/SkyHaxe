package com.sulake.habbo.avatar.common
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IScrollableGridWindow;
    import com.sulake.core.window.events.WindowEvent;

     class AvatarEditorGridView implements IAvatarEditorGridView 
    {
        public static inline final REMOVE_ITEM= "REMOVE_ITEM";
        public static inline final GET_MORE= "GET_MORE";

        static inline final _Str_6331= 2;

        var _view:IWindowContainer;
        var _model:IAvatarEditorCategoryModel;
        var _partGrid:IItemGridWindow;
        var _paletteGrids:Array<ASAny>;
        var _categoryId:String;
        var _notification:IWindow;
        var _title:IWindow;

        public function new(k:IWindowContainer)
        {
            this._view = k;
            this._partGrid = Std.downcast(this._view.findChildByName("thumbs") , IItemGridWindow);
            this._paletteGrids = [];
            this._paletteGrids.push(Std.downcast(this._view.findChildByName("palette0") , IItemGridWindow));
            this._paletteGrids.push(Std.downcast(this._view.findChildByName("palette1") , IItemGridWindow));
            this._notification = this._view.findChildByName("content_notification");
            this._title = this._view.findChildByName("content_title");
            this._notification.visible = false;
            this._title.visible = false;
        }

        public function dispose()
        {
            var k:IItemGridWindow = null;
            if (this._partGrid != null)
            {
                this._partGrid.dispose();
                this._partGrid = null;
            }
            if (this._paletteGrids != null)
            {
                final _iter_ = this._paletteGrids; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    if (k != null)
                    {
                        k.dispose();
                        k = null;
                    }
                }
                this._paletteGrids = null;
            }
            this._model = null;
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
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

        public function initFromList(k:IAvatarEditorCategoryModel, _arg_2:String)
        {
            var _local_4:IItemGridWindow = null;
            var _local_5:AvatarEditorGridPartItem = null;
            var _local_6 = 0;
            var _local_7:Array<ASAny> = null;
            var _local_8:AvatarEditorGridColorItem = null;
            var _local_3= k.getCategoryData(_arg_2);
            if (_local_3 == null)
            {
                return;
            }
            this._view.visible = true;
            this._model = k;
            this._categoryId = _arg_2;
            this._partGrid.removeGridItems();
            if (_local_3.parts.length == 0)
            {
                this._title.visible = true;
                this._notification.visible = true;
            }
            else
            {
                this._title.visible = false;
                this._notification.visible = false;
                final _iter_ = this._paletteGrids; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    _local_4.removeGridItems();
                }
                final _iter_ = _local_3.parts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_5  = _tmp_;
                    if (_local_5 != null)
                    {
                        this._partGrid.addGridItem(_local_5.view);
                        _local_5.view.addEventListener(WindowMouseEvent.CLICK, this._Str_22871);
                        if (_local_5.Selected)
                        {
                            this._Str_5614(_local_5._Str_17445);
                        }
                    }
                }
                _local_6 = 0;
                while (_local_6 < AvatarEditorGridView._Str_6331)
                {
                    _local_7 = _local_3.getPalette(_local_6);
                    _local_4 = ASCompat.dynamicAs(this._paletteGrids[_local_6] , IItemGridWindow);
                    if (!((!(_local_7 != null)) || (!(_local_4 != null))))
                    {
                        if (checkNullIteratee(_local_7)) for (_tmp_ in _local_7)
                        {
_local_8  = _tmp_;
                            _local_4.addGridItem(_local_8.view);
                            _local_8.view.procedure = this._Str_25838;
                        }
                    }
                    _local_6++;
                }
            }
        }

        public function _Str_5614(k:Int)
        {
            var _local_2= Std.downcast(this._view.findChildByName("palette0") , IScrollableGridWindow);
            var _local_3= Std.downcast(this._view.findChildByName("palette1") , IScrollableGridWindow);
            var _local_4= this._partGrid.width;
            var _local_5= Std.int((this._partGrid.width - 10) / 2);
            if (k <= 1)
            {
                _local_2.width = _local_4;
                _local_2.visible = true;
                _local_3.visible = false;
            }
            else
            {
                _local_2.width = _local_5;
                _local_3.width = _local_5;
                _local_3.x = (_local_2.right + 10);
                _local_2.visible = true;
                _local_3.visible = true;
            }
        }

        public function _Str_830(k:Int, _arg_2:IWindowContainer)
        {
            var _local_3= this._partGrid.getGridItemAt(k);
            if (_local_3 == null)
            {
                return;
            }
            _local_3 = _arg_2;
        }

        function _Str_22871(k:WindowMouseEvent)
        {
            var _local_2 = 0;
            switch (k.target.name)
            {
                case REMOVE_ITEM:
                    _local_2 = this._partGrid.getGridItemIndex(k.window);
                    this._model.selectPart(this._categoryId, _local_2);
                    return;
                case GET_MORE:
                    this._model.controller.manager.catalog.openCatalogPage(this._model.controller.manager.getProperty("catalog.clothes.page"));
                    return;
                default:
                    _local_2 = this._partGrid.getGridItemIndex(k.window);
                    this._model.selectPart(this._categoryId, _local_2);
            }
        }

        function _Str_25838(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            var _local_4:IItemGridWindow = null;
            var _local_5 = 0;
            var _local_6:IWindow = null;
            var _local_7 = 0;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_6 = k.window;
                _local_7 = 0;
                while (_local_7 < AvatarEditorGridView._Str_6331)
                {
                    if (this._paletteGrids.length > _local_7)
                    {
                        _local_4 = ASCompat.dynamicAs(this._paletteGrids[_local_7] , IItemGridWindow);
                        _local_5 = _local_4.getGridItemIndex(_local_6);
                        if (_local_5 > -1)
                        {
                            this._model.selectColor(this._categoryId, _local_5, _local_7);
                            return;
                        }
                    }
                    _local_7++;
                }
            }
        }
    }


