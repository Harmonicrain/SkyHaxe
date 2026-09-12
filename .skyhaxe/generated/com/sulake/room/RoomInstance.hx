package com.sulake.room
;
    import com.sulake.core.utils.Map;
    import com.sulake.room.renderer.IRoomRendererBase;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.room.object.logic.IRoomObjectEventHandler;
    import com.sulake.room.object.IRoomObject;

     class RoomInstance implements IRoomInstance 
    {
        var _numberDataList:ASDictionary<ASAny,ASAny>;
        var _stringDataList:ASDictionary<ASAny,ASAny>;
        var _numberReadOnlyList:Array<ASAny>;
        var _stringReadOnlyList:Array<ASAny>;
        var _managers:Map;
        var _updateCategories:Array<ASAny>;
        var _renderer:IRoomRendererBase;
        var _container:IRoomInstanceContainer;
        var _id:String;

        public function new(k:String, _arg_2:IRoomInstanceContainer)
        {
            this._managers = new Map();
            this._updateCategories = [];
            this._container = _arg_2;
            this._id = k;
            this._numberDataList = new ASDictionary<ASAny,ASAny>();
            this._stringDataList = new ASDictionary<ASAny,ASAny>();
            this._numberReadOnlyList = [];
            this._stringReadOnlyList = [];
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        public function dispose()
        {
var k:String  = null;            var k:String = null;
            var _local_2 = 0;
            var _local_3:IRoomObjectManager = null;
            if (this._managers != null)
            {
                _local_2 = 0;
                while ((_local_2 : UInt) < this._managers.length)
                {
                    _local_3 = ASCompat.dynamicAs(this._managers.getWithIndex(_local_2) , IRoomObjectManager);
                    if (_local_3 != null)
                    {
                        _local_3.dispose();
                    }
                    _local_2++;
                }
                this._managers.dispose();
                this._managers = null;
            }
            if (this._renderer != null)
            {
                this._renderer.dispose();
                this._renderer = null;
            }
            this._container = null;
            this._updateCategories = null;
            if (this._numberDataList != null)
            {
                final _iter_ = this._numberDataList; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
k = _tmp_;
                    this._numberDataList.remove(k);
                }
                this._numberDataList = null;
            }
            if (this._stringDataList != null)
            {
                final _iter_ = this._stringDataList; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
k = _tmp_;
                    this._stringDataList.remove(k);
                }
                this._stringDataList = null;
            }
            this._stringReadOnlyList = [];
            this._numberReadOnlyList = [];
        }

        public function getNumber(k:String):Float
        {
            return ASCompat.toNumber(this._numberDataList[k]);
        }

        public function setNumber(k:String, _arg_2:Float, _arg_3:Bool=false)
        {
            if (this._numberReadOnlyList.indexOf(k) >= 0)
            {
                return;
            }
            if (_arg_3)
            {
                this._numberReadOnlyList.push(k);
            }
            if (this._numberDataList[k] != _arg_2)
            {
                this._numberDataList[k] = _arg_2;
            }
        }

        public function getString(k:String):String
        {
            return this._stringDataList[k];
        }

        public function setString(k:String, _arg_2:String, _arg_3:Bool=false)
        {
            if (this._stringReadOnlyList.indexOf(k) >= 0)
            {
                return;
            }
            if (_arg_3)
            {
                this._stringReadOnlyList.push(k);
            }
            if (this._stringDataList[k] != _arg_2)
            {
                this._stringDataList[k] = _arg_2;
            }
        }

        public function addObjectUpdateCategory(k:Int)
        {
            var _local_2= this._updateCategories.indexOf(k);
            if (_local_2 >= 0)
            {
                return;
            }
            this._updateCategories.push(k);
        }

        public function removeObjectUpdateCategory(k:Int)
        {
            var _local_2= this._updateCategories.indexOf(k);
            if (_local_2 >= 0)
            {
                this._updateCategories.splice(_local_2, 1);
            }
        }

        public function update()
        {
            var _local_3 = 0;
            var _local_4:IRoomObjectManager = null;
            var _local_5 = 0;
            var _local_6:IRoomObjectController = null;
            var _local_7:IRoomObjectEventHandler = null;
            var k= flash.Lib.getTimer();
            var _local_2= (this._updateCategories.length - 1);
            while (_local_2 >= 0)
            {
                _local_3 = ASCompat.toInt(this._updateCategories[_local_2]);
                _local_4 = this.getObjectManager(_local_3);
                if (_local_4 != null)
                {
                    _local_5 = (_local_4.getObjectCount() - 1);
                    while (_local_5 >= 0)
                    {
                        _local_6 = _local_4.getObjectWithIndex(_local_5);
                        if (_local_6 != null)
                        {
                            _local_7 = _local_6.getEventHandler();
                            if (_local_7 != null)
                            {
                                _local_7.update(k);
                            }
                        }
                        _local_5--;
                    }
                }
                _local_2--;
            }
        }

        public function createRoomObject(k:Int, _arg_2:String, _arg_3:Int):IRoomObject
        {
            if (this._container != null)
            {
                return this._container.createRoomObject(this._id, k, _arg_2, _arg_3);
            }
            return null;
        }

        public function createObjectInternal(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int):IRoomObject
        {
            var _local_6:IRoomObjectController = null;
            var _local_5= this.createObjectManager(_arg_4);
            if (_local_5 != null)
            {
                _local_6 = _local_5.createObject(k, _arg_2, _arg_3);
                if (this._renderer != null)
                {
                    this._renderer.feedRoomObject(_local_6);
                }
                return _local_6;
            }
            return null;
        }

        public function getObject(k:Int, _arg_2:Int):IRoomObject
        {
            var _local_3= this.getObjectManager(_arg_2);
            if (_local_3 != null)
            {
                return _local_3.getObject(k);
            }
            return null;
        }

        public function getObjects(k:Int):Array<ASAny>
        {
            var _local_2= this.getObjectManager(k);
            return (_local_2 != null) ? _local_2.getObjects() : [];
        }

        public function getObjectWithIndex(k:Int, _arg_2:Int):IRoomObject
        {
            var _local_3= this.getObjectManager(_arg_2);
            if (_local_3 != null)
            {
                return _local_3.getObjectWithIndex(k);
            }
            return null;
        }

        public function getObjectCount(k:Int):Int
        {
            var _local_2= this.getObjectManager(k);
            if (_local_2 != null)
            {
                return _local_2.getObjectCount();
            }
            return 0;
        }

        public function getObjectWithIndexAndType(k:Int, _arg_2:String, _arg_3:Int):IRoomObject
        {
            var _local_4= this.getObjectManager(_arg_3);
            if (_local_4 != null)
            {
                return _local_4.getObjectWithIndexAndType(k, _arg_2);
            }
            return null;
        }

        public function getObjectCountForType(k:String, _arg_2:Int):Int
        {
            var _local_3= this.getObjectManager(_arg_2);
            if (_local_3 != null)
            {
                return _local_3.getObjectCountForType(k);
            }
            return 0;
        }

        public function disposeObject(k:Int, _arg_2:Int):Bool
        {
            var _local_4:IRoomObject = null;
            var _local_3= this.getObjectManager(_arg_2);
            if (_local_3 != null)
            {
                _local_4 = _local_3.getObject(k);
                if (_local_4 != null)
                {
                    _local_4.tearDown();
                    if (this._renderer != null)
                    {
                        this._renderer.removeRoomObject(_local_4);
                    }
                    return _local_3.disposeObject(k);
                }
            }
            return false;
        }

        public function disposeObjects(k:Int):Int
        {
            var _local_4 = 0;
            var _local_5:IRoomObjectController = null;
            var _local_2 = 0;
            var _local_3= this.getObjectManager(k);
            if (_local_3 != null)
            {
                _local_2 = _local_3.getObjectCount();
                _local_4 = 0;
                while (_local_4 < _local_2)
                {
                    _local_5 = _local_3.getObjectWithIndex(_local_4) ;
                    if (_local_5 != null)
                    {
                        if (this._renderer != null)
                        {
                            this._renderer.removeRoomObject(_local_5);
                        }
                        _local_5.dispose();
                    }
                    _local_4++;
                }
                _local_3.reset();
            }
            return _local_2;
        }

        public function setRenderer(k:IRoomRendererBase)
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:IRoomObjectController = null;
            if (k == this._renderer)
            {
                return;
            }
            if (this._renderer != null)
            {
                this._renderer.dispose();
            }
            this._renderer = k;
            if (this._renderer == null)
            {
                return;
            }
            this._renderer.reset();
            var _local_2= this.getObjectManagerIds();
            var _local_3= (_local_2.length - 1);
            while (_local_3 >= 0)
            {
                _local_4 = ASCompat.toInt(_local_2[_local_3]);
                _local_5 = this.getObjectCount(_local_4);
                _local_6 = (_local_5 - 1);
                while (_local_6 >= 0)
                {
                    _local_7 = Std.downcast(this.getObjectWithIndex(_local_6, _local_4) , IRoomObjectController);
                    if (_local_7 != null)
                    {
                        this._renderer.feedRoomObject(_local_7);
                    }
                    _local_6--;
                }
                _local_3--;
            }
        }

        public function getRenderer():IRoomRendererBase
        {
            return this._renderer;
        }

        public function getObjectManagerIds():Array<ASAny>
        {
            return this._managers.getKeys();
        }

        function createObjectManager(k:Int):IRoomObjectManager
        {
            var _local_2= Std.string(k);
            if (this._managers.getValue(_local_2) != null)
            {
                return ASCompat.dynamicAs(this._managers.getValue(_local_2) , IRoomObjectManager);
            }
            if (this._container == null)
            {
                return null;
            }
            var _local_3= this._container.createRoomObjectManager();
            if (_local_3 != null)
            {
                this._managers.add(_local_2, _local_3);
            }
            return _local_3;
        }

        function getObjectManager(k:Int):IRoomObjectManager
        {
            return ASCompat.dynamicAs(this._managers.getValue(Std.string(k)) , IRoomObjectManager);
        }

        function disposeObjectManager(k:Int):Bool
        {
            var _local_3:IRoomObjectManager = null;
            var _local_2= Std.string(k);
            this.disposeObjects(k);
            if (this._managers.getValue(_local_2) != null)
            {
                _local_3 = ASCompat.dynamicAs(this._managers.remove(_local_2) , IRoomObjectManager);
                if (_local_3 != null)
                {
                    _local_3.dispose();
                }
                return true;
            }
            return false;
        }

        public function hasUninitializedObjects():Bool
        {
            var k:RoomObjectManager = null;
            var _local_2 = 0;
            var _local_3 = 0;
            final _iter_ = this._managers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                _local_2 = k.getObjectCount();
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    if (!k.getObjectWithIndex(_local_3).isInitialized())
                    {
                        return true;
                    }
                    _local_3++;
                }
            }
            return false;
        }
    }


