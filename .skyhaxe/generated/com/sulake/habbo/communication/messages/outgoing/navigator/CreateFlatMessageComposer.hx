package com.sulake.habbo.communication.messages.outgoing.navigator
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class CreateFlatMessageComposer implements IMessageComposer implements  IDisposable 
    {
        var _array:Array<ASAny>;

        public function new(roomName:String, roomDesc:String, roomLayout:String, selectedFlatCategoryNodeId:Int, maxVisitors:Int, roomTradeSetting:Int)
        {
            this._array = new Array<ASAny>();
            this._array.push(roomName);
            this._array.push(roomDesc);
            this._array.push(roomLayout);
            this._array.push(selectedFlatCategoryNodeId);
            this._array.push(maxVisitors);
            this._array.push(roomTradeSetting);
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

