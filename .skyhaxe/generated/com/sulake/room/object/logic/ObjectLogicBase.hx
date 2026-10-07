package com.sulake.room.object.logic
;
    import flash.events.IEventDispatcher;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class ObjectLogicBase implements IRoomObjectEventHandler 
    {
        var _events:IEventDispatcher;
        var _object:IRoomObjectController;

        
        public var eventDispatcher(get,set):IEventDispatcher;
public function  get_eventDispatcher():IEventDispatcher
        {
            return this._events;
        }
public function  set_eventDispatcher(k:IEventDispatcher):IEventDispatcher        {
            return this._events = k;
        }

        public function getEventTypes():Array<ASAny>
        {
            return [];
        }

        function getAllEventTypes(k:Array<ASAny>, _arg_2:Array<ASAny>):Array<ASAny>
        {
            var _local_4:String = null;
            var _local_3= k.copy();
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_4  = _tmp_;
                if (_local_3.indexOf(_local_4) < 0)
                {
                    _local_3.push(_local_4);
                }
            }
            return _local_3;
        }

        public function dispose()
        {
            this._object = null;
        }

        
        public var object(get,set):IRoomObjectController;
public function  set_object(k:IRoomObjectController):IRoomObjectController        {
            if (this._object == k)
            {
                return k;
            }
            if (this._object != null)
            {
                this._object.setEventHandler(null);
            }
            if (k == null)
            {
                this.dispose();
                this._object = null;
            }
            else
            {
                this._object = k;
                this._object.setEventHandler(this);
            }
return k;
        }
public function  get_object():IRoomObjectController
        {
            return this._object;
        }

        public function mouseEvent(k:RoomSpriteMouseEvent, _arg_2:IRoomGeometry)
        {
        }

        public function initialize(k:com.sulake.core.utils.xml.XML)
        {
        }

        public function update(k:Int)
        {
        }

        public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            if (k != null)
            {
                if (this._object != null)
                {
                    this._object.setLocation(k.loc);
                    this._object.setDirection(k.dir);
                }
            }
        }

        public function useObject()
        {
        }

        public function tearDown()
        {
        }

        public var widget(get,never):String;
public function  get_widget():String
        {
            return null;
        }

        public var contextMenu(get,never):String;
public function  get_contextMenu():String
        {
            return null;
        }

	public function new() {}
    }

