package org.openvideoads.vast
;
    import org.openvideoads.base._Str_4989;
    import org.openvideoads.vast.server.response._Str_3802;
    import org.openvideoads.vast.schedule.ads._Str_8118;
    import org.openvideoads.vast.config._Str_2741;
    import org.openvideoads.vast.analytics._Str_2408;
    import org.openvideoads.vast.schedule.StreamSequence;
    import org.openvideoads.vast.schedule.ads.AdSchedule;
    import org.openvideoads.vast.schedule.ads.AdSlot;
    import org.openvideoads.vast.server.response.AdServerTemplate;
    import org.openvideoads.vast.overlay.OverlayController;
    import org.openvideoads.vast.config.Config;
    import org.openvideoads.vast.config.groupings.PlayerConfigGroup;
    import org.openvideoads.vast.config.ConfigPreConverter;
    import org.openvideoads.util.DisplaySpecification;
    import org.openvideoads.vast.schedule.DurationlessStreamSequence;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.vast.server.events.TemplateEvent;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.util.Display;
    import org.openvideoads.vast.tracking.TrackingTable;
    import org.openvideoads.vast.config.groupings.ProvidersConfigGroup;
    import org.openvideoads.vast.overlay.button.skip._Str_4790;
    import org.openvideoads.vast.tracking._Str_4278;
    import org.openvideoads.vast.events._Str_8609;
    import org.openvideoads.vast.schedule.Stream;
    import org.openvideoads.vast.events._Str_9357;
    import org.openvideoads.vast.events.TrackingPointEvent;
    import org.openvideoads.vast.tracking._Str_2460;
    import org.openvideoads.vast.events._Str_2333;
    import org.openvideoads.vpaid._Str_5844;
    import org.openvideoads.vast.events._Str_4041;
    import org.openvideoads.vast.model.TrackingEvent;
    import org.openvideoads.vast.events.AdTagEvent;
    import org.openvideoads.vast.server.request.AdServerRequest;
    import flash.events.Event;
    import org.openvideoads.vast.events._Str_3250;
    import org.openvideoads.vast.events._Str_7987;
    import org.openvideoads.vast.events._Str_6977;
    import org.openvideoads.vast.events._Str_2833;
    import flash.external.ExternalInterface;
    import org.openvideoads.vast.model.NonLinearVideoAd;
    import org.openvideoads.vast.events._Str_3525;
    import org.openvideoads.vast.events._Str_4535;
    import org.openvideoads.vast.overlay.OverlayView;
    import org.openvideoads.util.UserAgentUtils;
    import flash.events.MouseEvent;
    import org.openvideoads.vast.model.LinearVideoAd;
    import org.openvideoads.vast.model.VideoAd;
    import org.openvideoads.vast.model.CompanionAd;
    import org.openvideoads.util.BrowserUtils;
    import org.openvideoads.vast.events._Str_3117;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

     class VASTController extends _Str_4989 implements _Str_3802 implements  _Str_8118 implements  _Str_2741 
    {
        public static inline final _Str_17330= "relative-to-clip";
        public static inline final CONTINUOUS= "continuous";
        public static inline final VERSION= "v1.2.0 (Final Build)";
        public static inline final _Str_19653= false;
        static var _Str_2361:_Str_2408 = null;

        var _Str_2653:StreamSequence = null;
        var _Str_2527:AdSchedule = null;
        var _Str_7864:AdSlot = null;
        var _Str_2620:AdServerTemplate = null;
        var _Str_2596:OverlayController = null;
        var _Str_2297:Config;
        var _Str_20766:String = "relative-to-clip";
        var _Str_19242:Bool = false;
        var _Str_26397:Bool = true;
        var _Str_19125:Int = 0;
        var _Str_17949:Int = 0;
        var _Str_16466:_Str_2741 = null;
        var _Str_20525:Bool = false;
        var _Str_23262:Bool = false;
        var _Str_19236:Bool = true;
        var _Str_4300:ASObject;
        var _Str_14426:ASObject;
        var _Str_19146:Bool = false;
        var _Str_21607:Float = 1;
        var _Str_10869:String = null;
        var _Str_3351:Bool = false;
        var _Str_16590:PlayerConfigGroup = null;
        var _Str_26022:String = "";

        public function new(k:Config=null, _arg_2:Int=0)
        {
            this._Str_2297 = new Config();
            this._Str_4300 = new ASObject();
            this._Str_14426 = new ASObject();
            super();
            if (k != null)
            {
                this.initialise(k);
            }
            this._Str_17949 = _arg_2;
        }

        public function initialise(k:ASObject, _arg_2:Bool=false, _arg_3:_Str_2741=null, _arg_4:Config=null)
        {
            this._Str_19146 = true;
            this._Str_16466 = _arg_3;
            this._Str_20525 = _arg_2;
            if (Std.is(k , Config))
            {
                this.config = ASCompat.dynamicAs(k , Config);
            }
            else
            {
                if (_arg_4 != null)
                {
                    _arg_4.initialise(this._Str_20817(k));
                    this.config = _arg_4;
                }
                else
                {
                    this.config = new Config(this._Str_20817(k));
                }
            }
            if (this.config.outputingDebug())
            {
            }
            this.config.setLoadedListener(this);
        }

        public function _Str_20817(k:ASObject):ASObject
        {
            return ConfigPreConverter._Str_4080(k);
        }

        public var _Str_6229(get,never):Bool;
public function  get__Str_6229():Bool
        {
            return this._Str_3351;
        }

        public function _Str_23278(k:ASObject=null)
        {
            this._Str_16590 = new PlayerConfigGroup(k);
        }

        public function _Str_26446(k:Bool):DisplaySpecification
        {
            if (k)
            {
                return this._Str_2297._Str_4565.getDisplaySpecification(DisplaySpecification.NONLINEAR);
            }
            return this._Str_2297._Str_4565.getDisplaySpecification(DisplaySpecification.LINEAR);
        }

        public function _Str_26394():PlayerConfigGroup
        {
            if (this._Str_16590 == null)
            {
                this._Str_23278();
            }
            return this._Str_16590;
        }

        public var analyticsProcessor(get,never):_Str_2408;
public function  get_analyticsProcessor():_Str_2408
        {
            return _Str_2361;
        }

        public function fireAdPlaybackAnalytics(k:String, _arg_2:AdSlot, _arg_3:ASAny)
        {
            if (_Str_2361 != null)
            {
                _Str_2361._Str_20536(k, _arg_2, _arg_3, this._Str_2378());
            }
        }

        
        public var playerVolume(get,set):Float;
public function  set_playerVolume(k:Float):Float        {
            return this._Str_21607 = k;
        }
public function  get_playerVolume():Float
        {
            return this._Str_21607;
        }

        public function _Str_26173():Bool
        {
            return this._Str_1242;
        }

        public var _Str_1242(get,never):Bool;
public function  get__Str_1242():Bool
        {
            return this._Str_19146;
        }

        public function isOVAConfigLoading():Bool
        {
            return this._Str_23262;
        }

        public function onOVAConfigLoaded()
        {
            _Str_2361 = new _Str_2408(this._Str_2297.analytics);
            if (this.config.operateWithoutStreamDuration())
            {
                this._Str_2653 = new DurationlessStreamSequence();
            }
            else
            {
                this._Str_2653 = new StreamSequence();
            }
            if (this._Str_20525)
            {
                this.load();
            }
            if (this._Str_16466 != null)
            {
                this._Str_16466.onOVAConfigLoaded();
            }
        }

        public function delayAdRequestUntilPlay():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297.delayAdRequestUntilPlay;
            }
            return false;
        }

        public function _Str_26102():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297.adsConfig.vpaidConfig.testing;
            }
            return false;
        }

        public function _Str_25930():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297.supportExternalPlaylistLoading;
            }
            return false;
        }

        public function _Str_25932():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297.autoPlayOnExternalLoad;
            }
            return false;
        }

        public function _Str_26339(k:AdSlot):Bool
        {
            if (k != null)
            {
                return k._Str_24052(this);
            }
            return false;
        }

        public function _Str_26342():Bool
        {
            var k= this._Str_22620();
            if (k != null)
            {
                return k.isPreRoll();
            }
            return false;
        }

        public function _Str_22620():AdSlot
        {
            if (this._Str_2653 != null)
            {
                if (this._Str_2653.length > 0)
                {
                    if (Std.is(this._Str_2653._Str_6899(0) , AdSlot))
                    {
                        return Std.downcast(this._Str_2653._Str_6899(0) , AdSlot);
                    }
                    if (this._Str_2653.length >= 2)
                    {
                        if (this._Str_2653._Str_6899(0)._Str_23330())
                        {
                            if (Std.is(this._Str_2653._Str_6899(1) , AdSlot))
                            {
                                if (cast(this._Str_2653._Str_6899(1), AdSlot).isPreRoll())
                                {
                                    return Std.downcast(this._Str_2653._Str_6899(1) , AdSlot);
                                }
                            }
                        }
                    }
                }
            }
            return null;
        }

        public var _Str_26235(never,set):String;
