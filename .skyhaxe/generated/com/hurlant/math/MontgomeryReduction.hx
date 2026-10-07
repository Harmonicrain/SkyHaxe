package com.hurlant.math
;
    /*use*/ /*namespace*/ /*bi_internal*/
	/**
	 * Montgomery reduction
	 */
	/*internal*/ class MontgomeryReduction implements IReduction
	{
		var m:BigInteger;
		var mp:Int = 0;
		var mpl:Int = 0;
		var mph:Int = 0;
		var um:Int = 0;
		var mt2:Int = 0;
		public function new(m:BigInteger) {
			this.m = m;
			mp = m.invDigit();
			mpl = mp & 0x7fff;
			mph = mp>>15;
			um = (1<<(BigInteger.DB-15))-1;
			mt2 = 2*m.t;
		}
		/**
		 * xR mod m
		 */
		public function convert(x:BigInteger):BigInteger {
			var r= new BigInteger();
		 	x.abs().dlShiftTo(m.t, r);
		 	r.divRemTo(m, null, r);
		 	if (x.s<0 && r.compareTo(BigInteger.ZERO)>0) {
		 		m.subTo(r,r);
		 	}
		 	return r;
		}
		/**
		 * x/R mod m
		 */
		public function revert(x:BigInteger):BigInteger {
			var r= new BigInteger();
			x.copyTo(r);
			reduce(r);
			return r;
		}
		/**
		 * x = x/R mod m (HAC 14.32)
		 */
		public function reduce(x:BigInteger) {
var 			i = 0, j = 0, u0 = 0;			while (x.t<=mt2) {		// pad x so am has enough room later
				x.a[x.t++] = 0;
			}
			i=0;while (i<m.t) {
j= ASCompat.toInt(x.a[i])&0x7fff;
u0= (j*mpl+(((j*mph+(ASCompat.toInt(x.a[i])>>15)*mpl)&um)<<15))&BigInteger.DM;
				// use am to combine the multiply-shift-add into one call
				j = i+m.t;
				x.a[j] += m.am(0, u0, x, i, 0, m.t);
				// propagate carry
				while (x.a[j]>=BigInteger.DV) {
					x.a[j] -= BigInteger.DV;
{++j;					x.a[j]= ASCompat.toNumber(x.a[j])+1;};
				}
++i;
			}
	 		x.clamp();
		 	x.drShiftTo(m.t, x);
	 		if (x.compareTo(m)>=0) {
	 			x.subTo(m,x);
	 		}
		}
		/**
		 * r = "x^2/R mod m"; x != r
		 */
		public function sqrTo(x:BigInteger, r:BigInteger) {
			x.squareTo(r);
			reduce(r);
		}
		/**
		 * r = "xy/R mod m"; x,y != r
		 */
		public function mulTo(x:BigInteger, y:BigInteger, r:BigInteger) {
			x.multiplyTo(y,r);
			reduce(r);
		}
	}

