package com.sulake.core.window.tools
;
    import flash.geom.Point;
    import com.sulake.core.runtime.IProfiler;
    import com.sulake.core.runtime.ICore;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.ICoreWindowManager;
    import com.sulake.core.window.graphics.IWindowRenderer;
    import com.sulake.core.utils.Map;
    import com.sulake.core.runtime.IContext;
    import flash.utils.ByteArray;
    import com.sulake.core.window.components.ILabelWindow;
    import com.sulake.core.runtime.IIDProfiler;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import flash.events.Event;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.utils.profiler.ProfilerAgentTask;
    import flash.display.BitmapData;
    import com.sulake.core.window.tools.binaryData.*;

     class ProfilerOutput implements IDevTool 
    {
        static final ZERO_POINT:Point = new Point();
        static var _Str_15863:Class<Dynamic> = ProfilerOutput__Str_15863;
        static var _Str_15882:Class<Dynamic> = ProfilerOutput__Str_15882;

        var _disposed:Bool = false;
        var _profilerComponent:IProfiler;
        var _core:ICore;
        var _window:IFrameWindow;
        var _windowItemArray:Array<ASAny>;
        var _windowManager:ICoreWindowManager;
        var _windowRenderer:IWindowRenderer;
        var _memoryTracking:Bool = false;
        var _windowToTaskMap:Map;

        public function new(context:IContext, windowManager:ICoreWindowManager, windowRenderer:IWindowRenderer)
        {
            this._core = Std.downcast(context , ICore);
            this._windowItemArray = new Array<ASAny>();
            this._profilerComponent = this.profiler;
            this._windowManager = windowManager;
            this._windowRenderer = windowRenderer;
            this._windowToTaskMap = new Map();
        }

        static function padAlign(k:String, _arg_2:Int, _arg_3:String=" ", _arg_4:Bool=false):String
        {
            var _local_5= (_arg_2 - k.length);
            if (_local_5 <= 0)
            {
                return k.substring(0, _arg_2);
            }
            var _local_6= "";
            var _local_7 = 0;
            while (_local_7 < _local_5)
            {
                _local_6 = (_local_6 + _arg_3);
                _local_7++;
            }
            return _arg_4 ? (_local_6 + k) : (k + _local_6);
        }


        public var caption(get,never):String;
public function  get_caption():String
        {
            return "Component Profiler";
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var visible(get,set):Bool;
public function  get_visible():Bool
        {
            return (this._window != null) && this._window.visible;
        }
public function  set_visible(value:Bool):Bool        {
            var bytes:com.sulake.core.utils.ByteArray = null;
            var xml:com.sulake.core.utils.xml.XML = null;
            if (((!(this._window != null)) && value))
            {
                bytes = ASCompat.asByteArray(Type.createInstance(_Str_15863, []) );
                xml = new com.sulake.core.utils.xml.XML(bytes.readUTFBytes(bytes.length));
                this._window = Std.downcast(this._windowManager.buildFromXML(xml, 2) , IFrameWindow);
                this._window.procedure = this.profilerWindowEventProc;
                this._window.findChildByName("header").caption = (((((((padAlign("task", 28) + "|") + padAlign("#rounds", 8)) + "|") + padAlign("latest ms", 8)) + "|") + padAlign("total ms", 8)) + "|");
                this._window.findChildByName("footer").caption = "<- Click to enable bitmap memory tracking";
                cast(this._window.findChildByName("footer"), ILabelWindow).textColor = 0xFF666666;
            }
            if (this._window != null)
            {
                if (value)
                {
                    this._window.activate();
                    this._core.setProfilerMode(true);
                    this._core.queueInterface(new IIDProfiler(), function (k:com.sulake.core.runtime.IID, _arg_2:com.sulake.core.runtime.IUnknown)
                    {
                        profiler = ASCompat.reinterpretAs(_arg_2 , IProfiler);
                    });
                }
                else
                {
                    this._core.setProfilerMode(false);
                    this._window.dispose();
                    this._window = null;
                }
            }
return value;
        }

        
        public var profiler(get,set):IProfiler;
public function  set_profiler(k:IProfiler):IProfiler        {
            if (this._profilerComponent != null)
            {
                this._profilerComponent.removeStopEventListener(this.refresh);
                this._profilerComponent = null;
            }
            if (((!(this._profilerComponent != null)) && (k != null)))
            {
                this._profilerComponent = k;
                this._profilerComponent.addStopEventListener(this.refresh);
            }
return k;
        }
public function  get_profiler():IProfiler
        {
            return this._profilerComponent;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._window != null)
                {
                    this._window.dispose();
                    this._window = null;
                }
                this._profilerComponent.removeStopEventListener(this.refresh);
                this._profilerComponent = null;
                this._windowManager = null;
                this._windowRenderer = null;
                this._windowToTaskMap.dispose();
                this._windowToTaskMap = null;
                this._disposed = true;
            }
        }

        function profilerWindowEventProc(windowEvent:WindowEvent, window:IWindow)
        {
            if (windowEvent.type == WindowMouseEvent.CLICK)
            {
                if (window.tags.indexOf("close") > -1)
                {
                    this.visible = false;
                }
                else
                {
                    if (window.name == "button_gc")
                    {
                        this._profilerComponent.gc();
                    }
                }
            }
            if (window.name == "footer_enable_toggle")
            {
                if (windowEvent.type == WindowEvent.WINDOW_EVENT_SELECTED)
                {
                    this._memoryTracking = true;
                    cast(this._window.findChildByName("footer"), ILabelWindow).textColor = 0xFF000000;
                }
                else
                {
                    if (windowEvent.type == WindowEvent.WINDOW_EVENT_UNSELECTED)
                    {
                        this._memoryTracking = false;
                        cast(this._window.findChildByName("footer"), ILabelWindow).textColor = 0xFF666666;
                    }
                }
            }
        }

        public function refresh(k:Event)
        {
            if (this._window == null)
            {
                return;
            }
            this._windowToTaskMap.reset();
            var _local_2= this._profilerComponent.getProfilerAgentsInArray();
            var _local_3= Std.downcast(this._window.findChildByName("list") , IItemListWindow);
            var _local_4:UInt = 0;
            while (_local_2.length > 0)
            {
                _local_4 = this.recursiveRedraw(_local_2.pop(), _local_3, _local_4, 0);
            }
            if (this._memoryTracking)
            {
                this._window.findChildByName("footer").caption = (((((((((((("Assets - Libraries: " + Std.string(this._profilerComponent.numAssetLibraryInstances)) + " ") + "Bitmaps: ") + Std.string(this._profilerComponent.numBitmapAssetInstances)) + " / ") + Std.string(this._profilerComponent.numAllocatedBitmapDataBytes)) + " bytes \n") + "Tracked bitmap data: ") + Std.string(this._profilerComponent.numTrackedBitmapDataInstances)) + " / ") + Std.string(this._profilerComponent.numTrackedBitmapDataBytes)) + " bytes");
            }
        }

        function recursiveRedraw(k:ProfilerAgentTask, _arg_2:IItemListWindow, _arg_3:UInt, _arg_4:UInt):UInt
        {
            var _local_5:IWindowContainer = null;
            var _local_9:IBitmapWrapperWindow = null;
            if (_arg_3 >= (_arg_2.numListItems : UInt))
            {
                _local_5 = this.createListItem(_arg_2);
            }
            else
            {
                _local_5 = Std.downcast(_arg_2.getListItemAt(_arg_3) , IWindowContainer);
            }
            var _local_6= k.name;
            if (_arg_4 > 0)
            {
                _local_6 = padAlign(_local_6, ASCompat.toInt(_arg_4 + _local_6.length), "-", true);
            }
            var _local_7= _local_5.findChildByName("text") ;
            _local_7.caption = (((((((padAlign(_local_6, 28, " ", false) + "|") + padAlign(Std.string(k.rounds), 8, " ", true)) + "|") + padAlign(Std.string(k.latest), 8, " ", true)) + "|") + padAlign(Std.string(k.total), 8, " ", true)) + "|\r");
            _local_5.findChildByName("caption").caption = k.caption;
            _local_5.findChildByName("check").setStateFlag(WindowState.SELECTED, (!k.paused));
            this._windowToTaskMap.add(_local_5, k);
            if (!k.paused)
            {
                _local_9 = Std.downcast(_local_5.findChildByName("canvas") , IBitmapWrapperWindow);
                this.refreshBitmapImage(_local_9, k);
            }
            _arg_3++;
            var _local_8:UInt = 0;
            while (_local_8 < k.numSubTasks)
            {
                _arg_3 = this.recursiveRedraw(k.getSubTaskAt(_local_8), _arg_2, _arg_3, (_arg_4 + 1));
                _local_8++;
            }
            return _arg_3;
        }

        function refreshBitmapImage(k:IBitmapWrapperWindow, _arg_2:ProfilerAgentTask)
        {
            var _local_3= k.bitmap;
            if (_local_3 == null)
            {
                _local_3 = new BitmapData(k.width, k.height, false, 0xFFFFFFFF);
                k.bitmap = _local_3;
            }
            var _local_4= _local_3.rect;
            var _local_5= _arg_2.latest;
            var _local_6= ((_local_5 > _local_3.height) ? _local_3.height : _local_5);
            _local_4.x = (_local_4.x + 1);
            _local_4.width--;
            _local_3.copyPixels(_local_3, _local_4, ZERO_POINT);
            _local_4.x = (_local_4.x + (_local_4.width - 2));
            _local_4.y = (_local_4.y + (_local_4.height - _local_6));
            _local_4.width = 1;
            _local_4.height = _local_6;
            _local_3.fillRect(_local_4, ((_local_5 > _local_3.height) ? 0xFFFF0000 : 0xFF0000FF));
            k.invalidate();
        }

        function createListItem(k:IItemListWindow):IWindowContainer
        {
            var _local_2= ASCompat.asByteArray(Type.createInstance(_Str_15882, []) );
            var _local_3= new com.sulake.core.utils.xml.XML(_local_2.readUTFBytes(_local_2.length));
            var _local_4= Std.downcast(this._windowManager.buildFromXML(_local_3, 2) , IWindowContainer);
            k.addListItem(_local_4);
            var _local_5= _local_4.findChildByName("check");
            _local_5.addEventListener(WindowMouseEvent.CLICK, this.onCheckMouseClick);
            return _local_4;
        }

        function onCheckMouseClick(k:WindowEvent)
        {
            var _local_2= k.window;
            var _local_3:ProfilerAgentTask = this._windowToTaskMap.getValue(_local_2.parent);
            if (_local_3 != null)
            {
                _local_3.paused = (!_local_2.getStateFlag(WindowState.SELECTED));
            }
        }
    }

