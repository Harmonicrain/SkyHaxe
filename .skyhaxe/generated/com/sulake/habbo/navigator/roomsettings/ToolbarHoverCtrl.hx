package com.sulake.habbo.navigator.roomsettings
;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.events.WindowEvent;

     class ToolbarHoverCtrl extends UserListCtrl 
    {
        var _Str_6933:Int = -1;

        public function new(k:IHabboTransitionalNavigator)
        {
            super(k, false);
        }

        override function getRowView():IWindowContainer
        {
            return cast(_navigator.getXmlWindow("ros_banned_user"), IWindowContainer);
        }

        override function onBgMouseClick(k:WindowEvent)
        {
            this._Str_6933 = k.target.parent.id;
            this._Str_17449(Std.downcast(k.target.findParentByName("moderation_banned_users") , IItemListWindow));
        }

        override function getBgColor(k:Int, _arg_2:Bool):UInt
        {
            if (k == this._Str_6933)
            {
                return 0xFF9AB8D9;
            }
            return super.getBgColor(k, _arg_2);
        }

        function _Str_17449(k:IItemListWindow)
        {
            var _local_3:IWindowContainer = null;
            var _local_2 = 0;
            while (_local_2 < _Str_3114)
            {
                _local_3 = cast(k.getListItemAt(_local_2), IWindowContainer);
                _local_3.color = this.getBgColor(_local_2, false);
                _local_2++;
            }
        }

        public var _Str_20232(get,never):Int;
public function  get__Str_20232():Int
        {
            return this._Str_6933;
        }
    }

