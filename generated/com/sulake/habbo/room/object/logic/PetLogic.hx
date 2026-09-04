package com.sulake.habbo.room.object.logic
;
	import com.sulake.habbo.room.object.logic.MovingObjectLogic;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.events.RoomObjectMouseEvent;
    import com.sulake.habbo.room.events.RoomObjectMoveEvent;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.utils.XMLValidator;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.messages.RoomObjectAvatarPostureUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarChatUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarPetGestureUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarSleepUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarSelectedMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarExperienceUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarFigureUpdateMessage;
    import com.sulake.habbo.avatar.pets.PetFigureData;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.IVector3d;
    import flash.events.MouseEvent;
    import com.sulake.habbo.avatar.pets.PetTypeEnum;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

     class PetLogic extends MovingObjectLogic 
    {
        var _talkingEndTimeStamp:Int = 0;
        var _gestureEndTimeStamp:Int = 0;
        var _expressionEndTimeStamp:Int = 0;
        var _selected:Bool = false;
        var _reportedLoc:Vector3d = null;
        var _debugMode:Bool = false;
        var _postureIndex:Int = 0;
        var _gestureIndex:Int = 0;
        var _headDirectionDelta:Int = 0;
        var _debugDirectionIndex:Int = 0;
        var _directions:Array<ASAny>;

        public function new()
        {
            this._directions = [];
            super();
        }

        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectMouseEvent.ROE_MOUSE_CLICK, RoomObjectMoveEvent.ROME_POSITION_CHANGED];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function dispose()
        {
            var k:RoomObjectEvent;
            if ((this._selected && (!(object == null))))
            {
                if (eventDispatcher != null)
                {
                    k = new RoomObjectMoveEvent(RoomObjectMoveEvent.ROME_OBJECT_REMOVED, object);
                    eventDispatcher.dispatchEvent(k);
                }
            }
            this._directions = null;
            super.dispose();
            this._reportedLoc = null;
        }

        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            var _local_5:com.sulake.core.utils.xml.XML;
            var _local_6:Int;
            super.initialize(k);
            this._directions = [];
            var _local_2= k.child("model").child("directions").child("direction");
            var _local_3:Array<ASAny> = ["id"];
            var _local_4 = 0;
            while (_local_4 < _local_2.length())
            {
                _local_5 = _local_2.at(_local_4);
                if (XMLValidator.checkRequiredAttributes(_local_5, _local_3))
                {
                    _local_6 = ASCompat.parseInt(_local_5.attribute("id").toString());
                    this._directions.push(_local_6);
                }
                _local_4++;
            }
            ASCompat.ASArray.sortWithOptions(this._directions, ASCompat.ASArray.NUMERIC);
            object.getModelController().setNumberArray(RoomObjectVariableEnum.PET_ALLOWED_DIRECTIONS, this._directions, true);
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_3:RoomObjectAvatarPostureUpdateMessage;
            var _local_4:RoomObjectAvatarUpdateMessage;
            var _local_5:RoomObjectAvatarChatUpdateMessage;
            var _local_6:RoomObjectAvatarPetGestureUpdateMessage;
            var _local_7:RoomObjectAvatarSleepUpdateMessage;
            var _local_8:RoomObjectAvatarSelectedMessage;
            var _local_9:RoomObjectAvatarExperienceUpdateMessage;
            var _local_10:RoomObjectAvatarFigureUpdateMessage;
            var _local_11:String;
            var _local_12:PetFigureData;
            if (((k == null) || (object == null)))
            {
                return;
            }
            var _local_2= object.getModelController();
            if (!this._debugMode)
            {
                super.processUpdateMessage(k);
                if (Std.is(k , RoomObjectAvatarPostureUpdateMessage))
                {
                    _local_3 = Std.downcast(k , RoomObjectAvatarPostureUpdateMessage);
                    _local_2.setString(RoomObjectVariableEnum.FIGURE_POSTURE, _local_3.postureType);
                    return;
                }
                if (Std.is(k , RoomObjectAvatarUpdateMessage))
                {
                    _local_4 = Std.downcast(k , RoomObjectAvatarUpdateMessage);
                    _local_2.setNumber(RoomObjectVariableEnum.HEAD_DIRECTION, _local_4.dirHead);
                    return;
                }
                if (Std.is(k , RoomObjectAvatarChatUpdateMessage))
                {
                    _local_5 = Std.downcast(k , RoomObjectAvatarChatUpdateMessage);
                    _local_2.setNumber(RoomObjectVariableEnum.FIGURE_TALK, 1);
                    this._talkingEndTimeStamp = (flash.Lib.getTimer() + (_local_5.numberOfWords * 1000));
                    return;
                }
                if (Std.is(k , RoomObjectAvatarPetGestureUpdateMessage))
                {
                    _local_6 = Std.downcast(k , RoomObjectAvatarPetGestureUpdateMessage);
                    _local_2.setString(RoomObjectVariableEnum.FIGURE_GESTURE, _local_6.gesture);
                    this._gestureEndTimeStamp = (flash.Lib.getTimer() + (3 * 1000));
                    return;
                }
                if (Std.is(k , RoomObjectAvatarSleepUpdateMessage))
                {
                    _local_7 = Std.downcast(k , RoomObjectAvatarSleepUpdateMessage);
                    _local_2.setNumber(RoomObjectVariableEnum.FIGURE_SLEEP, ASCompat.toNumber(_local_7.isSleeping));
                    return;
                }
            }
            if (Std.is(k , RoomObjectAvatarSelectedMessage))
            {
                _local_8 = Std.downcast(k , RoomObjectAvatarSelectedMessage);
                this._selected = _local_8.selected;
                this._reportedLoc = null;
                return;
            }
            if (Std.is(k , RoomObjectAvatarExperienceUpdateMessage))
            {
                _local_9 = Std.downcast(k , RoomObjectAvatarExperienceUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_EXPERIENCE_TIMESTAMP, flash.Lib.getTimer());
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_GAINED_EXPERIENCE, _local_9._Str_18578);
                return;
            }
            if (Std.is(k , RoomObjectAvatarFigureUpdateMessage))
            {
                _local_10 = Std.downcast(k , RoomObjectAvatarFigureUpdateMessage);
                _local_11 = _local_2.getString(RoomObjectVariableEnum.FIGURE);
                _local_12 = new PetFigureData(_local_10.figure);
                _local_2.setString(RoomObjectVariableEnum.FIGURE, _local_10.figure);
                _local_2.setString(RoomObjectVariableEnum.RACE, _local_10.race);
                _local_2.setNumber(RoomObjectVariableEnum.PET_PALETTE_INDEX, _local_12.paletteId);
                _local_2.setNumber(RoomObjectVariableEnum.PET_COLOR, _local_12.color);
                _local_2.setNumber(RoomObjectVariableEnum.PET_TYPE, _local_12.typeId);
                _local_2.setNumberArray(RoomObjectVariableEnum.PET_CUSTOM_LAYER_IDS, _local_12.customLayerIds);
                _local_2.setNumberArray(RoomObjectVariableEnum.PET_CUSTOM_PARTS_IDS, _local_12.customPartIds);
                _local_2.setNumberArray(RoomObjectVariableEnum.PET_CUSTOM_PALETTE_IDS, _local_12.customPaletteIds);
                _local_2.setNumber(RoomObjectVariableEnum.PET_IS_RIDING, (_local_10.isRiding ? 1 : 0));
                return;
            }
        }

        override public function mouseEvent(k:RoomSpriteMouseEvent, _arg_2:IRoomGeometry)
        {
            var _local_7:Int;
            var _local_8:RoomObjectEvent;
            if (((object == null) || (k == null)))
            {
                return;
            }
            var _local_3= object.getModelController();
            var _local_4:IVector3d;
            var _local_5:Vector3d;
            var _local_6:String = null;
            switch (k.type)
            {
                case MouseEvent.CLICK:
                    _local_6 = RoomObjectMouseEvent.ROE_MOUSE_CLICK;
                    if (this._debugMode)
                    {
                        this.debugMouseEvent(k);
                    }
                    
                case MouseEvent.DOUBLE_CLICK:
                    
                case MouseEvent.MOUSE_DOWN:
                    if (!this._debugMode)
                    {
                        _local_7 = Std.int(_local_3.getNumber(RoomObjectVariableEnum.PET_TYPE));
                        if (_local_7 == PetTypeEnum.MONSTERPLANT)
                        {
                            if (eventDispatcher != null)
                            {
                                _local_8 = new RoomObjectMouseEvent(RoomObjectMouseEvent.ROE_MOUSE_DOWN, object, k.eventId, k.altKey, k.ctrlKey, k.shiftKey, k.buttonDown);
                                eventDispatcher.dispatchEvent(_local_8);
                            }
                        }
                    }
                    
            }
            if (_local_6 != null)
            {
                if (eventDispatcher != null)
                {
                    _local_8 = new RoomObjectMouseEvent(_local_6, object, k.eventId, k.altKey, k.ctrlKey, k.shiftKey, k.buttonDown);
                    eventDispatcher.dispatchEvent(_local_8);
                }
            }
        }

        function debugMouseEvent(k:RoomSpriteMouseEvent)
        {
            var _local_3:Int;
            var _local_2= object.getModelController();
            if (((!k.altKey) && (!k.ctrlKey)))
            {
                _local_3 = ASCompat.toInt(this._directions[this._debugDirectionIndex]);
                object.setDirection(new Vector3d(_local_3));
                _local_2.setNumber(RoomObjectVariableEnum.HEAD_DIRECTION, (_local_3 + this._headDirectionDelta));
                this._debugDirectionIndex++;
                if (this._debugDirectionIndex == this._directions.length)
                {
                    this._debugDirectionIndex = 0;
                }
            }
            else
            {
                if ((k.altKey && (!k.ctrlKey)))
                {
                    this._postureIndex++;
                    _local_2.setNumber(RoomObjectVariableEnum.FIGURE_POSTURE, this._postureIndex);
                    _local_2.setNumber(RoomObjectVariableEnum.FIGURE_GESTURE, Math.NaN);
                }
                else
                {
                    if ((k.ctrlKey && (!k.altKey)))
                    {
                        this._gestureIndex++;
                        _local_2.setNumber(RoomObjectVariableEnum.FIGURE_GESTURE, this._gestureIndex);
                    }
                    else
                    {
                        this._headDirectionDelta = (this._headDirectionDelta + 45);
                        if (this._headDirectionDelta > 45)
                        {
                            this._headDirectionDelta = -45;
                        }
                        _local_3 = Std.int(object.getDirection().x);
                        _local_2.setNumber(RoomObjectVariableEnum.HEAD_DIRECTION, (_local_3 + this._headDirectionDelta));
                    }
                }
            }
        }

        override public function update(k:Int)
        {
            var _local_2:IVector3d;
            var _local_3:RoomObjectEvent;
            super.update(k);
            if ((this._selected && (!(object == null))))
            {
                if (eventDispatcher != null)
                {
                    _local_2 = object.getLocation();
                    if (((((this._reportedLoc == null) || (!(this._reportedLoc.x == _local_2.x))) || (!(this._reportedLoc.y == _local_2.y))) || (!(this._reportedLoc.z == _local_2.z))))
                    {
                        if (this._reportedLoc == null)
                        {
                            this._reportedLoc = new Vector3d();
                        }
                        this._reportedLoc.assign(_local_2);
                        _local_3 = new RoomObjectMoveEvent(RoomObjectMoveEvent.ROME_POSITION_CHANGED, object);
                        eventDispatcher.dispatchEvent(_local_3);
                    }
                }
            }
            if (((!(object == null)) && (!(object.getModelController() == null))))
            {
                this.updateActions(k, object.getModelController());
            }
        }

        function updateActions(k:Int, _arg_2:IRoomObjectModelController)
        {
            if (((this._gestureEndTimeStamp > 0) && (k > this._gestureEndTimeStamp)))
            {
                _arg_2.setString(RoomObjectVariableEnum.FIGURE_GESTURE, null);
                this._gestureEndTimeStamp = 0;
            }
            if (this._talkingEndTimeStamp > 0)
            {
                if (k > this._talkingEndTimeStamp)
                {
                    _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_TALK, 0);
                    this._talkingEndTimeStamp = 0;
                }
            }
            if (((this._expressionEndTimeStamp > 0) && (k > this._expressionEndTimeStamp)))
            {
                _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_EXPRESSION, 0);
                this._expressionEndTimeStamp = 0;
            }
        }
    }

