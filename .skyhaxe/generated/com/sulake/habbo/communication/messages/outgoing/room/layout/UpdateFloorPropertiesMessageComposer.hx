package com.sulake.habbo.communication.messages.outgoing.room.layout
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class UpdateFloorPropertiesMessageComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:String, _arg_2:Int=-1, _arg_3:Int=-1, _arg_4:Int=-1, _arg_5:Int=-1, _arg_6:Int=-1, _arg_7:Int=-1)
        {
            if ((((((_arg_2 == -1) && (_arg_3 == -1)) && (_arg_4 == -1)) && (_arg_5 == -1)) && (_arg_6 == -1)))
            {
                this._array = [k];
            }
            else
            {
                if (_arg_7 == -1)
                {
                    this._array = [k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6];
                }
                else
                {
                    this._array = [k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7];
                }
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
    }

