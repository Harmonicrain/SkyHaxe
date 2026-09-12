/**
 * RSAKey
 * 
 * An ActionScript 3 implementation of RSA + PKCS#1 (light version)
 * Copyright (c) 2007 Henri Torgemane
 * 
 * Derived from:
 * 		The jsbn library, Copyright (c) 2003-2005 Tom Wu
 * 
 * See LICENSE.txt for full license information.
 */
package com.sulake.core.communication.encryption.rsa
;

	import com.hurlant.crypto.prng.Random;
	import com.hurlant.math.BigInteger;
	import com.hurlant.util.Memory;
	
	import flash.utils.ByteArray;
	import com.hurlant.crypto.tls.TLSError;
	
	/**
	 * Current limitations:
	 * exponent must be smaller than 2^31.
	 */
	 class RSAKey
	{
		// public key
		public var e:Int = 0;              // public exponent. must be <2^31
		public var n:BigInteger; // modulus
		// private key
		public var d:BigInteger;
		// extended private key
		public var p:BigInteger;
		public var q:BigInteger;
		public var dmp1:BigInteger;
		public var dmq1:BigInteger;
		public var coeff:BigInteger;
		// flags. flags are cool.
		var canDecrypt:Bool = false;
		var canEncrypt:Bool = false;
		
		public function new(N:BigInteger, E:Int, 
			D:BigInteger=null,
			P:BigInteger = null, Q:BigInteger=null,
			DP:BigInteger=null, DQ:BigInteger=null,
			C:BigInteger=null) {
				
			this.n = N;
			this.e = E;
			this.d = D;
			this.p = P;
			this.q = Q;
			this.dmp1 = DP;
			this.dmq1 = DQ;
			this.coeff = C;
			
			// adjust a few flags.
			canEncrypt = (n!=null&&e!=0);
			canDecrypt = (canEncrypt&&d!=null);
		}

		public static function parsePublicKey(N:String, E:String):RSAKey {
			return new RSAKey(new BigInteger(N, 16, true), ASCompat.parseInt(E,16));
		}
		public static function parsePrivateKey(N:String, E:String, D:String, 
			P:String=null,Q:String=null, DMP1:String=null, DMQ1:String=null, IQMP:String=null):RSAKey {
			if (P==null) {
				return new RSAKey(new BigInteger(N,16, true), ASCompat.parseInt(E,16), new BigInteger(D,16, true));
			} else {
				return new RSAKey(new BigInteger(N,16, true), ASCompat.parseInt(E,16), new BigInteger(D,16, true),
					new BigInteger(P,16, true), new BigInteger(Q,16, true),
					new BigInteger(DMP1,16, true), new BigInteger(DMQ1, 16, true),
					new BigInteger(IQMP, 16, true));
			}
		}
		
		public function getBlockSize():UInt {
			return Std.int((n.bitLength()+7)/8);
		}
		public function dispose() {
			e = 0;
			n.dispose();
			n = null;
			Memory.gc();
		}

		public function encrypt(src:com.sulake.core.utils.ByteArray, dst:com.sulake.core.utils.ByteArray, length:UInt, pad:ASFunction=null) {
			_encrypt(doPublic, src, dst, length, pad, 0x02);
		}
		public function decrypt(src:com.sulake.core.utils.ByteArray, dst:com.sulake.core.utils.ByteArray, length:UInt, pad:ASFunction=null) {
			_decrypt(doPrivate2, src, dst, length, pad, 0x02);
		}

		public function sign(src:com.sulake.core.utils.ByteArray, dst:com.sulake.core.utils.ByteArray, length:UInt, pad:ASFunction = null) {
			_encrypt(doPrivate2, src, dst, length, pad, 0x01);
		}
		public function verify(src:com.sulake.core.utils.ByteArray, dst:com.sulake.core.utils.ByteArray, length:UInt, pad:ASFunction = null) {
			_decrypt(doPublic, src, dst, length, pad, 0x01);
		}

		function _encrypt(op:ASFunction, src:com.sulake.core.utils.ByteArray, dst:com.sulake.core.utils.ByteArray, length:UInt, pad:ASFunction, padType:Int) {
var block:BigInteger  = null, chunk:BigInteger  = null, b:UInt  = 0;			// adjust pad if needed
			if (pad==null) pad = pkcs1pad;
			// convert src to BigInteger
			if (src.position >= src.length) {
				src.position = 0;
			}
			var bl= getBlockSize();
			var end= ASCompat.toInt(src.position + length);
			while (src.position<(end : UInt)) {
block= new BigInteger(pad(src, end, bl, padType), ASCompat.toInt(bl), true);
chunk= op(block);
				
				for(_tmp_ in (1...Std.int(Std.int(bl - Math.fceil(chunk.bitLength() / 8)) + 1)).reverse()) {
b= _tmp_;
					dst.writeByte(0x00);
				}
								
				chunk.toArray(dst);
			}
		}
		function _decrypt(op:ASFunction, src:com.sulake.core.utils.ByteArray, dst:com.sulake.core.utils.ByteArray, length:UInt, pad:ASFunction, padType:Int) {
var block:BigInteger  = null, chunk:BigInteger  = null, b:com.sulake.core.utils.ByteArray  = null;			// adjust pad if needed
			if (pad==null) pad = pkcs1unpad;
			
			// convert src to BigInteger
			if (src.position >= src.length) {
				src.position = 0;
			}
			var bl= getBlockSize();
			var end= ASCompat.toInt(src.position + length);
			while (src.position<(end : UInt)) {
block= new BigInteger(src, ASCompat.toInt(bl), true);
chunk= op(block);
b= pad(chunk, bl, padType);
				if (b == null) 
					 throw new TLSError( "Decrypt error - padding function returned null!", ASCompat.toInt(TLSError.decode_error ));
ASCompat.byteArrayWriteBytes(				// if (b != null)
				dst, b);
			}
		}
		
		/**
		 * PKCS#1 pad. type 1 (0xff) or 2, random.
		 * puts as much data from src into it, leaves what doesn't fit alone.
		 */
		function pkcs1pad(src:com.sulake.core.utils.ByteArray, end:Int, n:UInt, type:UInt = 0x02):com.sulake.core.utils.ByteArray {
var rng:Random  = null, x = 0;			var out= new com.sulake.core.utils.ByteArray();
			var p= src.position;
			end = Std.int(Math.min(end, Math.min(src.length, p+n-11)));
			src.position = end;
			var i= end-1;
			while ((i : UInt)>=p && n>11) {
				out[--n] = src[i--];
			}
			out[--n] = 0;
			if (type==0x02) { // type 2
rng= new Random();
x= 0;
				while (n>2) {
					do {
						x = rng.nextByte();
					} while (x==0);
					out[--n] = x;
				}
			} else { // type 1
				while (n>2) {
					out[--n] = 0xFF;
				}
			}
			out[--n] = type;
			out[--n] = 0;
			return out;
		}
		
		/**
		 * 
		 * @param src
		 * @param n
		 * @param type Not used.
		 * @return 
		 * 
		 */
		function pkcs1unpad(src:BigInteger, n:UInt, type:UInt = 0x02):com.sulake.core.utils.ByteArray {
			var out= new com.sulake.core.utils.ByteArray();
			
			var b= new com.sulake.core.utils.ByteArray();
			src.toArray(b);
			
			b.position = 0;
			var i= 0;
			while ((i : UInt)<b.length && b[i]==0) ++i;
			if (b.length-i != n-1 || b[i]!=type) {
				trace("PKCS#1 unpad: i="+Std.string(i)+", expected b[i]=="+Std.string(type)+", got b[i]="+ASCompat.toRadix(b[i], 16));
				return null;
			}
			++i;
			while (b[i]!=0) {
				if ((++i : UInt)>=b.length) {
					trace("PKCS#1 unpad: i="+Std.string(i)+", b[i-1]!=0 (="+ASCompat.toRadix(b[i-1], 16)+")");
					return null;
				}
			}
			while ((++i : UInt) < b.length) {
				out.writeByte(ASCompat.toInt(b[i]));
			}
			out.position = 0;
			return out;
		}
		/**
		 * Raw pad.
		 */
		public function rawpad(src:com.sulake.core.utils.ByteArray, end:Int, n:UInt, type:UInt = 0):com.sulake.core.utils.ByteArray {
			return src;
		}
		public function rawunpad(src:BigInteger, n:UInt, type:UInt = 0):com.sulake.core.utils.ByteArray {
			return src.toByteArray();
		}
		
		public function toString():String {
			return "rsa";
		}
		
		public function dump():String {
			var s= "N="+n.toString(16)+"\n"+
			"E="+ASCompat.toRadix(e, 16)+"\n";
			if (canDecrypt) {
				s+="D="+d.toString(16)+"\n";
				if (p!=null && q!=null) {
					s+="P="+p.toString(16)+"\n";
					s+="Q="+q.toString(16)+"\n";
					s+="DMP1="+dmp1.toString(16)+"\n";
					s+="DMQ1="+dmq1.toString(16)+"\n";
					s+="IQMP="+coeff.toString(16)+"\n";
				}
			}
			return s;
		}
		
		
		/**
		 * 
		 * note: We should have a "nice" variant of this function that takes a callback,
		 * 		and perform the computation is small fragments, to keep the web browser
		 * 		usable.
		 * 
		 * @param B
		 * @param E
		 * @return a new random private key B bits long, using public expt E
		 * 
		 */
		public static function generate(B:UInt, E:String):RSAKey {
var t:BigInteger  = null, p1:BigInteger  = null, q1:BigInteger  = null, phi:BigInteger  = null;			var rng= new Random();
			var qs:UInt = ASCompat.toInt(B)>>1;
			var key= new RSAKey(null,0,null);
			key.e = ASCompat.parseInt(E, 16);
			var ee= new BigInteger(E,16, true);
			while (true) {
				while (true) {
					key.p = bigRandom(ASCompat.toInt(B-qs), rng);
					if (key.p.subtract(BigInteger.ONE).gcd(ee).compareTo(BigInteger.ONE)==0 &&
						key.p.isProbablePrime(10)) break;
				}
				while (true) {
					key.q = bigRandom(ASCompat.toInt(qs), rng);
					if (key.q.subtract(BigInteger.ONE).gcd(ee).compareTo(BigInteger.ONE)==0 &&
						key.q.isProbablePrime(10)) break;
				}
				if (key.p.compareTo(key.q)<=0) {
t= key.p;
					key.p = key.q;
					key.q = t;
				}
p1= key.p.subtract(BigInteger.ONE);
q1= key.q.subtract(BigInteger.ONE);
phi= p1.multiply(q1);
				if (phi.gcd(ee).compareTo(BigInteger.ONE)==0) {
					key.n = key.p.multiply(key.q);
					key.d = ee.modInverse(phi);
					key.dmp1 = key.d.mod(p1);
					key.dmq1 = key.d.mod(q1);
					key.coeff = key.q.modInverse(key.p);
					break;
				}
			}
			key.canEncrypt = (key.n != null && key.e != 0);
			key.canDecrypt = (key.canEncrypt && key.d != null);
			return key;
		}
		
		static function bigRandom(bits:Int, rnd:Random):BigInteger {
			if (bits<2) return BigInteger.nbv(1);
			var x= new com.sulake.core.utils.ByteArray();
			rnd.nextBytes(x, (bits>>3));
			x.position = 0;
			var b= new BigInteger(x,0,true);
			b.primify(bits, 1);
			return b;
		}
		
		function doPublic(x:BigInteger):BigInteger {
			return x.modPowInt(e, n);
		}
		
		function doPrivate2(x:BigInteger):BigInteger {
			if (p==null && q==null) {
				return x.modPow(d,n);
			}
			
			var xp= x.mod(p).modPow(dmp1, p);
			var xq= x.mod(q).modPow(dmq1, q);
			
			while (xp.compareTo(xq)<0) {
				xp = xp.add(p);
			}
			var r= xp.subtract(xq).multiply(coeff).mod(p).multiply(q).add(xq);
			
			return r;
		}
		
		function doPrivate(x:BigInteger):BigInteger {
			if (p==null || q==null) {
				return x.modPow(d, n);
			}
			// TODO: re-calculate any missing CRT params
			var xp= x.mod(p).modPow(dmp1, p);
			var xq= x.mod(q).modPow(dmq1, q);
			
			while (xp.compareTo(xq)<0) {
				xp = xp.add(p);
			}
			return xp.subtract(xq).multiply(coeff).mod(p).multiply(q).add(xq);
		}
		
		
	}

