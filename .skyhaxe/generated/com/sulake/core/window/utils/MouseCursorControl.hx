package com.sulake.core.window.utils
;
    import com.sulake.core.window._enum.MouseCursorType;
    import flash.display.Stage;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;

     class MouseCursorControl 
    {
        static var _type:UInt = MouseCursorType.DEFAULT;
        static var _Str_2691:Stage;
        static var _visible:Bool = true;
        static var _disposed:Bool = false;
        static var _Str_7147:Bool = true;
        static var _Str_3522:DisplayObject;
        static var _Str_13973:ASDictionary<ASAny,ASAny> = new ASDictionary();

        public function new(k:DisplayObject)
        {
            _Str_2691 = k.stage;
        }

        public static function dispose()
        {
            if (!_disposed)
            {
                if (_Str_3522 != null)
                {
                    _Str_2691.removeChild(_Str_3522);
                    _Str_2691.removeEventListener(Event.MOUSE_LEAVE, (_Str_16609 : ASAny));
                    _Str_2691.removeEventListener(MouseEvent.MOUSE_MOVE, (_Str_3983 : ASAny));
                    _Str_2691.removeEventListener(MouseEvent.MOUSE_OVER, (_Str_3983 : ASAny));
                    _Str_2691.removeEventListener(MouseEvent.MOUSE_OUT, (_Str_3983 : ASAny));
                }
                _disposed = true;
            }
        }

        public static var disposed(get,never):Bool;
public static function  get_disposed():Bool
        {
            return _disposed;
        }

        
        public static var type(get,set):UInt;
public static function  get_type():UInt
        {
            return _type;
        }
public static function  set_type(k:UInt):UInt        {
            if (_type != k)
            {
                _type = k;
                _Str_7147 = true;
            }
return k;
        }

        
        public static var visible(get,set):Bool;
public static function  get_visible():Bool
        {
            return _visible;
        }
public static function  set_visible(k:Bool):Bool        {
            _visible = k;
            if (_visible)
            {
                if (_Str_3522 != null)
                {
                    _Str_3522.visible = true;
                }
                else
                {
                    Mouse.show();
                }
            }
            else
            {
                if (_Str_3522 != null)
                {
                    _Str_3522.visible = false;
                }
                else
                {
                    Mouse.hide();
                }
            }
return k;
        }

        public static function change()
        {
            var k:DisplayObject = null;
            if (_Str_7147)
            {
                k = _Str_13973[_type];
                if (k != null)
                {
                    if (_Str_3522 != null)
                    {
                        _Str_2691.removeChild(_Str_3522);
                    }
                    else
                    {
                        _Str_2691.addEventListener(Event.MOUSE_LEAVE, (_Str_16609 : ASAny));
                        _Str_2691.addEventListener(MouseEvent.MOUSE_MOVE, (_Str_3983 : ASAny));
                        _Str_2691.addEventListener(MouseEvent.MOUSE_OVER, (_Str_3983 : ASAny));
                        _Str_2691.addEventListener(MouseEvent.MOUSE_OUT, (_Str_3983 : ASAny));
                        Mouse.hide();
                    }
                    _Str_3522 = k;
                    _Str_2691.addChild(_Str_3522);
                }
                else
                {
                    if (_Str_3522 != null)
                    {
                        _Str_2691.removeChild(_Str_3522);
                        _Str_2691.removeEventListener(Event.MOUSE_LEAVE, (_Str_16609 : ASAny));
                        _Str_2691.removeEventListener(MouseEvent.MOUSE_MOVE, (_Str_3983 : ASAny));
                        _Str_2691.removeEventListener(MouseEvent.MOUSE_OVER, (_Str_3983 : ASAny));
                        _Str_2691.removeEventListener(MouseEvent.MOUSE_OUT, (_Str_3983 : ASAny));
                        _Str_3522 = null;
                        Mouse.show();
                    }
                    switch (_type)
                    {
                        case MouseCursorType.DEFAULT
                           | MouseCursorType.ARROW:
                            Mouse.cursor = MouseCursor.AUTO;
                            
                        case MouseCursorType.ARROW_LINK:
                            Mouse.cursor = MouseCursor.BUTTON;
                            
                        case MouseCursorType.DRAG
                           | MouseCursorType.MOVE
                           | MouseCursorType.MOVE_VERTICAL
                           | MouseCursorType.MOVE_HORIZONTAL:
                            Mouse.cursor = MouseCursor.HAND;
                            
                        case MouseCursorType.NONE:
                            Mouse.cursor = MouseCursor.AUTO;
                            Mouse.hide();
                            
                    }
                }
                _Str_7147 = false;
            }
        }

        public static function _Str_26277(k:UInt, _arg_2:DisplayObject)
        {
            _Str_13973[k] = _arg_2;
        }

        static function _Str_3983(k:MouseEvent)
        {
            if (_Str_3522 != null)
            {
                _Str_3522.x = (k.stageX - 2);
                _Str_3522.y = k.stageY;
                if (_type == MouseCursorType.DEFAULT)
                {
                    _visible = false;
                    Mouse.show();
                }
                else
                {
                    _visible = true;
                    Mouse.hide();
                }
            }
        }

        static function _Str_16609(k:Event)
        {
            if (((_Str_3522 != null) && (!(_type == MouseCursorType.DEFAULT))))
            {
                Mouse.hide();
                _visible = false;
            }
        }
    }

