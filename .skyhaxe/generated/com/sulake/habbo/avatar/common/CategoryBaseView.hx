package com.sulake.habbo.avatar.common
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;

     class CategoryBaseView 
    {
        var window:IWindowContainer;
        var _Str_2889:String = "";
        var _Str_2851:String = "";
        var _model:IAvatarEditorCategoryModel;
        var _isInitialized:Bool = false;

        public function new(k:IAvatarEditorCategoryModel)
        {
            this._model = k;
        }

        public function dispose()
        {
            if (this.window != null)
            {
                this.window.dispose();
                this.window = null;
            }
            this._model = null;
            this._isInitialized = false;
        }

        public function init()
        {
        }

        public function reset()
        {
            this._Str_2889 = "";
            this._Str_2851 = "";
            this._isInitialized = false;
        }

        public function getWindowContainer():IWindowContainer
        {
            if (!this._isInitialized)
            {
                this.init();
            }
            return this.window;
        }

        public function _Str_5614(k:String, _arg_2:Int)
        {
            this._model.controller.view._Str_19197._Str_5614(_arg_2);
        }

        function updateGridView(k:String)
        {
            this._model.controller.view._Str_19197.initFromList(this._model, k);
        }

        function _Str_3621(k:String)
        {
            var _local_3:IStaticBitmapWrapperWindow = null;
            if (this.window == null)
            {
                return;
            }
            var _local_2= Std.downcast(this.window.findChildByName(k) , IWindowContainer);
            if (_local_2 != null)
            {
                _local_3 = Std.downcast(_local_2.findChildByTag("BITMAP") , IStaticBitmapWrapperWindow);
                TabUtils.setElementImage(_local_3, true);
            }
        }

        function _Str_3905(k:String)
        {
            var _local_3:IStaticBitmapWrapperWindow = null;
            if (this.window == null)
            {
                return;
            }
            var _local_2= Std.downcast(this.window.findChildByName(k) , IWindowContainer);
            if (_local_2 != null)
            {
                _local_3 = Std.downcast(_local_2.findChildByTag("BITMAP") , IStaticBitmapWrapperWindow);
                TabUtils.setElementImage(_local_3, false);
            }
        }
    }


