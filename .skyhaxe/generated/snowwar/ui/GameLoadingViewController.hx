package snowwar.ui
;
	import com.sulake.core.runtime.IDisposable;
    import snowwar.SnowWarEngine;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
	import com.sulake.core.assets.BitmapDataAsset;
	import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.habbo.game.WindowUtils;
    import flash.display.BitmapData;
    import flash.geom.Point;

     class GameLoadingViewController implements IDisposable 
    {
        var _disposed:Bool = false;
        var snowWarEngine:SnowWarEngine;
        var windowContainer:IWindowContainer;

        public function new(snowWarEngine:SnowWarEngine)
        {
            this.snowWarEngine = snowWarEngine;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            this.snowWarEngine = null;
            if (this.windowContainer != null)
            {
                this.windowContainer.dispose();
                this.windowContainer = null;
            }
            this._disposed = true;
        }

        public var background(get,never):IWindow;
public function  get_background():IWindow
        {
            if (this.windowContainer == null)
            {
                this.loadWindow();
            }
            return this.windowContainer;
        }

        function loadWindow()
        {
var bitmapWrapper:IBitmapWrapperWindow = null, bitmapAsset:BitmapDataAsset = null, desktop:IDesktopWindow  = null;			try
			{
bitmapWrapper;
bitmapAsset;
desktop= this.snowWarEngine.windowManager.getDesktop(0);
            this.windowContainer = Std.downcast(WindowUtils.createWindow("snowwar_loading_background_xml", 1) , IWindowContainer);
            this.windowContainer.width = desktop.width;
            this.windowContainer.height = desktop.height;
            desktop.addChildAt(this.windowContainer, 0);
            this.changeAssetState("bg_sky", "sky", this.windowContainer);
            this.changeAssetState("bg_sunshine", "sunshine", this.windowContainer);
            this.changeAssetState("bg_vista_1", "vista_1", this.windowContainer, true);
            this.changeAssetState("bg_vista_2", "vista_2", this.windowContainer, true);
            this.changeAssetState("bg_vista_3", "vista_3", this.windowContainer, true);
			}
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught); 			{
				Habbo.trackLoginStep(e.getStackTrace());
			}
 }        }

        function changeAssetState(assetName:String, childName:String, windowContainer:IWindowContainer, visible:Bool=false)
        {
            var bitmapData:BitmapData = null;
            var widthOffset = 0;
            var bitmapAsset= Std.downcast(this.snowWarEngine.assets.getAssetByName(assetName) , BitmapDataAsset);
            var bitmapWrapper= Std.downcast(windowContainer.findChildByName(childName) , IBitmapWrapperWindow);
            var sourceBitmapData= ASCompat.dynamicAs(bitmapAsset.content , BitmapData);
            if (visible)
            {
                bitmapData = new BitmapData(windowContainer.width, sourceBitmapData.height, true, 0);
                widthOffset = 0;
                while (widthOffset < ((windowContainer.width / sourceBitmapData.width) + 1))
                {
                    bitmapData.copyPixels(sourceBitmapData, sourceBitmapData.rect, new Point((widthOffset * sourceBitmapData.width), 0));
                    widthOffset++;
                }
                bitmapWrapper.bitmap = bitmapData;
            }
            else
            {
                bitmapWrapper.bitmap = sourceBitmapData;
                bitmapWrapper.disposesBitmap = false;
            }
        }
    }

