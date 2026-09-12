package com.sulake.habbo.room.object.logic
;
    import com.sulake.habbo.room.events.RoomObjectMoveEvent;
    import com.sulake.room.object.logic.ObjectLogicBase;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.habbo.room.messages.RoomObjectMoveUpdateMessage;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class MovingObjectLogic extends ObjectLogicBase
    {
        public static inline final DEFAULT_UPDATE_INTERVAL= 500;
        static var helper_vector:Vector3d = new Vector3d();

        var _locDelta:Vector3d;
        var _loc:Vector3d;
        var _liftAmount:Float = 0;
        var _lastUpdateTime:Int = 0;
        var _changeTime:Int = 0;
        var _updateInterval:Int = 500;
        var _overshootTime:Float = 0;
        var _curveStrength:Float = 0;

        public function new()
        {
            this._locDelta = new Vector3d();
            this._loc = new Vector3d();
            super();
        }

        var lastUpdateTime(get,never):Int;
function  get_lastUpdateTime():Int
        {
            return this._lastUpdateTime;
        }

        override public function dispose()
        {
            super.dispose();
            this._loc = null;
            this._locDelta = null;
        }

        override public function  set_object(k:IRoomObjectController):IRoomObjectController        {
            super.object = k;
            if (k != null)
            {
                this._loc.assign(k.getLocation());
            }
return k;
        }

        var moveUpdateInterval(never,set):Int;
function  set_moveUpdateInterval(k:Int):Int        {
            if (k <= 0)
            {
                k = 1;
            }
            return this._updateInterval = k;
        }

        function setMoveUpdateInterval(k:Int, _arg_2:Float=0, _arg_3:Float=0)
        {
            if (k <= 0)
            {
                k = 1;
            }
            this._updateInterval = k;
            if (((!Math.isNaN(_arg_2)) && (_arg_2 == 0)))
            {
                _arg_2 = Math.NaN;
            }
            this._overshootTime = _arg_2;
            if (((!Math.isNaN(_arg_3)) && (_arg_3 == 0)))
            {
                _arg_3 = Math.NaN;
            }
            this._curveStrength = _arg_3;
        }

        function getCurveStrength(k:RoomObjectMoveUpdateMessage):Float
        {
            return k.curveStrength;
        }

        function calculateCurveOffset(k:Int, _arg_2:Int):Float
        {
            if ((Math.isNaN(this._curveStrength) || (this._curveStrength == 0)))
            {
                return 0;
            }
            return (((4 * (((this._curveStrength / 100) * (this._locDelta.length / 4)) / (_arg_2 * _arg_2))) * k) * (_arg_2 - k));
        }

        function fixDeltaAndIntervalForOvershooting()
        {
            var _local_1 = Math.NaN;
            if (((!Math.isNaN(this._overshootTime)) && (!(this._overshootTime == 0))) && (!(this._updateInterval == 0)))
            {
                _local_1 = this._locDelta.z;
                this._locDelta.mul(((this._updateInterval + this._overshootTime) / this._updateInterval));
                this._locDelta.z = _local_1;
                this._updateInterval = Std.int(this._updateInterval + this._overshootTime);
            }
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_3:IVector3d = null;
            var _local_4 = 0;
            if (k == null)
            {
                return;
            }
            super.processUpdateMessage(k);
            var _local_2= Std.downcast(k , RoomObjectMoveUpdateMessage);
            if (((_local_2 != null) && _local_2.skipPositionUpdate))
            {
                return;
            }
            if (k.loc != null)
            {
                this._loc.assign(k.loc);
                this._locDelta.x = 0;
                this._locDelta.y = 0;
                this._locDelta.z = 0;
            }
            if (_local_2 == null)
            {
                return;
            }
            if (object != null)
            {
                if (k.loc != null)
                {
                    _local_3 = _local_2._Str_7569;
                    _local_4 = Std.int((Math.isNaN(_local_2.animationTime) ? 500 : _local_2.animationTime));
                    this.setMoveUpdateInterval(_local_4, _local_2.overshootAnimationTime, this.getCurveStrength(_local_2));
                    this._changeTime = ((this._lastUpdateTime > 0) ? this._lastUpdateTime : flash.Lib.getTimer());
                    this._locDelta.assign(_local_3);
                    this._locDelta.sub(this._loc);
                    this.fixDeltaAndIntervalForOvershooting();
                }
            }
        }

        function getLocationOffset():IVector3d
        {
            return null;
        }

        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectMoveEvent.ROME_SLIDE_ANIMATION];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function update(k:Int)
        {
            var _local_4 = 0;
            var _local_5:RoomObjectEvent = null;
            var _local_2= this.getLocationOffset();
            var _local_3= object.getModelController();
            if (_local_3 != null)
            {
                if (_local_2 != null)
                {
                    if (this._liftAmount != _local_2.z)
                    {
                        this._liftAmount = _local_2.z;
                        _local_3.setNumber(RoomObjectVariableEnum.FURNITURE_LIFT_AMOUNT, this._liftAmount);
                    }
                }
                else
                {
                    if (this._liftAmount != 0)
                    {
                        this._liftAmount = 0;
                        _local_3.setNumber(RoomObjectVariableEnum.FURNITURE_LIFT_AMOUNT, this._liftAmount);
                    }
                }
            }
            if (((this._locDelta.length > 0) || (!(_local_2 == null))))
            {
                _local_4 = (k - this._changeTime);
                if (_local_4 == (this._updateInterval >> 1))
                {
                    _local_4++;
                }
                if (_local_4 > this._updateInterval)
                {
                    _local_4 = this._updateInterval;
                }
                if (this._locDelta.length > 0)
                {
                    helper_vector.assign(this._locDelta);
                    helper_vector.mul((_local_4 / this._updateInterval));
                    helper_vector.add(this._loc);
                }
                else
                {
                    helper_vector.assign(this._loc);
                }
                if (_local_2 != null)
                {
                    helper_vector.add(_local_2);
                }
                if (((!Math.isNaN(this._curveStrength)) && (!(this._curveStrength == 0))))
                {
                    helper_vector.z = (helper_vector.z + this.calculateCurveOffset(_local_4, this._updateInterval));
                }
                if (object != null)
                {
                    object.setLocation(helper_vector);
                }
                if (_local_4 == this._updateInterval)
                {
                    this._locDelta.x = 0;
                    this._locDelta.y = 0;
                    this._locDelta.z = 0;
                }
                _local_5 = new RoomObjectMoveEvent(RoomObjectMoveEvent.ROME_SLIDE_ANIMATION, object);
                eventDispatcher.dispatchEvent(_local_5);
            }
            this._lastUpdateTime = k;
        }
    }

