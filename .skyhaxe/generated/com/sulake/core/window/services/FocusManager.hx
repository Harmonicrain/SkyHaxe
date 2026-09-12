package com.sulake.core.window.services
;
    import flash.display.Stage;
    import com.sulake.core.window.components.IFocusWindow;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.display.DisplayObject;
    import com.sulake.core.window.utils.*;

     class FocusManager implements IFocusManagerService 
    {
        var _disposed:Bool = false;
        var _stage:Stage;
        var _array:Vector<IFocusWindow>;

        public function new(k:DisplayObject)
        {
            this._array = new Vector<IFocusWindow>();
            this._stage = k.stage;
            this._stage.addEventListener(Event.ACTIVATE, (this._Str_21302 : ASAny));
            this._stage.addEventListener(FocusEvent.FOCUS_OUT, (this._Str_4932 : ASAny));
            this._stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, (this._Str_4932 : ASAny));
            this._stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, (this._Str_4932 : ASAny));
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._stage.removeEventListener(Event.ACTIVATE, (this._Str_21302 : ASAny));
                this._stage.removeEventListener(FocusEvent.FOCUS_OUT, (this._Str_4932 : ASAny));
                this._stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, (this._Str_4932 : ASAny));
                this._stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, (this._Str_4932 : ASAny));
                this._stage = null;
                this._disposed = true;
                this._array = null;
            }
        }

        public function registerFocusWindow(k:IFocusWindow)
        {
            if (k != null)
            {
                if (this._array.indexOf(k) == -1)
                {
                    this._array.push(k);
                    if (this._stage.focus == null)
                    {
                        k.focus();
                    }
                }
            }
        }

        public function removeFocusWindow(k:IFocusWindow)
        {
            var _local_2 = 0;
            if (k != null)
            {
                _local_2 = this._array.indexOf(k);
                if (_local_2 > -1)
                {
                    this._array.splice(_local_2, 1);
                }
            }
            if (this._stage.focus == null)
            {
                this._Str_16261();
            }
        }

        function _Str_16261():IFocusWindow
        {
            var _local_2:IFocusWindow = null;
            var k:UInt = this._array.length;
            while (k-- != 0)
            {
                _local_2 = this._array[ASCompat.toInt(k)] ;
                if (_local_2.disposed)
                {
                    this._array.splice(ASCompat.toInt(k), 1);
                }
                else
                {
                    _local_2.focus();
                    break;
                }
            }
            return _local_2;
        }

        function _Str_21302(k:Event)
        {
            if (this._stage.focus == null)
            {
                this._Str_16261();
            }
        }

        function _Str_4932(k:FocusEvent)
        {
            if (this._stage.focus == null)
            {
                this._Str_16261();
            }
        }
    }

