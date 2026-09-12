package com.sulake.habbo.friendbar.talent
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.toolbar.ToolbarDisplayExtensionIds;
    import com.sulake.habbo.communication.messages.incoming.talent.TalentTrackLevelMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.talent.TalentLevelUpEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserObjectEvent;
    import com.sulake.habbo.communication.messages.outgoing.talent.GetTalentTrackLevelMessageComposer;
    import com.sulake.habbo.toolbar.ExtensionFixedSlotsEnum;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.talent.GetTalentTrackMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class TalentPromoCtrl implements IDisposable 
    {
        static inline final _Str_3591:UInt = 0xFF78746D;
        static inline final _Str_3385:UInt = 0xFF55534E;

        var _manager:HabboTalent;
        var _window:IWindowContainer;
        var _level:Int = 0;
        var _maxLevel:Int = 0;
        var _originalHeight:Int = 0;

        public function new(k:HabboTalent)
        {
            this._manager = k;
        }

        public function dispose()
        {
            if (this._Str_8061())
            {
                this._manager.toolbar.extensionView.detachExtension(ToolbarDisplayExtensionIds.TALENT_PROMO);
            }
            this._manager = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._manager == null;
        }

        public function initialize()
        {
            if (!this.enabled)
            {
                return;
            }
            this._manager.communicationManager.addHabboConnectionMessageEvent(new TalentTrackLevelMessageEvent(this._Str_23765));
            this._manager.communicationManager.addHabboConnectionMessageEvent(new TalentLevelUpEvent(this._Str_16796));
            this._manager.communicationManager.addHabboConnectionMessageEvent(new UserObjectEvent(this.onUserObject));
        }

        function onUserObject(k:UserObjectEvent)
        {
            this._manager.send(new GetTalentTrackLevelMessageComposer(this._Str_7925));
        }

        function _Str_23765(k:TalentTrackLevelMessageEvent)
        {
            var _local_2= k.getParser();
            if (_local_2.talentTrackName == this._Str_7925)
            {
                this._maxLevel = _local_2._Str_16859;
                this._level = _local_2.level;
                this.refresh();
            }
        }

        function _Str_16796(k:TalentLevelUpEvent)
        {
            var _local_2= k.getParser();
            if (_local_2.talentTrackName == this._Str_7925)
            {
                this._level = _local_2.level;
                this.refresh();
            }
        }

        function refresh()
        {
            if (((!this.enabled) || this._Str_23367))
            {
                this.close();
                return;
            }
            this.prepareWindow();
            this.setText("title");
            this._window.x = 0;
            this._window.y = 0;
            if (this._Str_8061())
            {
                this._manager.toolbar.extensionView.attachExtension(ToolbarDisplayExtensionIds.TALENT_PROMO, this._window, ExtensionFixedSlotsEnum._Str_16454);
            }
        }

        function setText(k:String)
        {
            this._window.findChildByName((k + "_txt")).caption = (((("${talentpromo." + this._Str_7925) + ".") + k) + "}");
        }

        function prepareWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._manager.getXmlWindow("track_promo"), IWindowContainer);
            this._window.addEventListener(WindowMouseEvent.CLICK, this._Str_25480);
            this._window.addEventListener(WindowMouseEvent.OVER, this._Str_7963);
            this._window.addEventListener(WindowMouseEvent.OUT, this._Str_7021);
            this._originalHeight = this._window.height;
        }

        public function close()
        {
            if (this._window != null)
            {
                if (this._Str_8061())
                {
                    this._manager.toolbar.extensionView.detachExtension(ToolbarDisplayExtensionIds.TALENT_PROMO);
                }
            }
        }

        function _Str_25480(k:WindowEvent, _arg_2:IWindow=null)
        {
            if (((k.type == WindowMouseEvent.CLICK) && this.enabled))
            {
                this._manager.tracking.trackTalentTrackOpen(this._Str_7925, "talentpromo");
                this._manager.send(new GetTalentTrackMessageComposer(this._Str_7925));
            }
        }

        function _Str_8061():Bool
        {
            return (((!(this._manager == null)) && (!(this._manager.toolbar == null))) && (!(this._manager.toolbar.extensionView == null))) && this.enabled;
        }

        var enabled(get,never):Bool;
function  get_enabled():Bool
        {
            return !(this._Str_7925 == "");
        }

        var _Str_7925(get,never):String;
function  get__Str_7925():String
        {
            return this._manager.getProperty("talentpromo.track");
        }

        var _Str_23367(get,never):Bool;
function  get__Str_23367():Bool
        {
            return this._level >= this._maxLevel;
        }

        function _Str_7963(k:WindowMouseEvent)
        {
            this._window.findChildByTag("BGCOLOR").color = _Str_3591;
        }

        function _Str_7021(k:WindowMouseEvent)
        {
            this._window.findChildByTag("BGCOLOR").color = _Str_3385;
        }
    }

