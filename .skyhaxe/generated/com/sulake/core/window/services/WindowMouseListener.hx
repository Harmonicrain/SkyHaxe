package com.sulake.core.window.services
;
    import com.sulake.core.window._enum.MouseListenerType;
    import flash.display.DisplayObject;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.geom.Point;
    import flash.events.Event;

     class WindowMouseListener extends WindowMouseOperator implements IMouseListenerService 
    {
        var _eventTypes:Array<ASAny>;
        var _areaLimit:UInt = 0;

        public function new(k:DisplayObject)
        {
            this._eventTypes = new Array<ASAny>();
            this._areaLimit = MouseListenerType.EVENT_INSIDE_STAGE;
            super(k);
        }

        public var eventTypes(get,never):Array<ASAny>;
public function  get_eventTypes():Array<ASAny>
        {
            return this._eventTypes;
        }

        
        public var _Str_14321(get,set):UInt;
public function  get__Str_14321():UInt
        {
            return this._areaLimit;
        }
public function  set__Str_14321(k:UInt):UInt        {
            return this._areaLimit = k;
        }

        override public function end(k:IWindow):IWindow
        {
            var _local_2= this._eventTypes.length;
            while (_local_2 > 0)
            {
                this._eventTypes.pop();
                _local_2--;
            }
            return super.end(k);
        }

        override function handler(k:Event)
        {
            var _local_2 = false;
            if ((_Str_5527 && (!window.disposed)))
            {
                if (this._eventTypes.indexOf(k.type) >= 0)
                {
                    if (Std.is(k , WindowMouseEvent))
                    {
                        _local_2 = window.hitTestGlobalPoint(window.desktop.getDisplayObject().globalToLocal(new Point(cast(k, WindowMouseEvent).stageX, cast(k, WindowMouseEvent).stageY)));
                        if (((this._areaLimit == MouseListenerType.EVENTS_INSIDE_WINDOW) && (!_local_2)))
                        {
                            return;
                        }
                        if (((this._areaLimit == MouseListenerType.EVENTS_OUTSIDE_WINDOW) && _local_2))
                        {
                            return;
                        }
                    }
                    window.update(null, cast(k, WindowMouseEvent));
                }
            }
        }

        override public function operate(k:Int, _arg_2:Int)
        {
        }
    }

