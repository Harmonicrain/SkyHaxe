package
{
    import com.hurlant.crypto.hash.MD5;
    import com.hurlant.util.Hex;
    import flash.desktop.NativeApplication;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;

    /** AIR/AVM2 reference for native E4X parsing of G3's real DefineBinaryData blobs. */
    public class G3XmlReference extends Sprite
    {
        private const BASE:String = "http://127.0.0.1:8773/";
        private var contract:Object;
        private var fileIndex:int;
        private var results:Array = [];
        private var swfLoader:Loader;

        public function G3XmlReference()
        {
            loadText(BASE + "fixtures/g3_xml_blob_contract.json", function(text:String):void
            {
                contract = JSON.parse(text);
                loadNext();
            });
        }

        private function loadNext():void
        {
            var files:Array = contract.files as Array;
            if (fileIndex >= files.length)
            {
                if (results.length != 25) fail("expected 25 XML captures, got " + results.length);
                postResult({compared: results.length, records: results});
                return;
            }
            var relative:String = files[fileIndex++];
            trace("G3_LOADING " + relative);
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
                swfLoader.contentLoaderInfo.uncaughtErrorEvents.addEventListener(
                    UncaughtErrorEvent.UNCAUGHT_ERROR, function(event:UncaughtErrorEvent):void
                    {
                        trace("G3_LOADED_SWF_UNCAUGHT " + event.error);
                        event.preventDefault();
                    });
                var context:LoaderContext = new LoaderContext(false,
                    new ApplicationDomain(ApplicationDomain.currentDomain));
                context.allowCodeImport = true;
                swfLoader.loadBytes(bytes, context);
            });
        }

        private function capture(relative:String, domain:ApplicationDomain):void
        {
            for each (var expected:Object in contract.records)
            {
                if (expected.file != relative) continue;
                if (!domain.hasDefinition(expected.symbol)) fail("missing " + expected.symbol);
                var type:Class = domain.getDefinition(expected.symbol) as Class;
                var bytes:ByteArray = new type() as ByteArray;
                if (bytes == null) fail(expected.symbol + " is not ByteArray");
                bytes.position = 0;
                var text:String = bytes.readUTFBytes(bytes.length);
                if (text.length > 0 && text.charCodeAt(0) == 0xFEFF) text = text.substr(1);
                while (text.length > 0 && text.charCodeAt(text.length - 1) == 0) text = text.substr(0, text.length - 1);
                var measured:Object = measure(new XML(text));
                measured.file = relative;
                measured.symbol = expected.symbol;
                results.push(measured);
            }
        }

        private function measure(root:XML):Object
        {
            var state:Object = {tokens: [], elements: 0, attributes: 0, text_nodes: 0,
                max_depth: 0, tag_counts: {}};
            visit(root, 0, state);
            var encoded:ByteArray = new ByteArray();
            encoded.writeUTFBytes(state.tokens.join("\n"));
            return {
                root: root.localName().toString(),
                elements: state.elements,
                attributes: state.attributes,
                text_nodes: state.text_nodes,
                max_depth: state.max_depth,
                tag_counts: state.tag_counts,
                canonical_md5: Hex.fromArray(new MD5().hash(encoded))
            };
        }

        private function visit(node:XML, depth:int, state:Object):void
        {
            var name:String = node.localName().toString();
            state.elements++;
            if (depth > state.max_depth) state.max_depth = depth;
            state.tag_counts[name] = int(state.tag_counts[name]) + 1;
            state.tokens.push("E:" + name);
            var attributes:Array = [];
            for each (var attribute:XML in node.attributes())
                attributes.push({name: attribute.name().toString(), value: attribute.toString()});
            attributes.sortOn("name");
            for each (var item:Object in attributes)
            {
                state.attributes++;
                state.tokens.push("A:" + item.name + "=" + item.value);
            }
            for each (var child:XML in node.children())
            {
                if (child.nodeKind() == "element") visit(child, depth + 1, state);
                else if (child.nodeKind() == "text")
                {
                    var value:String = child.toString().replace(/^\s+|\s+$/g, "");
                    if (value != "")
                    {
                        state.text_nodes++;
                        state.tokens.push("T:" + value);
                    }
                }
            }
            state.tokens.push("X:" + name);
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
                trace("G3_FLASH_XML_PASS compared=" + results.length);
                NativeApplication.nativeApplication.exit(0);
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR, onFailure);
            loader.load(request);
        }

        private function loadText(url:String, done:Function):void
        {
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, function(_:Event):void { done(String(loader.data)); });
            loader.addEventListener(IOErrorEvent.IO_ERROR, onFailure);
            loader.load(new URLRequest(url));
        }

        private function loadBytes(url:String, done:Function):void
        {
            var loader:URLLoader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(Event.COMPLETE, function(_:Event):void { done(loader.data as ByteArray); });
            loader.addEventListener(IOErrorEvent.IO_ERROR, onFailure);
            loader.load(new URLRequest(url));
        }

        private function onFailure(event:Event):void { fail(event.toString()); }
        private function fail(message:String):void
        {
            trace("G3_FLASH_XML_FAIL " + message);
            NativeApplication.nativeApplication.exit(2);
            throw new Error(message);
        }
    }
}
