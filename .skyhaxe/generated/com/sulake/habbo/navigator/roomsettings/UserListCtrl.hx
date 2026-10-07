package com.sulake.habbo.navigator.roomsettings
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.IFlatUser;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.utils._Str_3521;
    import com.sulake.habbo.communication.messages.outgoing.room.action.AssignRightsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.action.RemoveRightsMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;

     class UserListCtrl implements IDisposable 
    {
        static inline final _Str_17518= 200;

        var _navigator:IHabboTransitionalNavigator;
        var _Str_16557:Bool = false;
        var _Str_3114:Int = 0;

        public function new(k:IHabboTransitionalNavigator, _arg_2:Bool)
        {
            this._navigator = k;
            this._Str_16557 = _arg_2;
        }

        public function dispose()
        {
            this._navigator = null;
        }

        public var navigator(never,set):IHabboTransitionalNavigator;
public function  set_navigator(k:IHabboTransitionalNavigator):IHabboTransitionalNavigator        {
            return this._navigator = k;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._navigator == null;
        }

        public function refresh(k:IItemListWindow, _arg_2:Array<ASAny>, _arg_3:String, _arg_4:Int)
        {
            var _local_6:IFlatUser = null;
            var _local_7 = 0;
            var _local_8 = false;
            var _local_5= new Array<ASAny>();
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_6  = _tmp_;
                if (((_arg_3 == "") || (_local_6.userName.toLowerCase().indexOf(_arg_3) > -1)))
                {
                    _local_5.push(_local_6);
                }
                if (_local_5.length >= _Str_17518)
                {
                    break;
                }
            }
            k.autoArrangeItems = false;
            _local_7 = 0;
            while (true)
            {
                _local_8 = this.refreshEntry(k, _local_7, _local_5[_local_7], _arg_4);
                if (_local_8)
                {
                    break;
                }
                _local_7++;
            }
            k.autoArrangeItems = true;
            k.invalidate();
            this._Str_3114 = _local_5.length;
        }

        function getListEntry(k:Int):IWindowContainer
        {
            var _local_2= this.getRowView();
            var _local_3= cast(_local_2.findChildByName("bg_region"), IRegionWindow);
            _local_3.addEventListener(WindowMouseEvent.CLICK, this.onBgMouseClick);
            _local_3.addEventListener(WindowMouseEvent.OVER, this._Str_18088);
            _local_3.addEventListener(WindowMouseEvent.OUT, this._Str_17027);
            _Str_3521.setup(_local_2, this._Str_25336);
            _local_2.id = k;
            return _local_2;
        }

        function getRowView():IWindowContainer
        {
            return cast(this._navigator.getXmlWindow((this._Str_16557 ? "ros_friend" : "ros_flat_controller")), IWindowContainer);
        }

        function getBgColor(k:Int, _arg_2:Bool):UInt
        {
            return _arg_2 ? 0xFFB6D9FF : (((k % 2) != 0) ? 0xFFFFFFFF : 0xFFE9E9E1);
        }

        function refreshEntry(k:IItemListWindow, _arg_2:Int, _arg_3:IFlatUser, _arg_4:Int):Bool
        {
            var _local_5= cast(k.getListItemAt(_arg_2), IWindowContainer);
            if (_local_5 == null)
            {
                if (_arg_3 == null)
                {
                    return true;
                }
                _local_5 = this.getListEntry(_arg_2);
                k.addListItem(_local_5);
            }
            if (_arg_3 != null)
            {
                _local_5.color = this.getBgColor(_arg_2, (_arg_3.userId == _arg_4));
                this.refreshEntryDetails(_local_5, _arg_3);
                _local_5.visible = true;
                _local_5.height = 20;
            }
            else
            {
                _local_5.height = 0;
                _local_5.visible = false;
            }
            return false;
        }

        function refreshEntryDetails(k:IWindowContainer, _arg_2:IFlatUser)
        {
            k.findChildByName("user_name_txt").caption = _arg_2.userName;
            var _local_3= cast(k.findChildByName("bg_region"), IRegionWindow);
            _local_3.id = _arg_2.userId;
            k.findChildByName("user_info_region").id = _arg_2.userId;
            _Str_3521._Str_3927(false, k);
        }

        function onBgMouseClick(k:WindowEvent)
        {
            var _local_3:Array<ASAny> = null;
            var _local_2= cast(k.target, IWindowContainer);
            if (this._Str_16557)
            {
                this._navigator.send(new AssignRightsMessageComposer(_local_2.id));
            }
            else
            {
                _local_3 = new Array<ASAny>();
                _local_3.push(_local_2.id);
                this._navigator.send(new RemoveRightsMessageComposer(_local_3));
            }
        }

        function _Str_18088(k:WindowEvent)
        {
            var _local_2= cast(k.target.parent, IWindowContainer);
            _local_2.color = this.getBgColor(-1, true);
            var _local_3= _local_2.findChildByName("arrow_icon");
            if (_local_3 != null)
            {
                _local_3.visible = true;
            }
        }

        function _Str_17027(k:WindowEvent)
        {
            var _local_2= cast(k.target.parent, IWindowContainer);
            _local_2.color = this.getBgColor(_local_2.id, false);
            var _local_3= _local_2.findChildByName("arrow_icon");
            if (_local_3 != null)
            {
                _local_3.visible = false;
            }
        }

        public var userCount(get,never):Int;
public function  get_userCount():Int
        {
            return this._Str_3114;
        }

        function _Str_25336(k:WindowEvent)
        {
            this._navigator.trackGoogle("extendedProfile", "navigator_roomSettingsUsersList");
            this._navigator.send(new GetExtendedProfileMessageComposer(k.target.id));
        }
    }

