package com.sulake.habbo.groups
;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.components.IRadioButtonWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.users.IGuildData;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class GuildSettingsCtrl 
    {
        public static inline final TYPE_REGULAR= 0;
        public static inline final TYPE_EXCLUSIVE= 1;
        public static inline final TYPE_CLOSED= 2;
        public static inline final TYPE_LARGE= 3;
        public static inline final TYPE_LARGE_CLOSED= 4;
        public static inline final RIGHTS_MEMBERS= 0;
        public static inline final RIGHTS_ADMINS= 1;

        var _data:GuildSettingsData;
        var _guildSelector:ISelectorWindow;
        var _guildRegular:IRadioButtonWindow;
        var _guildExclusive:IRadioButtonWindow;
        var _guildClosed:IRadioButtonWindow;
        var _membersHaveRights:ICheckBoxWindow;


        public function prepare(k:IWindowContainer)
        {
            var _local_2= Std.downcast(k.findChildByName("step_cont_5") , IWindowContainer);
            this._guildSelector = Std.downcast(_local_2.findChildByName("group_type_selector") , ISelectorWindow);
            this._guildRegular = Std.downcast(_local_2.findChildByName("rb_type_regular") , IRadioButtonWindow);
            this._guildRegular.procedure = this._Str_25413;
            this._guildExclusive = Std.downcast(_local_2.findChildByName("rb_type_exclusive") , IRadioButtonWindow);
            this._guildExclusive.procedure = this._Str_22719;
            this._guildClosed = Std.downcast(_local_2.findChildByName("rb_type_private") , IRadioButtonWindow);
            this._guildClosed.procedure = this._Str_22569;
            this._membersHaveRights = Std.downcast(_local_2.findChildByName("cb_member_rights") , ICheckBoxWindow);
            this._membersHaveRights.procedure = this._Str_25398;
        }

        public function refresh(k:IGuildData)
        {
            this._data = new GuildSettingsData(k);
            switch (this._data.guildType)
            {
                case TYPE_REGULAR:
                    this._guildSelector.setSelected(this._guildRegular);
                    
                case TYPE_EXCLUSIVE:
                    this._guildSelector.setSelected(this._guildExclusive);
                    
                case TYPE_CLOSED:
                    this._guildSelector.setSelected(this._guildClosed);
                    
                default:
                    this._guildSelector.setSelected(this._guildRegular);
            }
            if (this._data._Str_7959 == GuildSettingsCtrl.RIGHTS_MEMBERS)
            {
                this._membersHaveRights.select();
            }
            else
            {
                this._membersHaveRights.unselect();
            }
            this._guildSelector.invalidate();
        }

        function _Str_25413(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowEvent.WINDOW_EVENT_SELECT)
            {
                this._data.guildType = TYPE_REGULAR;
            }
        }

        function _Str_22719(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowEvent.WINDOW_EVENT_SELECT)
            {
                this._data.guildType = TYPE_EXCLUSIVE;
            }
        }

        function _Str_22569(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowEvent.WINDOW_EVENT_SELECT)
            {
                this._data.guildType = TYPE_CLOSED;
            }
        }

        function _Str_25398(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowEvent.WINDOW_EVENT_SELECT)
            {
                this._data._Str_7959 = GuildSettingsCtrl.RIGHTS_MEMBERS;
            }
            if (k.type == WindowEvent.WINDOW_EVENT_UNSELECT)
            {
                this._data._Str_7959 = GuildSettingsCtrl.RIGHTS_ADMINS;
            }
        }

        public function _Str_15948()
        {
            if (((!(this._data == null)) && this._data._Str_22472))
            {
                this._data._Str_15948();
            }
        }

        public var guildType(get,never):Int;
public function  get_guildType():Int
        {
            return this._data.guildType;
        }

        public var _Str_7959(get,never):Int;
public function  get__Str_7959():Int
        {
            return this._data._Str_7959;
        }

        public var isInitialized(get,never):Bool;
public function  get_isInitialized():Bool
        {
            return !(this._data == null);
        }
public function new(){}
    }


