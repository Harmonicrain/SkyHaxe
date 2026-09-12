package com.sulake.habbo.communication.messages.outgoing.navigator
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class ForwardToARandomPromotedRoomMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _content:Array<ASAny>;

        public function new(k:String)
        {
            this._content = new Array<ASAny>();
            this._content.push(k);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._content;
        }

        public function dispose()
        {
            this._content = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }
    }

