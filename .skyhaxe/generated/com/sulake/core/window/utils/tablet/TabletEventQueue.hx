package com.sulake.core.window.utils.tablet
;
    import com.sulake.core.window.utils.GenericEventQueue;
    import flash.geom.Point;
    import flash.events.IEventDispatcher;

     class TabletEventQueue extends GenericEventQueue 
    {
        var _touchPosition:Point;

        public function new(eventDispatcher:IEventDispatcher)
        {
            super(eventDispatcher);
            this._touchPosition = new Point();
        }

        public var touchPosition(get,never):Point;
public function  get_touchPosition():Point
        {
            return this._touchPosition;
        }

        override public function dispose()
        {
            if (!_disposed)
            {
                super.dispose();
            }
        }
    }

