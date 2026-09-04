package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomData implements IDisposable
    {
        var _exists:Bool = false;
        var _name:String;
        var _desc:String;
        var _tags:Array<ASAny>;
        var _disposed:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._tags = new Array<ASAny>();
            this._exists = k.readBoolean();
            if (!this.exists)
            {
                return;
            }
            this._name = k.readString();
            this._desc = k.readString();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._tags.push(k.readString());
                _local_3++;
            }
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._disposed;
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

        public var name(get,never):String;
function  get_name():String
        {
            return this._name;
        }

        public var desc(get,never):String;
function  get_desc():String
        {
            return this._desc;
        }

        public var tags(get,never):Array<ASAny>;
function  get_tags():Array<ASAny>
        {
            return this._tags;
        }

        public var exists(get,never):Bool;
function  get_exists():Bool
        {
            return this._exists;
        }
    }

