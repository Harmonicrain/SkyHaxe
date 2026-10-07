package com.sulake.habbo.avatar.head
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

     class HeadView extends CategoryBaseView implements IAvatarEditorCategoryView 
    {
        public function new(k:IAvatarEditorCategoryModel)
        {
            super(k);
        }

        override public function init()
        {
            if (window == null)
            {
                window = Std.downcast(_model.controller.view.getCategoryContainer(AvatarEditorFigureCategory.HEAD) , IWindowContainer);
                window.visible = false;
                window.procedure = this.windowEventProc;
            }
            _isInitialized = true;
            if (((_model != null) && (_Str_2889 == "")))
            {
                _model.switchCategory(FigureData.HR);
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
                case FigureData.HR:
                    _Str_2851 = "tab_hair";
                    
                case FigureData.HA:
                    _Str_2851 = "tab_hat";
                    
                case FigureData.HE:
                    _Str_2851 = "tab_accessories";
                    
                case FigureData.EA:
                    _Str_2851 = "tab_eyewear";
                    
                case FigureData.FA:
                    _Str_2851 = "tab_masks";
                    
                default:
                    throw new ASError((('[HeadView] Unknown item category: "' + k) + '"'));
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
                    case "tab_hair":
                        this.switchCategory(FigureData.HR);
                        
                    case "tab_hat":
                        this.switchCategory(FigureData.HA);
                        
                    case "tab_accessories":
                        this.switchCategory(FigureData.HE);
                        
                    case "tab_eyewear":
                        this.switchCategory(FigureData.EA);
                        
                    case "tab_masks":
                        this.switchCategory(FigureData.FA);
                        
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    switch (_arg_2.name)
                    {
                        case "tab_hair"
                           | "tab_hat"
                           | "tab_accessories"
                           | "tab_eyewear"
                           | "tab_masks":
                            _Str_3621(_arg_2.name);
                            
                    }
                }
                else
                {
                    if (k.type == WindowMouseEvent.OUT)
                    {
                        switch (_arg_2.name)
                        {
                            case "tab_hair"
                               | "tab_hat"
                               | "tab_accessories"
                               | "tab_eyewear"
                               | "tab_masks":
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

