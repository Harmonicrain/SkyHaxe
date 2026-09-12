package com.sulake.habbo.avatar.misc
;
    import com.sulake.habbo.avatar.HabboAvatarEditor;
    import com.sulake.habbo.avatar.common.CategoryBaseModel;
    import com.sulake.habbo.avatar.common.CategoryData;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryModel;
    import com.sulake.habbo.avatar.figuredata.FigureData;

     class MiscModel extends CategoryBaseModel implements IAvatarEditorCategoryModel 
    {
        public function new(k:HabboAvatarEditor)
        {
            super(k);
        }

        override function init()
        {
            super.init();
            _Str_3130(FigureData.PET);
            _Str_3130(FigureData.MISC);
            this.ensureEmptyCategory(FigureData.PET);
            this.ensureEmptyCategory(FigureData.MISC);
            _isInitialized = true;
            if (_view == null)
            {
                _view = new MiscView(this);
                if (_view != null)
                {
                    _view.init();
                }
            }
        }

        function ensureEmptyCategory(k:String)
        {
            if ((_categories == null) || (_categories.getValue(k)!= null))
            {
                return;
            }
            _categories.setProperty(k, new CategoryData([], []));
        }
    }

