package com.hurlant.crypto.prng
;
    import flash.utils.ByteArray;
    import flash.text.Font;
    import flash.system.System;
    import flash.system.Capabilities;
    import com.hurlant.util.Memory;

     class Random 
    {
        var state:IPRNG;
		var ready:Bool = false;
		var pool:com.sulake.core.utils.ByteArray;
		var psize:Int = 0;
		var pptr:Int = 0;
		var seeded:Bool = false;

        public function new(prng:Class<Dynamic>=null)
        {
var t:UInt  = 0;            if (prng==null) prng = ARC4;
			state = ASCompat.dynamicAs(Type.createInstance(prng, []) , IPRNG);
			psize= ASCompat.toInt(state.getPoolSize());
			pool = new com.sulake.core.utils.ByteArray();
			pptr = 0;
			while (pptr < psize)
			{
t= Std.int(65536*Math.random());
				pool[pptr++] = ASCompat.toInt(t )>>> 8;
				pool[pptr++] = ASCompat.toInt(t)&255;
			}
			pptr=0;
			seed();
        }

        public function seed(x:Int = 0)
		{
			if (x==0) {
				x = Std.int(Date.now().getTime());
			}
			pool[pptr++] ^= x & 255;
			pool[pptr++] ^= (x>>8)&255;
			pool[pptr++] ^= (x>>16)&255;
			pool[pptr++] ^= (x>>24)&255;
			pptr %= psize;
			seeded = true;
		}

        public function autoSeed()
		{
var f:Font  = null;			var b= new com.sulake.core.utils.ByteArray();
			b.writeUnsignedInt(System.totalMemory);
			b.writeUTF(Capabilities.serverString);
			b.writeUnsignedInt(flash.Lib.getTimer());
			b.writeUnsignedInt(Std.int(Date.now().getTime()));
			var a= Font.enumerateFonts(true);
			if (checkNullIteratee(a)) for (_tmp_ in a)
			{
f = _tmp_;
				b.writeUTF(f.fontName);
				b.writeUTF(f.fontStyle);
				b.writeUTF(f.fontType);
			}
			b.position=0;
			while (b.bytesAvailable>=4) {
				seed(ASCompat.toInt(b.readUnsignedInt()));
			}
		}

        public function nextBytes(buffer:com.sulake.core.utils.ByteArray, length:Int)
		{
			while (length-- != 0) {
				buffer.writeByte(nextByte());
			}
		}

        public function nextByte():Int
        {
            if (!ready)
			{
				if (!seeded)
				{
					autoSeed();
				}
				state.init(pool);
				pool.length = 0;
				pptr = 0;
				ready = true;
			}
			return ASCompat.toInt(state.next());
		}
		
        public function dispose()
        {
var 			i:UInt  = 0;			i= 0;while (i < pool.length)
			{
				pool[i] = Std.int(Math.random()*256);
i++;
			}
			pool.length=0;
			pool = null;
			state.dispose();
			state = null;
			psize = 0;
			pptr = 0;
			Memory.gc();
		}

        public function toString():String
        {
            return "random-" + this.state.toString();
        }
    }

