package com.probertson.utils
;
    import flash.utils.ByteArray;

     class CRC32Generator 
    {
        static var _crcTable:Array<ASAny>;
        static var _tableComputed:Bool = false;


        static function makeCRCTable()
        {
var i = 0, j = 0;            _crcTable = ASCompat.allocArray(256);
			var val:UInt = 0;
			for (_tmp_ in 0...256)
			{
i= _tmp_;
				val = i;
				for (_tmp_ in 0...8)
				{
j= _tmp_;
					if ((ASCompat.toInt(val )& 1) != 0)
					{
						val = ASCompat.toInt(0xedb88320 )^ (ASCompat.toInt(val )>>> 1);
					}
					else
					{
						val = ASCompat.toInt(val )>>> 1;
					}
				}
				_crcTable[i] = val;
			}
			_tableComputed = true;
        }


        public function generateCRC32(buffer:com.sulake.core.utils.ByteArray):UInt
        {
var i = 0;            if (!_tableComputed)
			{
				makeCRCTable();
			}
			var result:UInt = ~0;
			var len= ASCompat.toInt(buffer.length);
			for (_tmp_ in 0...len)
			{
i= _tmp_;
				result = ASCompat.toInt(_crcTable[(ASCompat.toInt(result )^ ASCompat.toInt(buffer[i])) & 0xff] )^ (ASCompat.toInt(result )>>> 8);
			}
			result = ~ASCompat.toInt(result);
			
			return (ASCompat.toInt(result )& ASCompat.toInt(0xffffffff));
        }
public function new(){}
    }

