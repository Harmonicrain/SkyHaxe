package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PromotedRoomsData implements IDisposable implements  MsgWithRequestId
    {
        var _entries:Array<ASAny>;
        var _disposed:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._entries = new Array<ASAny>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._entries.push(new PromotedRoomCategoryData(k));
                _local_3++;
            }
        }

        public function dispose()
        {
            var k:PromotedRoomCategoryData = null;
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._entries != null)
            {
                final _iter_ = this._entries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    k.dispose();
                }
            }
            this._entries = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var entries(get,never):Array<ASAny>;
public function  get_entries():Array<ASAny>
        {
            return this._entries;
        }
    }

