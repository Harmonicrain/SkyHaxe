package com.sulake.core.communication.util
;
    import flash.utils.ByteArray;

     class Short 
    {
        var ba:com.sulake.core.utils.ByteArray;

        public function new(value:Int)
        {
            this.ba = new com.sulake.core.utils.ByteArray();
            this.ba.writeShort(value);
            this.ba.position = 0;
        }

        public var value(get,never):Int;
public function  get_value():Int
        {
            var value = 0;
            this.ba.position = 0;
            if (this.ba.bytesAvailable != 0)
            {
                value = this.ba.readShort();
                this.ba.position = 0;
            }
            return value;
        }
    }

