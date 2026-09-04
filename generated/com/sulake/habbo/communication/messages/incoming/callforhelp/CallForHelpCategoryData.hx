package com.sulake.habbo.communication.messages.incoming.callforhelp
;
    import com.sulake.habbo.communication.messages.incoming.moderation.INamed;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.moderation.*;

     class CallForHelpCategoryData implements INamed implements  IDisposable
    {
        var _name:String;
        var _topics:Vector<CallForHelpTopicData>;
        var _disposed:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._topics = new Vector<CallForHelpTopicData>();
            this._name = k.readString();
            Logger.log([("READ CFH CAT: " + this._name)]);
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._topics.push(new CallForHelpTopicData(k));
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
            this._topics = null;
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var name(get,never):String;
function  get_name():String
        {
            return this._name;
        }

        public var _Str_14841(get,never):Vector<CallForHelpTopicData>;
function  get__Str_14841():Vector<CallForHelpTopicData>
        {
            return this._topics;
        }
    }

