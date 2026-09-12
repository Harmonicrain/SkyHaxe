package com.sulake.habbo.navigator
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.communication.messages.outgoing.users.GetHabboGroupDetailsMessageComposer;
    import com.sulake.core.window.events.WindowEvent;

     class GuildInfoCtrl implements IDisposable 
    {
        static inline final GUILD_INFO= "guild_info";

        var _navigator:IHabboTransitionalNavigator;
        var _groupId:Int = 0;

        public function new(k:IHabboTransitionalNavigator)
        {
            this._navigator = k;
        }

        public function dispose()
        {
            this._navigator = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._navigator == null;
        }

        public function refresh(k:IWindowContainer, _arg_2:GuestRoomData, _arg_3:Bool=false)
        {
            var _local_4= cast(k.findChildByName(GUILD_INFO), IWindowContainer);
            if (_local_4 == null)
            {
                _local_4 = cast(this._navigator.getXmlWindow("guild_info"), IWindowContainer);
                _local_4.name = GUILD_INFO;
                k.addChild(_local_4);
                _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_23405);
            }
            if (((_arg_2 == null) || (_arg_2.habboGroupId < 1)))
            {
                _local_4.visible = false;
                return;
            }
            _local_4.visible = true;
            this._navigator.registerParameter("navigator.guildbase", "groupName", _arg_2.groupName);
            _local_4.findChildByName("guild_base_txt").caption = this._navigator.getText("navigator.guildbase");
            var _local_5= Std.downcast(cast(k.findChildByName("guild_badge"), IWidgetWindow).widget , IBadgeImageWidget);
            _local_5.badgeId = _arg_2.groupBadgeCode;
            _local_5.groupId = _arg_2.habboGroupId;
            this._groupId = _arg_2.habboGroupId;
        }

        function _Str_23405(k:WindowEvent)
        {
            this._navigator.send(new GetHabboGroupDetailsMessageComposer(this._groupId, true));
        }
    }

