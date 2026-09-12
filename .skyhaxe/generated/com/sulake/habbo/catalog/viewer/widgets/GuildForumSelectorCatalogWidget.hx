package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.guilds.GuildMembershipsController;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupEntryData;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetShowWarningTextEvent;

     class GuildForumSelectorCatalogWidget extends GuildSelectorCatalogWidget 
    {
        public function new(k:IWindowContainer, _arg_2:GuildMembershipsController)
        {
            super(k, _arg_2);
        }

        override function filterGroupMemberships(k:Array<ASAny>):Array<ASAny>
        {
            var _local_5:HabboGroupEntryData = null;
            var _local_2= new Array<ASAny>();
            var _local_3= _Str_5363.catalog.sessionDataManager.userId;
            var _local_4= _Str_5363.catalog.sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_5  = _tmp_;
                if ((((!_local_5._Str_21674) && (!(_local_5.ownerId == _local_3))) && (!_local_4)))
                {
                }
                else
                {
                    _local_2.push(_local_5);
                }
            }
            return _local_2;
        }

        override function selectGroup(k:HabboGroupEntryData)
        {
            super.selectGroup(k);
            events.dispatchEvent(new CatalogWidgetShowWarningTextEvent((k._Str_21674 ? "${catalog.alert.group_has_forum}" : "")));
        }
    }

