package com.sulake.core.window.motion
;
    import com.sulake.core.window.IWindow;

     class Motion 
    {
        var _target:IWindow;
        var _running:Bool = false;
        var _complete:Bool = true;
        var _tag:String;

        public function new(k:IWindow)
        {
            this._target = k;
        }

        public var running(get,never):Bool;
public function  get_running():Bool
        {
            return (this._running && (this._target != null)) && (!this._target.disposed);
        }

        public var complete(get,never):Bool;
public function  get_complete():Bool
        {
            return this._complete;
        }

        
        public var target(get,set):IWindow;
public function  set_target(k:IWindow):IWindow        {
            return this._target = k;
        }
public function  get_target():IWindow
        {
            return this._target;
        }

        
        public var tag(get,set):String;
public function  set_tag(k:String):String        {
            return this._tag = k;
        }
public function  get_tag():String
        {
            return this._tag;
        }

        public function start()
        {
            this._running = true;
        }

        public function update(k:Float)
        {
        }

        public function stop()
        {
            this._target = null;
            this._running = false;
        }

        public function tick(k:Int)
        {
        }
    }

