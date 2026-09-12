package com.sulake.habbo.communication.messages.outgoing.competition
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class ForwardToRandomCompetitionRoomMessageComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:String)
        {
            this._array = new Array<ASAny>();
            this._array.push(k);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public function dispose()
        {
            this._array = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }
    }