public function  set__Str_26235(k:String):String        {
            return this._Str_10869 = k;
        }

        function _Str_2378(k:String=""):String
        {
            if (this._Str_10869 != null)
            {
                if (StringUtils._Str_4861(this._Str_10869, "&"))
                {
                    return this._Str_10869 + k;
                }
                return ("&" + this._Str_10869) + k;
            }
            return k;
        }

        public function _Str_26260():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297._Str_4565.hideLogoOnLinearPlayback;
            }
            return false;
        }

        public function _Str_19861():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297._Str_21867._Str_19861();
            }
            return false;
        }

        public function _Str_20773():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297._Str_20773();
            }
            return false;
        }

        public function _Str_21394():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297._Str_21394();
            }
            return false;
        }

        
        public var _Str_17706(get,set):Bool;
public function  get__Str_17706():Bool
        {
            return this._Str_19236;
        }
public function  set__Str_17706(k:Bool):Bool        {
            return this._Str_19236 = k;
        }

        
        public var endStreamSafetyMargin(get,set):Int;
public function  set_endStreamSafetyMargin(k:Int):Int        {
            return this._Str_17949 = k;
        }
public function  get_endStreamSafetyMargin():Int
        {
            return this._Str_17949;
        }

        
        public var startStreamSafetyMargin(get,set):Int;
public function  set_startStreamSafetyMargin(k:Int):Int        {
            return this._Str_19125 = k;
        }
public function  get_startStreamSafetyMargin():Int
        {
            return this._Str_19125;
        }

        
        public var acceptedLinearAdMimeTypes(get,set):Array<ASAny>;
public function  set_acceptedLinearAdMimeTypes(k:Array<ASAny>):Array<ASAny>        {
            if (this._Str_2297 != null)
            {
                this.config.acceptedLinearAdMimeTypes = k;
            }
return k;
        }
public function  get_acceptedLinearAdMimeTypes():Array<ASAny>
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297.acceptedLinearAdMimeTypes;
            }
            return new Array<ASAny>();
        }

        public var playOnce(get,never):Bool;
public function  get_playOnce():Bool
        {
            return this.config.playOnce;
        }

        
        public var _Str_17402(get,set):Bool;
public function  set__Str_17402(k:Bool):Bool        {
            return this._Str_19242 = k;
        }
public function  get__Str_17402():Bool
        {
            return this._Str_19242;
        }

        public function autoPlay():Bool
        {
            return this._Str_2297.autoPlay;
        }

        public function _Str_26184()
        {
            this._Str_2297.autoPlay = true;
        }

        public function _Str_26182()
        {
            this._Str_2297.autoPlay = false;
        }

        public var allowPlaylistControl(get,never):Bool;
public function  get_allowPlaylistControl():Bool
        {
            return this._Str_2297.allowPlaylistControl;
        }

        public function _Str_26177(k:String, _arg_2:Bool):Bool
        {
            return this._Str_2297.controlEnabledForLinearAdType(k, _arg_2);
        }

        public function _Str_26044(k:String)
        {
            this._Str_20766 = k;
        }

        function _Str_21546():Bool
        {
            return this._Str_20766 == VASTController._Str_17330;
        }

        public function _Str_21270(k:Int, _arg_2:Bool=false, _arg_3:Bool=false):Int
        {
            if (this._Str_2653 != null)
            {
                return this._Str_2653._Str_21270(k, _arg_2, _arg_3);
            }
            return -1;
        }

        public function _Str_26326(k:Int, _arg_2:Float, _arg_3:Float):Array<ASAny>
        {
            var _local_5 = 0;
            var _local_4= new Array<ASAny>();
            if (this._Str_2527 != null)
            {
                _local_5 = 0;
                while (_local_5 < this._Str_2527.length)
                {
                    if (this._Str_2527._Str_4198(_local_5).associatedStreamIndex == k)
                    {
                        if ((this._Str_2527._Str_4198(_local_5).isMidRoll() && (this._Str_2527._Str_4198(_local_5).isEmpty() == false)))
                        {
                            if (this._Str_2527._Str_4198(_local_5)._Str_25769(_arg_2, _arg_3))
                            {
                                _local_4.push(this._Str_2527._Str_4198(_local_5));
                            }
                        }
                    }
                    _local_5++;
                }
            }
            return _local_4;
        }

        public function load()
        {
            this._Str_3351 = true;
            this.config.ensureProvidersAreSet();
            if (this._Str_2527._Str_23072())
            {
                this._Str_2527._Str_23849(this);
            }
            else
            {
                this._Str_5916(new TemplateEvent(TemplateEvent._Str_6462, "Not triggering ad server calls at this time as there are no pre-loaded ad slots declared"));
            }
        }

        public function unload()
        {
            if (this._Str_2527 != null)
            {
                this._Str_2527.unload();
            }
        }

        public function _Str_25972(k:AdSlot):Bool
        {
            if (k != null)
            {
                return k.load(this);
            }
            return false;
        }

        public function _Str_26138(k:Int):Bool
        {
            if (this._Str_2527 != null)
            {
                if (this._Str_2527.length < k)
                {
                    if (cast((this._Str_2527 : ASAny)[k], AdSlot).loadOnDemand == true)
                    {
                        return cast((this._Str_2527 : ASAny)[k], AdSlot).load(this);
                    }
                }
            }
            return false;
        }

        
        public var playerWidth(get,set):Int;
public function  set_playerWidth(k:Int):Int        {
            if (this._Str_2297 != null)
            {
                this._Str_2297._Str_4565.width = k;
            }
return k;
        }
public function  get_playerWidth():Int
        {
            if (this._Str_2297 != null)
            {
                return ASCompat.toInt(this._Str_2297._Str_4565.width);
            }
            return -1;
        }

        
        public var playerHeight(get,set):Int;
public function  set_playerHeight(k:Int):Int        {
            if (this._Str_2297 != null)
            {
                this._Str_2297._Str_4565.height = k;
            }
return k;
        }
public function  get_playerHeight():Int
        {
            if (this._Str_2297 != null)
            {
                return ASCompat.toInt(this._Str_2297._Str_4565.height);
            }
            return -1;
        }

        
        public var config(get,set):Config;
public function  set_config(k:Config):Config        {
            this._Str_2297 = k;
            if (this._Str_2297._Str_18288())
            {
                Debuggable.getInstance().setLevelFromString(this._Str_2297._Str_23960);
            }
            if (this._Str_2297._Str_16875())
            {
                Debuggable.getInstance().activeDebuggers = this._Str_2297.debugger;
            }
            this._Str_2527 = new AdSchedule(this, this._Str_2653, this._Str_2297);
return k;
        }
