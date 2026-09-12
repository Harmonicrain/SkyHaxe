package com.sulake.core.window.utils
;
    import com.sulake.core.runtime.IDisposable;
    import flash.events.IEventDispatcher;
    import flash.events.Event;

     class GenericEventQueue implements IEventQueue implements  IDisposable 
    {
        var _disposed:Bool = false;
        var _eventDispatcher:IEventDispatcher;
        var _Str_4751:Vector<Event>;
        var _index:UInt = 0;
        var _Str_18060:Bool = true;

        public function new(k:IEventDispatcher)
        {
            this._Str_4751 = new Vector<Event>();
            this._eventDispatcher = k;
        }

        public var length(get,never):UInt;
public function  get_length():UInt
        {
            return this._Str_4751.length;
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
                this._eventDispatcher = null;
                if (this._Str_4751.length != 0)
                {
                    this._Str_4751.splice(0, this._Str_4751.length);
                }
                this._disposed = true;
            }
        }

        public function begin()
        {
            if (!this._Str_18060)
            {
                this.flush();
            }
            this._index = 0;
            this._Str_18060 = false;
        }

        public function next():Event
        {
            var k:Event = null;
            if (this._index < (this._Str_4751.length : UInt))
            {
                k = this._Str_4751[ASCompat.toInt(this._index)];
                this._index++;
            }
            return k;
        }

        public function remove()
        {
            this._Str_4751.splice(ASCompat.toInt(this._index - 1), 1);
            if (this._index > 0)
            {
                this._index--;
            }
        }

        public function end()
        {
            this._index = 0;
            this._Str_18060 = true;
        }

        public function flush()
        {
            this._Str_4751.splice(0, this._Str_4751.length);
            this._index = 0;
        }

        function _Str_26253(k:Event)
        {
            this._Str_4751.push(k);
        }
    }

