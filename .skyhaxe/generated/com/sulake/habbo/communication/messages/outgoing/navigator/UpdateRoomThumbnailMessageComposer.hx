package com.sulake.habbo.communication.messages.outgoing.navigator
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class UpdateRoomThumbnailMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;

        public function new(flatId:Int, bgImgId:Int, frontImgId:Int, objCount:Int)
        {
            this._array = new Array<ASAny>();
            this._array.push(flatId);
            this._array.push(bgImgId);
            this._array.push(frontImgId);
            this._array.push(objCount);
        }

        public function _Str_26191(k:Int, _arg_2:Int)
        {
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

