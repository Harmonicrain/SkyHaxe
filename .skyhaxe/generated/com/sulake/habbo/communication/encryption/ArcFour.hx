package com.sulake.habbo.communication.encryption
;
    import com.sulake.core.communication.encryption.IEncryption;
    import flash.utils.ByteArray;

     class ArcFour implements IEncryption 
    {
        var i:UInt = 0;
        var j:UInt = 0;
        var sbox:Vector<UInt>;
        var markI:UInt = 0;
        var markJ:UInt = 0;
        var markBox:Vector<UInt>;

        public function new()
        {
            this.sbox = new Vector<UInt>();
        }

        public function init(k:com.sulake.core.utils.ByteArray)
        {
            var _local_3:UInt = 0;
            var _local_2= k.length;
            this.i = 0;
            while (this.i < 0x0100)
            {
                this.sbox[ASCompat.toInt(this.i)] = this.i;
                this.i++;
            }
            this.j = 0;
            this.i = 0;
            while (this.i < 0x0100)
            {
                this.j = (((this.j + this.sbox[ASCompat.toInt(this.i)]) + k[(this.i % _local_2)]) % 0x0100);
                _local_3 = this.sbox[ASCompat.toInt(this.i)];
                this.sbox[ASCompat.toInt(this.i)] = this.sbox[ASCompat.toInt(this.j)];
                this.sbox[ASCompat.toInt(this.j)] = _local_3;
                this.i++;
            }
            this.i = 0;
            this.j = 0;
        }

        public function encipher(k:com.sulake.core.utils.ByteArray):com.sulake.core.utils.ByteArray
        {
            var _local_3:UInt = 0;
            var _local_4:UInt = 0;
            var _local_2= new com.sulake.core.utils.ByteArray();
            k.position = 0;
            while (k.bytesAvailable != 0)
            {
                this.i = ((this.i + 1) % 0x0100);
                this.j = ((this.j + this.sbox[ASCompat.toInt(this.i)]) % 0x0100);
                _local_3 = this.sbox[ASCompat.toInt(this.i)];
                this.sbox[ASCompat.toInt(this.i)] = this.sbox[ASCompat.toInt(this.j)];
                this.sbox[ASCompat.toInt(this.j)] = _local_3;
                _local_4 = ((this.sbox[ASCompat.toInt(this.i)] + this.sbox[ASCompat.toInt(this.j)]) % 0x0100);
                _local_2.writeByte((ASCompat.toInt(this.sbox[ASCompat.toInt(_local_4)] )^ k.readByte()));
            }
            _local_2.position = 0;
            return _local_2;
        }

        public function decipher(k:com.sulake.core.utils.ByteArray):com.sulake.core.utils.ByteArray
        {
            var _local_3:UInt = 0;
            var _local_4:UInt = 0;
            var _local_2= new com.sulake.core.utils.ByteArray();
            k.position = 0;
            while (k.bytesAvailable != 0)
            {
                this.i = (ASCompat.toInt(this.i + 1) & 0xFF);
                this.j = (ASCompat.toInt(this.j + this.sbox[ASCompat.toInt(this.i)]) & 0xFF);
                _local_3 = this.sbox[ASCompat.toInt(this.i)];
                this.sbox[ASCompat.toInt(this.i)] = this.sbox[ASCompat.toInt(this.j)];
                this.sbox[ASCompat.toInt(this.j)] = _local_3;
                _local_4 = this.sbox[(ASCompat.toInt(this.sbox[ASCompat.toInt(this.i)] + this.sbox[ASCompat.toInt(this.j)]) & 0xFF)];
                _local_2.writeByte((k.readByte() ^ ASCompat.toInt(_local_4)));
            }
            _local_2.position = 0;
            return _local_2;
        }

        public function mark()
        {
            this.markI = this.i;
            this.markJ = this.j;
            this.markBox = this.sbox.concat();
        }

        public function reset()
        {
            this.i = this.markI;
            this.j = this.markJ;
            this.sbox = this.markBox.concat();
        }
    }

