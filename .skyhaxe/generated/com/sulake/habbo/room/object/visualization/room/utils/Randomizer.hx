package com.sulake.habbo.room.object.visualization.room.utils
;
     class Randomizer 
    {
        public static inline final DEFAULT_SEED= 1;
        public static inline final DEFAULT_MODULUS= 16777216;
        static var _randomizer:Randomizer = null;

        var _seed:Int = 1;
        var _modulus:Int = 16777216;
        var _multiplier:Int = 69069;
        var _increment:Int = 5;


        public static function setSeed(k:Int=1)
        {
            if (_randomizer == null)
            {
                _randomizer = Type.createInstance(Randomizer, []);
            }
            _randomizer.seed = k;
        }

        public static function setModulus(k:Int=16777216)
        {
            if (_randomizer == null)
            {
                _randomizer = Type.createInstance(Randomizer, []);
            }
            _randomizer.modulus = k;
        }

        public static function getValues(k:Int, _arg_2:Int, _arg_3:Int):Array<ASAny>
        {
            if (_randomizer == null)
            {
                _randomizer = Type.createInstance(Randomizer, []);
            }
            return _randomizer.getRandomValues(k, _arg_2, _arg_3);
        }

        public static function getArray(k:Int, _arg_2:Int):Array<ASAny>
        {
            if (_randomizer == null)
            {
                _randomizer = Type.createInstance(Randomizer, []);
            }
            return _randomizer.getRandomArray(k, _arg_2);
        }


        public var seed(never,set):Int;
public function  set_seed(k:Int):Int        {
            return this._seed = k;
        }

        public var modulus(never,set):Int;
public function  set_modulus(k:Int):Int        {
            if (k < 1)
            {
                k = 1;
            }
            return this._modulus = k;
        }

        public function dispose()
        {
        }

        public function getRandomValues(k:Int, _arg_2:Int, _arg_3:Int):Array<ASAny>
        {
            var _local_4:Array<ASAny> = [];
            var _local_5 = 0;
            while (_local_5 < k)
            {
                _local_4.push(this.iterateScaled(_arg_2, (_arg_3 - _arg_2)));
                _local_5++;
            }
            return _local_4;
        }

        public function getRandomArray(k:Int, _arg_2:Int):Array<ASAny>
        {
            var _local_7 = 0;
            if (((k > _arg_2) || (_arg_2 > 1000)))
            {
                return null;
            }
            var _local_3:Array<ASAny> = [];
            var _local_4 = 0;
            while (_local_4 <= _arg_2)
            {
                _local_3.push(_local_4);
                _local_4++;
            }
            var _local_5:Array<ASAny> = [];
            var _local_6 = 0;
            while (_local_6 < k)
            {
                _local_7 = this.iterateScaled(0, (_local_3.length - 1));
                _local_5.push(_local_3[_local_7]);
                _local_3.splice(_local_7, 1);
                _local_6++;
            }
            return _local_5;
        }

        function iterate():Int
        {
            var k= ((this._multiplier * this._seed) + this._increment);
            if (k < 0)
            {
                k = -k;
            }
            k = (k % this._modulus);
            this._seed = k;
            return k;
        }

        function iterateScaled(k:Int, _arg_2:Int):Int
        {
            var _local_3= this.iterate();
            if (_arg_2 < 1)
            {
                return k;
            }
            _local_3 = Std.int(k + ((_local_3 / this._modulus) * _arg_2));
            return _local_3;
        }

	public function new() {}
    }

