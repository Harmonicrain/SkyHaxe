package snowwar._str_254
;
	import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.utils.Timer;
    import flash.display.BitmapData;
    import flash.events.TimerEvent;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.geom.Point;

     class SnowWarAnimatedWindowElement implements IDisposable 
    {
        var _SafeStr_6169:Int = 0;
        var _SafeStr_22043:String;
        var _SafeStr_6037:Array<ASAny>;
        var _SafeStr_22044:Int = 0;
        var _SafeStr_20417:IBitmapWrapperWindow;
        var _SafeStr_12319:Timer;
        var _disposed:Bool = false;

        public function new(k:IAssetLibrary, _arg_2:IBitmapWrapperWindow, _arg_3:String, _arg_4:Int, _arg_5:Int=100, _arg_6:Bool=false)
        {
            var _local_7 = 0;
            this._SafeStr_6037 = [];
            this._SafeStr_20417 = _arg_2;
            this._SafeStr_22043 = _arg_3;
            this._SafeStr_6169 = _arg_4;
            _local_7 = 1;
            while (_local_7 <= this._SafeStr_6169)
            {
                if (k.hasAsset((this._SafeStr_22043 + Std.string(_local_7))))
                {
                    this._SafeStr_6037.push(ASCompat.dynamicAs(k.getAssetByName((this._SafeStr_22043 + Std.string(_local_7))).content , BitmapData));
                }
                else
                {
                    this._SafeStr_6037.push(new BitmapData(1, 1));
                    Logger.log([(("Missing asset for Snow War: " + this._SafeStr_22043) + Std.string(_local_7))]);
                }
                _local_7++;
            }
            if (_arg_6)
            {
                this._SafeStr_6169 = (this._SafeStr_6169 + (_arg_4 - 2));
                _local_7 = (_arg_4 - 1);
                while (_local_7 > 1)
                {
                    if (k.hasAsset((this._SafeStr_22043 + Std.string(_local_7))))
                    {
                        this._SafeStr_6037.push(ASCompat.dynamicAs(k.getAssetByName((this._SafeStr_22043 + Std.string(_local_7))).content , BitmapData));
                    }
                    else
                    {
                        this._SafeStr_6037.push(new BitmapData(1, 1));
                        Logger.log([(("Missing loop asset for Snow War: " + this._SafeStr_22043) + Std.string(_local_7))]);
                    }
                    _local_7--;
                }
            }
            this.update();
            this._SafeStr_12319 = new Timer(_arg_5);
            this._SafeStr_12319.addEventListener(TimerEvent.TIMER, (this.onTimer : ASAny));
            this._SafeStr_12319.start();
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._SafeStr_12319.removeEventListener(TimerEvent.TIMER, (this.onTimer : ASAny));
                this._SafeStr_12319.stop();
                this._SafeStr_12319 = null;
                if (((this._SafeStr_20417 != null) && (this._SafeStr_20417.bitmap != null)))
                {
                    this._SafeStr_20417.bitmap.fillRect(this._SafeStr_20417.bitmap.rect, 0);
                    this._SafeStr_20417.invalidate();
                }
                this._SafeStr_20417 = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function onTimer(k:TimerEvent)
        {
            this.update();
        }

        function update()
        {
var k:BitmapData  = null, _local_2:Point  = null;			try
			{
            this._SafeStr_22044 = (++this._SafeStr_22044 % this._SafeStr_6169);
            if (this._SafeStr_20417.bitmap == null)
            {
                this._SafeStr_20417.bitmap = new BitmapData(this._SafeStr_20417.width, this._SafeStr_20417.height);
            }
            this._SafeStr_20417.bitmap.fillRect(this._SafeStr_20417.bitmap.rect, 0);
k= this._SafeStr_6037[this._SafeStr_22044];
_local_2= new Point(((this._SafeStr_20417.width - k.width) / 2), ((this._SafeStr_20417.height - k.height) / 2));
            this._SafeStr_20417.bitmap.copyPixels(k, k.rect, _local_2);
            this._SafeStr_20417.invalidate();
			}
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught); 			{
				trace(Std.string(_SafeStr_6169) + "/" + Std.string(this._SafeStr_12319.delay) + "| " + this._SafeStr_22043 + " | " + e.getStackTrace());
					
			}
 }        }
    }

