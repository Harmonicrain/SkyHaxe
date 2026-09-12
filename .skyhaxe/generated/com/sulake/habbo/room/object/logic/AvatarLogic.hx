package com.sulake.habbo.room.object.logic
;
	import com.sulake.habbo.room.object.logic.MovingObjectLogic;
    import com.sulake.habbo.habbicons.assets.HabbiconAssetManager;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.events.RoomObjectMouseEvent;
    import com.sulake.habbo.room.events.RoomObjectMoveEvent;
    import com.sulake.habbo.room.events.RoomObjectFurnitureActionEvent;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.messages.RoomObjectAvatarPostureUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarChatUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarTypingUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarMutedUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarPlayingGameMessage;
    import com.sulake.habbo.room.messages.RoomObjectMoveUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarDirectionUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarGestureUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarDanceUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarSleepUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarPlayerValueUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarEffectUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarCarryObjectUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarUseObjectUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarSignUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarFlatControlUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarFigureUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarSelectedMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarGuideStatusUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectAvatarHabbiconUpdateMessage;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.messages.RoomObjectAvatarExpressionUpdateMessage;
    import com.sulake.habbo.avatar._enum.AvatarAction;
    import com.sulake.habbo.room.messages.RoomObjectAvatarOwnMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import flash.events.MouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.utils.IVector3d;

     class AvatarLogic extends MovingObjectLogic 
    {
        static inline final WARP_WARN_THRESHOLD= 1.5;
        static inline final EFFECT_TYPE_SPLASH= 28;
        static inline final EFFECT_TYPE_SWIM= 29;
        static inline final EFFECT_SPLASH_LENGTH= 184;
        static inline final CARRY_ITEM_NULL= 185;
        static inline final CARRY_ITEM_LAST_CONSUMABLE= 500;
        static inline final CARRY_ITEM_EMPTY_HAND= 0;
        static inline final CARRY_ITEM_DELAY_BEFORE_USE= 999;
        static inline final CARRY_ITEM_EMPTY_HAND_ANIMATION_LENGTH= 999999999;
        static inline final _Str_18795= 5000;
        static inline final _Str_17418= 1500;
        static inline final SPINNING_DUCK_HABBICON_NAME= "duck_spinning";
        static inline final HABBICON_VISIBLE_DURATION_MS= 6000;
        static inline final HABBICON_SPIN_DURATION_MS= 3200;
        static inline final HABBICON_SPIN_STEP_MS= 100;
        static inline final HABBICON_SPIN_STEP_DEGREES= -45;

        var _selected:Bool = false;
        var _reportedLoc:Vector3d = null;
        var _effectChangeTimeStamp:Int = 0;
        var _newEffect:Int = 0;
        var _talkingEndTimeStamp:Int = 0;
        var _talkingPauseEndTimeStamp:Int = 0;
        var _talkingPauseStartTimeStamp:Int = 0;
        var _animationEndTimeStamp:Int = 0;
        var _gestureEndTimeStamp:Int = 0;
        var _signEndTimeStamp:Int = 0;
        var _carryObjectStartTimeStamp:Int = 0;
        var _carryObjectEndTimeStamp:Int = 0;
        var _allowUseCarryObject:Bool = false;
        var _blinkingEndTimeStamp:Int = 0;
        var _blinkingStartTimeStamp:Int = 0;
        var _numberValueEndTimeStamp:Int = 0;
        var _habbiconEndTimeStamp:Int = 0;
        var _habbiconSpinStartTimeStamp:Int = 0;
        var _habbiconSpinEndTimeStamp:Int = 0;
        var _habbiconSpinOffset:Int = 0;

        public function new()
        {
            super();
            this._blinkingStartTimeStamp = (flash.Lib.getTimer() + this.getBlinkInterval());
        }

        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectMouseEvent.ROE_MOUSE_CLICK, RoomObjectMoveEvent.ROME_POSITION_CHANGED, RoomObjectMouseEvent.ROE_MOUSE_ENTER, RoomObjectMouseEvent.ROE_MOUSE_LEAVE, RoomObjectFurnitureActionEvent.MOUSE_BUTTON, RoomObjectFurnitureActionEvent.MOUSE_ARROW];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function dispose()
        {
            var k:RoomObjectEvent = null;
            if ((this._selected && (!(object == null))))
            {
                if (eventDispatcher != null)
                {
                    k = new RoomObjectMoveEvent(RoomObjectMoveEvent.ROME_OBJECT_REMOVED, object);
                    eventDispatcher.dispatchEvent(k);
                }
            }
            super.dispose();
            this._reportedLoc = null;
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_3:RoomObjectAvatarPostureUpdateMessage = null;
            var _local_4:RoomObjectAvatarChatUpdateMessage = null;
            var _local_5:RoomObjectAvatarTypingUpdateMessage = null;
            var _local_6:RoomObjectAvatarMutedUpdateMessage = null;
            var _local_7:RoomObjectAvatarPlayingGameMessage = null;
            var _local_8:RoomObjectAvatarUpdateMessage = null;
            var _local_9:RoomObjectAvatarGestureUpdateMessage = null;
            var _local_10:RoomObjectAvatarDanceUpdateMessage = null;
            var _local_11:RoomObjectAvatarSleepUpdateMessage = null;
            var _local_12:RoomObjectAvatarPlayerValueUpdateMessage = null;
            var _local_13:RoomObjectAvatarEffectUpdateMessage = null;
            var _local_14 = 0;
            var _local_15 = 0;
            var _local_16:RoomObjectAvatarCarryObjectUpdateMessage = null;
            var _local_17:RoomObjectAvatarUseObjectUpdateMessage = null;
            var _local_18:RoomObjectAvatarSignUpdateMessage = null;
            var _local_19:RoomObjectAvatarFlatControlUpdateMessage = null;
            var _local_20 = Math.NaN;
            var _local_21:RoomObjectAvatarFigureUpdateMessage = null;
            var _local_22:String = null;
            var _local_23:String = null;
            var _local_24:String = null;
            var _local_25:RoomObjectAvatarSelectedMessage = null;
            var _local_26:RoomObjectAvatarGuideStatusUpdateMessage = null;
            var _local_27:RoomObjectAvatarDirectionUpdateMessage = null;
            var _local_28:RoomObjectAvatarHabbiconUpdateMessage = null;
            if (((k == null) || (object == null)))
            {
                return;
            }
            super.processUpdateMessage(k);
            var _local_2= object.getModelController();
            if (Std.is(k , RoomObjectAvatarPostureUpdateMessage))
            {
                _local_3 = Std.downcast(k , RoomObjectAvatarPostureUpdateMessage);
                _local_2.setString(RoomObjectVariableEnum.FIGURE_POSTURE, _local_3.postureType);
                _local_2.setString(RoomObjectVariableEnum.FIGURE_POSTURE_PARAMETER, _local_3.parameter);
                return;
            }
            if (Std.is(k , RoomObjectAvatarChatUpdateMessage))
            {
                _local_4 = Std.downcast(k , RoomObjectAvatarChatUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_TALK, 1);
                this._talkingEndTimeStamp = (flash.Lib.getTimer() + (_local_4.numberOfWords * 1000));
                return;
            }
            if (Std.is(k , RoomObjectAvatarTypingUpdateMessage))
            {
                _local_5 = Std.downcast(k , RoomObjectAvatarTypingUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_IS_TYPING, ASCompat.toNumber(_local_5.isTyping));
                return;
            }
            if (Std.is(k , RoomObjectAvatarMutedUpdateMessage))
            {
                _local_6 = Std.downcast(k , RoomObjectAvatarMutedUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_IS_MUTED, ASCompat.toNumber(_local_6.isMuted));
                return;
            }
            if (Std.is(k , RoomObjectAvatarPlayingGameMessage))
            {
                _local_7 = Std.downcast(k , RoomObjectAvatarPlayingGameMessage);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_IS_PLAYING_GAME, ASCompat.toNumber(_local_7.isPlayingGame));
                return;
            }
            if (Std.is(k , RoomObjectAvatarUpdateMessage))
            {
                _local_8 = Std.downcast(k , RoomObjectAvatarUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.HEAD_DIRECTION, _local_8.dirHead);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_CAN_STAND_UP, ASCompat.toNumber(_local_8.canStandUp));
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_VERTICAL_OFFSET, _local_8.baseY);
                if (!Math.isNaN(_local_8.jumpingPower))
                {
                    _local_2.setNumber(RoomObjectVariableEnum.FIGURE_JUMPING_POWER, _local_8.jumpingPower);
                }
                return;
            }
            if (Std.is(k , RoomObjectAvatarDirectionUpdateMessage))
            {
                _local_27 = Std.downcast(k , RoomObjectAvatarDirectionUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.HEAD_DIRECTION, _local_27.dirHead);
                return;
            }
            if (Std.is(k , RoomObjectAvatarGestureUpdateMessage))
            {
                _local_9 = Std.downcast(k , RoomObjectAvatarGestureUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_GESTURE, _local_9.gesture);
                this._gestureEndTimeStamp = (flash.Lib.getTimer() + (3 * 1000));
                return;
            }
            if (Std.is(k , RoomObjectAvatarExpressionUpdateMessage))
            {
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_EXPRESSION, cast(k, RoomObjectAvatarExpressionUpdateMessage).expressionType);
                this._animationEndTimeStamp = AvatarAction.getExpressionTime(Std.int(_local_2.getNumber(RoomObjectVariableEnum.FIGURE_EXPRESSION)));
                if (this._animationEndTimeStamp > -1)
                {
                    this._animationEndTimeStamp = (this._animationEndTimeStamp + flash.Lib.getTimer());
                }
                return;
            }
            if (Std.is(k , RoomObjectAvatarDanceUpdateMessage))
            {
                _local_10 = Std.downcast(k , RoomObjectAvatarDanceUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_DANCE, _local_10._Str_8263);
                return;
            }
            if (Std.is(k , RoomObjectAvatarSleepUpdateMessage))
            {
                _local_11 = Std.downcast(k , RoomObjectAvatarSleepUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_SLEEP, ASCompat.toNumber(_local_11.isSleeping));
                return;
            }
            if (Std.is(k , RoomObjectAvatarPlayerValueUpdateMessage))
            {
                _local_12 = Std.downcast(k , RoomObjectAvatarPlayerValueUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_NUMBER_VALUE, _local_12.value);
                this._numberValueEndTimeStamp = (flash.Lib.getTimer() + 3000);
                return;
            }
            if (Std.is(k , RoomObjectAvatarEffectUpdateMessage))
            {
                _local_13 = Std.downcast(k , RoomObjectAvatarEffectUpdateMessage);
                _local_14 = _local_13.effect;
                _local_15 = _local_13.delayMilliSeconds;
                this.updateEffect(_local_14, _local_15, _local_2);
                return;
            }
            if (Std.is(k , RoomObjectAvatarCarryObjectUpdateMessage))
            {
                _local_16 = Std.downcast(k , RoomObjectAvatarCarryObjectUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_CARRY_OBJECT, _local_16.itemType);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_USE_OBJECT, 0);
                this._carryObjectStartTimeStamp = flash.Lib.getTimer();
                if (_local_16.itemType < CARRY_ITEM_EMPTY_HAND_ANIMATION_LENGTH)
                {
                    this._carryObjectEndTimeStamp = 0;
                    this._allowUseCarryObject = (_local_16.itemType <= CARRY_ITEM_DELAY_BEFORE_USE);
                }
                else
                {
                    this._carryObjectEndTimeStamp = (this._carryObjectStartTimeStamp + _Str_17418);
                    this._allowUseCarryObject = false;
                }
                return;
            }
            if (Std.is(k , RoomObjectAvatarUseObjectUpdateMessage))
            {
                _local_17 = Std.downcast(k , RoomObjectAvatarUseObjectUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_USE_OBJECT, _local_17.itemType);
                return;
            }
            if (Std.is(k , RoomObjectAvatarSignUpdateMessage))
            {
                _local_18 = Std.downcast(k , RoomObjectAvatarSignUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_SIGN, _local_18.signType);
                this._signEndTimeStamp = (flash.Lib.getTimer() + (5 * 1000));
                return;
            }
            if (Std.is(k , RoomObjectAvatarFlatControlUpdateMessage))
            {
                _local_19 = Std.downcast(k , RoomObjectAvatarFlatControlUpdateMessage);
                _local_20 = ASCompat.parseInt(_local_19.rawData);
                if ((((_local_20 == _local_20) && (_local_20 >= 0)) && (_local_20 <= 5)))
                {
                    _local_2.setNumber(RoomObjectVariableEnum.FIGURE_FLAT_CONTROL, _local_20);
                }
                else
                {
                    _local_2.setNumber(RoomObjectVariableEnum.FIGURE_FLAT_CONTROL, 0);
                }
                return;
            }
            if (Std.is(k , RoomObjectAvatarFigureUpdateMessage))
            {
                _local_21 = Std.downcast(k , RoomObjectAvatarFigureUpdateMessage);
                _local_22 = _local_2.getString(RoomObjectVariableEnum.FIGURE);
                _local_23 = _local_21.figure;
                _local_24 = _local_21.gender;
                if (((!(_local_22 == null)) && (!(_local_22.indexOf(".bds-") == -1))))
                {
                    _local_23 = (_local_23 + _local_22.substr(_local_22.indexOf(".bds-")));
                }
                _local_2.setString(RoomObjectVariableEnum.FIGURE, _local_23);
                _local_2.setString(RoomObjectVariableEnum.GENDER, _local_24);
                return;
            }
            if (Std.is(k , RoomObjectAvatarSelectedMessage))
            {
                _local_25 = Std.downcast(k , RoomObjectAvatarSelectedMessage);
                this._selected = _local_25.selected;
                this._reportedLoc = null;
                return;
            }
            if (Std.is(k , RoomObjectAvatarGuideStatusUpdateMessage))
            {
                _local_26 = Std.downcast(k , RoomObjectAvatarGuideStatusUpdateMessage);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_GUIDE_STATUS, _local_26.guideStatus);
                return;
            }
            if (Std.is(k , RoomObjectAvatarHabbiconUpdateMessage))
            {
                _local_28 = Std.downcast(k , RoomObjectAvatarHabbiconUpdateMessage);
                _local_14 = flash.Lib.getTimer();
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_HABBICON, _local_28.habbiconId);
                _local_2.setNumber(RoomObjectVariableEnum.FIGURE_HABBICON_TRIGGER_SEQUENCE, _local_14);
                this._habbiconEndTimeStamp = _local_14 + HABBICON_VISIBLE_DURATION_MS;
                this.updateHabbiconSpinForHabbicon(_local_28.habbiconId, _local_14, _local_2);
                return;
            }
            if (Std.is(k , RoomObjectAvatarOwnMessage))
            {
                _local_2.setNumber(RoomObjectVariableEnum.OWN_USER, 1);
                return;
            }
        }

        function updateEffect(k:Int, _arg_2:Int, _arg_3:IRoomObjectModelController)
        {
            if (k == EFFECT_TYPE_SPLASH)
            {
                this._effectChangeTimeStamp = (flash.Lib.getTimer() + CARRY_ITEM_LAST_CONSUMABLE);
                this._newEffect = EFFECT_TYPE_SWIM;
            }
            else
            {
                if (k == EFFECT_SPLASH_LENGTH)
                {
                    this._effectChangeTimeStamp = (flash.Lib.getTimer() + CARRY_ITEM_LAST_CONSUMABLE);
                    this._newEffect = CARRY_ITEM_NULL;
                }
                else
                {
                    if (_arg_3.getNumber(RoomObjectVariableEnum.FIGURE_EFFECT) == EFFECT_TYPE_SWIM)
                    {
                        this._effectChangeTimeStamp = (flash.Lib.getTimer() + CARRY_ITEM_LAST_CONSUMABLE);
                        this._newEffect = k;
                        k = EFFECT_TYPE_SPLASH;
                    }
                    else
                    {
                        if (_arg_3.getNumber(RoomObjectVariableEnum.FIGURE_EFFECT) == CARRY_ITEM_NULL)
                        {
                            this._effectChangeTimeStamp = (flash.Lib.getTimer() + CARRY_ITEM_LAST_CONSUMABLE);
                            this._newEffect = k;
                            k = EFFECT_SPLASH_LENGTH;
                        }
                        else
                        {
                            if (_arg_2 == 0)
                            {
                                this._effectChangeTimeStamp = 0;
                            }
                            else
                            {
                                this._effectChangeTimeStamp = (flash.Lib.getTimer() + _arg_2);
                                this._newEffect = k;
                                return;
                            }
                        }
                    }
                }
            }
            _arg_3.setNumber(RoomObjectVariableEnum.FIGURE_EFFECT, k);
        }

        override public function mouseEvent(k:RoomSpriteMouseEvent, _arg_2:IRoomGeometry)
        {
            var _local_5:RoomObjectEvent = null;
            if (((object == null) || (k == null)))
            {
                return;
            }
            var _local_3= object.getModelController();
            var _local_4:String = null;
            switch (k.type)
            {
                case MouseEvent.CLICK:
                    _local_4 = RoomObjectMouseEvent.ROE_MOUSE_CLICK;
                    
                case MouseEvent.ROLL_OVER:
                    _local_4 = RoomObjectMouseEvent.ROE_MOUSE_ENTER;
                    if (_local_3 != null)
                    {
                        _local_3.setNumber(RoomObjectVariableEnum.FIGURE_HIGHLIGHT, 1);
                    }
                    eventDispatcher.dispatchEvent(new RoomObjectFurnitureActionEvent(RoomObjectFurnitureActionEvent.MOUSE_BUTTON, object));
                    
                case MouseEvent.ROLL_OUT:
                    if (_local_3 != null)
                    {
                        _local_3.setNumber(RoomObjectVariableEnum.FIGURE_HIGHLIGHT, 0);
                    }
                    _local_4 = RoomObjectMouseEvent.ROE_MOUSE_LEAVE;
                    eventDispatcher.dispatchEvent(new RoomObjectFurnitureActionEvent(RoomObjectFurnitureActionEvent.MOUSE_ARROW, object));
                    
            }
            if (_local_4 != null)
            {
                if (eventDispatcher != null)
                {
                    _local_5 = new RoomObjectMouseEvent(_local_4, object, k.eventId, k.altKey, k.ctrlKey, k.shiftKey, k.buttonDown);
                    eventDispatcher.dispatchEvent(_local_5);
                }
            }
        }

        override public function update(k:Int)
        {
            var _local_2:IVector3d = null;
            var _local_3:RoomObjectEvent = null;
            var _local_4:IRoomObjectModelController = null;
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
            if (object != null)
            {
                _local_4 = object.getModelController();
                if (_local_4 != null)
                {
                    this.updateActions(k, _local_4);
                }
            }
        }

        function updateActions(k:Int, _arg_2:IRoomObjectModelController)
        {
            if (this._talkingEndTimeStamp > 0)
            {
                if (k > this._talkingEndTimeStamp)
                {
                    _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_TALK, 0);
                    this._talkingEndTimeStamp = 0;
                    this._talkingPauseStartTimeStamp = 0;
                    this._talkingPauseEndTimeStamp = 0;
                }
                else
                {
                    if (((this._talkingPauseEndTimeStamp == 0) && (this._talkingPauseStartTimeStamp == 0)))
                    {
                        this._talkingPauseStartTimeStamp = (k + this.getTalkingPauseInterval());
                        this._talkingPauseEndTimeStamp = (this._talkingPauseStartTimeStamp + this.getTalkingPauseLength());
                    }
                    else
                    {
                        if (((this._talkingPauseStartTimeStamp > 0) && (k > this._talkingPauseStartTimeStamp)))
                        {
                            _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_TALK, 0);
                            this._talkingPauseStartTimeStamp = 0;
                        }
                        else
                        {
                            if (((this._talkingPauseEndTimeStamp > 0) && (k > this._talkingPauseEndTimeStamp)))
                            {
                                _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_TALK, 1);
                                this._talkingPauseEndTimeStamp = 0;
                            }
                        }
                    }
                }
            }
            if (((this._animationEndTimeStamp > 0) && (k > this._animationEndTimeStamp)))
            {
                _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_EXPRESSION, 0);
                this._animationEndTimeStamp = 0;
            }
            if (((this._gestureEndTimeStamp > 0) && (k > this._gestureEndTimeStamp)))
            {
                _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_GESTURE, 0);
                this._gestureEndTimeStamp = 0;
            }
            if (((this._signEndTimeStamp > 0) && (k > this._signEndTimeStamp)))
            {
                _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_SIGN, -1);
                this._signEndTimeStamp = 0;
            }
            if (this._carryObjectEndTimeStamp > 0)
            {
                if (k > this._carryObjectEndTimeStamp)
                {
                    _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_CARRY_OBJECT, CARRY_ITEM_EMPTY_HAND);
                    _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_USE_OBJECT, 0);
                    this._carryObjectStartTimeStamp = (this._carryObjectEndTimeStamp = 0);
                    this._allowUseCarryObject = false;
                }
            }
            if (this._allowUseCarryObject)
            {
                if ((k - this._carryObjectStartTimeStamp) > _Str_18795)
                {
                    if (((k - this._carryObjectStartTimeStamp) % 10000) < 1000)
                    {
                        _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_USE_OBJECT, 1);
                    }
                    else
                    {
                        _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_USE_OBJECT, 0);
                    }
                }
            }
            if (k > this._blinkingStartTimeStamp)
            {
                _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_BLINK, 1);
                this._blinkingStartTimeStamp = (k + this.getBlinkInterval());
                this._blinkingEndTimeStamp = (k + this.getBlinkLength());
            }
            if (((this._blinkingEndTimeStamp > 0) && (k > this._blinkingEndTimeStamp)))
            {
                _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_BLINK, 0);
                this._blinkingEndTimeStamp = 0;
            }
            if (((this._effectChangeTimeStamp > 0) && (k > this._effectChangeTimeStamp)))
            {
                _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_EFFECT, this._newEffect);
                this._effectChangeTimeStamp = 0;
            }
            if (((this._numberValueEndTimeStamp > 0) && (k > this._numberValueEndTimeStamp)))
            {
                _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_NUMBER_VALUE, 0);
                this._numberValueEndTimeStamp = 0;
            }
            if (((this._habbiconEndTimeStamp > 0) && (k > this._habbiconEndTimeStamp)))
            {
                _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_HABBICON, 0);
                _arg_2.setNumber(RoomObjectVariableEnum.FIGURE_HABBICON_TRIGGER_SEQUENCE, 0);
                this.clearHabbiconSpin(_arg_2);
                this._habbiconEndTimeStamp = 0;
            }
            this.updateHabbiconSpin(k, _arg_2);
        }

        function updateHabbiconSpinForHabbicon(habbiconId:Int, startTime:Int, model:IRoomObjectModelController)
        {
            if (HabbiconAssetManager.getHabbiconNameKey(habbiconId) == SPINNING_DUCK_HABBICON_NAME)
            {
                this._habbiconSpinStartTimeStamp = startTime;
                this._habbiconSpinEndTimeStamp = startTime + HABBICON_SPIN_DURATION_MS;
                this.setHabbiconSpinOffset(0, model);
                return;
            }
            this.clearHabbiconSpin(model);
        }

        function updateHabbiconSpin(time:Int, model:IRoomObjectModelController)
        {
            var offset = 0;
            if (this._habbiconSpinEndTimeStamp <= 0)
            {
                return;
            }
            if (time >= this._habbiconSpinEndTimeStamp)
            {
                this.clearHabbiconSpin(model);
                return;
            }
            offset = Std.int((time - this._habbiconSpinStartTimeStamp) / HABBICON_SPIN_STEP_MS) * HABBICON_SPIN_STEP_DEGREES % 360;
            this.setHabbiconSpinOffset(offset, model);
        }

        function setHabbiconSpinOffset(offset:Int, model:IRoomObjectModelController)
        {
            if (this._habbiconSpinOffset != offset)
            {
                this._habbiconSpinOffset = offset;
                model.setNumber(RoomObjectVariableEnum.FIGURE_HABBICON_SPIN_OFFSET, offset);
            }
        }

        function clearHabbiconSpin(model:IRoomObjectModelController)
        {
            this._habbiconSpinStartTimeStamp = 0;
            this._habbiconSpinEndTimeStamp = 0;
            this.setHabbiconSpinOffset(0, model);
        }

        function getTalkingPauseInterval():Int
        {
            return Std.int(100 + (Math.random() * 200));
        }

        function getTalkingPauseLength():Int
        {
            return Std.int(75 + (Math.random() * 75));
        }

        function getBlinkInterval():Int
        {
            return Std.int(4500 + (Math.random() * 1000));
        }

        function getBlinkLength():Int
        {
            return Std.int(50 + (Math.random() * 200));
        }

        override function getCurveStrength(k:RoomObjectMoveUpdateMessage):Float
        {
            if (((k == null) || (object == null)))
            {
                return super.getCurveStrength(k);
            }
            if (Std.is(k , RoomObjectAvatarUpdateMessage))
            {
                return Std.downcast(k , RoomObjectAvatarUpdateMessage).jumpingPower;
            }
            var _local_2= object.getModelController();
            if (_local_2.hasNumber(RoomObjectVariableEnum.FIGURE_JUMPING_POWER))
            {
                return _local_2.getNumber(RoomObjectVariableEnum.FIGURE_JUMPING_POWER);
            }
            return super.getCurveStrength(k);
        }

        function targetIsWarping(k:IVector3d):Bool
        {
            var _local_2= object.getLocation();
            if (k == null)
            {
                return false;
            }
            if (((_local_2.x == 0) && (_local_2.y == 0)))
            {
                return false;
            }
            if (((Math.abs((_local_2.x - k.x)) > WARP_WARN_THRESHOLD) || (Math.abs((_local_2.y - k.y)) > WARP_WARN_THRESHOLD)))
            {
                return true;
            }
            return false;
        }
    }

