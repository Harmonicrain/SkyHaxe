package com.sulake.core.runtime
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IID;
    import com.sulake.core.runtime.*;

    /*internal*/ class ComponentInterfaceQueue implements IDisposable 
    {
        var _identifier:IID;
        var _isDisposed:Bool = false;
        var _receivers:Vector<ASFunction>;

        public function new(identifier:IID)
        {
            this._identifier = identifier;
            this._receivers = new Vector<ASFunction>();
            this._isDisposed = false;
        }

        public var identifier(get,never):IID;
public function  get_identifier():IID
        {
            return this._identifier;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public var receivers(get,never):Vector<ASFunction>;
public function  get_receivers():Vector<ASFunction>
        {
            return this._receivers;
        }

        public function dispose()
        {
            if (!this._isDisposed)
            {
                this._isDisposed = true;
                this._identifier = null;
                while (this._receivers.length > 0)
                {
                    this._receivers.pop();
                }
                this._receivers = null;
            }
        }
    }

