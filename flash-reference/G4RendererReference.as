package
{
    import com.sulake.room.renderer.utils.ExtendedSprite;
    import flash.desktop.NativeApplication;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;

    /** Native Flash display-list reference for G4's deterministic compositor scene. */
    public class G4RendererReference extends Sprite
    {
        private const BASE:String = "http://127.0.0.1:8774/";
        private var frames:int;

        public function G4RendererReference()
        {
            addEventListener(Event.ENTER_FRAME, onFrame);
        }

        private function onFrame(_:Event):void
        {
            if (++frames < 2) return;
            removeEventListener(Event.ENTER_FRAME, onFrame);
            try { capture(); }
            catch (error:Error) { fail(error.message); }
        }

        private function capture():void
        {
            var thresholdData:BitmapData = new BitmapData(4, 4, true, 0);
            thresholdData.setPixel32(0, 1, 0x7FFFFFFF);
            thresholdData.setPixel32(1, 1, 0x80FFFFFF);
            thresholdData.setPixel32(2, 1, 0x81FFFFFF);
            var threshold:ExtendedSprite = new ExtendedSprite();
            threshold.bitmapData = thresholdData;
            threshold.alphaTolerance = 128;

            var master:Sprite = new Sprite();
            var display:Sprite = new Sprite();
            master.addChild(display);
            var mask:Sprite = new Sprite();
            mask.graphics.beginFill(0);
            mask.graphics.drawRect(0, 0, 3, 3);
            mask.graphics.endFill();
            master.addChild(mask);
            display.mask = mask;

            var back:ExtendedSprite = new ExtendedSprite();
            back.identifier = "exact-back";
            back.bitmapData = new BitmapData(4, 4, true, 0xFF400000);
            var front:ExtendedSprite = new ExtendedSprite();
            front.identifier = "exact-front";
            front.bitmapData = new BitmapData(4, 4, true, 0xFF004000);
            front.blendMode = BlendMode.ADD;
            display.addChild(back);
            display.addChild(front);

            var image:BitmapData = new BitmapData(6, 6, true, 0);
            image.draw(master);
            var pixels:Array = [];
            for (var y:int = 0; y < 6; y++)
                for (var x:int = 0; x < 6; x++)
                    pixels.push(("00000000" + image.getPixel32(x, y).toString(16).toUpperCase()).substr(-8));
            post({
                runtime: "Harman AIR 51.2.2 / native Flash display list",
                alpha_127_hit: threshold.hitTestPoint(0, 1),
                alpha_128_hit: threshold.hitTestPoint(1, 1),
                alpha_129_hit: threshold.hitTestPoint(2, 1),
                order: [ExtendedSprite(display.getChildAt(0)).identifier,
                    ExtendedSprite(display.getChildAt(1)).identifier],
                front_blend_mode_add: front.blendMode == BlendMode.ADD,
                mask_outside_alpha: image.getPixel32(4, 1) >>> 24,
                capture_argb_hex: pixels
            });
        }

        private function post(value:Object):void
        {
            var request:URLRequest = new URLRequest(BASE + "flash-result");
            request.method = URLRequestMethod.POST;
            request.contentType = "application/json";
            request.data = JSON.stringify(value);
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, function(_:Event):void
            {
                trace("G4_FLASH_REFERENCE_PASS pixels=36");
                NativeApplication.nativeApplication.exit(0);
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void
            {
                fail(event.text);
            });
            loader.load(request);
        }

        private function fail(message:String):void
        {
            trace("G4_FLASH_REFERENCE_FAIL " + message);
            NativeApplication.nativeApplication.exit(1);
        }
    }
}
