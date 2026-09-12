package com.sulake.habbo.avatar.effects
;
    import com.sulake.habbo.avatar.common.IAvatarEditorGridView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryModel;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.avatar.IHabboAvatarEditorAvatarEffect;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.avatar.common.*;

     class AvatarEditorGridViewEffects implements IAvatarEditorGridView 
    {
        var _view:IWindowContainer;
        var _firstView:Bool = true;
        var _model:IAvatarEditorCategoryModel;
        var _categoryId:String;
        var _partGrid:IItemGridWindow;
        var _effectItems:Vector<AvatarEditorGridItemEffect>;
        var _notification:IWindow;
        var _title:IWindow;

        public function new(k:IWindowContainer)
        {
            this._view = k;
            this._partGrid = Std.downcast(this._view.findChildByName("thumbs") , IItemGridWindow);
            this._notification = this._view.findChildByName("content_notification");
            this._title = this._view.findChildByName("content_title");
        }

        public function dispose()
        {
            if (this._partGrid != null)
            {
                this._partGrid.dispose();
                this._partGrid = null;
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
            return this._view;
        }

        public function initFromList(k:IAvatarEditorCategoryModel, _arg_2:String)
        {
            var _local_4:AvatarEditorGridItemEffect = null;
            var _local_5:IHabboAvatarEditorAvatarEffect = null;
            this._model = k;
            this._categoryId = _arg_2;
            this._view.visible = true;
            var _local_3= cast(this._model, EffectsModel).effects;
            this._partGrid.removeGridItems();
            this._effectItems = new Vector<AvatarEditorGridItemEffect>();
            if (_local_3.length == 0)
            {
                this._title.visible = true;
                this._notification.visible = true;
            }
            else
            {
                this._notification.visible = false;
                this._title.visible = false;
                _local_4 = new AvatarEditorGridItemEffect(null, this._model.controller.manager.windowManager, this._model.controller.manager.assets);
                this.addGridItem(_local_4);
                if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
                {
_local_5  = _tmp_;
                    _local_4 = new AvatarEditorGridItemEffect(_local_5, this._model.controller.manager.windowManager, this._model.controller.manager.assets);
                    this.addGridItem(_local_4);
                }
            }
            this._Str_5614(0);
            this._firstView = false;
        }

        function addGridItem(k:AvatarEditorGridItemEffect)
        {
            k.window.procedure = this._Str_23531;
            this._effectItems.push(k);
            this._partGrid.addGridItem(k.window);
        }

        public function _Str_5614(k:Int)
        {
            var _local_2= this._view.findChildByName("palette0");
            var _local_3= this._view.findChildByName("palette1");
            _local_2.visible = false;
            _local_3.visible = false;
        }

        public var _Str_26200(get,never):Bool;
public function  get__Str_26200():Bool
        {
            return this._firstView;
        }

        public function _Str_24690(k:Int, _arg_2:Bool)
        {
            if (((k >= 0) && (k < this._effectItems.length)))
            {
                this._effectItems[k].selected = _arg_2;
            }
        }

        public function _Str_17454(k:Int):Int
        {
            var _local_2 = 0;
            while (_local_2 < this._effectItems.length)
            {
                if (this._effectItems[_local_2].effectType == k)
                {
                    return _local_2;
                }
                _local_2++;
            }
            return -1;
        }

        function _Str_23531(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            if (k.type == WindowMouseEvent.DOWN)
            {
                _local_3 = this._partGrid.getGridItemIndex(k.window);
                this._model.selectPart(this._categoryId, _local_3);
            }
        }
    }

