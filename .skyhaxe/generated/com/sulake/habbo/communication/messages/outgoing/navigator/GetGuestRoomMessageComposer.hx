package com.sulake.habbo.communication.messages.outgoing.navigator
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class GetGuestRoomMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;

        public function new(flatId:Int, enterRoom:Bool, roomForward:Bool)
        {
            this._array = new Array<ASAny>();
            this._array.push(flatId);
            this._array.push((enterRoom ? 1 : 0));
            this._array.push((roomForward ? 1 : 0));
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

