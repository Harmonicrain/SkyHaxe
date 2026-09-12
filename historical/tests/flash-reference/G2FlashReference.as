package
{
    import com.hurlant.crypto.hash.MD5;
    import com.hurlant.util.Hex;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.desktop.NativeApplication;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;
    import flash.utils.getQualifiedClassName;

    /** Independent AIR/Flash runtime capture for G2e. */
    public class G2FlashReference extends Sprite
    {
        private const BASE:String = "http://127.0.0.1:8770/";
        private const FILES:Array = [
            "dcr/hof_furni/15pillow.swf",
            "dcr/hof_furni/01_dragonlamp_skream.swf",
            "dcr/hof_furni/vip_sof5.swf"
        ];

        private var contract:Object;
        private var fileIndex:int;
        private var results:Array = [];
        private var swfLoader:Loader;

        public function G2FlashReference()
        {
            loadText(BASE + "fixtures/g2_reader_contract.json", onContract);
        }

        private function onContract(text:String):void
        {
            contract = JSON.parse(text);
            loadNext();
        }

        private function loadNext():void
        {
            if (results.length >= 20 || fileIndex >= FILES.length)
            {
                if (results.length != 20) fail("expected 20 bitmap captures, got " + results.length);
                postResult({compared: results.length, assets: results});
                return;
            }
            var relative:String = FILES[fileIndex++];
            loadBytes(BASE + "ngh/" + relative, function(bytes:ByteArray):void
            {
                swfLoader = new Loader();
                swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(_:Event):void
                {
                    capture(relative, swfLoader.contentLoaderInfo.applicationDomain);
                    swfLoader.unload();
                    swfLoader = null;
                    loadNext();
                });
                swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onFailure);
                swfLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFailure);
                var context:LoaderContext = new LoaderContext(false,
                    new ApplicationDomain(ApplicationDomain.currentDomain));
                context.allowCodeImport = true;
                swfLoader.loadBytes(bytes, context);
            });
        }

        private function capture(relative:String, domain:ApplicationDomain):void
        {
            var symbols:Array = contract.files[relative].symbols as Array;
            for each (var symbol:Object in symbols)
            {
                if (results.length >= 20) return;
                if (symbol.kind != "bitmap" || symbol.encoding != "zlib") continue;
                if (!domain.hasDefinition(symbol.name)) fail("missing Flash definition " + symbol.name);
                var type:Class = domain.getDefinition(symbol.name) as Class;
                var bitmap:BitmapData;
                var instance:Object;
                try { instance = new type(0, 0); }
                catch (_:Error) { instance = new type(); }
                if (instance is BitmapData) bitmap = instance as BitmapData;
                else if (instance is Bitmap) bitmap = Bitmap(instance).bitmapData;
                if (bitmap == null) fail(symbol.name + " instantiated as "
                    + getQualifiedClassName(instance) + ", not BitmapData/Bitmap");
                var rgba:ByteArray = new ByteArray();
                for (var y:int = 0; y < bitmap.height; y++)
                {
                    for (var x:int = 0; x < bitmap.width; x++)
                    {
                        var pixel:uint = bitmap.getPixel32(x, y);
                        rgba.writeByte((pixel >>> 16) & 0xFF);
                        rgba.writeByte((pixel >>> 8) & 0xFF);
                        rgba.writeByte(pixel & 0xFF);
                        rgba.writeByte((pixel >>> 24) & 0xFF);
                    }
                }
                var md5:String = Hex.fromArray(new MD5().hash(rgba));
                results.push({file: relative, name: symbol.name, width: bitmap.width,
                    height: bitmap.height, rgba_md5: md5});
                bitmap.dispose();
            }
        }

        private function loadText(url:String, done:Function):void
        {
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, function(_:Event):void { done(String(loader.data)); });
            loader.addEventListener(IOErrorEvent.IO_ERROR, onFailure);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFailure);
            loader.load(new URLRequest(url));
        }

        private function loadBytes(url:String, done:Function):void
        {
            var loader:URLLoader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(Event.COMPLETE, function(_:Event):void { done(loader.data as ByteArray); });
            loader.addEventListener(IOErrorEvent.IO_ERROR, onFailure);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFailure);
            loader.load(new URLRequest(url));
        }

        private function postResult(value:Object):void
        {
            var request:URLRequest = new URLRequest(BASE + "flash-result");
            request.method = URLRequestMethod.POST;
            request.contentType = "application/json";
            request.data = JSON.stringify(value);
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, function(_:Event):void
            {
                trace("G2_FLASH_REFERENCE_PASS compared=" + results.length);
                NativeApplication.nativeApplication.exit(0);
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR, onFailure);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFailure);
            loader.load(request);
        }

        private function onFailure(event:Event):void { fail(event.toString()); }

        private function fail(message:String):void
        {
            trace("G2_FLASH_REFERENCE_FAIL " + message);
            NativeApplication.nativeApplication.exit(2);
            throw new Error(message);
        }
    }
}
