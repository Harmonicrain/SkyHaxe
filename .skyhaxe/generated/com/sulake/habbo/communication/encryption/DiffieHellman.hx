package com.sulake.habbo.communication.encryption
;
    import com.sulake.core.communication.handshake.IKeyExchange;
    import com.hurlant.math.BigInteger;

     class DiffieHellman implements IKeyExchange 
    {
        var _privateKey:BigInteger;
        var _publicKey:BigInteger;
        var _serverPublicKey:BigInteger;
        var _sharedKey:BigInteger;
        var _prime:BigInteger;
        var _generator:BigInteger;
        var _minimumPublicKey:BigInteger;
        var _minimumSharedSecret:BigInteger;

        public function new(prime:BigInteger, generator:BigInteger)
        {
            this._minimumPublicKey = BigInteger.nbv(2);
            this._minimumSharedSecret = BigInteger.nbv(2);
            this._prime = prime;
            this._generator = generator;
        }

        public function init(k:String, _arg_2:UInt=16):Bool
        {
            this._privateKey = new BigInteger();
            this._privateKey.fromRadix(k, ASCompat.toInt(_arg_2));
            this._publicKey = this._generator.modPow(this._privateKey, this._prime);
            return true;
        }

        public function generateSharedKey(k:String, _arg_2:UInt=16):String
        {
            this._serverPublicKey = new BigInteger();
            this._serverPublicKey.fromRadix(k, ASCompat.toInt(_arg_2));
            this._sharedKey = this._serverPublicKey.modPow(this._privateKey, this._prime);
            return this.getSharedKey(_arg_2);
        }

        public function getPublicKey(k:UInt=16):String
        {
            return this._publicKey.toRadix(k);
        }

        public function getSharedKey(k:UInt=16):String
        {
            return this._sharedKey.toRadix(k);
        }

        public function isValidServerPublicKey():Bool
        {
            return this._serverPublicKey.compareTo(this._minimumPublicKey) >= 0;
        }

        public function isValidSharedKey():Bool
        {
            return this._sharedKey.compareTo(this._minimumSharedSecret) >= 0;
        }
    }

