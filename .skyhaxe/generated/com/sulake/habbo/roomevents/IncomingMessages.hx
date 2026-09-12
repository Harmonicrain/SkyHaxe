package com.sulake.habbo.roomevents
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredTriggerDataEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredSelectorDataEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.OpenEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredRewardResultMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredConditionDataEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.CloseConnectionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredSavedEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.ObjectRemoveMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredEffectDataEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredValidationErrorEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredValidationErrorParameter;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredAddonDataEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariableDataEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserObjectEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMembershipsMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.OpenMessageComposer;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;

     class IncomingMessages implements IDisposable 
    {
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _messageEvents:Vector<IMessageEvent>;

        public function new(k:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = k;
            this._messageEvents = new Vector<IMessageEvent>(0);
            var _local_2= this._roomEvents.communication;
            this.addMessageEvent(new WiredTriggerDataEvent(this._Str_22337));
            this.addMessageEvent(new WiredSelectorDataEvent(this.onSelectorData));
            this.addMessageEvent(new WiredAddonDataEvent(this.onAddonData));
            this.addMessageEvent(new WiredVariableDataEvent(this.onVariableData));
            this.addMessageEvent(new OpenEvent(this.onOpen));
            this.addMessageEvent(new WiredRewardResultMessageEvent(this._Str_23600));
            this.addMessageEvent(new WiredConditionDataEvent(this._Str_23144));
            this.addMessageEvent(new CloseConnectionMessageEvent(this.onRoomExit));
            this.addMessageEvent(new WiredSavedEvent(this._Str_25470));
            this.addMessageEvent(new ObjectRemoveMessageEvent(this.onObjectRemove));
            this.addMessageEvent(new WiredEffectDataEvent(this._Str_23979));
            this.addMessageEvent(new WiredValidationErrorEvent(this._Str_25729));
            this.addMessageEvent(new UserObjectEvent(this.onUserObject));
            this.addMessageEvent(new GuildMembershipsMessageEvent(this.onGuildMemberships));
        }


        function onAddonData(k:IMessageEvent)
        {
            if (!this._roomEvents.isWiredFeatureEnabled(WiredCapabilityCodes.ADDONS))
            {
                return;
            }
            var _local_2= Std.downcast(k , WiredAddonDataEvent).getParser();
            if (_local_2.definition != null)
            {
                this._roomEvents._Str_7247._Str_18351(_local_2.definition);
            }
        }

        function onVariableData(k:IMessageEvent)
        {
            if (!this._roomEvents.isWiredFeatureEnabled(WiredCapabilityCodes.VARIABLES))
            {
                return;
            }
            var _local_2= Std.downcast(k , WiredVariableDataEvent).getParser();
            if (_local_2.definition != null)
            {
                this._roomEvents._Str_7247._Str_18351(_local_2.definition);
            }
        }

        function onGuildMemberships(k:IMessageEvent)
        {
            this._roomEvents._Str_7247.onGuildMemberships(Std.downcast(k , GuildMembershipsMessageEvent).guilds);
        }

        function addMessageEvent(k:IMessageEvent)
        {
            this._messageEvents.push(this._roomEvents.communication.addHabboConnectionMessageEvent(k));
        }

        function onOpen(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , OpenEvent).getParser();
            this._roomEvents.send(new OpenMessageComposer(_local_2.stuffId));
        }

        function _Str_22337(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , WiredTriggerDataEvent).getParser();
            this._roomEvents._Str_7247._Str_18351(_local_2._Str_10812);
        }

        function _Str_23979(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , WiredEffectDataEvent).getParser();
            this._roomEvents._Str_7247._Str_18351(_local_2.definition);
        }

        function _Str_23144(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , WiredConditionDataEvent).getParser();
            this._roomEvents._Str_7247._Str_18351(_local_2.definition);
        }

        function onSelectorData(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , WiredSelectorDataEvent).getParser();
            this._roomEvents._Str_7247._Str_18351(_local_2.definition);
        }

        function onUserObject(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserObjectEvent).getParser();
            this._roomEvents.userName = _local_2.name;
        }

        function onRoomExit(k:IMessageEvent)
        {
            this._roomEvents.resetWiredRoomState();
            this._roomEvents._Str_7247.close();
        }

        function onObjectRemove(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , ObjectRemoveMessageEvent).getParser();
            Logger.log([((("Received object remove event: " + Std.string(_local_2.id)) + ", ") + Std.string(_local_2.isExpired))]);
            this._roomEvents._Str_7247._Str_25654(_local_2.id);
        }

        function _Str_23600(k:IMessageEvent)
        {
            var _local_2= cast(k, WiredRewardResultMessageEvent).getParser();
            if (_local_2.reason == WiredRewardResultMessageEvent._Str_18436)
            {
                this._roomEvents.windowManager.alert(this._roomEvents.localization.getLocalization("wiredfurni.rewardsuccess.title"), this._roomEvents.localization.getLocalization("wiredfurni.rewardsuccess.body"), 0, null);
            }
            else
            {
                if (_local_2.reason == WiredRewardResultMessageEvent._Str_17787)
                {
                    this._roomEvents.windowManager.alert(this._roomEvents.localization.getLocalization("wiredfurni.badgereceived.title"), this._roomEvents.localization.getLocalization("wiredfurni.badgereceived.body"), 0, null);
                }
                else
                {
                    this._roomEvents.windowManager.alert(this._roomEvents.localization.getLocalization("wiredfurni.rewardfailed.title"), this._roomEvents.localization.getLocalization(("wiredfurni.rewardfailed.reason." + Std.string(_local_2.reason))), 0, null);
                }
            }
        }

        function _Str_25729(k:IMessageEvent)
        {
var _local_4:WiredValidationErrorParameter  = null;            this._roomEvents.wiredCtrl.onSaveFailure();
            var _local_2= cast(k, WiredValidationErrorEvent).getParser();
            var _local_3= new Map();
            final _iter_ = _local_2.parameters; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4 = _tmp_;
                _local_3.add(_local_4.key, _local_4.value);
            }
            var _local_5= this._roomEvents.localization.getLocalizationWithParamMap(_local_2.localizationKey, _local_2.localizationKey, _local_3);
            var _local_6= this._roomEvents.localization.getLocalization("wiredfurni.error.title", "Update failed");
            this._roomEvents.windowManager.alert(_local_6, _local_5, 0, null);
        }

        function _Str_25470(k:IMessageEvent)
        {
            this._roomEvents.wiredCtrl.onSaveSuccess();
        }

        public function dispose()
        {
            var _local_2:IMessageEvent = null;
            if (this.disposed)
            {
                return;
            }
            var k= this._roomEvents.communication;
            if (((!(this._messageEvents == null)) && (!(k == null))))
            {
                final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    k.removeHabboConnectionMessageEvent(_local_2);
                }
            }
            this._roomEvents = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._roomEvents == null;
        }
    }

