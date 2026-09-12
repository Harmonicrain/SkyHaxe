package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.guilds.GuildMembershipsController;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetGuildSelectedEvent;

     class GuildBadgeViewCatalogWidget extends CatalogWidget
    {
        var _groupMembershipsCtrl:GuildMembershipsController;

        public function new(k:IWindowContainer, _arg_2:GuildMembershipsController)
        {
            super(k);
            this._groupMembershipsCtrl = _arg_2;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                this._groupMembershipsCtrl = null;
                super.dispose();
            }
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            _Str_2819(CatalogWidgetEnum.GUILD_BADGE_VIEW);
            events.addEventListener(CatalogWidgetEvent.GUILD_SELECTED, this._Str_16625);
            return true;
        }

        function _Str_16625(k:CatalogWidgetGuildSelectedEvent)
        {
            if (disposed)
            {
                return;
            }
            var _local_2= Std.downcast(cast(_window.findChildByName("badge"), IWidgetWindow).widget , IBadgeImageWidget);
            if (_local_2 != null)
            {
                _local_2.badgeId = k.badgeCode;
                _local_2.groupId = k.guildId;
            }
        }
    }

