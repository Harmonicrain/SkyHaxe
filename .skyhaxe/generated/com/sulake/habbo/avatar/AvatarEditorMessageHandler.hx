package com.sulake.habbo.avatar
;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.communication.messages.incoming.inventory.avatareffect.AvatarEffectExpiredMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.avatareffect.AvatarEffectActivatedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.avatar.WardrobeMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.avatar.CheckUserNameResultMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserRightsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.action.AvatarEffectMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.avatareffect.AvatarEffectSelectedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.avatareffect.AvatarEffectAddedMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.avatar.SaveWardrobeOutfitMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.avatar.CheckUserNameMessageComposer;
    import com.sulake.habbo.avatar._enum.AvatarEditorInstanceId;
    import com.sulake.habbo.communication.messages.incoming.avatar.ChangeUserNameResultMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.avatar.GetWardrobeMessageComposer;
    import com.sulake.core.communication.messages.IMessageEvent;

     class AvatarEditorMessageHandler 
    {
        var _communication:IHabboCommunicationManager;
        var _controller:HabboAvatarEditorManager;

        public function new(k:HabboAvatarEditorManager, _arg_2:IHabboCommunicationManager)
        {
            this._controller = k;
            this._communication = _arg_2;
            this._communication.addHabboConnectionMessageEvent(new AvatarEffectExpiredMessageEvent(this.onAvatarEffectExpired));
            this._communication.addHabboConnectionMessageEvent(new AvatarEffectActivatedMessageEvent(this._Str_17365));
            this._communication.addHabboConnectionMessageEvent(new WardrobeMessageEvent(this._Str_25446));
            this._communication.addHabboConnectionMessageEvent(new CheckUserNameResultMessageEvent(this._Str_18696));
            this._communication.addHabboConnectionMessageEvent(new UserRightsMessageEvent(this.onUserRights));
            this._communication.addHabboConnectionMessageEvent(new AvatarEffectMessageEvent(this._Str_22375));
            this._communication.addHabboConnectionMessageEvent(new AvatarEffectSelectedMessageEvent(this._Str_22833));
            this._communication.addHabboConnectionMessageEvent(new AvatarEffectAddedMessageEvent(this._Str_18461));
        }

        public function dispose()
        {
            this._communication = null;
            this._controller = null;
        }

        public function _Str_25374(k:Int, _arg_2:IOutfit)
        {
            if (this._communication == null)
            {
                return;
            }
            var _local_3= new SaveWardrobeOutfitMessageComposer(k, _arg_2.figure, _arg_2.gender);
            this._communication.connection.send(_local_3);
            _local_3.dispose();
            _local_3 = null;
        }

        public function checkName(k:String)
        {
            if (this._communication == null)
            {
                return;
            }
            this._communication.connection.send(new CheckUserNameMessageComposer(k));
        }

        function _Str_18696(k:CheckUserNameResultMessageEvent)
        {
            if (((k == null) || (!(this._controller != null))))
            {
                return;
            }
            var _local_2= this._controller.getEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.view._Str_22767;
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= k.getParser();
            if (_local_4.resultCode == ChangeUserNameResultMessageEvent.NAME_OK)
            {
                _local_3._Str_16320 = _local_4.name;
            }
            else
            {
                _local_3._Str_14489(_local_4.resultCode, _local_4.name, _local_4.nameSuggestions);
            }
        }

        public function _Str_22376()
        {
            if (this._communication == null)
            {
                return;
            }
            var k= new GetWardrobeMessageComposer();
            this._communication.connection.send(k);
            k.dispose();
            k = null;
        }

        function _Str_25446(k:WardrobeMessageEvent)
        {
            if (((k == null) || (!(this._controller != null))))
            {
                return;
            }
            var _local_2= this._controller.getEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR);
            if (_local_2 != null)
            {
                _local_2.wardrobe._Str_15301(k.state, k._Str_17746);
            }
        }

        function onUserRights(k:UserRightsMessageEvent)
        {
            if (((k == null) || (!(this._controller != null))))
            {
                return;
            }
            var _local_2= this._controller.getEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR);
            if (_local_2 != null)
            {
                _local_2.clubMemberLevel = k.clubLevel;
                _local_2.update();
            }
        }

        function _Str_18461(k:IMessageEvent)
        {
            if (((k == null) || (!(this._controller != null))))
            {
                return;
            }
            var _local_2= this._controller.getEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR);
            if (_local_2 != null)
            {
                _local_2.effects.reset();
            }
        }

        function _Str_17365(k:AvatarEffectActivatedMessageEvent)
        {
            if (((k == null) || (!(this._controller != null))))
            {
                return;
            }
            var _local_2= this._controller.getEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR);
            if (_local_2 != null)
            {
                _local_2.effects.reset();
                _local_2.figureData.avatarEffectType = k.getParser().type;
                _local_2.figureData.updateView();
            }
        }

        function onAvatarEffectExpired(k:AvatarEffectExpiredMessageEvent)
        {
            var _local_3 = 0;
            if (((k == null) || (!(this._controller != null))))
            {
                return;
            }
            var _local_2= this._controller.getEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR);
            if (_local_2 != null)
            {
                _local_2.effects.reset();
                _local_3 = k.getParser().type;
                if (_local_2.figureData.avatarEffectType == _local_3)
                {
                    _local_2.figureData.avatarEffectType = -1;
                    _local_2.figureData.updateView();
                }
            }
        }

        function _Str_22375(k:AvatarEffectMessageEvent)
        {
            if (((k == null) || (!(this._controller != null))))
            {
                return;
            }
            var _local_2= this._controller.getEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR);
            if ((((_local_2 != null) && (!(this._controller.roomDesktop == null))) && (k.getParser().userId == this._controller.roomDesktop.roomSession.ownUserRoomId)))
            {
                _local_2.figureData.avatarEffectType = k.getParser().effectId;
                _local_2.figureData.updateView();
            }
        }

        function _Str_22833(k:AvatarEffectExpiredMessageEvent)
        {
            if (((k == null) || (!(this._controller != null))))
            {
                return;
            }
            var _local_2= this._controller.getEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR);
            if (_local_2 != null)
            {
                _local_2.figureData.avatarEffectType = k.getParser().type;
                _local_2.figureData.updateView();
            }
        }
    }

