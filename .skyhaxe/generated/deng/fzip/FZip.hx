package deng.fzip
;
    import flash.events.EventDispatcher;
    import flash.net.URLStream;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.utils.IDataOutput;
    import flash.utils.IDataInput;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.ProgressEvent;
    import flash.utils.*;
    import flash.events.*;

     class FZip extends EventDispatcher 
    {
        @:allow(deng.fzip) static inline final _Str_1517:UInt = 33639248;
        @:allow(deng.fzip) static inline final _Str_2215:UInt = 808471376;
        @:allow(deng.fzip) static inline final _Str_1265:UInt = 67324752;
        @:allow(deng.fzip) static inline final _Str_2045:UInt = 84233040;
        @:allow(deng.fzip) static inline final _Str_1758:UInt = 101010256;
        @:allow(deng.fzip) static inline final SIG_ZIP64_END_OF_CENTRAL_DIRECTORY:UInt = 101075792;
        @:allow(deng.fzip) static inline final SIG_ZIP64_END_OF_CENTRAL_DIRECTORY_LOCATOR:UInt = 117853008;
        @:allow(deng.fzip) static inline final _Str_1548:UInt = 134695760;
        @:allow(deng.fzip) static inline final _Str_1224:UInt = 134630224;
        @:allow(deng.fzip) static inline final _Str_1080:UInt = 134695760;

        var _Str_1974:Array<ASAny>;
        var _Str_1485:ASDictionary<ASAny,ASAny>;
        var _Str_1578:URLStream;
        var _Str_1902:String;
        var _Str_675:ASFunction;
        var _Str_1618:FZipFile;
        var _Str_2114:com.sulake.core.utils.ByteArray;
        var _Str_2253:UInt = 0;
        var _Str_1831:UInt = 0;

        public function new(k:String="utf-8")
        {
            super();
            this._Str_1902 = k;
            this._Str_675 = this._Str_1922;
        }

        public var active(get,never):Bool;
public function  get_active():Bool
        {
            return !(this._Str_675 == this._Str_1922);
        }

        public function load(k:URLRequest)
        {
            if (((!(this._Str_1578 != null)) && (this._Str_675 == this._Str_1922)))
            {
                this._Str_1578 = new URLStream();
                this._Str_1578.endian = Endian.LITTLE_ENDIAN;
                this._Str_1740();
                this._Str_1974 = [];
                this._Str_1485 = new ASDictionary<ASAny,ASAny>();
                this._Str_675 = this._Str_1084;
                this._Str_1578.load(k);
            }
        }

        public function loadBytes(k:com.sulake.core.utils.ByteArray)
        {
            if (((!(this._Str_1578 != null)) && (this._Str_675 == this._Str_1922)))
            {
                this._Str_1974 = [];
                this._Str_1485 = new ASDictionary<ASAny,ASAny>();
                k.position = 0;
                k.endian = Endian.LITTLE_ENDIAN;
                this._Str_675 = this._Str_1084;
                if (this.parse(k))
                {
                    this._Str_675 = this._Str_1922;
                    dispatchEvent(new Event(Event.COMPLETE));
                }
                else
                {
                    dispatchEvent(new _Str_897(_Str_897.PARSEERROR, "EOF"));
                }
            }
        }

        public function close()
        {
            if (this._Str_1578 != null)
            {
                this._Str_675 = this._Str_1922;
                this._Str_2076();
                this._Str_1578.close();
                this._Str_1578 = null;
            }
        }

        public function _Str_1294(k:IDataOutput, _arg_2:Bool=false)
        {
            var _local_3:String = null;
            var _local_4:com.sulake.core.utils.ByteArray = null;
            var _local_5:UInt = 0;
            var _local_6:UInt = 0;
            var _local_7 = 0;
            var _local_8:FZipFile = null;
            if (((!(k == null)) && (this._Str_1974.length > 0)))
            {
                _local_3 = k.endian;
                _local_4 = new com.sulake.core.utils.ByteArray();
                k.endian = (_local_4.endian = Endian.LITTLE_ENDIAN);
                _local_5 = 0;
                _local_6 = 0;
                _local_7 = 0;
                while (_local_7 < this._Str_1974.length)
                {
                    _local_8 = ASCompat.dynamicAs(this._Str_1974[_local_7] , FZipFile);
                    if (_local_8 != null)
                    {
                        _local_8._Str_1294(_local_4, _arg_2, true, _local_5);
                        _local_5 = (_local_5 + _local_8._Str_1294(k, _arg_2));
                        _local_6++;
                    }
                    _local_7++;
                }
                if (_local_4.length > 0)
                {
                    k.writeBytes(_local_4);
                }
                k.writeUnsignedInt(_Str_1758);
                k.writeShort(0);
                k.writeShort(0);
                k.writeShort(ASCompat.toInt(_local_6));
                k.writeShort(ASCompat.toInt(_local_6));
                k.writeUnsignedInt(_local_4.length);
                k.writeUnsignedInt(_local_5);
                k.writeShort(0);
                k.endian = _local_3;
            }
        }

        public function _Str_1455():UInt
        {
            return (this._Str_1974 != null) ? this._Str_1974.length : 0;
        }

        public function _Str_1988(k:UInt):FZipFile
        {
            return (this._Str_1974 != null) ? ASCompat.dynamicAs(this._Str_1974[ASCompat.toInt(k)] , FZipFile) : null;
        }

        public function _Str_1843(k:String):FZipFile
        {
            return this._Str_1485[k] ? ASCompat.dynamicAs(this._Str_1485[k] , FZipFile) : null;
        }

        public function _Str_2254(k:String, _arg_2:com.sulake.core.utils.ByteArray=null, _arg_3:Bool=true):FZipFile
        {
            return this._Str_2171(((this._Str_1974 != null) ? this._Str_1974.length : 0), k, _arg_2, _arg_3);
        }

        public function _Str_1432(k:String, _arg_2:String, _arg_3:String="utf-8", _arg_4:Bool=true):FZipFile
        {
            return this._Str_2177(((this._Str_1974 != null) ? this._Str_1974.length : 0), k, _arg_2, _arg_3, _arg_4);
        }

        public function _Str_2171(k:UInt, _arg_2:String, _arg_3:com.sulake.core.utils.ByteArray=null, _arg_4:Bool=true):FZipFile
        {
            if (this._Str_1974 == null)
            {
                this._Str_1974 = [];
            }
            if (this._Str_1485 == null)
            {
                this._Str_1485 = new ASDictionary<ASAny,ASAny>();
            }
            else
            {
                if (this._Str_1485[_arg_2])
                {
                    throw new ASError((("File already exists: " + _arg_2) + ". Please remove first."));
                }
            }
            var _local_5= new FZipFile();
            _local_5.filename = _arg_2;
            _local_5._Str_1657(_arg_3, _arg_4);
            if (k >= (this._Str_1974.length : UInt))
            {
                this._Str_1974.push(_local_5);
            }
            else
            {
                this._Str_1974.insert(ASCompat.toInt(k), _local_5);
            }
            this._Str_1485[_arg_2] = _local_5;
            return _local_5;
        }

        public function _Str_2177(k:UInt, _arg_2:String, _arg_3:String, _arg_4:String="utf-8", _arg_5:Bool=true):FZipFile
        {
            if (this._Str_1974 == null)
            {
                this._Str_1974 = [];
            }
            if (this._Str_1485 == null)
            {
                this._Str_1485 = new ASDictionary<ASAny,ASAny>();
            }
            else
            {
                if (this._Str_1485[_arg_2])
                {
                    throw new ASError((("File already exists: " + _arg_2) + ". Please remove first."));
                }
            }
            var _local_6= new FZipFile();
            _local_6.filename = _arg_2;
            _local_6._Str_1982(_arg_3, _arg_4, _arg_5);
            if (k >= (this._Str_1974.length : UInt))
            {
                this._Str_1974.push(_local_6);
            }
            else
            {
                this._Str_1974.insert(ASCompat.toInt(k), _local_6);
            }
            this._Str_1485[_arg_2] = _local_6;
            return _local_6;
        }

        public function _Str_1950(k:UInt):FZipFile
        {
            var _local_2:FZipFile = null;
            if ((((!(this._Str_1974 == null)) && (!(this._Str_1485 == null))) && (k < (this._Str_1974.length : UInt))))
            {
                _local_2 = ASCompat.dynamicAs(this._Str_1974[ASCompat.toInt(k)] , FZipFile);
                if (_local_2 != null)
                {
                    this._Str_1974.splice(ASCompat.toInt(k), 1);
                    this._Str_1485.remove(_local_2.filename);
                    return _local_2;
                }
            }
            return null;
        }

        function parse(k:IDataInput):Bool
        {
            do 
            {
            } while (this._Str_675(k));
            return this._Str_675 == this._Str_1922;
        }

        function _Str_1922(k:IDataInput):Bool
        {
            return false;
        }

        function _Str_1084(k:IDataInput):Bool
        {
            var _local_2:UInt = 0;
            if (k.bytesAvailable >= 4)
            {
                _local_2 = k.readUnsignedInt();
                switch (_local_2)
                {
                    case _Str_1265:
                        this._Str_675 = this._Str_2081;
                        this._Str_1618 = new FZipFile(this._Str_1902);
                        
                    case _Str_1517
                       | _Str_1758
                       | _Str_2215
                       | _Str_2045
                       | SIG_ZIP64_END_OF_CENTRAL_DIRECTORY
                       | SIG_ZIP64_END_OF_CENTRAL_DIRECTORY_LOCATOR
                       | _Str_1548
                       | _Str_1224
                       | _Str_1080:
                        this._Str_675 = this._Str_1922;
                        
                    default:
                        throw new ASError(("Unknown record signature: 0x" + ASCompat.toRadix(_local_2, 16)));
                }
                return true;
            }
            return false;
        }

        function _Str_2081(k:IDataInput):Bool
        {
            if (this._Str_1618.parse(k))
            {
                if (this._Str_1618._Str_1515)
                {
                    this._Str_675 = this._Str_1551;
                    this._Str_2114 = new com.sulake.core.utils.ByteArray();
                    this._Str_2253 = 0;
                    this._Str_1831 = 0;
                    return true;
                }
                this._Str_1838();
                if (this._Str_675 != this._Str_1922)
                {
                    this._Str_675 = this._Str_1084;
                    return true;
                }
            }
            return false;
        }

        function _Str_1551(k:IDataInput):Bool
        {
            var _local_2:UInt = 0;
            while (k.bytesAvailable > 0)
            {
                _local_2 = k.readUnsignedByte();
                this._Str_2253 = ((ASCompat.toInt(this._Str_2253 )>>> 8) | (ASCompat.toInt(_local_2 )<< 24));
                if (this._Str_2253 == _Str_1548)
                {
                    this._Str_2114.length = (this._Str_2114.length - 3);
                    this._Str_675 = this._Str_2151;
                    return true;
                }
                this._Str_2114.writeByte(ASCompat.toInt(_local_2));
            }
            return false;
        }

        function _Str_2151(k:IDataInput):Bool
        {
            var _local_2:UInt = 0;
            var _local_3:UInt = 0;
            var _local_4:UInt = 0;
            if (k.bytesAvailable >= 12)
            {
                _local_2 = k.readUnsignedInt();
                _local_3 = k.readUnsignedInt();
                _local_4 = k.readUnsignedInt();
                if (this._Str_2114.length == _local_3)
                {
                    this._Str_2114.position = 0;
                    this._Str_1618._Str_1235 = _local_2;
                    this._Str_1618._Str_1796 = _local_3;
                    this._Str_1618._Str_1623 = _local_4;
                    this._Str_1618._Str_1308(this._Str_2114);
                    this._Str_1838();
                    this._Str_675 = this._Str_1084;
                }
                else
                {
                    this._Str_2114.writeUnsignedInt(_local_2);
                    this._Str_2114.writeUnsignedInt(_local_3);
                    this._Str_2114.writeUnsignedInt(_local_4);
                    this._Str_675 = this._Str_1551;
                }
                return true;
            }
            return false;
        }

        function _Str_1838()
        {
            this._Str_1974.push(this._Str_1618);
            if (ASCompat.stringAsBool(this._Str_1618.filename))
            {
                this._Str_1485[this._Str_1618.filename] = this._Str_1618;
            }
            dispatchEvent(new _Str_661(_Str_661.FILELOADED, this._Str_1618));
            this._Str_1618 = null;
        }

        function _Str_2036(evt:Event)
        {
            dispatchEvent(evt.clone());
            try
            {
                if (this.parse(this._Str_1578))
                {
                    this.close();
                    dispatchEvent(new Event(Event.COMPLETE));
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                close();
                if (hasEventListener(_Str_897.PARSEERROR))
                {
                    dispatchEvent(new _Str_897(_Str_897.PARSEERROR, e.message));
                }
            }
 }        }

        function _Str_1189(k:Event)
        {
            dispatchEvent(k.clone());
        }

        function _Str_2255(k:Event)
        {
            this.close();
            dispatchEvent(k.clone());
        }

        function _Str_1740()
        {
            this._Str_1578.addEventListener(Event.COMPLETE, (this._Str_1189 : ASAny));
            this._Str_1578.addEventListener(Event.OPEN, (this._Str_1189 : ASAny));
            this._Str_1578.addEventListener(HTTPStatusEvent.HTTP_STATUS, (this._Str_1189 : ASAny));
            this._Str_1578.addEventListener(IOErrorEvent.IO_ERROR, (this._Str_2255 : ASAny));
            this._Str_1578.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (this._Str_2255 : ASAny));
            this._Str_1578.addEventListener(ProgressEvent.PROGRESS, (this._Str_2036 : ASAny));
        }

        function _Str_2076()
        {
            this._Str_1578.removeEventListener(Event.COMPLETE, (this._Str_1189 : ASAny));
            this._Str_1578.removeEventListener(Event.OPEN, (this._Str_1189 : ASAny));
            this._Str_1578.removeEventListener(HTTPStatusEvent.HTTP_STATUS, (this._Str_1189 : ASAny));
            this._Str_1578.removeEventListener(IOErrorEvent.IO_ERROR, (this._Str_2255 : ASAny));
            this._Str_1578.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, (this._Str_2255 : ASAny));
            this._Str_1578.removeEventListener(ProgressEvent.PROGRESS, (this._Str_2036 : ASAny));
        }
    }

