package com.sulake.room.object
;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.object.visualization.IRoomObjectVisualization;
    import com.sulake.room.object.logic.IRoomObjectEventHandler;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.object.logic.IRoomObjectMouseHandler;
    import com.sulake.room.utils.*;

     class RoomObject implements IRoomObjectController 
    {
        static var _globalInstanceId:Int = 0;

        var _id:Int = 0;
        var _type:String = "";
        var _loc:Vector3d;
        var _dir:Vector3d;
        var _locVisible:Vector3d;
        var _dirVisible:Vector3d;
        var _stateList:Array<ASAny>;
        var _roomObjectModel:RoomObjectModel;
        var _visualization:IRoomObjectVisualization;
        var _roomObjectLogic:IRoomObjectEventHandler;
        var _updateID:Int = 0;
        var _instanceId:Int = 0;
        var _isInitialized:Bool = false;

        public function new(k:Int, _arg_2:Int, _arg_3:String)
        {
            this._id = k;
            this._loc = new Vector3d();
            this._dir = new Vector3d();
            this._locVisible = new Vector3d();
            this._dirVisible = new Vector3d();
            this._stateList = ASCompat.allocArray(_arg_2);
            var _local_4:Float = (_arg_2 - 1);
            while (_local_4 >= 0)
            {
                this._stateList[Std.int(_local_4)] = 0;
                _local_4--;
            }
            this._type = _arg_3;
            this._roomObjectModel = new RoomObjectModel();
            this._visualization = null;
            this._roomObjectLogic = null;
            this._updateID = 0;
            this._instanceId = _globalInstanceId++;
        }

        public function dispose()
        {
            this._loc = null;
            this._dir = null;
            this._stateList = null;
            this.setVisualization(null);
            this.setEventHandler(null);
            if (this._roomObjectModel != null)
            {
                this._roomObjectModel.dispose();
                this._roomObjectModel = null;
            }
        }

        public function setInitialized(k:Bool)
        {
            this._isInitialized = k;
        }

        public function isInitialized():Bool
        {
            return this._isInitialized;
        }

        public function getId():Int
        {
            return this._id;
        }

        public function getInstanceId():Int
        {
            return this._instanceId;
        }

        public function getType():String
        {
            return this._type;
        }

        public function getLocation():IVector3d
        {
            this._locVisible.assign(this._loc);
            return this._locVisible;
        }

        public function getDirection():IVector3d
        {
            this._dirVisible.assign(this._dir);
            return this._dirVisible;
        }

        public function getModel():IRoomObjectModel
        {
            return this._roomObjectModel;
        }

        public function getModelController():IRoomObjectModelController
        {
            return this._roomObjectModel;
        }

        public function getState(k:Int):Int
        {
            if (((k >= 0) && (k < this._stateList.length)))
            {
                return ASCompat.toInt(this._stateList[k]);
            }
            return -1;
        }

        public function getVisualization():IRoomObjectVisualization
        {
            return this._visualization;
        }

        public function setLocation(k:IVector3d)
        {
            if (k == null)
            {
                return;
            }
            if ((((!(this._loc.x == k.x)) || (!(this._loc.y == k.y))) || (!(this._loc.z == k.z))))
            {
                this._loc.x = k.x;
                this._loc.y = k.y;
                this._loc.z = k.z;
                this._updateID++;
            }
        }

        public function setDirection(k:IVector3d)
        {
            if (k == null)
            {
                return;
            }
            if ((((!(this._dir.x == k.x)) || (!(this._dir.y == k.y))) || (!(this._dir.z == k.z))))
            {
                this._dir.x = (((k.x % 360) + 360) % 360);
                this._dir.y = (((k.y % 360) + 360) % 360);
                this._dir.z = (((k.z % 360) + 360) % 360);
                this._updateID++;
            }
        }

        public function setState(k:Int, _arg_2:Int):Bool
        {
            if (((_arg_2 >= 0) && (_arg_2 < this._stateList.length)))
            {
                if (this._stateList[_arg_2] != k)
                {
                    this._stateList[_arg_2] = k;
                    this._updateID++;
                }
                return true;
            }
            return false;
        }

        public function setVisualization(k:IRoomObjectVisualization)
        {
            if (k != this._visualization)
            {
                if (this._visualization != null)
                {
                    this._visualization.dispose();
                }
                this._visualization = k;
                if (this._visualization != null)
                {
                    this._visualization.object = this;
                }
            }
        }

        public function setEventHandler(k:IRoomObjectEventHandler)
        {
            if (k == this._roomObjectLogic)
            {
                return;
            }
            var _local_2= this._roomObjectLogic;
            if (_local_2 != null)
            {
                this._roomObjectLogic = null;
                _local_2.object = null;
            }
            this._roomObjectLogic = k;
            if (this._roomObjectLogic != null)
            {
                this._roomObjectLogic.object = this;
            }
        }

        public function getEventHandler():IRoomObjectEventHandler
        {
            return this._roomObjectLogic;
        }

        public function getUpdateID():Int
        {
            return this._updateID;
        }

        public function getMouseHandler():IRoomObjectMouseHandler
        {
            return this.getEventHandler();
        }

        public function tearDown()
        {
            if (this._roomObjectLogic != null)
            {
                this._roomObjectLogic.tearDown();
            }
        }
    }

