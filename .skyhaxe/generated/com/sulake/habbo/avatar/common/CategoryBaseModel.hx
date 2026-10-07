package com.sulake.habbo.avatar.common
;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.avatar.HabboAvatarEditor;
    import com.sulake.habbo.inventory.IHabboInventory;
    import com.sulake.core.window.IWindow;

     class CategoryBaseModel implements IAvatarEditorCategoryModel 
    {
        var _categories:Map;
        var _controller:HabboAvatarEditor;
        var _isInitialized:Bool = false;
        var _view:IAvatarEditorCategoryView;
        var _disposed:Bool = false;

        public function new(k:HabboAvatarEditor)
        {
            this._controller = k;
        }

        public function dispose()
        {
            if (this._view != null)
            {
                this._view.dispose();
            }
            this._view = null;
            this._categories = null;
            this._controller = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function init()
        {
            if (this._categories == null)
            {
                this._categories = new Map();
            }
        }

        public function reset()
        {
            var k:CategoryData = null;
            this._isInitialized = false;
            final _iter_ = this._categories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                if (k != null)
                {
                    k.dispose();
                }
            }
            this._categories = new Map();
            if (this._view != null)
            {
                this._view.reset();
            }
        }

        function _Str_3130(k:String)
        {
            var _local_3:CategoryData = null;
            var _local_2:CategoryData = this._categories.getValue(k);
            if (_local_2 == null)
            {
                _local_3 = this._controller.generateDataContent(this, k);
                if (_local_3 != null)
                {
                    this._categories.setProperty(k, _local_3);
                    this.updateSelectionsFromFigure(k);
                }
            }
        }

        public function switchCategory(k:String="")
        {
            if (!this._isInitialized)
            {
                this.init();
            }
            if (this._view != null)
            {
                this._view.switchCategory(k);
            }
        }

        function updateSelectionsFromFigure(k:String)
        {
            if ((((!(this._categories != null)) || (!(this._controller != null))) || (!(this._controller.figureData != null))))
            {
                return;
            }
            var _local_2:CategoryData = this._categories.getValue(k);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._controller.figureData.getPartSetId(k);
            var _local_4= this._controller.figureData.getColourIds(k);
            if (_local_4 == null)
            {
                _local_4 = new Array<ASAny>();
            }
            _local_2._Str_20245(_local_3);
            _local_2._Str_17669(_local_4);
            if (this._view != null)
            {
                this._view._Str_5614(k, _local_4.length);
            }
        }

        public function _Str_20411(k:Int):Bool
        {
            var _local_2:CategoryData = null;
            var _local_3 = false;
            if (this._categories == null)
            {
                return false;
            }
            final _iter_ = this._categories.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2 != null)
                {
                    _local_3 = _local_2._Str_23352(k);
                    if (_local_3)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        public function _Str_7960(k:IHabboInventory):Bool
        {
            var _local_2:CategoryData = null;
            var _local_3 = false;
            if (this._categories == null)
            {
                return false;
            }
            final _iter_ = this._categories.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2 != null)
                {
                    _local_3 = _local_2._Str_7960(k);
                    if (_local_3)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        public function _Str_15298(k:Int):Bool
        {
            var _local_5:String = null;
            var _local_6:CategoryData = null;
            var _local_7 = false;
            var _local_8:AvatarEditorGridPartItem = null;
            if (this._categories == null)
            {
                return false;
            }
            var _local_2= this._categories.getKeys();
            var _local_3 = false;
            var _local_4 = 0;
            while (_local_4 < _local_2.length)
            {
                _local_5 = _local_2[_local_4];
                _local_6 = this._categories.getValue(_local_5);
                _local_7 = false;
                if (_local_6._Str_15298(k))
                {
                    _local_7 = true;
                }
                if (_local_6._Str_23810(k))
                {
                    _local_7 = true;
                }
                if (_local_7)
                {
                    _local_8 = _local_6._Str_6315();
                    if (((((_local_8 != null) && (this._controller != null)) && (this._controller.figureData != null)) && (_local_6 != null)))
                    {
                        this._controller.figureData._Str_2088(_local_5, _local_8.id, _local_6.getSelectedColorIds(), true);
                    }
                    _local_3 = true;
                }
                _local_4++;
            }
            return _local_3;
        }

        public function _Str_8360():Bool
        {
            var _local_4:String = null;
            var _local_5:CategoryData = null;
            var _local_6 = false;
            var _local_7:AvatarEditorGridPartItem = null;
            if (this._categories == null)
            {
                return false;
            }
            var k= this._categories.getKeys();
            var _local_2 = false;
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                _local_4 = k[_local_3];
                _local_5 = this._categories.getValue(_local_4);
                _local_6 = false;
                if (_local_5._Str_8360(this._controller.manager.inventory))
                {
                    _local_6 = true;
                }
                if (_local_6)
                {
                    _local_7 = _local_5._Str_6315();
                    if (((((_local_7 != null) && (this._controller != null)) && (this._controller.figureData != null)) && (_local_5 != null)))
                    {
                        this._controller.figureData._Str_2088(_local_4, _local_7.id, _local_5.getSelectedColorIds(), true);
                    }
                    _local_2 = true;
                }
                _local_3++;
            }
            return _local_2;
        }

        public function selectPart(k:String, _arg_2:Int)
        {
            var _local_3:CategoryData = this._categories.getValue(k);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= _local_3._Str_22359;
            _local_3._Str_8066(_arg_2);
            var _local_5= _local_3._Str_6315();
            if (_local_5 == null)
            {
                return;
            }
            if (_local_5._Str_14863)
            {
                _local_3._Str_8066(_local_4);
                this._controller.openHabboClubAdWindow();
                return;
            }
            if (this._view != null)
            {
                this._view._Str_5614(k, _local_5._Str_17445);
            }
            if (((this._controller != null) && (this._controller.figureData != null)))
            {
                this._controller.figureData._Str_2088(k, _local_5.id, _local_3.getSelectedColorIds(), true);
            }
        }

        public function selectColor(k:String, _arg_2:Int, _arg_3:Int)
        {
            var _local_6:AvatarEditorGridColorItem = null;
            var _local_4:CategoryData = this._categories.getValue(k);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5= _local_4._Str_24480(_arg_3);
            _local_4._Str_17959(_arg_2, _arg_3);
            if (((this._controller != null) && (this._controller.figureData != null)))
            {
                _local_6 = _local_4.getSelectedColor(_arg_3);
                if (_local_6.isDisabledForWearing)
                {
                    _local_4._Str_17959(_local_5, _arg_3);
                    this._controller.openHabboClubAdWindow();
                    return;
                }
                this._controller.figureData.savePartSetColourId(k, _local_4.getSelectedColorIds(), true);
            }
        }

        public var controller(get,never):HabboAvatarEditor;
public function  get_controller():HabboAvatarEditor
        {
            return this._controller;
        }

        public function getWindowContainer():IWindow
        {
            if (!this._isInitialized)
            {
                this.init();
            }
            if (this._view == null)
            {
                return null;
            }
            return this._view.getWindowContainer();
        }

        public function getCategoryData(k:String):CategoryData
        {
            if (!this._isInitialized)
            {
                this.init();
            }
            if (this._categories == null)
            {
                return null;
            }
            return this._categories.getValue(k);
        }
    }

