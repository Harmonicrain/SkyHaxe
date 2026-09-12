package com.sulake.core.assets.loaders
;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import flash.events.Event;
    import com.probertson.utils.GZIPBytesEncoder;

     class TextFileLoader extends BinaryFileLoader implements IAssetLoader 
    {
        public function new(type:String, urlRequest:URLRequest=null, cacheKey:String=null, cacheRevision:Int=-1, buffer:com.sulake.core.utils.ByteArray=null, id:Int=-1)
        {
            super(type, urlRequest, cacheKey, cacheRevision, buffer, id);
        }

        override function retry():Bool
        {
            if (!_disposed)
            {
                if (++_retries <= _attempts)
                {
                    try
                    {
                        _loader.close();
                    }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                     {
                    }
 }                    _loader.load(new URLRequest((((_url + ((_url.indexOf("?") == -1) ? "?" : "&")) + "retry=") + Std.string(_retries))));
                    return true;
                }
            }
            return false;
        }

        override function loadEventHandler(event:Event)
        {
            if (event.type == Event.COMPLETE)
            {
                this.unCompress();
            }
            super.loadEventHandler(event);
        }

        function unCompress()
        {
var byteArray:com.sulake.core.utils.ByteArray  = null, encoder:GZIPBytesEncoder  = null;            var data= "";
            if (ASCompat.isByteArray(_loader.data ))
            {
byteArray= ASCompat.asByteArray(_loader.data );
                if (byteArray.length == 0)
                {
                    data = "";
                }
                else
                {
                    try
                    {
encoder= new GZIPBytesEncoder();
                        data = encoder.uncompressToByteArray(byteArray).toString();
                    }
                    catch(error:flash.errors.IllegalOperationError)
                    {
                        byteArray.position = 0;
                        data = byteArray.readUTFBytes(byteArray.length);
                    }
                }
                byteArray.clear();
            }
            else
            {
                data = ASCompat.asString(_loader.data );
            }
            _loader.data = data;
        }
    }

