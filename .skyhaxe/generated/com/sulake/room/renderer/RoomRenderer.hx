package com.sulake.room.renderer
;
    import com.sulake.core.utils.Map;
    import com.sulake.core.runtime.Component;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.room.utils.RoomGeometry;

     class RoomRenderer implements IRoomRenderer implements  IRoomSpriteCanvasContainer 
    {
        var _objects:Map;
        var _canvases:Map;
        var _component:Component;
        var _disposed:Bool = false;
        var _roomObjectVariableAccurateZ:String = null;

        public function new(k:Component)
        {
            this._objects = new Map();
            this._canvases = new Map();
            if (k != null)
            {
                this._component = k;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var roomObjectVariableAccurateZ(get,set):String;
public function  get_roomObjectVariableAccurateZ():String
        {
            return this._roomObjectVariableAccurateZ;
        }
public function  set_roomObjectVariableAccurateZ(k:String):String        {
            return this._roomObjectVariableAccurateZ = k;
        }

        public function dispose()
        {
            var k = 0;
            var _local_2:RoomSpriteCanvas = null;
            if (this.disposed)
            {
                return;
            }
            if (this._canvases != null)
            {
                k = 0;
                while ((k : UInt) < this._canvases.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._canvases.getWithIndex(k) , RoomSpriteCanvas);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._canvases.dispose();
                this._canvases = null;
            }
            if (this._objects != null)
            {
                this._objects.dispose();
                this._objects = null;
            }
            if (this._component != null)
            {
                this._component = null;
            }
            this._disposed = true;
        }

        public function reset()
        {
            this._objects.reset();
        }

        public function getRoomObjectIdentifier(k:IRoomObject):String
        {
            if (k != null)
            {
                return Std.string(k.getInstanceId());
            }
            return null;
        }

        public function feedRoomObject(k:IRoomObject)
        {
            if (k == null)
            {
                return;
            }
            this._objects.add(this.getRoomObjectIdentifier(k), k);
        }

        public function removeRoomObject(k:IRoomObject)
        {
            var _local_4:RoomSpriteCanvas = null;
            var _local_2= this.getRoomObjectIdentifier(k);
            this._objects.remove(_local_2);
            var _local_3 = 0;
            while ((_local_3 : UInt) < this._canvases.length)
            {
                _local_4 = ASCompat.dynamicAs(this._canvases.getWithIndex(_local_3) , RoomSpriteCanvas);
                if (_local_4 != null)
                {
                    _local_4._Str_17192(_local_2);
                }
                _local_3++;
            }
        }

        public function getRoomObject(k:String):IRoomObject
        {
            return ASCompat.dynamicAs(this._objects.getValue(k) , IRoomObject);
        }

        public function getRoomObjectWithIndex(k:Int):IRoomObject
        {
            return ASCompat.dynamicAs(this._objects.getWithIndex(k) , IRoomObject);
        }

        public function getRoomObjectIdWithIndex(k:Int):String
        {
            return ASCompat.asString(this._objects.getKey(k) );
        }

        public function getRoomObjectCount():Int
        {
            return ASCompat.toInt(this._objects.length);
        }

        public function render()
        {
            var _local_3:IRoomRenderingCanvas = null;
            var k= flash.Lib.getTimer();
            ErrorReportStorage.addDebugData("Canvas count", ("Canvas count: " + Std.string(this._canvases.length)));
            var _local_2= ASCompat.toInt(this._canvases.length - 1);
            while (_local_2 >= 0)
            {
                _local_3 = ASCompat.dynamicAs(this._canvases.getWithIndex(_local_2) , IRoomRenderingCanvas);
                if (_local_3 != null)
                {
                    _local_3.render(k);
                }
                _local_2--;
            }
        }

        public function createCanvas(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int):IRoomRenderingCanvas
        {
            var _local_6:RoomGeometry = null;
            var _local_5= ASCompat.dynamicAs(this._canvases.getValue(Std.string(k)) , IRoomRenderingCanvas);
            if (_local_5 != null)
            {
                _local_5.initialize(_arg_2, _arg_3);
                _local_6 = Std.downcast(_local_5.geometry , RoomGeometry);
                if (_local_6 != null)
                {
                    _local_6.scale = _arg_4;
                }
                return _local_5;
            }
            _local_5 = this.createCanvasInstance(k, _arg_2, _arg_3, _arg_4);
            this._canvases.add(Std.string(k), _local_5);
            return _local_5;
        }

        function createCanvasInstance(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int):IRoomRenderingCanvas
        {
            return new RoomSpriteCanvas(this, k, _arg_2, _arg_3, _arg_4);
        }

        public function getCanvas(k:Int):IRoomRenderingCanvas
        {
            var _local_2= ASCompat.dynamicAs(this._canvases.getValue(Std.string(k)) , IRoomRenderingCanvas);
            return _local_2;
        }

        public function disposeCanvas(k:Int):Bool
        {
            var _local_2= ASCompat.dynamicAs(this._canvases.remove(Std.string(k)) , RoomSpriteCanvas);
            if (_local_2 != null)
            {
                _local_2.dispose();
            }
            return false;
        }

        public function update(k:UInt)
        {
            var _local_3:RoomSpriteCanvas = null;
            this.render();
            var _local_2= ASCompat.toInt(this._canvases.length - 1);
            while (_local_2 >= 0)
            {
                _local_3 = ASCompat.dynamicAs(this._canvases.getWithIndex(_local_2) , RoomSpriteCanvas);
                if (_local_3 != null)
                {
                    _local_3.update();
                }
                _local_2--;
            }
        }
    }

