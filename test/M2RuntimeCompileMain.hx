/** Compile-only root for the generated M2 dependency frontier. */
class M2RuntimeCompileMain {
    static var disposable:com.sulake.core.runtime.IDisposable;
    static var iid:com.sulake.core.runtime.IID;
    static var iidCore:com.sulake.core.runtime.IIDCore;
    static var iidProfiler:com.sulake.core.runtime.IIDProfiler;
    static var unknown:com.sulake.core.runtime.IUnknown;
    static var updateReceiver:com.sulake.core.runtime.IUpdateReceiver;
    static var logger:com.sulake.core.runtime.ILogger;
    static var errorLogger:com.sulake.core.runtime.ICoreErrorLogger;
    static var configuration:com.sulake.core.runtime.IHabboConfigurationManager;
    static var linkTracker:com.sulake.core.runtime.events.ILinkEventTracker;
    static var listener:com.sulake.core.runtime.events.EventListenerStruct;
    static var warning:com.sulake.core.runtime.events.WarningEvent;
    static var error:com.sulake.core.runtime.events.ErrorEvent;
    static var unknownEvent:com.sulake.core.runtime.events.UnknownEvent;
    static var hotelReady:com.sulake.core.runtime.events.HotelViewReadyEvent;
    static var libraryProgress:com.sulake.core.runtime.events.LibraryProgressEvent;
    static var asset:com.sulake.core.assets.IAsset;
    static var lazyAsset:com.sulake.core.assets.ILazyAsset;
    static var assetReceiver:com.sulake.core.assets.IAssetReceiver;
    static var resourceManager:com.sulake.core.assets.IResourceManager;
    static var assetType:com.sulake.core.assets.AssetTypeDeclaration;
    static var assetLoaderEvent:com.sulake.core.assets.loaders.AssetLoaderEvent;
    static var libraryLoaderEvent:com.sulake.core.utils.LibraryLoaderEvent;
    static var browserInfo:com.sulake.core.utils.BrowserInfo;
    static var playerVersion:com.sulake.core.utils.PlayerVersionCheck;
    static var profilerTask:com.sulake.core.utils.profiler.ProfilerAgentTask;
    static var unknownAsset:com.sulake.core.assets.UnknownAsset;
    static var textAsset:com.sulake.core.assets.TextAsset;
    static var xmlAsset:com.sulake.core.assets.XmlAsset;
    static var displayAsset:com.sulake.core.assets.DisplayAsset;
    static var soundAsset:com.sulake.core.assets.SoundAsset;
    static var bitmapDataAsset:com.sulake.core.assets.BitmapDataAsset;
    static var exception:com.sulake.core.runtime.exceptions.Exception;
    static var disposedException:com.sulake.core.runtime.exceptions.ComponentDisposedException;
    static var invalidException:com.sulake.core.runtime.exceptions.InvalidComponentException;

    static function main():Void {}
}
