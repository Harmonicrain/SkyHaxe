package com.sulake.core.assets
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.Core;

     class LazyAssetProcessor implements IUpdateReceiver 
    {
        var _queue:Vector<ILazyAsset>;
        var _running:Bool = false;
        var _disposed:Bool = false;

        public function new()
        {
            this._queue = new Vector<ILazyAsset>();
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
                Core.instance.removeUpdateReceiver(this);
                this._queue = null;
                this._running = false;
                this._disposed = true;
            }
        }

        public function push(lazyAsset:ILazyAsset)
        {
            if (lazyAsset != null)
            {
                this._queue.push(lazyAsset);
                if (!this._running)
                {
                    Core.instance.registerUpdateReceiver(this, 2);
                    this._running = true;
                }
            }
        }

        public function flush()
        {
            var lazyAsset:ILazyAsset = null;
            final _iter_ = this._queue; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
lazyAsset  = _tmp_;
                if (!lazyAsset.disposed)
                {
                    lazyAsset.prepareLazyContent();
                }
            }
            this._queue = new Vector<ILazyAsset>();
            if (this._running)
            {
                Core.instance.removeUpdateReceiver(this);
                this._running = false;
            }
        }

        public function update(k:UInt)
        {
            var lazyAsset= this._queue.shift();
            if (lazyAsset == null)
            {
                if (this._running)
                {
                    Core.instance.removeUpdateReceiver(this);
                    this._running = false;
                }
            }
            else
            {
                if (!lazyAsset.disposed)
                {
                    lazyAsset.prepareLazyContent();
                }
            }
        }
    }

