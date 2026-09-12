package com.sulake.habbo.communication.messages.outgoing.competition
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class ForwardToACompetitionRoomMessageComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:String, _arg_2:Int)
        {
            this._array = new Array<ASAny>();
            this._array.push(k);
            this._array.push(_arg_2);
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

