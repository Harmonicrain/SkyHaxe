package com.sulake.habbo.avatar.generic
;
    import com.sulake.habbo.avatar.common.CategoryBaseView;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryView;
    import com.sulake.habbo.avatar.figuredata.FigureData;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryModel;
    import com.sulake.habbo.avatar._enum.AvatarEditorFigureCategory;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class BodyView extends CategoryBaseView implements IAvatarEditorCategoryView 
    {
        static inline final TAB_BOY_ID= "tab_boy";
        static inline final TAB_GIRL_ID= "tab_girl";

        public function new(k:IAvatarEditorCategoryModel)
        {
            super(k);
            _Str_2889 = FigureData.FACE;
        }

        override public function reset()
        {
            super.reset();
            _Str_2889 = FigureData.FACE;
        }

        override public function init()
        {
            if (window == null)
            {
                window = Std.downcast(_model.controller.view.getCategoryContainer(AvatarEditorFigureCategory.GENERIC) , IWindowContainer);
                window.visible = false;
                window.procedure = this.windowEventProc;
            }
            updateGridView(FigureData.FACE);
            _isInitialized = true;
            this.updateGenderTab();
        }

        override public function getWindowContainer():IWindowContainer
        {
            if (!_isInitialized)
            {
                this.init();
            }
            this.updateGenderTab();
            return window;
        }

        public function updateGenderTab()
        {
            if (_model == null)
            {
                return;
            }
            switch (_model.controller.gender)
            {
                case FigureData.M:
                    _Str_3621(BodyView.TAB_BOY_ID);
                    _Str_3905(BodyView.TAB_GIRL_ID);
                    return;
                case FigureData.F:
                    _Str_3621(BodyView.TAB_GIRL_ID);
                    _Str_3905(BodyView.TAB_BOY_ID);
                    return;
            }
        }

        public function switchCategory(k:String)
        {
            this.updateGenderTab();
            updateGridView(((k == "") ? _Str_2889 : k));
        }

        function windowEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case BodyView.TAB_BOY_ID:
                        _model.controller.gender = FigureData.M;
                        k.stopPropagation();
                        
                    case BodyView.TAB_GIRL_ID:
                        _model.controller.gender = FigureData.F;
                        k.stopPropagation();
                        
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    switch (_arg_2.name)
                    {
                        case BodyView.TAB_BOY_ID
                           | BodyView.TAB_GIRL_ID:
                            _Str_3621(_arg_2.name);
                            
                    }
                }
                else
                {
                    if (k.type == WindowMouseEvent.OUT)
                    {
                        switch (_arg_2.name)
                        {
                            case BodyView.TAB_BOY_ID
                               | BodyView.TAB_GIRL_ID:
                                this.updateGenderTab();
                                return;
                        }
                    }
                }
            }
        }
    }

