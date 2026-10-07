package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.graphics.GraphicContext;
    import com.sulake.core.window.graphics.IGraphicContext;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import com.sulake.core.window.events.WindowEvent;

     class DesktopController extends ActivatorController implements IDesktopWindow implements  IDisplayObjectWrapper 
    {
        public function new(k:String, _arg_2:WindowContext, _arg_3:Rectangle)
        {
            super(k, 0, 0, 0, _arg_2, _arg_3, null, this._Str_19694, null, null, 0);
        }

        public var mouseX(get,never):Int;
public function  get_mouseX():Int
        {
            return Std.int(this.getDisplayObject().globalToLocal(new Point(this.getDisplayObject().stage.mouseX, this.getDisplayObject().stage.mouseY)).x);
        }

        public var mouseY(get,never):Int;
public function  get_mouseY():Int
        {
            return Std.int(this.getDisplayObject().globalToLocal(new Point(this.getDisplayObject().stage.mouseX, this.getDisplayObject().stage.mouseY)).y);
        }

        override public function  set_parent(k:IWindow):IWindow        {
            throw new ASError("Desktop window doesn't have parent!");
return k;
        }

        override public function  set_procedure(k:ASFunction):ASFunction        {
            _procedure = ((k != null) ? k : this._Str_19694);
return k;
        }

        override public function  get_host():IWindow
        {
            return this;
        }

        override public function  get_desktop():IDesktopWindow
        {
            return this;
        }

        override public function getGraphicContext(k:Bool):IGraphicContext
        {
            if ((k && (!(_graphics != null))))
            {
                _graphics = new GraphicContext((("GC {" + _name) + "}"), GraphicContext.GC_TYPE_DESKTOP, rectangle);
                cast(_graphics, GraphicContext).mouseEnabled = true;
                cast(_graphics, GraphicContext).doubleClickEnabled = true;
            }
            return _graphics;
        }

        public function getActiveWindow():IWindow
        {
            return getActiveChild();
        }

        public function setActiveWindow(k:IWindow):IWindow
        {
            return setActiveChild(k);
        }

        public function getDisplayObject():DisplayObject
        {
            return ASCompat.reinterpretAs(this.getGraphicContext(true) , DisplayObject);
        }

        public function setDisplayObject(k:DisplayObject)
        {
            this.getGraphicContext(true).setDisplayObject(k);
        }

        override public function invalidate(k:Rectangle=null)
        {
        }

        function _Str_19694(k:WindowEvent, _arg_2:IWindow)
        {
        }
    }