public function  get_config():Config
        {
            return this._Str_2297;
        }

        public var template(get,never):AdServerTemplate;
public function  get_template():AdServerTemplate
        {
            return this._Str_2620;
        }

        public var _Str_8392(get,never):AdSchedule;
public function  get__Str_8392():AdSchedule
        {
            return this._Str_2527;
        }

        public var _Str_25911(get,never):StreamSequence;
public function  get__Str_25911():StreamSequence
        {
            return this._Str_2653;
        }

        public var _Str_13758(get,never):OverlayController;
public function  get__Str_13758():OverlayController
        {
            return this._Str_2596;
        }

        public function _Str_21668(k:Int, _arg_2:Int)
        {
            if (this._Str_2653 != null)
            {
                this._Str_2653._Str_21668(k, _arg_2);
            }
        }

        public var pauseOnClickThrough(get,never):Bool;
public function  get_pauseOnClickThrough():Bool
        {
            return this._Str_2297.pauseOnClickThrough;
        }

        public function canSkipOnLinearAd():Bool
        {
            return this._Str_2297.canSkipOnLinearAd();
        }

        public function enforceLinearInteractiveAdScaling():Bool
        {
            return this._Str_2297.adsConfig.enforceLinearInteractiveAdScaling;
        }

        public function enforceLinearVideoAdScaling():Bool
        {
            return this._Str_2297.adsConfig.enforceLinearVideoAdScaling;
        }

        public function _Str_21050():Bool
        {
            return this._Str_2297._Str_21050();
        }

        public function _Str_19637():Bool
        {
            return this._Str_2297._Str_19637();
        }

        public function _Str_26074()
        {
            this._Str_2596 = null;
        }

        public function _Str_26386(k:Display)
        {
            this._Str_2596 = new OverlayController(this, k, this._Str_2297._Str_23104);
            if (k.displayObjectContainer != null)
            {
                k.displayObjectContainer.addChild(this._Str_2596);
                k.displayObjectContainer.setChildIndex(this._Str_2596, (k.displayObjectContainer.numChildren - 1));
            }
        }

        public function _Str_26254(k:Display)
        {
            if (this._Str_2596 != null)
            {
                this._Str_2596.resize(k);
            }
        }

        public function _Str_8843():Bool
        {
            return !(this._Str_2596 == null);
        }

        public function _Str_26220(k:Int):TrackingTable
        {
            if (k < this._Str_2653.length)
            {
                return this._Str_2653._Str_21989(k)._Str_22706();
            }
            return null;
        }

        public function _Str_16648()
        {
            if (this._Str_2596 != null)
            {
                this._Str_2596._Str_16648();
            }
        }

        public function _Str_9717()
        {
            if (this._Str_2596 != null)
            {
                this._Str_2596._Str_9717();
            }
        }

        public function _Str_26309()
        {
            if (this._Str_2596 != null)
            {
                this._Str_2596._Str_5888();
            }
        }

        public function _Str_26081()
        {
            if (this._Str_2596 != null)
            {
                this._Str_2596._Str_23447();
            }
        }

        public function closeActiveOverlaysAndCompanions()
        {
            if (this._Str_2527 != null)
            {
                this._Str_2527.closeActiveOverlaysAndCompanions(this._Str_2297.adsConfig.resetTrackingOnReplay);
            }
        }

        public function getProvider(k:String):String
        {
            return this._Str_2297.getProvider(k);
        }

        public function _Str_26051():ProvidersConfigGroup
        {
            return this._Str_2297._Str_4721;
        }

        public function _Str_26432():StreamSequence
        {
            var k:StreamSequence = null;
            if (!this.allowPlaylistControl)
            {
                if (this._Str_7864 != null)
                {
                    k = new StreamSequence(this);
                    k._Str_3329(this._Str_7864, false);
                    return k;
                }
            }
            return null;
        }

        public var _Str_25971(never,set):Bool;
