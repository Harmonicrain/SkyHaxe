package com.sulake.habbo.catalog.guilds
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.catalog.viewer.widgets.GuildSelectorCatalogWidget;
    import com.sulake.habbo.communication.messages.outgoing.users.GetGuildMembershipsMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMembershipsMessageEvent;

     class GuildMembershipsController 
    {
        var _catalog:HabboCatalog;
        var _guildSelectorWidget:GuildSelectorCatalogWidget;

        public function new(k:HabboCatalog)
        {
            this._catalog = k;
        }

        public function dispose()
        {
            this._catalog = null;
            this._guildSelectorWidget = null;
        }

        public var catalog(get,never):HabboCatalog;
public function  get_catalog():HabboCatalog
        {
            return this._catalog;
        }

        public function registerGuildSelectorWidget(k:GuildSelectorCatalogWidget)
        {
            this._guildSelectorWidget = k;
            this._catalog.connection.send(new GetGuildMembershipsMessageComposer());
        }

        public function unregisterGuildSelectorWidget(k:GuildSelectorCatalogWidget)
        {
            if (this._guildSelectorWidget == k)
            {
                this._guildSelectorWidget = null;
            }
            else
            {
                Logger.log(["ERROR: Tried to unregister a nonregistered group selector catalog widget"]);
            }
        }

        public function onGuildMembershipsMessageEvent(k:GuildMembershipsMessageEvent)
        {
            var _local_2= k.guilds.slice(0, k.guilds.length);
            if (((this._guildSelectorWidget != null) && (!this._guildSelectorWidget.disposed)))
            {
                this._guildSelectorWidget.populateAndSelectFavorite(_local_2);
                this._guildSelectorWidget.selectFirstOffer();
            }
        }

        public function onGuildVisualSettingsChanged(k:Int)
        {
            if (this._guildSelectorWidget != null)
            {
                this._catalog.connection.send(new GetGuildMembershipsMessageComposer());
            }
        }
    }

