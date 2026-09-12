package com.sulake.habbo.utils
;
     class FixedSizeStack 
    {
        var _data:Array<ASAny>;
        var _maxSize:Int = 0;
        var _index:Int = 0;

        public function new(k:Int)
        {
            this._data = [];
            this._maxSize = k;
        }

        public function reset()
        {
            this._data = [];
            this._index = 0;
        }

        public function _Str_22775(k:Int)
        {
            if (this._data.length < this._maxSize)
            {
                this._data.push(k);
            }
            else
            {
                this._data[this._index] = k;
            }
            this._index = ((this._index + 1) % this._maxSize);
        }

        public function _Str_25797():Int
        {
            var k= ASCompat.MIN_INT;
            var _local_2 = 0;
            while (_local_2 < this._maxSize)
            {
                if (this._data[_local_2] > k)
                {
                    k = ASCompat.toInt(this._data[_local_2]);
                }
                _local_2++;
            }
            return k;
        }

        public function _Str_26219():Int
        {
            var k= ASCompat.MAX_INT;
            var _local_2 = 0;
            while (_local_2 < this._maxSize)
            {
                if (this._data[_local_2] < k)
                {
                    k = ASCompat.toInt(this._data[_local_2]);
                }
                _local_2++;
            }
            return k;
        }
    }

