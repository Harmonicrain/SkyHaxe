package com.sulake.habbo.notifications.feed.view.pane
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.notifications.feed.NotificationView;
    import com.sulake.core.runtime.exceptions.Exception;

     class AbstractPane implements IPane 
    {
        public static inline final PANE_VIEW_LEVEL_BASE= 0;
        public static inline final PANE_VIEW_LEVEL_FEED= 1;
        public static inline final PANE_VIEW_LEVEL_MODAL= 2;

        var _Str_580:Bool = false;
        var _isVisible:Bool = false;
        var _Str_20734:Int = 0;
        var window:IWindowContainer;
        var _mainView:NotificationView;
        var _name:String;

        public function new(k:String, _arg_2:NotificationView, _arg_3:IWindowContainer, _arg_4:Int)
        {
            if (_arg_3 == null)
            {
                throw new Exception(("Window was null for feed pane: " + k));
            }
            this._name = k;
            this._mainView = _arg_2;
            this._Str_20734 = _arg_4;
            this.window = _arg_3;
        }

        public function dispose()
        {
            this._Str_580 = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._Str_580;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var _Str_16687(get,never):Int;
public function  get__Str_16687():Int
        {
            return this._Str_20734;
        }

        
        public var isVisible(get,set):Bool;
public function  set_isVisible(k:Bool):Bool        {
            this._isVisible = k;
            this.window.visible = this._isVisible;
return k;
        }
public function  get_isVisible():Bool
        {
            return this._isVisible;
        }
    }

