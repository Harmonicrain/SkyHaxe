package com.sulake.habbo.avatar.misc
;
    import com.sulake.habbo.avatar.common.CategoryBaseView;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryModel;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryView;
    import com.sulake.habbo.avatar._enum.AvatarEditorFigureCategory;
    import com.sulake.habbo.avatar.figuredata.FigureData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;

     class MiscView extends CategoryBaseView implements IAvatarEditorCategoryView 
    {
        final defaultCategory:String = FigureData.PET;

        public function new(k:IAvatarEditorCategoryModel)
        {
            super(k);
        }

        override public function init()
        {
            if (window == null)
            {
                window = Std.downcast(_model.controller.view.getCategoryContainer(AvatarEditorFigureCategory.MISC) , IWindowContainer);
                if (window == null)
                {
                    return;
                }
                window.visible = false;
                window.procedure = this.windowEventProc;
            }
            _isInitialized = true;
            if (((_model != null) && (_Str_2889 == "")))
            {
                _model.switchCategory(this.defaultCategory);
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
            _Str_3905(_Str_2851);
            k = ((k == "") ? _Str_2889 : k);
            switch (k)
            {
                case FigureData.PET:
                    _Str_2851 = "tab_pets";
                    
                case FigureData.MISC:
                    _Str_2851 = "tab_misc";
                    
                default:
                    throw new ASError((('[MiscView] Unknown item category: "' + k) + '"'));
            }
            _Str_2889 = k;
            _Str_3621(_Str_2851);
            if (!_isInitialized)
            {
                this.init();
            }
            updateGridView(k);
        }

        function windowEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "tab_pets":
                        this.switchCategory(FigureData.PET);
                        
                    case "tab_misc":
                        this.switchCategory(FigureData.MISC);
                        
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    switch (_arg_2.name)
                    {
                        case "tab_pets"
                           | "tab_misc":
                            _Str_3621(_arg_2.name);
                            
                    }
                }
                else
                {
                    if (k.type == WindowMouseEvent.OUT)
                    {
                        switch (_arg_2.name)
                        {
                            case "tab_pets"
                               | "tab_misc":
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

