package com.sulake.habbo.avatar.generic
;
    import com.sulake.habbo.avatar.common.CategoryBaseModel;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryModel;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar.HabboAvatarEditor;
    import com.sulake.habbo.avatar.figuredata.FigureData;
    import com.sulake.habbo.avatar.common.CategoryData;
    import com.sulake.habbo.avatar.common.AvatarEditorGridPartItem;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;

     class BodyModel extends CategoryBaseModel implements IAvatarEditorCategoryModel implements  IAvatarImageListener 
    {
        var _imageCallBackHandled:Bool = false;

        public function new(k:HabboAvatarEditor)
        {
            super(k);
        }

        override function init()
        {
            super.init();
            _Str_3130(FigureData.FACE);
            _isInitialized = true;
            if (_view == null)
            {
                _view = new BodyView(this);
                if (_view != null)
                {
                    _view.init();
                }
            }
        }

        override public function switchCategory(k:String="")
        {
            _view.switchCategory(k);
        }

        override public function selectColor(k:String, _arg_2:Int, _arg_3:Int)
        {
            var _local_4:CategoryData = _categories.getValue(k);
            if (_local_4 == null)
            {
                return;
            }
            _local_4._Str_17959(_arg_2, _arg_3);
            var _local_5= _local_4.getSelectedColor(_arg_3);
            if (_local_5.isDisabledForWearing)
            {
                _controller.openHabboClubAdWindow();
                return;
            }
            _controller.figureData.savePartSetColourId(k, _local_4.getSelectedColorIds(), true);
            this.updateSelectionsFromFigure(FigureData.FACE);
        }

        override function updateSelectionsFromFigure(k:String)
        {
            var _local_5:AvatarEditorGridPartItem = null;
            var _local_6:String = null;
            var _local_7:IAvatarImage = null;
            if (_categories == null)
            {
                return;
            }
            var _local_2= _controller.figureData.getPartSetId(FigureData.FACE);
            var _local_3= _controller.figureData.getColourIds(FigureData.FACE);
            var _local_4:CategoryData = _categories.getValue(k);
            if (_local_4 == null)
            {
                return;
            }
            _local_4._Str_20245(_local_2);
            _local_4._Str_17669(_local_3);
            final _iter_ = _local_4.parts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                _local_6 = _controller.figureData.getFigureStringWithFace(_local_5.id);
                _local_7 = _controller.manager.avatarRenderManager.createAvatarImage(_local_6, AvatarScaleType.LARGE, null, this);
_local_5.icon = _local_7.getCroppedImage(AvatarSetType.HEAD);
                _local_7.dispose();
            }
        }

        public function avatarImageReady(k:String)
        {
            if (!this._imageCallBackHandled)
            {
                this._imageCallBackHandled = true;
                this.updateSelectionsFromFigure(FigureData.FACE);
            }
        }
    }


