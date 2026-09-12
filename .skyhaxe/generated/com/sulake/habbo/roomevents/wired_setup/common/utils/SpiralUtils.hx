package com.sulake.habbo.roomevents.wired_setup.common.utils
;
    import flash.utils.ByteArray;
    import flash.utils.Endian;

     class SpiralUtils
    {
        public static function parseSpiralVector(values:Array<ASAny>, radius:Int):Array<ASAny>
        {
var x = 0, y = 0, cell:ASObject  = null;            var mask= intParamsToBoolMask(values);
            var dimension= radius * 2 + 1;
            var floor:Array<ASAny> = [];
            for (_tmp_ in 0...dimension)
            {
x= _tmp_;
                floor[x] = ([] : Array<Dynamic>);
                for (_tmp_ in 0...dimension) {y= _tmp_;
floor[x][y] = false;
};
            }
            final _iter_ = walkSpiral(radius); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
cell = _tmp_;
                if (cell.rank < mask.length && ASCompat.toBool(mask[ASCompat.toInt(cell.rank)]))
                {
                    floor[ASCompat.toInt(cell.x + radius)][cell.y + radius] = true;
                }
            }
            return floor;
        }

        public static function createSpiralVector(floor:Array<ASAny>, radius:Int):Array<ASAny>
        {
var             i = 0, cell:ASObject  = null;            var dimension= radius * 2 + 1;
            var mask:Array<ASAny> = [];
            i= 0;while (i < dimension * dimension) {mask.push(false);
i++;
};
            final _iter_ = walkSpiral(radius); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
cell = _tmp_;
                if (floor[ASCompat.toInt(cell.x + radius)][cell.y + radius]) mask[ASCompat.toInt(cell.rank)] = true;
            }
            return boolMaskToIntParams(mask);
        }

        static function walkSpiral(radius:Int):Array<ASAny>
        {
var runLength = 0, turn = 0, step = 0;            var dimension= radius * 2 + 1;
            var count= dimension * dimension;
            var result:Array<ASAny> = [];
            var rank= 0;
            var x= 0;
            var y= 0;
            var direction:Array<ASAny> = [1, 0];
            for (_tmp_ in 1...dimension + 1)
            {
runLength= _tmp_;
                for (_tmp_ in 0...2)
                {
turn= _tmp_;
                    for (_tmp_ in 0...runLength)
                    {
step= _tmp_;
                        result.push({rank:rank, x:x, y:y});
                        x += ASCompat.toInt(direction[0]);
                        y += ASCompat.toInt(direction[1]);
                        rank++;
                        if (rank == count) return result;
                    }
                    direction = nextDirection(direction);
                }
            }
            return result;
        }

        static function nextDirection(direction:Array<ASAny>):Array<ASAny>
        {
            if (direction[0] == 0 && direction[1] == -1) return [-1, 0];
            if (direction[0] == 1 && direction[1] == 0) return [0, -1];
            if (direction[0] == 0 && direction[1] == 1) return [1, 0];
            return [0, 1];
        }

        static function intParamsToBoolMask(values:Array<ASAny>):Array<ASAny>
        {
var value = 0, octet = 0, bit = 0;            var bytes= new com.sulake.core.utils.ByteArray();
            bytes.endian = Endian.LITTLE_ENDIAN;
            if (checkNullIteratee(values)) for (_tmp_ in values) {value = ASCompat.toInt(_tmp_);
bytes.writeInt(value);
};
            bytes.position = 0;
            var result:Array<ASAny> = [];
            while (bytes.bytesAvailable != 0)
            {
octet= bytes.readByte();
                for (_tmp_ in 0...8) {bit= _tmp_;
result.push((octet & (1 << bit)) > 0);
};
            }
            return result;
        }

        static function boolMaskToIntParams(mask:Array<ASAny>):Array<ASAny>
        {
var byteIndex = 0, octet = 0, bit = 0;            var bytes= new com.sulake.core.utils.ByteArray();
            bytes.endian = Endian.LITTLE_ENDIAN;
            var index= 0;
            while (index < mask.length)
            {
                for (_tmp_ in 0...4)
                {
byteIndex= _tmp_;
octet= 0;
                    for (_tmp_ in 0...8)
                    {
bit= _tmp_;
                        if (index < mask.length && ASCompat.toBool(mask[index])) octet |= 1 << bit;
                        index++;
                    }
                    bytes.writeByte(octet);
                }
            }
            bytes.position = 0;
            var result:Array<ASAny> = [];
            while (bytes.bytesAvailable >= 4) result.push(bytes.readInt());
            return result;
        }

	public function new() {}
    }

