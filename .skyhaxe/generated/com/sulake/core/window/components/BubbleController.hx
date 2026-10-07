package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.Direction;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.PropertyStruct;

     class BubbleController extends FrameController implements IBubbleWindow 
    {
        static inline final _POINTER_UP= "_POINTER_UP";
        static inline final _POINTER_DOWN= "_POINTER_DOWN";
        static inline final _POINTER_LEFT= "_POINTER_LEFT";
        static inline final _POINTER_RIGHT= "_POINTER_RIGHT";

        var _direction:String = "down";
        var _pointerOffset:Int = 0;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        
        public var direction(get,set):String;
public function  get_direction():String
        {
            return this._direction;
        }
public function  set_direction(k:String):String        {
            var _local_2:IWindow = null;
            if (k != this._direction)
            {
                _local_2 = getChildByName(k);
                if (_local_2 == null)
                {
                    throw new ASError((('Invalid pointer direction: "' + k) + '"!'));
                }
                getChildByName(this._direction).visible = false;
                _local_2.visible = true;
                this._direction = k;
                this._Str_8006 = this._pointerOffset;
            }
return k;
        }

        
        public var _Str_8006(get,set):Int;
public function  get__Str_8006():Int
        {
            return this._pointerOffset;
        }
public function  set__Str_8006(k:Int):Int        {
            var _local_2= getChildByName(this._direction);
            if (_local_2 == null)
            {
                throw new ASError((('Invalid pointer direction: "' + this._direction) + '"!'));
            }
            if (((this._direction == Direction.UP) || (this._direction == Direction.DOWN)))
            {
                _local_2.x = Std.int((width / 2) + k);
            }
            else
            {
                _local_2.y = Std.int((height / 2) + k);
            }
            return this._pointerOffset = k;
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            var _local_3= super.update(k, _arg_2);
            if (this._pointerOffset != 0)
            {
                if ((k : ASAny) == (this : ASAny))
                {
                    if (_arg_2.type == WindowEvent.WINDOW_EVENT_RESIZED)
                    {
                        this._Str_8006 = this._pointerOffset;
                    }
                }
            }
            return _local_3;
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= super.properties;
            k.push(createProperty(PropertyKeys.DIRECTION, this._direction));
            k.push(createProperty(PropertyKeys.POINTER_OFFSET, this._pointerOffset));
            return k;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case PropertyKeys.DIRECTION:
                        this.direction = ASCompat.asString(_local_2.value );
                        
                    case PropertyKeys.POINTER_OFFSET:
                        this._Str_8006 = ASCompat.asInt(_local_2.value );
                        
                }
            }
            return super.properties = k;
        }
    }

