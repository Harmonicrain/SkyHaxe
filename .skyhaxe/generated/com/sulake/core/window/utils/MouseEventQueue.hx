package com.sulake.core.window.utils
;
    import flash.geom.Point;
    import flash.events.MouseEvent;
    import flash.events.IEventDispatcher;

     class MouseEventQueue extends GenericEventQueue 
    {
        var _Str_15049:Point;

        public function new(k:IEventDispatcher)
        {
            super(k);
            this._Str_15049 = new Point();
            _eventDispatcher.addEventListener(MouseEvent.CLICK, this._Str_4614, false);
            _eventDispatcher.addEventListener(MouseEvent.DOUBLE_CLICK, this._Str_4614, false);
            _eventDispatcher.addEventListener(MouseEvent.MOUSE_DOWN, this._Str_4614, false);
            _eventDispatcher.addEventListener(MouseEvent.MOUSE_MOVE, this._Str_4614, false);
            _eventDispatcher.addEventListener(MouseEvent.MOUSE_UP, this._Str_4614, false);
            _eventDispatcher.addEventListener(MouseEvent.MOUSE_WHEEL, this._Str_4614, false);
        }

        public var _Str_26151(get,never):Point;
public function  get__Str_26151():Point
        {
            return this._Str_15049;
        }

        override public function dispose()
        {
            if (!_disposed)
            {
                _eventDispatcher.removeEventListener(MouseEvent.CLICK, this._Str_4614, false);
                _eventDispatcher.removeEventListener(MouseEvent.DOUBLE_CLICK, this._Str_4614, false);
                _eventDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, this._Str_4614, false);
                _eventDispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, this._Str_4614, false);
                _eventDispatcher.removeEventListener(MouseEvent.MOUSE_UP, this._Str_4614, false);
                _eventDispatcher.removeEventListener(MouseEvent.MOUSE_WHEEL, this._Str_4614, false);
                super.dispose();
            }
        }

        function _Str_4614(k:MouseEvent)
        {
            this._Str_15049.x = k.stageX;
            this._Str_15049.y = k.stageY;
            _Str_4751.push(k);
        }
    }

