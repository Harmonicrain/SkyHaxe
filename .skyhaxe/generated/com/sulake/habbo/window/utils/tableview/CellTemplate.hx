package com.sulake.habbo.window.utils.tableview
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;

     class CellTemplate
    {
        var _template:IRegionWindow;
        var _highlightBorderTemplate:IBorderWindow;
        var _textTemplate:ITextWindow;
        var _inputTemplate:ITextFieldWindow;
        var _linkTemplate:IRegionWindow;
        var _extraButtonTemplate:IRegionWindow;

        public function new(template:IRegionWindow)
        {
            this._template = template;
            this._highlightBorderTemplate = Std.downcast(template.findChildByName("highlight_border") , IBorderWindow);
            this._textTemplate = Std.downcast(template.findChildByName("element_text") , ITextWindow);
            this._inputTemplate = Std.downcast(template.findChildByName("element_input") , ITextFieldWindow);
            this._linkTemplate = Std.downcast(template.findChildByName("link_container") , IRegionWindow);
            this._extraButtonTemplate = Std.downcast(template.findChildByName("extra_button") , IRegionWindow);

            if (this._extraButtonTemplate != null)
            {
                this._template.removeChild(this._extraButtonTemplate);
            }
            if (this._linkTemplate != null)
            {
                this._template.removeChild(this._linkTemplate);
            }
            if (this._inputTemplate != null)
            {
                this._template.removeChild(this._inputTemplate);
            }
            if (this._textTemplate != null)
            {
                this._template.removeChild(this._textTemplate);
            }
            if (this._highlightBorderTemplate != null)
            {
                this._template.removeChild(this._highlightBorderTemplate);
            }
        }

        public function clone():IRegionWindow
        {
            return Std.downcast(this._template.clone() , IRegionWindow);
        }

        public function createHighlightBorder(parent:IWindowContainer):IBorderWindow
        {
            return Std.downcast(this.fixAlignmentsAndAdd(this._highlightBorderTemplate, parent) , IBorderWindow);
        }

        public function createElementText(parent:IWindowContainer):ITextWindow
        {
            return Std.downcast(this.fixAlignmentsAndAdd(this._textTemplate, parent) , ITextWindow);
        }

        public function createElementInput(parent:IWindowContainer):ITextFieldWindow
        {
            return Std.downcast(this.fixAlignmentsAndAdd(this._inputTemplate, parent) , ITextFieldWindow);
        }

        public function createLinkContainer(parent:IWindowContainer):IRegionWindow
        {
            return Std.downcast(this.fixAlignmentsAndAdd(this._linkTemplate, parent) , IRegionWindow);
        }

        public function createExtraButton(parent:IWindowContainer):IRegionWindow
        {
            return Std.downcast(this.fixAlignmentsAndAdd(this._extraButtonTemplate, parent) , IRegionWindow);
        }

        function cloneAndAdd(template:IWindow, parent:IWindowContainer):IWindow
        {
            var clone:IWindow = null;
            if (template == null)
            {
                return null;
            }
            clone = template.clone();
            if (clone != null)
            {
                parent.addChild(clone);
            }
            return clone;
        }

        function fixAlignmentsAndAdd(template:IWindow, parent:IWindowContainer):IWindow
        {
            var widthDelta = 0;
            var clone:IWindow = null;
            var params:UInt = 0;
            var x = 0;
            var width = 0;
            var horizontalFlags:UInt = 0;
            if (template == null)
            {
                return null;
            }
            widthDelta = (parent.width - this._template.width);
            clone = template.clone();
            params = template.param;
            x = template.x;
            width = template.width;
            horizontalFlags = (ASCompat.toInt(params )& 0xC0);
            if (horizontalFlags == 128)
            {
                width = (width + widthDelta);
            }
            else
            {
                if (horizontalFlags == 64)
                {
                    x = (x + widthDelta);
                }
                else
                {
                    if (horizontalFlags == 192)
                    {
                        if (((parent.width < template.width) && template.getParamFlag(16)))
                        {
                            x = 0;
                        }
                        else
                        {
                            x = Std.int(Math.ffloor((parent.width / 2)) - Math.ffloor((width / 2)));
                        }
                    }
                }
            }
            clone.x = x;
            clone.width = width;
            parent.addChild(clone);
            return clone;
        }
    }

