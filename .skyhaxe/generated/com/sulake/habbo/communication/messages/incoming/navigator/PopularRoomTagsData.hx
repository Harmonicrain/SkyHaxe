package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PopularRoomTagsData implements IDisposable implements  MsgWithRequestId
    {
        var _tags:Array<ASAny>;
        var _disposed:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._tags = new Array<ASAny>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._tags.push(new PopularTagData(k));
                _local_3++;
            }
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._tags = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var tags(get,never):Array<ASAny>;
public function  get_tags():Array<ASAny>
        {
            return this._tags;
        }
    }

