package com.sulake.habbo.communication.messages.outgoing.talent
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class GetTalentTrackMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _data:Array<ASAny>;

        public function new(k:String)
        {
            this._data = [];
            this._data.push(k);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._data;
        }

        public function dispose()
        {
            this._data = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._data == null;
        }
    }

