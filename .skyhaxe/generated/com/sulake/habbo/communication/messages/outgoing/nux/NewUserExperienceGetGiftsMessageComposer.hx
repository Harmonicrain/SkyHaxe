package com.sulake.habbo.communication.messages.outgoing.nux
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class NewUserExperienceGetGiftsMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;

        public function new(selectedItems:Vector<NewUserExperienceGetGiftsSelection>)
        {
            var _local_2:NewUserExperienceGetGiftsSelection = null;
            this._array = new Array<ASAny>();
            this._array.push((selectedItems.length * 3));
            if (checkNullIteratee(selectedItems)) for (_tmp_ in selectedItems)
            {
_local_2  = _tmp_;
                this._array.push(_local_2.dayIndex);
                this._array.push(_local_2.stepIndex);
                this._array.push(_local_2.giftIndex);
            }
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

