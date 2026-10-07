package com.sulake.habbo.inventory.badges
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.IWidgetWindow;

     class Badge 
    {
        static inline final _Str_4072= 0xCCCCCC;
        static inline final _Str_4169= 10275685;

        var _badgeId:String;
        var _isInUse:Bool = false;
        var _isSelected:Bool = false;
        var _window:IWindowContainer;
        var _selectionHighlighter:IWindow;
        var _isUnseen:Bool = false;

        public function new(badgeId:String, window:IWindowContainer, isUnseen:Bool)
        {
            this._badgeId = badgeId;
            this._window = window;
            this._selectionHighlighter = this._window.findChildByTag("BG_COLOR");
            this._isUnseen = isUnseen;
            cast(cast(this._window.findChildByName("badge"), IWidgetWindow).widget, IBadgeImageWidget).badgeId = badgeId;
            this._window.findChildByName("badge").visible = true;
            this.Selected = false;
        }

        public var badgeId(get,never):String;
public function  get_badgeId():String
        {
            return this._badgeId;
        }

        
        public var isInUse(get,set):Bool;
public function  get_isInUse():Bool
        {
            return this._isInUse;
        }

        
        public var Selected(get,set):Bool;
public function  get_Selected():Bool
        {
            return this._isSelected;
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }
public function  set_isInUse(k:Bool):Bool        {
            return this._isInUse = k;
        }
public function  set_Selected(k:Bool):Bool        {
            this._isSelected = k;
            if (this._selectionHighlighter == null)
            {
                return k;
            }
            this._selectionHighlighter.color = (this._isUnseen ? _Str_4169 : _Str_4072);
            return this._window.findChildByName("outline").visible = k;
        }

        public var isUnseen(never,set):Bool;
public function  set_isUnseen(k:Bool):Bool        {
            if (this._isUnseen != k)
            {
                this._isUnseen = k;
                this.Selected = this._isSelected;
            }
return k;
        }
    }


