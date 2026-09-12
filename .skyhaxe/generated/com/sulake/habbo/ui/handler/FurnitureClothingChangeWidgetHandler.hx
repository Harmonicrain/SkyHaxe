package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.avatar._Str_5523;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.avatar._enum.AvatarEditorInstanceId;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniToWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetClothingChangeMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetAvatarEditorMessage;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.ui.widget.events.RoomWidgetClothingChangeUpdateEvent;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.habbo.avatar.figuredata.FigureData;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.avatar._enum.AvatarEditorFigureCategory;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;

     class FurnitureClothingChangeWidgetHandler implements IRoomWidgetHandler implements  _Str_5523 
    {
        static inline final _Str_17140= "hd-99999-99999.lg-270-62";
        static inline final _Str_18077= "hd-99999-99999.ch-630-62.lg-695-62";

        var _isDisposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;
        var _objectId:Int = -1;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.CLOTHING_CHANGE;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public function dispose()
        {
            if (((this._container != null) && (this._container.avatarEditor != null)))
            {
                this._container.avatarEditor.close(AvatarEditorInstanceId.FURNITURE_AVATAR_EDITOR);
            }
            this._isDisposed = true;
            this._container = null;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_CLOTHING_CHANGE, RoomWidgetClothingChangeMessage.RWCCM_REQUEST_EDITOR, RoomWidgetAvatarEditorMessage.RWCM_OPEN_AVATAR_EDITOR];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_5:RoomWidgetFurniToWidgetMessage = null;
            var _local_6:RoomWidgetClothingChangeMessage = null;
            var _local_7 = false;
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_2:IRoomObject = null;
            var _local_3:IRoomObjectModel = null;
            var _local_4:RoomWidgetClothingChangeUpdateEvent = null;
            switch (k.type)
            {
                case RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_CLOTHING_CHANGE:
                    _local_5 = Std.downcast(k , RoomWidgetFurniToWidgetMessage);
                    _local_2 = this._container.roomEngine.getRoomObject(_local_5.roomId, _local_5.id, _local_5.category);
                    if (_local_2 != null)
                    {
                        _local_3 = _local_2.getModel();
                        if (_local_3 != null)
                        {
                            _local_7 = ((this._container.roomSession.isRoomOwner || this._container.sessionDataManager.isAnyRoomController) || (this._container.roomSession.roomControllerLevel >= RoomControllerLevel.GUEST));
                            if (_local_7)
                            {
                                _local_4 = new RoomWidgetClothingChangeUpdateEvent(RoomWidgetClothingChangeUpdateEvent.RWCCUE_SHOW_GENDER_SELECTION, _local_5.id, _local_5.category, _local_5.roomId);
                                this._container.events.dispatchEvent(_local_4);
                            }
                        }
                    }
                    
                case RoomWidgetClothingChangeMessage.RWCCM_REQUEST_EDITOR:
                    _local_6 = Std.downcast(k , RoomWidgetClothingChangeMessage);
                    _local_2 = this._container.roomEngine.getRoomObject(_local_6.roomId, _local_6.objectId, _local_6.objectCategory);
                    if (_local_2 != null)
                    {
                        _local_3 = _local_2.getModel();
                        if (_local_3 != null)
                        {
                            this._objectId = _local_6.objectId;
                            _local_8 = FigureData.M;
                            _local_9 = _local_3.getString(RoomObjectVariableEnum.FURNITURE_CLOTHING_BOY);
                            if (((_local_9 == null) || (_local_9 == "")))
                            {
                                _local_9 = _Str_17140;
                            }
                            if (_local_6.gender == FigureData.F)
                            {
                                _local_8 = FigureData.F;
                                _local_9 = _local_3.getString(RoomObjectVariableEnum.FURNITURE_CLOTHING_GIRL);
                                if (((_local_9 == null) || (_local_9 == "")))
                                {
                                    _local_9 = _Str_18077;
                                }
                            }
                            if (this._container.avatarEditor.openEditor(AvatarEditorInstanceId.FURNITURE_AVATAR_EDITOR, this, [AvatarEditorFigureCategory.TORSO, AvatarEditorFigureCategory.LEGS], false, "${widget.furni.clothingchange.editor.title}") != null)
                            {
                                this._container.avatarEditor.loadAvatarInEditor(AvatarEditorInstanceId.FURNITURE_AVATAR_EDITOR, _local_9, _local_8, HabboClubLevelEnum.NO_CLUB);
                                _local_4 = new RoomWidgetClothingChangeUpdateEvent(RoomWidgetClothingChangeUpdateEvent.RWCCUE_SHOW_GENDER_SELECTION, _local_6.objectId, _local_6.objectCategory, _local_6.roomId);
                                this._container.events.dispatchEvent(_local_4);
                            }
                        }
                    }
                    
            }
            return null;
        }

        public function update()
        {
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [];
        }

        public function processEvent(k:Event)
        {
        }

        public function _Str_21941(k:String, _arg_2:String)
        {
            if (this._container == null)
            {
                return;
            }
            this._container.roomSession.sendUpdateClothingChangeFurniture(this._objectId, _arg_2, k);
            this._container.avatarEditor.close(AvatarEditorInstanceId.FURNITURE_AVATAR_EDITOR);
        }
public function new(){}
    }

