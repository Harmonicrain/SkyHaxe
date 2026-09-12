package com.sulake.habbo.android
;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.habbo.utils.HabboWebTools;
    import flash.display.Stage;
    import flash.events.GesturePhase;
    import flash.events.TransformGestureEvent;
    import flash.geom.Point;

     final class AndroidRoomGestureController
    {
        static inline final ZOOM_THRESHOLD= 1.15;

        var _canvas:IDisplayObjectWrapper;
        var _stage:Stage;
        var _zoomHandler:ASFunction;
        var _pinchScale:Float = 1;

        public static function create(canvas:IDisplayObjectWrapper, zoomHandler:ASFunction):AndroidRoomGestureController
        {
            var controller:AndroidRoomGestureController = null;
            if (!HabboWebTools.isAirMobile)
            {
                return null;
            }
            controller = new AndroidRoomGestureController(zoomHandler);
            if (!controller.attach(canvas))
            {
                controller.dispose();
                return null;
            }
            return controller;
        }

        public function new(zoomHandler:ASFunction)
        {
            this._zoomHandler = zoomHandler;
        }

        public function attach(canvas:IDisplayObjectWrapper):Bool
        {
            this.disposeStageListener();
            this._canvas = canvas;
            if (((this._canvas == null) || (this._canvas.getDisplayObject() == null)) || (this._canvas.getDisplayObject().stage == null))
            {
                return false;
            }
            this._stage = this._canvas.getDisplayObject().stage;
            this._stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, (this.onPinchZoom : ASAny), true, 0, true);
            return true;
        }

        public function dispose()
        {
            this.disposeStageListener();
            this._canvas = null;
            this._zoomHandler = null;
            this._pinchScale = 1;
        }

        function disposeStageListener()
        {
            if (this._stage != null)
            {
                this._stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, (this.onPinchZoom : ASAny), true);
                this._stage = null;
            }
        }

        function onPinchZoom(event:TransformGestureEvent)
        {
var stagePoint:Point  = null;            var eventScale = Math.NaN;
            var direction = 0;
            var origin:Point = null;
            if (((this._canvas == null) || (this._zoomHandler == null)) || (this._canvas.getDisplayObject() == null))
            {
                return;
            }
            if (event.phase == GesturePhase.BEGIN)
            {
                this._pinchScale = 1;
                return;
            }
            if (event.phase == GesturePhase.END)
            {
                if (this._pinchScale >= ZOOM_THRESHOLD)
                {
                    direction = 1;
                }
                else if (this._pinchScale <= (1 / ZOOM_THRESHOLD))
                {
                    direction = -1;
                }
            }
            else
            {
                eventScale = ((Math.abs((event.scaleX - 1)) >= Math.abs((event.scaleY - 1))) ? event.scaleX : event.scaleY);
                if ((Math.isNaN(eventScale) || (eventScale <= 0)))
                {
                    return;
                }
                this._pinchScale = (this._pinchScale * eventScale);
            }
            if (direction != 0)
            {
                origin = new Point();
                this._canvas.getGlobalPosition(origin);
stagePoint= this._canvas.desktop.getDisplayObject().globalToLocal(new Point(event.stageX, event.stageY));
                origin.x = (stagePoint.x - origin.x);
                origin.y = (stagePoint.y - origin.y);
                this._zoomHandler(direction, origin);
            }
            if (event.phase == GesturePhase.END)
            {
                this._pinchScale = 1;
            }
            if (event.cancelable)
            {
                event.preventDefault();
            }
            event.stopPropagation();
        }
    }

