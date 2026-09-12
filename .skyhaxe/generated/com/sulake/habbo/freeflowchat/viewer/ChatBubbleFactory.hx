package com.sulake.habbo.freeflowchat.viewer
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.habbo.freeflowchat.viewer.visualization.style.ChatStyleLibrary;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.freeflowchat.viewer.visualization.PooledChatBubble;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.freeflowchat.viewer.visualization.style.ChatStyle;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import com.sulake.habbo.session.events.RoomSessionChatEvent;
    import com.sulake.habbo.freeflowchat.viewer._enum.ChatColours;
    import com.sulake.habbo.freeflowchat.data.ChatItem;
    import com.sulake.habbo.freeflowchat.viewer.simulation.BlankStyle;
    import com.sulake.habbo.freeflowchat.viewer.visualization.style.IChatStyleInternal;
    import com.sulake.habbo.freeflowchat.viewer.simulation.ChatFlowStage;
    import com.sulake.habbo.freeflowchat.viewer.visualization.ChatBubble;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomChatSettings;
    import com.sulake.habbo.freeflowchat.history.visualization.entry.ChatHistoryEntryBitmapBubble;
    import com.sulake.habbo.freeflowchat.history.visualization.entry.IChatHistoryEntryBitmap;
    import com.sulake.habbo.freeflowchat.history.visualization.entry.ChatHistoryRoomChangeEntry;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar.structure.figure.IPartColor;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.habbo.avatar._enum.AvatarFigurePartType;
    import com.sulake.habbo.avatar.pets.PetFigureData;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.room.utils.Vector3d;

     class ChatBubbleFactory implements IGetImageListener implements  IAvatarImageListener 
    {
        static inline final _Str_14010= 30;

        var _component:HabboFreeFlowChat;
        var _chatStyleLibrary:ChatStyleLibrary;
        var _avatarImageCache:Map;
        var _petImageCache:Map;
        var _avatarColorCache:Map;
        var _petImageIdToFigureString:Map;
        var _imagesWaitingForDispose:Array<ASAny>;
        var _chatBubblePool:Vector<PooledChatBubble>;
        var _accountId:Int = 0;

        public function new(k:HabboFreeFlowChat)
        {
            this._avatarImageCache = new Map();
            this._petImageCache = new Map();
            this._avatarColorCache = new Map();
            this._petImageIdToFigureString = new Map();
            this._imagesWaitingForDispose = [];
            this._chatBubblePool = new Vector<PooledChatBubble>(0);
            this._component = k;
            this._chatStyleLibrary = new ChatStyleLibrary(this._component.assets);
            this._accountId = this._component.sessionDataManager.userId;
        }

        public function dispose()
        {
            this._Str_17762();
            this._imagesWaitingForDispose = [];
            this._chatStyleLibrary.dispose();
            this._chatStyleLibrary = null;
            this._component = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._component == null;
        }

        public function _Str_22521(k:ChatItem, _arg_2:Bool=false):PooledChatBubble
        {
            var _local_4:RoomUserData = null;
            var _local_8:PooledChatBubble = null;
            var _local_10:String = null;
            var _local_11:IRoomObject = null;
            var _local_12:String = null;
            var _local_13 = false;
            var _local_14 = 0;
            var _local_15 = 0;
            var _local_16:String = null;
            var _local_17:String = null;
            var _local_18:String = null;
            var _local_19:String = null;
            var _local_20:String = null;
            var _local_21:String = null;
            var _local_3= cast(this._chatStyleLibrary.getStyle(k.style), ChatStyle);
            _local_4 = this._component.roomSessionManager.getSession(k.roomId).userDataManager.getUserDataByIndex(k.userId);
            var _local_5= "";
            var _local_6:UInt = 0;
            var _local_7= _local_3.iconImage;
            if ((ASCompat.stringAsBool(k._Str_15251) || ASCompat.stringAsBool(k._Str_14270)))
            {
                if (_local_7 == null)
                {
                    _local_7 = this._Str_7081(k._Str_15251);
                }
                _local_5 = k._Str_14270;
            }
            else
            {
                if (_local_4 != null)
                {
                    _local_5 = _local_4.name;
                    _local_10 = _local_4.figure;
                    _local_6 = ASCompat.toUInt(this._avatarColorCache.getValue(_local_10));
                    if (_local_7 == null)
                    {
                        switch (_local_4.type)
                        {
                            case RoomObjectTypeEnum.PET:
                                _local_11 = this._component.roomEngine.getRoomObject(k.roomId, _local_4.roomObjectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                                _local_12 = null;
                                if (_local_11 != null)
                                {
                                    _local_12 = _local_11.getModel().getString(RoomObjectVariableEnum.FIGURE_POSTURE);
                                }
                                _local_13 = true;
                                _local_14 = 32;
                                _local_15 = 2;
                                _local_7 = this.getPetImage(_local_10, _local_15, _local_13, _local_14, _local_12);
                                
                            case RoomObjectTypeEnum.HABBO:
                                _local_7 = this._Str_7081(_local_10);
                                
                        }
                    }
                }
            }
            if (k.chatType == RoomSessionChatEvent.CHAT_TYPE_RESPECT)
            {
                k.text = ((this._component.localizations != null) ? this._component.localizations.getLocalizationWithParams("widgets.chatbubble.respect", "", ["username", _local_5]) : "");
            }
            else
            {
                if (k.chatType == RoomSessionChatEvent.CHAT_TYPE_PETRESPECT)
                {
                    k.text = ((this._component.localizations != null) ? this._component.localizations.getLocalizationWithParams("widget.chatbubble.petrespect", "", ["petname", _local_5]) : "");
                }
                else
                {
                    if (k.chatType == RoomSessionChatEvent.CHAT_TYPE_PETTREAT)
                    {
                        k.text = ((this._component.localizations != null) ? this._component.localizations.getLocalizationWithParams("widget.chatbubble.pettreat", "", ["petname", _local_5]) : "");
                    }
                }
            }
            if (k.chatType == RoomSessionChatEvent.CHAT_TYPE_HAND_ITEM_RECEIVED)
            {
                _local_16 = "widget.chatbubble.handitem";
                _local_17 = this._component.localizations.getLocalization(("handitem" + Std.string(k.extraParam)), ("handitem" + Std.string(k.extraParam)));
                this._component.localizations.registerParameter(_local_16, "username", _local_5);
                this._component.localizations.registerParameter(_local_16, "handitem", _local_17);
                k.text = this._component.localizations.getLocalizationRaw(_local_16).value;
            }
            if (k.chatType == RoomSessionChatEvent._Str_8909)
            {
                _local_18 = "widget.chatbubble.mutetime";
                _local_19 = Std.string((k.extraParam % 60));
                _local_20 = Std.string(((k.extraParam > 0) ? Math.ffloor(((k.extraParam % 3600) / 60)) : 0));
                _local_21 = Std.string(((k.extraParam > 0) ? Math.ffloor((k.extraParam / 3600)) : 0));
                this._component.localizations.registerParameter(_local_18, "hours", _local_21);
                this._component.localizations.registerParameter(_local_18, "minutes", _local_20);
                this._component.localizations.registerParameter(_local_18, "seconds", _local_19);
                k.text = this._component.localizations.getLocalizationRaw(_local_18).value;
            }
            if (this._chatBubblePool.length > 0)
            {
                _local_8 = this._chatBubblePool.pop();
            }
            else
            {
                _local_8 = new PooledChatBubble(this._component);
            }
            this._Str_20462(k, _local_3);
            var _local_9:ASObject = _local_3.textFormat.color;
            ChatColours._Str_25637(k, _local_3);
            _local_8.chatItem = k;
            _local_8.style = _local_3;
            _local_8.face = _local_7;
            _local_8._Str_19209(_local_5, (k._Str_15133 ? ASCompat.toUInt(k._Str_15133) : _local_6), this._component.roomChatBorderLimited);
            _local_3.textFormat.color = _local_9;
            return _local_8;
        }

        public function _Str_25435(k:Int):PooledChatBubble
        {
            var _local_5:PooledChatBubble = null;
            var _local_2:IChatStyleInternal = new BlankStyle();
            var _local_3= new RoomSessionChatEvent(RoomSessionChatEvent.RSCE_CHAT_EVENT, null, -1, "", RoomSessionChatEvent.CHAT_TYPE_WHISPER);
            var _local_4= new ChatItem(_local_3, flash.Lib.getTimer());
            if (this._chatBubblePool.length > 0)
            {
                _local_5 = this._chatBubblePool.pop();
            }
            else
            {
                _local_5 = new PooledChatBubble(this._component);
            }
            _local_5.chatItem = _local_4;
            _local_5.style = _local_2;
            _local_5.face = null;
            _local_5._Str_19209("", 0, false, ChatFlowStage._Str_7698);
            return _local_5;
        }

        public function _Str_23020(k:ChatItem):IChatHistoryEntryBitmap
        {
            var _local_3:RoomUserData = null;
            var _local_10:String = null;
            var _local_11:IRoomObject = null;
            var _local_12:String = null;
            var _local_13 = false;
            var _local_14 = 0;
            var _local_15 = 0;
            var _local_16:String = null;
            var _local_17:String = null;
            var _local_18:String = null;
            var _local_19:String = null;
            var _local_20:String = null;
            var _local_21:String = null;
            var _local_2= cast(this._chatStyleLibrary.getStyle(k.style), ChatStyle);
            _local_3 = this._component.roomSessionManager.getSession(k.roomId).userDataManager.getUserDataByIndex(k.userId);
            var _local_4= "";
            var _local_5:UInt = 0;
            var _local_6= _local_2.iconImage;
            var _local_7:ASAny = (((!_local_2.isNotification) && (!(_local_3 == null))) && (!(_local_3.id == this._accountId)));
            if ((ASCompat.stringAsBool(k._Str_15251) || ASCompat.stringAsBool(k._Str_14270)))
            {
                if (_local_6 == null)
                {
                    _local_6 = this._Str_7081(k._Str_15251);
                }
                _local_4 = k._Str_14270;
            }
            else
            {
                if (_local_3 != null)
                {
                    _local_4 = _local_3.name;
                    _local_10 = _local_3.figure;
                    _local_5 = ASCompat.toUInt(this._avatarColorCache.getValue(_local_10));
                    if (_local_6 == null)
                    {
                        switch (_local_3.type)
                        {
                            case RoomObjectTypeEnum.PET:
                                _local_11 = this._component.roomEngine.getRoomObject(k.roomId, _local_3.roomObjectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                                _local_12 = null;
                                if (_local_11 != null)
                                {
                                    _local_12 = _local_11.getModel().getString(RoomObjectVariableEnum.FIGURE_POSTURE);
                                }
                                _local_13 = false;
                                _local_14 = 64;
                                _local_15 = 2;
                                _local_6 = this.getPetImage(_local_10, _local_15, _local_13, _local_14, _local_12);
                                
                            case RoomObjectTypeEnum.BOT
                               | RoomObjectTypeEnum.RENTABLE_BOT
                               | RoomObjectTypeEnum.HABBO:
                                _local_6 = this._Str_7081(_local_10);
                                
                        }
                    }
                }
            }
            if (k.chatType == RoomSessionChatEvent.CHAT_TYPE_RESPECT)
            {
                k.text = ((this._component.localizations != null) ? "" : this._component.localizations.getLocalizationWithParams("widgets.chatbubble.respect", "", ["username", _local_4]));
                _local_7 = false;
            }
            else
            {
                if (k.chatType == RoomSessionChatEvent.CHAT_TYPE_PETRESPECT)
                {
                    k.text = ((this._component.localizations != null) ? "" : this._component.localizations.getLocalizationWithParams("widget.chatbubble.petrespect", "", ["petname", _local_4]));
                    _local_7 = false;
                }
                else
                {
                    if (k.chatType == RoomSessionChatEvent.CHAT_TYPE_PETTREAT)
                    {
                        k.text = ((this._component.localizations != null) ? "" : this._component.localizations.getLocalizationWithParams("widget.chatbubble.pettreat", "", ["petname", _local_4]));
                        _local_7 = false;
                    }
                }
            }
            if (k.chatType == RoomSessionChatEvent.CHAT_TYPE_HAND_ITEM_RECEIVED)
            {
                _local_16 = "widget.chatbubble.handitem";
                _local_17 = this._component.localizations.getLocalizationWithParams(("handitem" + Std.string(k.extraParam)), ("handitem" + Std.string(k.extraParam)));
                k.text = this._component.localizations.getLocalizationWithParams(_local_16, "", ["username", _local_4, "handitem", _local_17]);
                _local_7 = false;
            }
            if (k.chatType == RoomSessionChatEvent._Str_8909)
            {
                _local_18 = "widget.chatbubble.mutetime";
                _local_19 = Std.string((k.extraParam % 60));
                _local_20 = Std.string(((k.extraParam > 0) ? Math.ffloor(((k.extraParam % 3600) / 60)) : 0));
                _local_21 = Std.string(((k.extraParam > 0) ? Math.ffloor((k.extraParam / 3600)) : 0));
                this._component.localizations.registerParameter(_local_18, "hours", _local_21);
                this._component.localizations.registerParameter(_local_18, "minutes", _local_20);
                this._component.localizations.registerParameter(_local_18, "seconds", _local_19);
                k.text = this._component.localizations.getLocalizationRaw(_local_18).value;
                _local_7 = false;
            }
            this._Str_20462(k, _local_2);
            var _local_8= new ChatBubble(k, _local_2, _local_6, _local_4, (k._Str_15133 ? ASCompat.toUInt(k._Str_15133) : _local_5), this._component, RoomChatSettings.CHAT_BUBBLE_WIDTH_NORMAL);
			var _local_9= new BitmapData(Std.int(_local_8.width), Std.int(_local_8.height), true, 0);
            _local_8._Str_23014(_local_9);
            return new ChatHistoryEntryBitmapBubble(k, _local_7, _local_4, _local_9, _local_2.overlap);
        }

        public function createStylePreviewBitmap(styleId:Int, userName:String, figure:String, sampleText:String):BitmapData
        {
            var _local_2= cast(this._chatStyleLibrary.getStyle(styleId), ChatStyle);
            if (_local_2 == null)
            {
                return new BitmapData(1, 1, true, 0);
            }
            var _local_3= _local_2.iconImage;
            if ((((_local_3 == null) && (!(figure == null))) && (figure.length > 0)))
            {
                _local_3 = this._Str_7081(figure);
            }
            var _local_4= ASCompat.toUInt(this._avatarColorCache.getValue(figure));
            var _local_5= new RoomSessionChatEvent(RoomSessionChatEvent.RSCE_CHAT_EVENT, null, -1, (ASCompat.stringAsBool(sampleText) ? sampleText : ""), RoomSessionChatEvent.CHAT_TYPE_SPEAK, styleId);
            var _local_6= new ChatItem(_local_5, flash.Lib.getTimer(), null, 0, null, null, figure, userName);
            this._Str_20462(_local_6, _local_2);
            var _local_7= new ChatBubble(_local_6, _local_2, _local_3, userName, _local_4, this._component, RoomChatSettings.CHAT_BUBBLE_WIDTH_NORMAL);
            var _local_8= new BitmapData(Std.int(Math.max(1, _local_7.width)), Std.int(Math.max(1, _local_7.height)), true, 0);
            _local_7._Str_23014(_local_8);
            return _local_8;
        }

        function _Str_20462(k:ChatItem, _arg_2:ChatStyle)
        {
            if (_arg_2.isNotification)
            {
                return;
            }
            if (!_arg_2.allowHTML)
            {
                k.text = new compat.RegExp(">", "g").replace(new compat.RegExp("<", "g").replace(k.text, "&lt;"), "&gt;");
                k.text = new compat.RegExp("&#[0-9]+;", "g").replace(k.text, "");
                k.text = new compat.RegExp("&#x[0-9]+;", "g").replace(k.text, "");
            }
        }

        public function _Str_23311(k:GuestRoomData):IChatHistoryEntryBitmap
        {
            return new ChatHistoryRoomChangeEntry(k, this._component);
        }

        public function recycle(k:PooledChatBubble)
        {
            this._chatBubblePool.push(k);
        }

        public function _Str_7081(k:String):BitmapData
        {
            var _local_4:IAvatarImage = null;
            var _local_5:IPartColor = null;
            var _local_2= this._component.getBoolean("zoom.enabled");
            var _local_3= ASCompat.dynamicAs(this._avatarImageCache.getValue(k) , BitmapData);
            if (_local_3 == null)
            {
                _local_4 = this._component.avatarRenderManager.createAvatarImage(k, (_local_2 ? AvatarScaleType.LARGE : AvatarScaleType.SMALL), null, this);
                if (_local_4 != null)
                {
_local_3 = _local_4.getCroppedImage(AvatarSetType.HEAD, (_local_2 ? 0.5 : 1));
                    _local_5 = _local_4._Str_867(AvatarFigurePartType.CHEST);
                    _local_4.dispose();
                    if (_local_5 != null)
                    {
                        this._avatarColorCache.add(k, _local_5._Str_915);
                    }
                }
            }
            if (_local_3 != null)
            {
                this._avatarImageCache.add(k, _local_3);
            }
            return _local_3;
        }

        function getPetImage(k:String, _arg_2:Int, _arg_3:Bool, _arg_4:Int=64, _arg_5:String=null):BitmapData
        {
            var _local_7:PetFigureData = null;
            var _local_8 = 0;
            var _local_9:UInt = 0;
            var _local_10 = false;
            var _local_11:ImageResult = null;
            var _local_6= ASCompat.dynamicAs(this._petImageCache.getValue((k + _arg_5)) , BitmapData);
            if (_local_6 == null)
            {
                _local_7 = new PetFigureData(k);
                _local_8 = _local_7.typeId;
                _local_9 = 0;
                _local_10 = false;
                _local_11 = this._component.roomEngine.getPetImage(_local_8, _local_7.paletteId, _local_7.color, new Vector3d((_arg_2 * 45)), _arg_4, this, _local_10, _local_9, _local_7._Str_3542, _arg_5);
                if (_local_11 != null)
                {
                    _local_6 = _local_11.data;
                    if (_local_11.id > 0)
                    {
                        this._petImageIdToFigureString.add(_local_11.id, _local_7.figureString);
                    }
                }
                this._avatarColorCache.add(k, _local_7.color);
            }
            if (_local_6 != null)
            {
                this._petImageCache.add((k + _arg_5), _local_6);
            }
            return _local_6;
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            var _local_3:String = this._petImageIdToFigureString.remove(k);
            if (_local_3 != null)
            {
                this._Str_18432(_local_3);
                if (this._petImageCache != null)
                {
                    this._petImageCache.add(_local_3, _arg_2);
                }
            }
        }

        public function imageFailed(k:Int)
        {
        }

        function _Str_18432(k:String)
        {
            var _local_2:BitmapData = null;
            if (this._petImageCache != null)
            {
                _local_2 = ASCompat.dynamicAs(this._petImageCache.remove(k) , BitmapData);
                if (_local_2 != null)
                {
                    this._imagesWaitingForDispose.push(_local_2);
                }
            }
            if (this._imagesWaitingForDispose.length > _Str_14010)
            {
                this._Str_17762();
            }
        }

        public function avatarImageReady(k:String)
        {
            var _local_2:BitmapData = null;
            if (this._avatarImageCache != null)
            {
                _local_2 = ASCompat.dynamicAs(this._avatarImageCache.remove(k) , BitmapData);
                if (_local_2 != null)
                {
                    this._imagesWaitingForDispose.push(_local_2);
                }
            }
            if (this._imagesWaitingForDispose.length > _Str_14010)
            {
                this._Str_17762();
            }
        }

        function _Str_17762()
        {
            var k:BitmapData = null;
            final _iter_ = this._imagesWaitingForDispose; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k != null)
                {
                    k.dispose();
                }
            }
        }

        public var chatStyleLibrary(get,never):ChatStyleLibrary;
public function  get_chatStyleLibrary():ChatStyleLibrary
        {
            return this._chatStyleLibrary;
        }
    }

