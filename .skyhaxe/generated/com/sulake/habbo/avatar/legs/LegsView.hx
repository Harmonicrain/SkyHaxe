package com.sulake.habbo.avatar.legs
;
    import com.sulake.habbo.avatar.common.CategoryBaseView;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryView;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryModel;
    import com.sulake.habbo.avatar._enum.AvatarEditorFigureCategory;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.avatar.figuredata.FigureData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class LegsView extends CategoryBaseView implements IAvatarEditorCategoryView 
    {
        public function new(k:IAvatarEditorCategoryModel)
        {
            super(k);
        }

        override public function init()
        {
            if (window == null)
            {
                window = Std.downcast(_model.controller.view.getCategoryContainer(AvatarEditorFigureCategory.LEGS) , IWindowContainer);
                window.visible = false;
                window.procedure = this.windowEventProc;
            }
            _isInitialized = true;
            if (((_model != null) && (_Str_2889 == "")))
            {
                _model.switchCategory(FigureData.LG);
            }
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
            _Str_3905(_Str_2851);
            switch (k)
            {
                case FigureData.LG:
                    _Str_2851 = "tab_pants";
                    
                case FigureData.SH:
                    _Str_2851 = "tab_shoes";
                    
                case FigureData.WA:
                    _Str_2851 = "tab_belts";
                    
                default:
                    throw new ASError((('[LegsView] Unknown item category: "' + k) + '"'));
            }
            _Str_2889 = k;
            _Str_3621(_Str_2851);
            if (!_isInitialized)
            {
                this.init();
            }
            updateGridView(_Str_2889);
        }

        function windowEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "tab_pants":
                        this.switchCategory(FigureData.LG);
                        
                    case "tab_shoes":
                        this.switchCategory(FigureData.SH);
                        
                    case "tab_belts":
                        this.switchCategory(FigureData.WA);
                        
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    switch (_arg_2.name)
                    {
                        case "tab_pants"
                           | "tab_shoes"
                           | "tab_belts":
                            _Str_3621(_arg_2.name);
                            
                    }
                }
                else
                {
                    if (k.type == WindowMouseEvent.OUT)
                    {
                        switch (_arg_2.name)
                        {
                            case "tab_pants"
                               | "tab_shoes"
                               | "tab_belts":
                                if (_Str_2851 != _arg_2.name)
                                {
                                    _Str_3905(_arg_2.name);
                                }
                                return;
                        }
                    }
                }
            }
        }
    }