public function  set__Str_25971(k:Bool):Bool        {
            if (this._Str_7864 != null)
            {
                this._Str_7864._Str_23103 = k;
            }
return k;
        }

        public function _Str_26247():Bool
        {
            if (this._Str_7864 != null)
            {
                return this._Str_7864._Str_21756();
            }
            return false;
        }

        public function activateLinearAdSkipButton(k:ASFunction)
        {
            if (this._Str_2596 != null)
            {
                this._Str_2596.activateLinearAdSkipButton(new _Str_4790(_Str_4790._Str_3831, "region", "image", k));
            }
        }

        public function deactivateLinearAdSkipButton()
        {
            if (this._Str_2596 != null)
            {
                this._Str_2596.deactivateLinearAdSkipButton(new _Str_4790(_Str_4790._Str_2703, "region"));
            }
        }

        public function processTimeEvent(k:Int, _arg_2:_Str_4278)
        {
            if (this._Str_2527 != null)
            {
                this._Str_2527.processTimeEvent(k, _arg_2, false);
            }
            if (this._Str_2653 != null)
            {
                this._Str_2653.processTimeEvent(k, _arg_2, false);
            }
        }

        public function _Str_26176(k:Int, _arg_2:_Str_4278, _arg_3:Bool=false)
        {
            if (k != -1)
            {
                if (k < this._Str_2527.length)
                {
                    this._Str_2527._Str_4198(k).processTimeEvent(_arg_2, true);
                }
            }
        }

        public function _Str_20425(k:Int)
        {
            if (((!(this._Str_2527 == null)) && (k > -1)))
            {
                this._Str_2527._Str_20425(k);
            }
        }

        public function _Str_20064(k:Int)
        {
            if (((!(this._Str_2653 == null)) && (k > -1)))
            {
                this._Str_2653._Str_20064(k);
            }
        }

        public function _Str_26308(k:Int)
        {
            if (((!(this._Str_2653 == null)) && (k > -1)))
            {
                this._Str_2653.resetRepeatableTrackingPoints(k);
            }
        }

        public function _Str_19573(k:String, _arg_2:String):String
        {
            if (this._Str_2596 != null)
            {
                return this._Str_2596._Str_19573(k, _arg_2);
            }
            return "-1, Overlay Controller is not active";
        }

        public function _Str_25265( k:Array<ASAny> = null):ASAny
        {
if (k == null) k = [];
            return null;
        }

        public function _Str_20598(k:Int, _arg_2:Stream)
        {
            if ((((this._Str_17402 == false) && _arg_2.isSlicedStream()) && (!_arg_2._Str_23955())))
            {
            }
            else
            {
                dispatchEvent(new _Str_8609(_Str_8609._Str_7412, k, _arg_2));
            }
        }

        public function _Str_19790(k:AdSlot, _arg_2:Bool=false)
        {
            dispatchEvent(new _Str_9357(_Str_9357._Str_7412, k));
        }

        public function _Str_23658(k:_Str_2460)
        {
            if (k != null)
            {
                dispatchEvent(new TrackingPointEvent(TrackingPointEvent._Str_17334, k));
            }
        }

        public function onProcessTrackingPoint(k:_Str_2460)
        {
            if (k != null)
            {
                dispatchEvent(new TrackingPointEvent(TrackingPointEvent._Str_7314, k));
            }
        }

        public function _Str_14186():Bool
        {
            if (this._Str_2596 != null)
            {
                return this._Str_2596._Str_14186();
            }
            return false;
        }

        public function _Str_13449()
        {
            if (this._Str_2596 != null)
            {
                this._Str_2596._Str_13449();
            }
        }

        public function _Str_16555(adSlot:AdSlot, muteOnStartup:Bool=false, reduceVPAIDAdHeightByControlbarHeight:Bool=false, playerVolume:Float=-1)
        {
            var ad:ASAny = /*undefined*/null;
            if (adSlot != null)
            {
                adSlot.markAsPlayed();
                if (this._Str_2596 != null)
                {
                    if ((adSlot.isLinear() && this._Str_2297.adsConfig.resetTrackingOnReplay))
                    {
                        adSlot.resetAllTrackingPoints();
                    }
                    ad = (adSlot.isLinear() ? adSlot._Str_16720() : adSlot._Str_14530());
                    this._Str_2596._Str_16555(adSlot, {
                        "onLoading":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            dispatchEvent(new _Str_2333(_Str_2333._Str_18913, adSlot));
                        },
                        "onLoaded":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.LOADED, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_16473 : _Str_2333._Str_13330), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onImpression":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_9754((adSlot.isLinear() ? _Str_2408.LINEAR : _Str_2408.NONLINEAR), adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_16657 : _Str_2333._Str_15304), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onStart":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.STARTED, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_17321 : _Str_2333._Str_14757), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onComplete":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.COMPLETE, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_17593 : _Str_2333._Str_15573), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onPaused":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.PAUSED, adSlot, ad, _Str_2378());
                            }
                        },
                        "onPlaying":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.PLAYING, adSlot, ad, _Str_2378());
                            }
                        },
                        "onError":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.ERROR, adSlot, ad, _Str_2378(("ova_error=" + k.data)));
                            }
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_18409 : _Str_2333._Str_14364), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onLog":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            dispatchEvent(new _Str_2333(_Str_2333._Str_12726, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onExpandedChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.EXPANDEDCHANGE, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_18146 : _Str_2333._Str_14288), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onLinearChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.LINEARCHANGE, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_19033 : _Str_2333._Str_15816), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onRemainingTimeChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_16922 : _Str_2333._Str_13294), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onClickThru":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_12452(_Str_2408.VPAID, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_18603 : _Str_2333._Str_13941), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onUserAcceptInvitation":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.USERACCEPTINVITATION, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_18117 : _Str_2333._Str_15854), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVolumeChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_15390 : _Str_2333._Str_15728), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onUserMinimize":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.COLLAPSE, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_16665 : _Str_2333._Str_13270), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onUserClose":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.CLOSE, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_16340 : _Str_2333._Str_13997), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVideoAdStart":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.VIDEOSTART, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_14526, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVideoAdFirstQuartile":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.VIDEOFIRSTQUARTILE, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_15420, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVideoAdMidpoint":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.VIDEOMIDPOINT, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_12528, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVideoAdThirdQuartile":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.VIDEOTHIRDQUARTILE, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_15164, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVideoAdComplete":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.VIDEOCOMPLETE, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_14824, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVPAIDAdSkipped":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.SKIPPED, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_4456, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVPAIDAdSkippableStateChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.SKIPPABLESTATECHANGE, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_6020, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVPAIDAdSizeChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.SIZECHANGE, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_5704, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVPAIDAdDurationChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.DURATIONCHANGE, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_5647, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVPAIDAdInteraction":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (((!(_Str_2361 == null)) && (!(ad == null))))
                            {
                                _Str_2361._Str_2689(_Str_2408.ADINTERACTION, adSlot, ad, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_5708, adSlot, k.data, k.bubbles, k.cancelable));
                        }
                    }, muteOnStartup, playerVolume, reduceVPAIDAdHeightByControlbarHeight);
                }
            }
        }

        public function _Str_20036():_Str_5844
        {
            if (this._Str_2596 != null)
            {
                return this._Str_2596._Str_20036();
            }
            return null;
        }

        public function _Str_26016():Bool
        {
            if (this._Str_2297 != null)
            {
                return this._Str_2297._Str_4565.shouldHideControlsOnLinearPlayback(true);
            }
            return true;
        }

        public function onLinearAdStart(k:AdSlot)
        {
            if (k != null)
            {
                if (k.videoAd != null)
                {
                    if (_Str_2361 != null)
                    {
                        _Str_2361._Str_9754(_Str_2408.LINEAR, k, k.videoAd.linearVideoAd, this._Str_2378());
                    }
                    dispatchEvent(new _Str_4041(_Str_4041._Str_6644, k));
                }
            }
        }

        public function onLinearAdComplete(k:AdSlot)
        {
            if (k != null)
            {
                dispatchEvent(new _Str_4041(_Str_4041.COMPLETE, k));
            }
        }

        public function _Str_22191(k:AdSlot)
        {
            if (k != null)
            {
                k.triggerTrackingEvent(TrackingEvent.CLOSE);
                dispatchEvent(new _Str_4041(_Str_4041._Str_4456, k));
            }
        }

        public function enableVisualLinearAdClickThroughCue(k:AdSlot)
        {
            if (((this._Str_2297.visuallyCueLinearAdClickThrough && k._Str_23430()) && (!(this._Str_13758 == null))))
            {
                this._Str_13758._Str_23274(k);
            }
        }

        public function disableVisualLinearAdClickThroughCue(k:AdSlot=null)
        {
            if ((this._Str_2297.visuallyCueLinearAdClickThrough && (!(this._Str_13758 == null))))
            {
                this._Str_13758._Str_20070();
            }
        }

        public function onAdCallStarted(k:AdServerRequest)
        {
            dispatchEvent(new AdTagEvent(AdTagEvent._Str_18229, {"masterTag":k}));
        }

        public function onAdCallFailover(k:AdServerRequest, _arg_2:AdServerRequest)
        {
            dispatchEvent(new AdTagEvent(AdTagEvent._Str_18441, {
                "masterTag":k,
                "failoverTag":_arg_2
            }));
        }

        public function onAdCallComplete(k:AdServerRequest, _arg_2:Bool)
        {
            dispatchEvent(new AdTagEvent(AdTagEvent._Str_16223, {
                "masterTag":k,
                "hasAds":_arg_2
            }));
        }

        public function onTemplateLoaded(k:AdServerTemplate)
        {
            this._Str_2620 = k;
            if (this._Str_2620.hasAds(this._Str_2620.forceImpressionServing))
            {
                this._Str_2527.schedule(this._Str_2620);
                this._Str_2653.initialise(this, this._Str_2297.streams, this._Str_2527, ASCompat.toInt(this._Str_2297.bitrate), this._Str_2297.baseURL, 100, this._Str_2297.previewImage);
                this._Str_2527.addNonLinearAdTrackingPoints(this._Str_21546(), true);
                this._Str_2527._Str_20275();
            }
            else
            {
                this._Str_2527.schedule();
                this._Str_2653.initialise(this, this._Str_2297.streams, this._Str_2527, ASCompat.toInt(this._Str_2297.bitrate), this._Str_2297.baseURL, 100, this._Str_2297.previewImage);
            }
            this._Str_3351 = false;
            dispatchEvent(new TemplateEvent(TemplateEvent.LOADED, this._Str_2620));
            if (_Str_2361 != null)
            {
                _Str_2361._Str_10768(_Str_2408.LOADED, this._Str_2378(("&ova_ad_count=" + Std.string(this._Str_2620._Str_24660()))));
            }
        }

        public function onTemplateLoadError(k:Event)
        {
            this._Str_2527.schedule();
            this._Str_2653.initialise(this, this._Str_2297.streams, this._Str_2527, ASCompat.toInt(this._Str_2297.bitrate), this._Str_2297.baseURL, 100, this._Str_2297.previewImage);
            this._Str_3351 = false;
            dispatchEvent(new TemplateEvent(TemplateEvent._Str_14592, k));
            if (_Str_2361 != null)
            {
                _Str_2361._Str_10768(_Str_2408.ERROR, this._Str_2378(("&ova_error=" + ASCompat.escape(k.toString()))));
            }
        }

        public function _Str_5807(k:Event)
        {
            this._Str_2527.schedule();
            this._Str_2653.initialise(this, this._Str_2297.streams, this._Str_2527, ASCompat.toInt(this._Str_2297.bitrate), this._Str_2297.baseURL, 100, this._Str_2297.previewImage);
            this._Str_3351 = false;
            dispatchEvent(new TemplateEvent(TemplateEvent._Str_6699, k));
            if (_Str_2361 != null)
            {
                _Str_2361._Str_10768(_Str_2408.TIMEOUT, this._Str_2378());
            }
        }

        public function _Str_5916(k:Event)
        {
            this._Str_2527.schedule();
            this._Str_2653.initialise(this, this._Str_2297.streams, this._Str_2527, ASCompat.toInt(this._Str_2297.bitrate), this._Str_2297.baseURL, 100, this._Str_2297.previewImage);
            if (this._Str_2527.hasNonLinearAds())
            {
                this._Str_2527.addNonLinearAdTrackingPoints(this._Str_21546(), true);
                this._Str_2527._Str_20275();
            }
            this._Str_3351 = false;
            dispatchEvent(new TemplateEvent(TemplateEvent._Str_6462, k));
            if (_Str_2361 != null)
            {
                _Str_2361._Str_10768(_Str_2408.DEFERRED, this._Str_2378());
            }
        }

        public function _Str_22061(k:_Str_3250)
        {
            if (k != null)
            {
                if (k.adSlot.hasVideoAd())
                {
                    if (k.adSlot.videoAd.isEmpty())
                    {
                        if (k.adSlot._Str_16176())
                        {
                            k.adSlot.processForcedImpression();
                        }
                    }
                }
                dispatchEvent(k);
                if (_Str_2361 != null)
                {
                    _Str_2361._Str_11038(_Str_2408.LOADED, k.adSlot, this._Str_2378());
                }
            }
        }

        public function _Str_16628(k:_Str_3250)
        {
            dispatchEvent(k);
            if (_Str_2361 != null)
            {
                _Str_2361._Str_11038(_Str_2408.ERROR, k.adSlot, this._Str_2378(("&ova_error=" + ASCompat.escape(k.toString()))));
            }
        }

        public function _Str_24831(k:_Str_3250)
        {
            dispatchEvent(k);
            if (_Str_2361 != null)
            {
                _Str_2361._Str_11038(_Str_2408.TIMEOUT, k.adSlot, this._Str_2378());
            }
        }

        public function _Str_20322(k:_Str_3250)
        {
            dispatchEvent(k);
            if (_Str_2361 != null)
            {
                _Str_2361._Str_11038(_Str_2408.DEFERRED, k.adSlot, this._Str_2378());
            }
        }

        public function _Str_26063(k:Int=-1, _arg_2:Bool=false, _arg_3:Float=0)
        {
            if (this._Str_2527 != null)
            {
                this._Str_2527._Str_23109(k, _arg_3, this._Str_2297.adsConfig.resetTrackingOnReplay);
                this.processTimeEvent(k, new _Str_4278(_arg_3, 0));
            }
        }

        public function _Str_26391(k:Int=-1, _arg_2:Bool=false)
        {
            if (_arg_2)
            {
                if (((k > -1) && (k < this._Str_2527.length)))
                {
                    this._Str_2527._Str_4198(k).processMuteEvent();
                }
            }
            else
            {
                if (this._Str_2653 != null)
                {
                    this._Str_2653._Str_22938(k);
                }
            }
        }

        public function _Str_26212(k:Int=-1, _arg_2:Bool=false)
        {
            if (_arg_2)
            {
                if (((k > -1) && (k < this._Str_2527.length)))
                {
                    this._Str_2527._Str_4198(k).processUnmuteEvent();
                }
            }
            else
            {
                if (this._Str_2653 != null)
                {
                    this._Str_2653._Str_25589(k);
                }
            }
        }

        public function _Str_26213(k:Int=-1, _arg_2:Bool=false)
        {
        }

        public function _Str_26340(k:Int=-1, _arg_2:Bool=false)
        {
            if (_arg_2)
            {
                if (((k > -1) && (k < this._Str_2527.length)))
                {
                    this._Str_2527._Str_4198(k).processStopStream();
                }
            }
            else
            {
                if (this._Str_2653 != null)
                {
                    this._Str_2653._Str_24894(k);
                }
                if (this._Str_8843())
                {
                    this._Str_2596._Str_16648();
                }
            }
        }

        public function _Str_26055(k:Int=-1, _arg_2:Bool=false)
        {
            if (_arg_2)
            {
                if (((k > -1) && (k < this._Str_2527.length)))
                {
                    this._Str_2527._Str_4198(k).processFullScreenEvent();
                }
            }
            else
            {
                if (this._Str_2653 != null)
                {
                    this._Str_2653._Str_20593(k);
                }
            }
        }

        public function _Str_25962(k:Int=-1, _arg_2:Bool=false)
        {
            if (_arg_2)
            {
                if (((k > -1) && (k < this._Str_2527.length)))
                {
                    this._Str_2527._Str_4198(k).processFullScreenEvent();
                }
            }
            else
            {
                if (this._Str_2653 != null)
                {
                    this._Str_2653._Str_20593(k);
                }
            }
        }

        public function _Str_26418(k:Int=-1, _arg_2:Bool=false)
        {
            if (_arg_2)
            {
                if (((k > -1) && (k < this._Str_2527.length)))
                {
                    this._Str_2527._Str_4198(k).processFullScreenExitEvent();
                }
            }
            else
            {
                if (this._Str_2653 != null)
                {
                    this._Str_2653._Str_23855(k);
                }
            }
        }

        public function _Str_26325(k:Int=-1, _arg_2:Bool=false)
        {
            var _local_3:Stream = null;
            if (_arg_2)
            {
                if (this._Str_2527 != null)
                {
                    _local_3 = this._Str_2527._Str_4198(k);
                }
            }
            else
            {
                if (this._Str_2653 != null)
                {
                    _local_3 = this._Str_2653._Str_6899(k);
                }
            }
            if (_local_3 != null)
            {
                if (Std.is(_local_3 , AdSlot))
                {
                    if (this._Str_2596 != null)
                    {
                        if ((cast(_local_3, AdSlot).isLinear() && cast(_local_3, AdSlot).isInteractive()))
                        {
                            if (this._Str_2596._Str_14186())
                            {
                                this._Str_2596._Str_25060();
                            }
                            this._Str_2596._Str_19443();
                            return;
                        }
                        this._Str_2596._Str_19443();
                    }
                }
                _local_3.processPauseStream();
            }
        }

        public function _Str_26231(k:Int=-1, _arg_2:Bool=false)
        {
            var _local_3:Stream = null;
            if (_arg_2)
            {
                if (this._Str_2527 != null)
                {
                    _local_3 = this._Str_2527._Str_4198(k);
                }
            }
            else
            {
                if (this._Str_2653 != null)
                {
                    _local_3 = this._Str_2653._Str_6899(k);
                }
            }
            if (_local_3 != null)
            {
                if (Std.is(_local_3 , AdSlot))
                {
                    if (this._Str_2596 != null)
                    {
                        if (((cast(_local_3, AdSlot).isLinear() && cast(_local_3, AdSlot).isInteractive()) && this._Str_2596._Str_14186()))
                        {
                            this._Str_2596._Str_25397();
                        }
                        this._Str_2596._Str_23900();
                    }
                }
                _local_3.processResumeStream();
            }
        }

        public function _Str_26350(k:Int=-1, _arg_2:Bool=false)
        {
        }

        public function _Str_20056(k:Bool)
        {
            if (this._Str_2297._Str_4565.shouldDisableControlsDuringLinearAds())
            {
                dispatchEvent(new _Str_7987(_Str_7987.TOGGLE, k));
                dispatchEvent(new _Str_6977((k ? _Str_6977._Str_16488 : _Str_6977._Str_18397)));
            }
        }

        public function _Str_26263(k:Array<ASAny>)
        {
            if (this._Str_2297 != null)
            {
                this._Str_2297.analytics.update(k);
            }
        }

        public function onDisplayNonLinearAd(k:_Str_2833)
        {
            if (k != null)
            {
                if (k.adSlot != null)
                {
                    if (k.displayMode == _Str_2833._Str_15057)
                    {
                        if (k._Str_21016() == false)
                        {
                            if (ExternalInterface.available)
                            {
                                this._Str_22955(k);
                            }
                        }
                    }
                    else
                    {
                        this._Str_23141(k);
                    }
                }
            }
        }

        public function onHideNonLinearAd(k:_Str_2833)
        {
            if ((((k.displayMode == _Str_2833._Str_15057) && (k._Str_21016() == false)) && ExternalInterface.available))
            {
                this._Str_22643(k);
            }
            else
            {
                this._Str_23948(k);
            }
        }

        function _Str_23141(overlayAdDisplayEvent:_Str_2833)
        {
            var adSlot:AdSlot = null;
            if ((this._Str_8843() && (!(overlayAdDisplayEvent == null))))
            {
                adSlot = overlayAdDisplayEvent.adSlot;
                if (overlayAdDisplayEvent.nonLinearVideoAd.hasAccompanyingVideoAd())
                {
                    this._Str_7864 = adSlot;
                }
                if (overlayAdDisplayEvent.nonLinearVideoAd.isInteractive())
                {
                    this._Str_2596._Str_16555(adSlot, {
                        "onLoading":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            dispatchEvent(new _Str_2333(_Str_2333._Str_16423, adSlot));
                        },
                        "onLoaded":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.LOADED, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_13330, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onImpression":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_9754(_Str_2408.NONLINEAR, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_15304, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onStart":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.STARTED, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_14757, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onPaused":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.PAUSED, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                        },
                        "onPlaying":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.PLAYING, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                        },
                        "onComplete":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.COMPLETE, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_15573, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onError":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.ERROR, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378(("&ova_error=" + k.data)));
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_14364, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onLog":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            dispatchEvent(new _Str_2333(_Str_2333._Str_12726, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onExpandedChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.EXPANDEDCHANGE, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_14288, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onLinearChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.LINEARCHANGE, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_15816, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onRemainingTimeChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            dispatchEvent(new _Str_2333(_Str_2333._Str_13294, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVolumeChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            dispatchEvent(new _Str_2333((adSlot.isLinear() ? _Str_2333._Str_15390 : _Str_2333._Str_15728), adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onClickThru":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_12452(_Str_2408.VPAID, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_13941, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onUserAcceptInvitation":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.USERACCEPTINVITATION, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_15854, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onUserMinimize":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.COLLAPSE, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_13270, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onUserClose":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.CLOSE, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_13997, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVideoAdStart":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.VIDEOSTART, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_14526, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVideoAdFirstQuartile":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.VIDEOFIRSTQUARTILE, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_15420, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVideoAdMidpoint":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.VIDEOMIDPOINT, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_12528, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVideoAdThirdQuartile":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.VIDEOTHIRDQUARTILE, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_15164, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onVideoAdComplete":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.VIDEOCOMPLETE, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_14824, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onSkipped":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.SKIPPED, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_4456, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onSkippableStateChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.SKIPPABLESTATECHANGE, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_6020, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onSizeChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.SIZECHANGE, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_5704, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onDurationChange":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.DURATIONCHANGE, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_5647, adSlot, k.data, k.bubbles, k.cancelable));
                        },
                        "onAdInteraction":function (k:org.openvideoads.vpaid._Str_2291=null)
                        {
                            if (_Str_2361 != null)
                            {
                                _Str_2361._Str_2689(_Str_2408.ADINTERACTION, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, _Str_2378());
                            }
                            dispatchEvent(new _Str_2333(_Str_2333._Str_5708, adSlot, k.data, k.bubbles, k.cancelable));
                        }
                    }, (this.playerVolume == 0), this.playerVolume, false, overlayAdDisplayEvent.region.enableScaling);
                }
                else
                {
                    if ((overlayAdDisplayEvent.nonLinearVideoAd.isIFrame() || overlayAdDisplayEvent.nonLinearVideoAd.isScript()))
                    {
                        return;
                    }
                    this._Str_2596.displayNonLinearAd(overlayAdDisplayEvent);
                    if (_Str_2361 != null)
                    {
                        _Str_2361._Str_9754(_Str_2408.NONLINEAR, adSlot, overlayAdDisplayEvent.nonLinearVideoAd, this._Str_2378());
                    }
                    dispatchEvent(overlayAdDisplayEvent);
                }
            }
        }

        function _Str_23948(k:_Str_2833)
        {
            var _local_2:AdSlot = null;
            if (this._Str_8843())
            {
                _local_2 = k.adSlot;
                if (k.nonLinearVideoAd.isInteractive())
                {
                    this._Str_2596._Str_13449();
                }
                else
                {
                    this._Str_2596.hideNonLinearAd(k);
                }
            }
            dispatchEvent(k);
        }

        function _Str_22955(overlayAdDisplayEvent:_Str_2833)
        {
            var regionID:String = null;
            if (overlayAdDisplayEvent != null)
            {
                if (overlayAdDisplayEvent.nonLinearVideoAd.isInteractive())
                {
                    return;
                }
                try
                {
                    regionID = overlayAdDisplayEvent.nonLinearVideoAd.getActiveDisplayRegionID();
                    ExternalInterface.call("ova.displayNonLinearAd", [{
                        "regionID":regionID,
                        "content":{
                            "type":overlayAdDisplayEvent.nonLinearVideoAd.contentType(),
                            "format":overlayAdDisplayEvent.nonLinearVideoAd.getContentFormat(),
                            "raw":overlayAdDisplayEvent.nonLinearVideoAd.getRawContent(),
                            "formed":overlayAdDisplayEvent.nonLinearVideoAd.getContent()
                        },
                        "clickThroughURL":overlayAdDisplayEvent.nonLinearVideoAd.getClickThroughURLString(),
                        "impressions":overlayAdDisplayEvent.nonLinearVideoAd.parentAdContainer.getImpressionList(),
                        "trackingEvents":overlayAdDisplayEvent.nonLinearVideoAd.getTrackingEventList(),
                        "region":overlayAdDisplayEvent.nonLinearVideoAd.activeDisplayRegion,
                        "closeButton":overlayAdDisplayEvent.nonLinearVideoAd.activeDisplayRegion.buttonConfig,
                        "nonLinearVideoAd":overlayAdDisplayEvent.nonLinearVideoAd.toJSObject(),
                        "adSlot":overlayAdDisplayEvent.adSlot.toJSObject()
                    }]);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
        }

        function _Str_22643(overlayAdDisplayEvent:_Str_2833)
        {
            var regionID:String = null;
            if (overlayAdDisplayEvent != null)
            {
                if (overlayAdDisplayEvent.nonLinearVideoAd.isInteractive())
                {
                    return;
                }
                try
                {
                    regionID = overlayAdDisplayEvent.nonLinearVideoAd.getActiveDisplayRegionID();
                    ExternalInterface.call("ova.hideNonLinearAd", [{
                        "regionID":regionID,
                        "content":{
                            "type":overlayAdDisplayEvent.nonLinearVideoAd.contentType(),
                            "format":overlayAdDisplayEvent.nonLinearVideoAd.getContentFormat()
                        },
                        "region":overlayAdDisplayEvent.nonLinearVideoAd.activeDisplayRegion,
                        "closeButton":overlayAdDisplayEvent.nonLinearVideoAd.activeDisplayRegion.buttonConfig,
                        "nonLinearVideoAd":overlayAdDisplayEvent.nonLinearVideoAd.toJSObject(),
                        "adSlot":overlayAdDisplayEvent.adSlot.toJSObject()
                    }]);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
        }

        public function onShowAdNotice(k:_Str_3525)
        {
            if (this._Str_8843())
            {
                this._Str_2596._Str_12288(k);
            }
            dispatchEvent(k);
        }

        public function onTickAdNotice(k:_Str_3525)
        {
            if (this._Str_8843())
            {
                this._Str_2596._Str_12288(k);
            }
            dispatchEvent(k);
        }

        public function onHideAdNotice(k:_Str_3525)
        {
            if (this._Str_8843())
            {
                this._Str_2596._Str_5888(k);
            }
            dispatchEvent(k);
        }

        public function _Str_25709(k:OverlayView)
        {
            var _local_2:AdSlot = null;
            var _local_3:NonLinearVideoAd = null;
            var _local_4:_Str_4535 = null;
            if (k._Str_5530 != null)
            {
                _local_2 = k._Str_5530;
                if (_local_2 != null)
                {
                    _local_3 = _local_2._Str_14530();
                    _local_3.close();
                    _local_4 = new _Str_2833(_Str_2833._Str_18947, _local_3, _local_2);
                    dispatchEvent(_local_4);
                }
            }
        }

        public function _Str_22653(k:OverlayView, _arg_2:MouseEvent)
        {
            var _local_3:AdSlot = null;
            var _local_4:NonLinearVideoAd = null;
            var _local_5:_Str_4535 = null;
            var _local_6:String = null;
            if (k._Str_5530 != null)
            {
                _local_3 = k._Str_5530;
                _local_4 = _local_3._Str_14530();
                _local_4.clicked();
                _local_5 = new _Str_2833(_Str_2833._Str_16841, _local_4, _local_3, null, _arg_2);
                if (_local_3.hasLinearAd())
                {
                    k.hide();
                    dispatchEvent(_local_5);
                }
                else
                {
                    if ((_local_4._Str_10419() && (_local_4.isInteractive() == false)))
                    {
                        _local_6 = _local_4._Str_6447();
                        UserAgentUtils.openWindow(_local_6, this._Str_2297.adsConfig.clickSignConfig.target);
                    }
                    dispatchEvent(_local_5);
                }
                if (_Str_2361 != null)
                {
                    _Str_2361._Str_12452(_Str_2408.NONLINEAR, _local_3, _local_4, this._Str_2378());
                }
            }
        }

        public function _Str_17469(k:AdSlot)
        {
            var _local_2:LinearVideoAd = null;
            if (k != null)
            {
                _local_2 = k._Str_16720();
                if (((!(_local_2 == null)) && _local_2._Str_10419()))
                {
                    _local_2.clicked();
                    UserAgentUtils.openWindow(_local_2._Str_6447(), this._Str_2297.adsConfig.clickSignConfig.target);
                    dispatchEvent(new _Str_4041(_Str_4041._Str_16178, k));
                    if (_Str_2361 != null)
                    {
                        _Str_2361._Str_12452(_Str_2408.LINEAR, k, _local_2, this._Str_2378());
                    }
                }
            }
        }

        public function _Str_26121(k:VideoAd)
        {
            if (k != null)
            {
                if (k._Str_25033())
                {
                    k._Str_23092().call();
                }
            }
        }

        public function _Str_19858(k:Bool=false)
        {
            if (this._Str_2527 != null)
            {
                this._Str_2527._Str_19858(k);
            }
        }

        function _Str_17521(k:NonLinearVideoAd, _arg_2:String, _arg_3:String=null)
        {
            if (k != null)
            {
ASCompat.setDynamicProperty(                this._Str_4300, _arg_2, {
                    "companionAd":k,
                    "parentAdUID":_arg_3
                }
);            }
            else
            {
ASCompat.setDynamicProperty(                this._Str_4300, _arg_2, null);
            }
        }

        function _Str_21217(k:String)
        {
            this._Str_17521(null, k);
        }

        function _Str_26270(k:NonLinearVideoAd, _arg_2:String, _arg_3:String):Bool
        {
            if (((!(ASCompat.getDynamicProperty(this._Str_4300, _arg_2)== /*undefined*/null)) && (!(ASCompat.getDynamicProperty(this._Str_4300, _arg_2)== null))))
            {
                if (StringUtils._Str_2576(ASCompat.getDynamicProperty(this._Str_4300, _arg_2).parentAdUID, _arg_3))
                {
                    return cast(k, CompanionAd)._Str_12152(ASCompat.getDynamicProperty(this._Str_4300, _arg_2));
                }
            }
            return false;
        }

        function _Str_17313(k:String, _arg_2:String):Bool
        {
            if (((!(ASCompat.getDynamicProperty(this._Str_4300, k)== /*undefined*/null)) && (!(ASCompat.getDynamicProperty(this._Str_4300, k)== null))))
            {
                return StringUtils._Str_2576(ASCompat.getDynamicProperty(this._Str_4300, k).parentAdUID, _arg_2);
            }
            return false;
        }

        function _Str_20943(k:NonLinearVideoAd, _arg_2:String, _arg_3:String):Bool
        {
            if (((!(ASCompat.getDynamicProperty(this._Str_4300, _arg_2)== /*undefined*/null)) && (!(ASCompat.getDynamicProperty(this._Str_4300, _arg_2)== null))))
            {
                return !cast(k, CompanionAd)._Str_6420(ASCompat.toInt(ASCompat.getDynamicProperty(this._Str_4300, _arg_2).width), ASCompat.toInt(ASCompat.getDynamicProperty(this._Str_4300, _arg_2).height));
            }
            return true;
        }

        public function _Str_23635(companionEvent:_Str_3117)
        {
            var previousContent:String = null;
            var companionAd= companionEvent.companionAd;
            if (this._Str_7826())
            {
                if (companionEvent._Str_20014())
                {
                    if (companionEvent.content != null)
                    {
                        if (companionEvent.content.length > 0)
                        {
                            if (((this._Str_17313(companionEvent._Str_4022, companionAd._Str_7774()) == false) && this._Str_20943(companionEvent.companionAd, companionEvent._Str_4022, companionAd._Str_7774())))
                            {
                                try
                                {
                                    previousContent = ExternalInterface.call("ova.readHTML", [companionEvent._Str_4022]);
                                    companionAd._Str_20207(companionEvent._Str_4022, previousContent);
                                    this._Str_17521(companionEvent.companionAd, companionEvent._Str_4022, companionAd._Str_7774());
                                    ExternalInterface.call("ova.writeElement", [companionEvent._Str_4022, companionEvent.content]);
                                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                                 {
                                }
 }                            }
                        }
                    }
                }
                else
                {
                    if (companionEvent._Str_22404())
                    {
                    }
                }
            }
            else
            {
                if (companionEvent._Str_20014())
                {
                    if (companionEvent.content != null)
                    {
                        if (companionEvent.content.length > 0)
                        {
                            if (((this._Str_17313(companionEvent._Str_4022, companionAd._Str_7774()) == false) && this._Str_20943(companionEvent.companionAd, companionEvent._Str_4022, companionAd._Str_7774())))
                            {
                                try
                                {
                                    previousContent = ExternalInterface.call((("function() {return document.getElementById('" + companionEvent._Str_4022) + "').innerHTML; }"));
                                    companionAd._Str_20207(companionEvent._Str_4022, previousContent);
                                    if (((companionEvent.companionAd._Str_22114() && (companionEvent.companionAd._Str_3937() == false)) && BrowserUtils._Str_19725()))
                                    {
                                        ExternalInterface.call(companionEvent.content);
                                    }
                                    else
                                    {
                                        ExternalInterface.call((((("function(){ document.getElementById('" + companionEvent._Str_4022) + "').innerHTML='") + StringUtils._Str_22738(StringUtils._Str_22866(companionEvent.content))) + "'; }"));
                                    }
                                    this._Str_17521(companionEvent.companionAd, companionEvent._Str_4022, companionAd._Str_7774());
                                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                                 {
                                }
 }                            }
                        }
                    }
                }
            }
        }

        public function _Str_23759(companionEvent:_Str_3117):Bool
        {
            var companionAd= companionEvent.companionAd;
            if (companionAd._Str_24622())
            {
                if (this._Str_7826())
                {
                    try
                    {
                        ExternalInterface.call("ova.writeHTML", [companionAd._Str_8601, companionAd._Str_15576]);
                        this._Str_21217(companionAd._Str_8601);
                        companionAd._Str_21728();
                    }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                     {
                    }
 }                }
                else
                {
                    try
                    {
                        ExternalInterface.call((((("function(){ document.getElementById('" + companionAd._Str_8601) + "').innerHTML='") + StringUtils._Str_21602(companionAd._Str_15576)) + "'; }"));
                        this._Str_21217(companionAd._Str_8601);
                        companionAd._Str_21728();
                    }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                     {
                    }
 }                }
                return true;
            }
            return false;
        }

        public function displayingCompanions():Bool
        {
            return this._Str_2297.displayCompanions;
        }

        public function _Str_7826():Bool
        {
            return this._Str_2297._Str_7826;
        }

        public function _Str_22059():Bool
        {
            return this._Str_2297._Str_22059;
        }

        function _Str_18864(k:CompanionAd, _arg_2:ASObject):Bool
        {
            var _local_5:String = null;
            var _local_6:_Str_3117 = null;
            if (this._Str_17313(_arg_2.id, k._Str_7774()))
            {
                return false;
            }
            var _local_3 = false;
            var _local_4 = false;
            if (((!(_arg_2.resourceType == /*undefined*/null)) && (_arg_2.creativeType == /*undefined*/null)))
            {
                _local_4 = k._Str_16909(ASCompat.toInt(_arg_2.width), ASCompat.toInt(_arg_2.height), _arg_2.resourceType);
            }
            else
            {
                if (_arg_2.index != /*undefined*/null)
                {
                    _local_4 = k._Str_18832(ASCompat.toInt(_arg_2.width), ASCompat.toInt(_arg_2.height), ASCompat.toInt(_arg_2.index));
                }
                else
                {
                    if (((!(_arg_2.creativeType == /*undefined*/null)) && (!(_arg_2.resoruceType == /*undefined*/null))))
                    {
                        _local_4 = k._Str_16856(ASCompat.toInt(_arg_2.width), ASCompat.toInt(_arg_2.height), _arg_2.creativeType, _arg_2.resourceType);
                    }
                    else
                    {
                        _local_4 = k._Str_6420(ASCompat.toInt(_arg_2.width), ASCompat.toInt(_arg_2.height));
                    }
                }
            }
            if (_local_4)
            {
                _local_3 = true;
                _local_5 = k._Str_23484(this.config.adsConfig.additionalParamsForSWFCompanions, this._Str_7826(), _arg_2.id, BrowserUtils._Str_19725());
                if (_local_5 != null)
                {
                    _local_6 = new _Str_3117(_Str_3117._Str_3831, k);
                    _local_6._Str_4022 = _arg_2.id;
                    _local_6.content = _local_5;
                    _arg_2.activeAdID = k.parentAdContainer.id;
                    if (this._Str_17706)
                    {
                        this._Str_23635(_local_6);
                    }
                    dispatchEvent(_local_6);
                }
            }
            return _local_3;
        }

        function _Str_25292(companionAd:CompanionAd, companionDivIDs:Array<ASAny>, delay:Int):Bool
        {
            var tickCounter = 0;
            var matchFound = false;
            var displayTimer= new Timer(delay, companionDivIDs.length);
            tickCounter = 0;
            displayTimer.addEventListener(TimerEvent.TIMER, (function (k:TimerEvent)
            {
                if (_Str_18864(companionAd, companionDivIDs[tickCounter]))
                {
                    matchFound = true;
                }
                tickCounter++;
            } : ASAny));
            displayTimer.start();
            return matchFound;
        }

        function _Str_24072(k:CompanionAd, _arg_2:Array<ASAny>):Bool
        {
            var _local_3 = false;
            var _local_4 = 0;
            while (_local_4 < _arg_2.length)
            {
                if (this._Str_18864(k, _arg_2[_local_4]))
                {
                    _local_3 = true;
                }
                _local_4++;
            }
            return _local_3;
        }

        public function onDisplayCompanionAd(k:_Str_3117):Bool
        {
            var _local_3:Array<ASAny> = null;
            var _local_2= k.companionAd;
            if (this._Str_2297._Str_8478())
            {
                _local_3 = this._Str_2297.companionDivIDs;
                if (this._Str_2297._Str_12146())
                {
                    return this._Str_25292(_local_2, _local_3, this._Str_2297.millisecondDelayOnCompanionInjection);
                }
                return this._Str_24072(_local_2, _local_3);
            }
            return false;
        }

        public function onHideCompanionAd(k:_Str_3117):Bool
        {
            var _local_2 = false;
            if (this._Str_2297.restoreCompanions)
            {
                if (this._Str_17706)
                {
                    _local_2 = this._Str_23759(k);
                }
                dispatchEvent(new _Str_3117(_Str_3117._Str_2703, k.companionAd));
            }
            return _local_2;
        }

        function _Str_20042(k:String, _arg_2:String=null)
        {
            if (k != null)
            {
ASCompat.setDynamicProperty(                this._Str_14426, k, _arg_2);
            }
            else
            {
ASCompat.setDynamicProperty(                this._Str_14426, k, null);
            }
        }

        function _Str_24803(k:String)
        {
            this._Str_20042(k, null);
        }

        function _Str_24233(k:String):String
        {
            return ASCompat.getDynamicProperty(this._Str_14426, k);
        }

        public function onSurveyDisplay(surveyUrl:String)
        {
            var previousContent:String = null;
            var surveyMarkup:String = null;
            if (this._Str_2297.adsConfig._Str_5168.declared())
            {
                try
                {
                    previousContent = ExternalInterface.call("ova.readHTML", [this._Str_2297.adsConfig._Str_5168.id]);
                    this._Str_20042(this._Str_2297.adsConfig._Str_5168.id, previousContent);
                    surveyMarkup = (("<iframe frameborder=0 src='" + surveyUrl) + "'></iframe>");
                    ExternalInterface.call("ova.writeElement", [this._Str_2297.adsConfig._Str_5168.id, surveyMarkup]);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
        }

        public function onSurveyHide()
        {
            if ((this._Str_2297.adsConfig._Str_5168.declared() && this._Str_2297.adsConfig._Str_5168.restore))
            {
                try
                {
                    ExternalInterface.call("ova.writeHTML", [this._Str_2297.adsConfig._Str_5168.id, this._Str_24233(this._Str_2297.adsConfig._Str_5168.id)]);
                    this._Str_24803(this._Str_2297.adsConfig._Str_5168.id);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
        }

        override public function addEventListener(k:String, _arg_2:ASFunction, _arg_3:Bool=false, _arg_4:Int=0, _arg_5:Bool=false)
        {
            if (k.indexOf("region-") > -1)
            {
                if (this._Str_2596 != null)
                {
                    this._Str_2596.addEventListener(k, (_arg_2 : ASAny), _arg_3, _arg_4, _arg_5);
                }
            }
            else
            {
                super.addEventListener(k, _arg_2, _arg_3, _arg_4, _arg_5);
            }
        }

        override public function removeEventListener(k:String, _arg_2:ASFunction, _arg_3:Bool=false)
        {
            if (k.indexOf("region-") > -1)
            {
                if (this._Str_2596 != null)
                {
                    this._Str_2596.addEventListener(k, (_arg_2 : ASAny), _arg_3);
                }
            }
            else
            {
                super.removeEventListener(k, _arg_2, _arg_3);
            }
        }

        public function _Str_25903():String
        {
            if (this._Str_2620 != null)
            {
                return this._Str_2620._Str_18406();
            }
            return "No VAST response available";
        }
    }

