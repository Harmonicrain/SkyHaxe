package com.sulake.core.utils.debug
;
    import com.sulake.core.runtime.IDisposable;

     class GarbageMonitor implements IDisposable 
    {
        var _disposed:Bool = false;
        var _dict:ASDictionary<ASAny,ASAny>;

        public function new()
        {
            this._dict = new ASDictionary<ASAny,ASAny>(true);
        }

        public function dispose()
        {
            var k:ASAny = null;
            if (!this._disposed)
            {
                final _iter_ = this._dict; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    this._dict.remove(k);
                }
                this._dict = null;
                this._disposed = true;
            }
        }

        public function insert(k:ASObject, _arg_2:String=null)
        {
            this._dict[k] = ((_arg_2 == null) ? Std.string(k) : _arg_2);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var list(get,never):Array<ASAny>;
public function  get_list():Array<ASAny>
        {
            var _local_2:ASAny = null;
            var k= new Array<ASAny>();
            final _iter_ = this._dict; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k.push(_local_2);
            }
            return k;
        }
    }

