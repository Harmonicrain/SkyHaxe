package com.sulake.habbo.ui.widget.furniture.contextmenu
;
    import com.sulake.habbo.ui.widget.contextmenu.ButtonMenuView;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.ui.widget.contextmenu.IContextMenuParentWidget;

     class FurnitureContextInfoView extends ButtonMenuView 
    {
        var _Str_2731:IRoomObject;
        var _title:String;

        public function new(k:IContextMenuParentWidget)
        {
            super(k);
        }

        public static function setup(k:FurnitureContextInfoView, _arg_2:IRoomObject, _arg_3:String="")
        {
            k._Str_2731 = _arg_2;
            k._title = _arg_3;
            com.sulake.habbo.ui.widget.contextmenu.ContextInfoView._Str_8532(k);
        }


        var _Str_26423(get,never):IRoomObject;
function  get__Str_26423():IRoomObject
        {
            return this._Str_2731;
        }

        override public function dispose()
        {
            this._Str_2731 = null;
            super.dispose();
        }
    }

