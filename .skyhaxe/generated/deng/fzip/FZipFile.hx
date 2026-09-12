package deng.fzip
;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import deng.utils.ChecksumUtil;
    import flash.utils.IDataOutput;
    import flash.utils.IDataInput;
    import flash.utils.*;

     class FZipFile 
    {
        public static inline final _Str_2181= 0;
        public static inline final _Str_2161= 1;
        public static inline final COMPRESSION_REDUCED_1= 2;
        public static inline final COMPRESSION_REDUCED_2= 3;
        public static inline final COMPRESSION_REDUCED_3= 4;
        public static inline final COMPRESSION_REDUCED_4= 5;
        public static inline final _Str_1207= 6;
        public static inline final _Str_1340= 7;
        public static inline final _Str_1526= 8;
        public static inline final _Str_1967= 9;
        public static inline final _Str_1145= 10;
        static var _Str_1093:Bool = true;
        static var _Str_1969:Bool = true;

        var _Str_1418:Int = 0;
        var _Str_2025:String = "2.0";
        var _Str_1062:Int = 8;
        var _Str_1281:Bool = false;
        var _Str_2010:Int = -1;
        var _Str_1264:Int = -1;
        var _Str_2043:Int = -1;
        var _Str_1462:Bool = false;
        var _Str_1258:Bool = false;
        var _Str_1423:Date;
        var _Str_1598:UInt = 0;
        var _Str_1677:Bool = false;
        var _Str_2198:UInt = 0;
        var _Str_2179:UInt = 0;
        var _Str_1673:String = "";
        var _Str_1804:String;
        var _Str_1617:ASDictionary<ASAny,ASAny>;
        var _Str_2165:String = "";
        var _content:com.sulake.core.utils.ByteArray;
        @:allow(deng.fzip) var _Str_1235:UInt = 0;
        @:allow(deng.fzip) var _Str_1796:UInt = 0;
        @:allow(deng.fzip) var _Str_1623:UInt = 0;
        var _Str_1864:Bool = false;
        var _Str_675:ASFunction;

        public function new(k:String="utf-8")
        {
            this._Str_675 = this._Str_1727;
            this._Str_1804 = k;
            this._Str_1617 = new ASDictionary<ASAny,ASAny>();
            this._content = new com.sulake.core.utils.ByteArray();
            this._content.endian = Endian.BIG_ENDIAN;
        }

        
        public var date(get,set):Date;
public function  get_date():Date
        {
            return this._Str_1423;
        }
public function  set_date(k:Date):Date        {
            this._Str_1423 = ((k != null) ? k : Date.now());
return k;
        }

        
        public var filename(get,set):String;
public function  get_filename():String
        {
            return this._Str_1673;
        }
public function  set_filename(k:String):String        {
            return this._Str_1673 = k;
        }

        @:allow(deng.fzip) var _Str_1515(get,never):Bool;
function  get__Str_1515():Bool
        {
            return this._Str_1462;
        }

        
        public var content(get,set):com.sulake.core.utils.ByteArray;
public function  get_content():com.sulake.core.utils.ByteArray
        {
            if (this._Str_1864)
            {
                this.uncompress();
            }
            return this._content;
        }
public function  set_content(k:com.sulake.core.utils.ByteArray):com.sulake.core.utils.ByteArray        {
            this._Str_1657(k);
return k;
        }

        public function _Str_1657(k:com.sulake.core.utils.ByteArray, _arg_2:Bool=true)
        {
            if (((!(k == null)) && (k.length > 0)))
            {
                k.position = 0;
                k.readBytes(this._content, 0, k.length);
                this._Str_1235 = ChecksumUtil._Str_1999(this._content);
                this._Str_1677 = false;
            }
            else
            {
                this._content.length = 0;
                this._content.position = 0;
                this._Str_1864 = false;
            }
            if (_arg_2)
            {
                this.compress();
            }
            else
            {
                this._Str_1623 = (this._Str_1796 = this._content.length);
            }
        }

        public var _Str_1639(get,never):String;
public function  get__Str_1639():String
        {
            return this._Str_2025;
        }

        public var _Str_1508(get,never):UInt;
public function  get__Str_1508():UInt
        {
            return this._Str_1796;
        }

        public var _Str_1318(get,never):UInt;
public function  get__Str_1318():UInt
        {
            return this._Str_1623;
        }

        public function _Str_1112(k:Bool=true, _arg_2:String="utf-8"):String
        {
            var _local_3:String = null;
            if (this._Str_1864)
            {
                this.uncompress();
            }
            this._content.position = 0;
            if (_arg_2 == "utf-8")
            {
                _local_3 = this._content.readUTFBytes(this._content.bytesAvailable);
            }
            else
            {
                _local_3 = this._content.readMultiByte(this._content.bytesAvailable, _arg_2);
            }
            this._content.position = 0;
            if (k)
            {
                this.compress();
            }
            return _local_3;
        }

        public function _Str_1982(k:String, _arg_2:String="utf-8", _arg_3:Bool=true)
        {
            this._content.length = 0;
            this._content.position = 0;
            this._Str_1864 = false;
            if (((!(k == null)) && (k.length > 0)))
            {
                if (_arg_2 == "utf-8")
                {
                    this._content.writeUTFBytes(k);
                }
                else
                {
                    this._content.writeMultiByte(k, _arg_2);
                }
                this._Str_1235 = ChecksumUtil._Str_1999(this._content);
                this._Str_1677 = false;
            }
            if (_arg_3)
            {
                this.compress();
            }
            else
            {
                this._Str_1623 = (this._Str_1796 = this._content.length);
            }
        }

        public function _Str_1294(k:IDataOutput, _arg_2:Bool, _arg_3:Bool=false, _arg_4:UInt=0):UInt
        {
var _local_10:ASObject  = null;            var _local_10:ASObject = null;
            var _local_15:com.sulake.core.utils.ByteArray = null;
            var _local_16 = false;
            if (k == null)
            {
                return 0;
            }
            if (_arg_3)
            {
                k.writeUnsignedInt(FZip._Str_1517);
                k.writeShort(((this._Str_1418 << 8) | 0x14));
            }
            else
            {
                k.writeUnsignedInt(FZip._Str_1265);
            }
            k.writeShort(((this._Str_1418 << 8) | 0x14));
            k.writeShort(((this._Str_1804 == "utf-8") ? 0x0800 : 0));
            k.writeShort((this._Str_1864 ? _Str_1526 : _Str_2181));
            var _local_5= ((this._Str_1423 != null) ? this._Str_1423 : Date.now());
            var _local_6:UInt = ((ASCompat.toInt(ASCompat.toUInt(_local_5.getSeconds()) )| (ASCompat.toInt(ASCompat.toUInt(_local_5.getMinutes()) )<< 5)) | (ASCompat.toInt(ASCompat.toUInt(_local_5.getHours()) )<< 11));
            var _local_7:UInt = ((ASCompat.toInt(ASCompat.toUInt(_local_5.getDate()) )| (ASCompat.toInt(ASCompat.toUInt((_local_5.getMonth() + 1)) )<< 5)) | (ASCompat.toInt(ASCompat.toUInt((_local_5.getFullYear() - 1980)) )<< 9));
            k.writeShort(ASCompat.toInt(_local_6));
            k.writeShort(ASCompat.toInt(_local_7));
            k.writeUnsignedInt(this._Str_1235);
            k.writeUnsignedInt(this._Str_1796);
            k.writeUnsignedInt(this._Str_1623);
            var _local_8= new com.sulake.core.utils.ByteArray();
            _local_8.endian = Endian.LITTLE_ENDIAN;
            if (this._Str_1804 == "utf-8")
            {
                _local_8.writeUTFBytes(this._Str_1673);
            }
            else
            {
                _local_8.writeMultiByte(this._Str_1673, this._Str_1804);
            }
            var _local_9= _local_8.position;
            final _iter_ = this._Str_1617; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_10 = _tmp_;
                _local_15 = ASCompat.asByteArray(this._Str_1617[_local_10] );
                if (_local_15 != null)
                {
                    _local_8.writeShort(ASCompat.toInt(ASCompat.toUInt(_local_10)));
                    _local_8.writeShort(ASCompat.toInt(_local_15.length));
ASCompat.byteArrayWriteBytes(                    _local_8, _local_15);
                }
            }
            if (_arg_2)
            {
                if (!this._Str_1677)
                {
                    _local_16 = this._Str_1864;
                    if (_local_16)
                    {
                        this.uncompress();
                    }
                    this._Str_1598 = ChecksumUtil._Str_1386(this._content, 0, this._content.length);
                    this._Str_1677 = true;
                    if (_local_16)
                    {
                        this.compress();
                    }
                }
                _local_8.writeShort(0xDADA);
                _local_8.writeShort(4);
                _local_8.writeUnsignedInt(this._Str_1598);
            }
            var _local_11= (_local_8.position - _local_9);
            if ((_arg_3 && (this._Str_2165.length > 0)))
            {
                if (this._Str_1804 == "utf-8")
                {
                    _local_8.writeUTFBytes(this._Str_2165);
                }
                else
                {
                    _local_8.writeMultiByte(this._Str_2165, this._Str_1804);
                }
            }
            var _local_12= ((_local_8.position - _local_9) - _local_11);
            k.writeShort(ASCompat.toInt(_local_9));
            k.writeShort(ASCompat.toInt(_local_11));
            if (_arg_3)
            {
                k.writeShort(ASCompat.toInt(_local_12));
                k.writeShort(0);
                k.writeShort(0);
                k.writeUnsignedInt(0);
                k.writeUnsignedInt(_arg_4);
            }
            if (((_local_9 + _local_11) + _local_12) > 0)
            {
                k.writeBytes(_local_8);
            }
            var _local_13:UInt = 0;
            if (((!_arg_3) && (this._content.length > 0)))
            {
                if (this._Str_1864)
                {
                    if ((_Str_1093 || _Str_1969))
                    {
                        _local_13 = this._content.length;
                        k.writeBytes(this._content, 0, _local_13);
                    }
                    else
                    {
                        _local_13 = (this._content.length - 6);
                        k.writeBytes(this._content, 2, _local_13);
                    }
                }
                else
                {
                    _local_13 = this._content.length;
                    k.writeBytes(this._content, 0, _local_13);
                }
            }
            var _local_14= ((((30 + _local_9) + _local_11) + _local_12) + _local_13);
            if (_arg_3)
            {
                _local_14 = (_local_14 + 16);
            }
            return _local_14;
        }

        @:allow(deng.fzip) function parse(k:IDataInput):Bool
        {
            do 
            {
            } while (((k.bytesAvailable != 0) && ASCompat.toBool(this._Str_675(k))));
            return this._Str_675 == this._Str_1678;
        }

        function _Str_1678(k:IDataInput):Bool
        {
            return false;
        }

        function _Str_1727(k:IDataInput):Bool
        {
            if (k.bytesAvailable >= 30)
            {
                this._Str_1627(k);
                if ((this._Str_2198 + this._Str_2179) > 0)
                {
                    this._Str_675 = this._Str_1338;
                }
                else
                {
                    this._Str_675 = this._Str_1903;
                }
                return true;
            }
            return false;
        }

        function _Str_1338(k:IDataInput):Bool
        {
            if (k.bytesAvailable >= (this._Str_2198 + this._Str_2179))
            {
                this._Str_1589(k);
                this._Str_675 = this._Str_1903;
                return true;
            }
            return false;
        }

        function _Str_1903(k:IDataInput):Bool
        {
            var _local_2= true;
            if (this._Str_1462)
            {
                this._Str_675 = this._Str_1678;
                _local_2 = false;
            }
            else
            {
                if (this._Str_1796 == 0)
                {
                    this._Str_675 = this._Str_1678;
                }
                else
                {
                    if (k.bytesAvailable >= this._Str_1796)
                    {
                        this._Str_1308(k);
                        this._Str_675 = this._Str_1678;
                    }
                    else
                    {
                        _local_2 = false;
                    }
                }
            }
            return _local_2;
        }

        function _Str_1627(k:IDataInput)
        {
            var _local_2= k.readUnsignedShort();
            this._Str_1418 = (ASCompat.toInt(_local_2 )>> 8);
            this._Str_2025 = ((Std.string(Math.ffloor(((ASCompat.toInt(_local_2 )& 0xFF) / 10))) + ".") + Std.string((ASCompat.toInt(_local_2 )& 0xFF) % 10));
            var _local_3= k.readUnsignedShort();
            this._Str_1062 = ASCompat.toInt(k.readUnsignedShort());
            this._Str_1281 = (!((ASCompat.toInt(_local_3 )& 0x01) == 0));
            this._Str_1462 = (!((ASCompat.toInt(_local_3 )& 0x08) == 0));
            this._Str_1258 = (!((ASCompat.toInt(_local_3 )& 0x20) == 0));
            if ((ASCompat.toInt(_local_3 )& 0x0320) != 0)
            {
                this._Str_1804 = "utf-8";
            }
            if (this._Str_1062 == _Str_1207)
            {
                this._Str_2010 = (((ASCompat.toInt(_local_3 )& 0x02) != 0) ? 0x2000 : 0x1000);
                this._Str_1264 = (((ASCompat.toInt(_local_3 )& 0x04) != 0) ? 3 : 2);
            }
            else
            {
                if (this._Str_1062 == _Str_1526)
                {
                    this._Str_2043 = ((ASCompat.toInt(_local_3 )& 0x06) >> 1);
                }
            }
            var _local_4= k.readUnsignedShort();
            var _local_5= k.readUnsignedShort();
            var _local_6:ASAny = (ASCompat.toInt(_local_4 )& 0x1F);
            var _local_7:ASAny = ((ASCompat.toInt(_local_4 )& 0x07E0) >> 5);
            var _local_8:ASAny = ((ASCompat.toInt(_local_4 )& 0xF800) >> 11);
            var _local_9:ASAny = (ASCompat.toInt(_local_5 )& 0x1F);
            var _local_10:ASAny = ((ASCompat.toInt(_local_5 )& 0x01E0) >> 5);
            var _local_11= (((ASCompat.toInt(_local_5 )& 0xFE00) >> 9) + 1980);
            this._Str_1423 = ASCompat.newDateWithMilliseconds(_local_11, (ASCompat.toNumber(_local_10) - 1), _local_9, _local_8, _local_7, _local_6, 0);
            this._Str_1235 = k.readUnsignedInt();
            this._Str_1796 = k.readUnsignedInt();
            this._Str_1623 = k.readUnsignedInt();
            this._Str_2198 = k.readUnsignedShort();
            this._Str_2179 = k.readUnsignedShort();
        }

        function _Str_1589(k:IDataInput)
        {
            var _local_3:UInt = 0;
            var _local_4:UInt = 0;
            var _local_5:com.sulake.core.utils.ByteArray = null;
            if (this._Str_1804 == "utf-8")
            {
                this._Str_1673 = k.readUTFBytes(this._Str_2198);
            }
            else
            {
                this._Str_1673 = k.readMultiByte(this._Str_2198, this._Str_1804);
            }
            var _local_2= this._Str_2179;
            while (_local_2 > 4)
            {
                _local_3 = k.readUnsignedShort();
                _local_4 = k.readUnsignedShort();
                if (_local_4 > _local_2)
                {
                    throw new ASError((("Parse error in file " + this._Str_1673) + ": Extra field data size too big."));
                }
                if (((_local_3 == 0xDADA) && (_local_4 == 4)))
                {
                    this._Str_1598 = k.readUnsignedInt();
                    this._Str_1677 = true;
                }
                else
                {
                    if (_local_4 > 0)
                    {
                        _local_5 = new com.sulake.core.utils.ByteArray();
                        k.readBytes(_local_5, 0, _local_4);
                        this._Str_1617[_local_3] = _local_5;
                    }
                }
                _local_2 = (_local_2 - (_local_4 + 4));
            }
            if (_local_2 > 0)
            {
                k.readBytes(new com.sulake.core.utils.ByteArray(), 0, _local_2);
            }
        }

        @:allow(deng.fzip) function _Str_1308(k:IDataInput)
        {
            var _local_2:UInt = 0;
            if (((this._Str_1062 == _Str_1526) && (!this._Str_1281)))
            {
                if ((_Str_1093 || _Str_1969))
                {
                    k.readBytes(this._content, 0, this._Str_1796);
                }
                else
                {
                    if (this._Str_1677)
                    {
                        this._content.writeByte(120);
                        _local_2 = (((~this._Str_2043) << 6) & 0xC0);
                        _local_2 = (_local_2 + (31 - (((120 << 8) | ASCompat.toInt(_local_2)) % 31)));
                        this._content.writeByte(ASCompat.toInt(_local_2));
                        k.readBytes(this._content, 2, this._Str_1796);
                        this._content.position = this._content.length;
                        this._content.writeUnsignedInt(this._Str_1598);
                    }
                    else
                    {
                        throw new ASError("Adler32 checksum not found.");
                    }
                }
                this._Str_1864 = true;
            }
            else
            {
                if (this._Str_1062 == _Str_2181)
                {
                    k.readBytes(this._content, 0, this._Str_1796);
                    this._Str_1864 = false;
                }
                else
                {
                    throw new ASError((("Compression method " + Std.string(this._Str_1062)) + " is not supported."));
                }
            }
            this._content.position = 0;
        }

        function compress()
        {
            if (!this._Str_1864)
            {
                if (this._content.length > 0)
                {
                    this._content.position = 0;
                    this._Str_1623 = this._content.length;
                    if (_Str_1969)
                    {
                        this._content.deflate();
                        this._Str_1796 = this._content.length;
                    }
                    else
                    {
                        if (_Str_1093)
                        {
                            Reflect.callMethod(this._content, this._content.compress, (["deflate"] : Array<Dynamic>));
                            this._Str_1796 = this._content.length;
                        }
                        else
                        {
                            this._content.compress();
                            this._Str_1796 = (this._content.length - 6);
                        }
                    }
                    this._content.position = 0;
                    this._Str_1864 = true;
                }
                else
                {
                    this._Str_1796 = 0;
                    this._Str_1623 = 0;
                }
            }
        }

        function uncompress()
        {
            if ((this._Str_1864 && (this._content.length > 0)))
            {
                this._content.position = 0;
                if (_Str_1969)
                {
                    this._content.inflate();
                }
                else
                {
                    if (_Str_1093)
                    {
                        Reflect.callMethod(this._content, this._content.uncompress, (["deflate"] : Array<Dynamic>));
                    }
                    else
                    {
                        this._content.uncompress();
                    }
                }
                this._content.position = 0;
                this._Str_1864 = false;
            }
        }

        public function toString():String
        {
            return ((((((((((((((((((((((((("[FZipFile]" + "\n  name:") + this._Str_1673) + "\n  date:") + this._Str_1423) + "\n  sizeCompressed:") + Std.string(this._Str_1796)) + "\n  sizeUncompressed:") + Std.string(this._Str_1623)) + "\n  versionHost:") + Std.string(this._Str_1418)) + "\n  versionNumber:") + this._Str_2025) + "\n  compressionMethod:") + Std.string(this._Str_1062)) + "\n  encrypted:") + Std.string(this._Str_1281)) + "\n  hasDataDescriptor:") + Std.string(this._Str_1462)) + "\n  hasCompressedPatchedData:") + Std.string(this._Str_1258)) + "\n  filenameEncoding:") + this._Str_1804) + "\n  crc32:") + ASCompat.toRadix(this._Str_1235, 16)) + "\n  adler32:") + ASCompat.toRadix(this._Str_1598, 16);
        }
    }

