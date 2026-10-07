package com.sulake.habbo.avatar.torso
;
    import com.sulake.habbo.avatar.common.CategoryBaseView;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryView;
    import com.sulake.habbo.avatar._enum.AvatarEditorFigureCategory;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.avatar.figuredata.FigureData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class TorsoView extends CategoryBaseView implements IAvatarEditorCategoryView 
    {
        public function new(k:TorsoModel)
        {
            super(k);
        }

        override public function init()
        {
            if (window == null)
            {
                window = Std.downcast(_model.controller.view.getCategoryContainer(AvatarEditorFigureCategory.TORSO) , IWindowContainer);
                window.visible = false;
                window.procedure = this.windowEventProc;
            }
            _isInitialized = true;
            if (((_model != null) && (_Str_2889 == "")))
            {
                _model.switchCategory(FigureData.CH);
            }
        }

        override public function dispose()
        {
            super.dispose();
            _model = null;
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
                case FigureData.CH:
                    _Str_2851 = "tab_shirt";
                    
                case FigureData.CC:
                    _Str_2851 = "tab_jacket";
                    
                case FigureData.CHEST_PRINTS:
                    _Str_2851 = "tab_prints";
                    
                case FigureData.CHEST_ACCESSORIES:
                    _Str_2851 = "tab_accessories";
                    
                default:
                    throw new ASError((('[TorsoView] Unknown item category: "' + k) + '"'));
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
                    case "tab_jacket":
                        this.switchCategory(FigureData.CC);
                        
                    case "tab_shirt":
                        this.switchCategory(FigureData.CH);
                        
                    case "tab_accessories":
                        this.switchCategory(FigureData.CHEST_ACCESSORIES);
                        
                    case "tab_prints":
                        this.switchCategory(FigureData.CHEST_PRINTS);
                        
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    switch (_arg_2.name)
                    {
                        case "tab_jacket"
                           | "tab_prints"
                           | "tab_shirt"
                           | "tab_accessories":
                            _Str_3621(_arg_2.name);
                            
                    }
                }
                else
                {
                    if (k.type == WindowMouseEvent.OUT)
                    {
                        switch (_arg_2.name)
                        {
                            case "tab_jacket"
                               | "tab_prints"
                               | "tab_shirt"
                               | "tab_accessories":
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

