package com.hurlant.math
;
    /*use*/ /*namespace*/ /*bi_internal*/
	/**
	 * A "null" reducer
	 */
	 class NullReduction implements IReduction
	{
		public function revert(x:BigInteger):BigInteger
		{
			return x;
		}
		
		public function mulTo(x:BigInteger, y:BigInteger, r:BigInteger)
		{
			x.multiplyTo(y,r);
		}
		
		public function sqrTo(x:BigInteger, r:BigInteger)
		{
			x.squareTo(r);
		}
		
		public function convert(x:BigInteger):BigInteger
		{
			return x;
		}
		
		public function reduce(x:BigInteger)
		{
		}
public function new(){}
		
	}

