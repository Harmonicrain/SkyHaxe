package com.hurlant.crypto.prng
;
    import com.hurlant.crypto.symmetric.IStreamCipher;
    import flash.utils.ByteArray;
    import com.hurlant.util.Memory;

     class ARC4 implements IPRNG implements  IStreamCipher 
    {
        static inline final psize:UInt = 0x0100;

        var i:Int = 0;
        var j:Int = 0;
        var S:com.sulake.core.utils.ByteArray;

        public function new(k:com.sulake.core.utils.ByteArray=null)
        {
            this.S = new com.sulake.core.utils.ByteArray();
            if (k != null)
            {
                this.init(k);
            }
        }

        public function getPoolSize():UInt
        {
            return psize;
        }

        public function init(key:com.sulake.core.utils.ByteArray)
        {
var i = 0;            var i = 0;
			var j = 0;
			var t = 0;
			for (_tmp_ in 0...256) {
i=_tmp_;
				S[i] = i;
			}
			j=0;
			for (_tmp_ in 0...256) {
i=_tmp_;
				j = ASCompat.toInt(j + S[i] + key[i%key.length]) & 255;
				t = ASCompat.toInt(S[i]);
				S[i] = S[j];
				S[j] = t;
			}
			this.i=0;
			this.j=0;
        }

        public function next():UInt
        {
            var t = 0;
			i = (i+1)&255;
			j = ASCompat.toInt(j+S[i])&255;
			t = ASCompat.toInt(S[i]);
			S[i] = S[j];
			S[j] = t;
			return S[ASCompat.toInt(t+S[i])&255];
        }

        public function getBlockSize():UInt
        {
            return 1;
        }

        public function encrypt(block:com.sulake.core.utils.ByteArray)
		{
			var i:UInt = 0;
			while (i<block.length) {
				block[i++] ^= next();
			}
		}

        public function decrypt(block:com.sulake.core.utils.ByteArray)
		{
			encrypt(block); // the beauty of XOR.
		}

        public function dispose()
        {
var 				i:UInt = 0;            var i:UInt = 0;
			if (S!=null) {
				i=0;while (i<S.length) {
					S[i] = Std.int(Math.random()*256);
i++;
				}
				S.length=0;
				S = null;
			}
			this.i = 0;
			this.j = 0;
			Memory.gc();
        }

        public function toString():String
        {
            return "rc4";
        }
    }

