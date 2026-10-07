package com.sulake.habbo.avatar.effects
;
    import com.sulake.habbo.avatar.common.CategoryBaseView;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryView;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryModel;
    import com.sulake.habbo.avatar._enum.AvatarEditorFigureCategory;
    import com.sulake.core.window.IWindowContainer;

     class EffectsView extends CategoryBaseView implements IAvatarEditorCategoryView 
    {
        public function new(k:IAvatarEditorCategoryModel)
        {
            super(k);
        }

        override public function init()
        {
            if (window == null)
            {
                window = Std.downcast(_model.controller.view.getCategoryContainer(AvatarEditorFigureCategory.EFFECTS) , IWindowContainer);
                window.visible = false;
            }
            if (((_model != null) && (_Str_2889 == "")))
            {
                _model.switchCategory(EffectsModel.EFFECTS);
            }
            _isInitialized = true;
            this.updateGridView(_Str_2889);
        }

        override public function reset()
        {
            this.updateGridView(_Str_2889);
            _model.selectPart(_Str_2889, -1);
        }

        public function switchCategory(k:String)
        {
            if (window == null)
            {
                return;
            }
            if (window.disposed)
            {
                return;
            }
            k = ((k == "") ? _Str_2889 : k);
            _Str_2889 = k;
            if (!_isInitialized)
            {
                this.init();
            }
            this.updateGridView(_Str_2889);
        }

        public function _Str_8706(k:String, _arg_2:Int, _arg_3:Bool)
        {
            cast(_model.controller.view.effectsGridView, AvatarEditorGridViewEffects)._Str_24690(_arg_2, _arg_3);
        }

        public function _Str_17454(k:Int):Int
        {
            return cast(_model.controller.view.effectsGridView, AvatarEditorGridViewEffects)._Str_17454(k);
        }

        override function updateGridView(k:String)
        {
            _model.controller.view.effectsGridView.initFromList(_model, k);
        }
    }


