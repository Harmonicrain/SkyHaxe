package com.sulake.room.utils
;
     class NumberBank 
    {
        var _size:Int = 0;
        var _reservedNumbers:Array<ASAny>;
        var _freeNumbers:Array<ASAny>;

        public function new(k:Int)
        {
            this._reservedNumbers = [];
            this._freeNumbers = [];
            if (k < 0)
            {
                k = 0;
            }
            var _local_2 = 0;
            while (_local_2 < k)
            {
                this._freeNumbers.push(_local_2);
                _local_2++;
            }
        }

        public function dispose()
        {
            this._reservedNumbers = null;
            this._freeNumbers = null;
            this._size = 0;
        }

        public function reserveNumber():Int
        {
            var k:Int;
            if (this._freeNumbers.length > 0)
            {
                k = ASCompat.toInt(this._freeNumbers.pop() );
                this._reservedNumbers.push(k);
                return k;
            }
            return -1;
        }

        public function freeNumber(k:Int)
        {
            var _local_2= this._reservedNumbers.indexOf(k);
            if (_local_2 >= 0)
            {
                this._reservedNumbers.splice(_local_2, 1);
                this._freeNumbers.push(k);
            }
        }
    }

