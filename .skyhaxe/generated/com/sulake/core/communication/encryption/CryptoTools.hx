package com.sulake.core.communication.encryption
;
    import flash.utils.ByteArray;

     class CryptoTools 
    {
        public static function byteArrayToString(input:com.sulake.core.utils.ByteArray):String
        {
            input.position = 0;
            var output= "";
            while (input.bytesAvailable != 0)
            {
                output = (output + ASCompat.stringFromCharCode(input.readByte()));
            }
            return output;
        }

        public static function stringToByteArray(input:String):com.sulake.core.utils.ByteArray
        {
var 			index = 0;            var buffer= new com.sulake.core.utils.ByteArray();
			index= 0;while (index < input.length)
            {
                buffer.writeByte(input.charCodeAt(index));
index++;
            }
            buffer.position = 0;
            return buffer;
        }

        public static function byteArrayToHexString(input:com.sulake.core.utils.ByteArray, toUpperCase:Bool=false):String
        {
            var byte:UInt = 0;
            var a:UInt = 0;
            var b:UInt = 0;
            input.position = 0;
            var output= "";
            while (input.bytesAvailable != 0)
            {
                byte = input.readUnsignedByte();
                a = (ASCompat.toInt(byte )>> 4);
                b = (ASCompat.toInt(byte )& 0x0F);
                output = (output + ASCompat.toRadix(a, 16));
                output = (output + ASCompat.toRadix(b, 16));
            }
            if (toUpperCase)
            {
                output = output.toUpperCase();
            }
            return output;
        }

        public static function hexStringToByteArray(input:String):com.sulake.core.utils.ByteArray
        {
            var a = 0;
            var b = 0;
            var byte = 0;
            var buffer= new com.sulake.core.utils.ByteArray();
            if ((input.length % 2) != 0)
            {
                input = ("0" + input);
            }
            var bytesRead = 0;
            while (bytesRead < (input.length - 1))
            {
                a = ASCompat.parseInt(input.charAt((bytesRead + 0)), 16);
                b = ASCompat.parseInt(input.charAt((bytesRead + 1)), 16);
                byte = ((a << 4) | b);
                buffer.writeByte(byte);
                bytesRead++;
                bytesRead++;
            }
            return buffer;
        }

        public static function BigIntegerToRadix(input:com.sulake.core.utils.ByteArray, _arg_2:UInt=16):String
        {
            return "";
        }

        public static function fletcher100(input:com.sulake.core.utils.ByteArray, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4= _arg_2;
            var _local_5= _arg_3;
            var counter = 0;
            while ((counter : UInt) < input.length)
            {
                _local_4 = ASCompat.toInt((_local_4 + input[counter]) % 0xFF);
                _local_5 = ((_local_4 + _local_5) % 0xFF);
                counter++;
            }
            return (_local_4 + _local_5) % 100;
        }

	public function new() {}
    }

