package com.sulake.habbo.avatar.hotlooks
;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.habbo.avatar._enum.AvatarEditorFigureCategory;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.avatar.wardrobe.Outfit;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class HotLooksView implements IAvatarEditorCategoryView 
    {
        var _window:IWindowContainer;
        var _model:HotLooksModel;
        var _hotLooksGrid:IItemGridWindow;

        public function new(k:HotLooksModel)
        {
            this._model = k;
        }

        public function init()
        {
            if (this._hotLooksGrid != null)
            {
                this._hotLooksGrid.removeGridItems();
            }
            if (this._window == null)
            {
                this._window = Std.downcast(this._model.controller.view.getCategoryContainer(AvatarEditorFigureCategory.HOTLOOKS) , IWindowContainer);
                this._hotLooksGrid = Std.downcast(this._window.findChildByName("hotlooks") , IItemGridWindow);
                this._window.visible = false;
            }
            this.update();
        }

        public function dispose()
        {
            this._hotLooksGrid.removeGridItems();
            this._window = null;
            this._model = null;
        }

        public function update()
        {
            var k:IWindow = null;
            var _local_2:Outfit = null;
            this._hotLooksGrid.removeGridItems();
            final _iter_ = this._model.hotLooks; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k = _local_2.view.window;
                this._hotLooksGrid.addGridItem(k);
                k.procedure = this._Str_23998;
            }
        }

        public function getWindowContainer():IWindowContainer
        {
            return this._window;
        }

        function _Str_23998(k:WindowEvent, _arg_2:IWindow=null)
        {
            var _local_3 = 0;
            if (_arg_2 == null)
            {
                _arg_2 = k.target ;
            }
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = this._hotLooksGrid.getGridItemIndex(_arg_2.parent);
                this._model.selectHotLook(_local_3);
            }
        }

        public function switchCategory(k:String)
        {
        }

        public function _Str_5614(k:String, _arg_2:Int)
        {
        }

        public function reset()
        {
        }
    }

