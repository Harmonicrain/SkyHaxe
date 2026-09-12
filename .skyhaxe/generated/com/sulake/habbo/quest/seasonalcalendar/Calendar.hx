package com.sulake.habbo.quest.seasonalcalendar
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.quest.HabboQuestEngine;
    import flash.display.BitmapData;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.utils.Timer;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import flash.events.TimerEvent;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.ITextWindow;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class Calendar implements IDisposable implements  IUpdateReceiver 
    {
        static inline final BACKGROUND_= "background_";
        static inline final DAY= "day";
        static inline final _UNCOMPLETE= "_uncomplete";
        static inline final _COMPLETED= "_completed";
        static inline final _Str_17255= 2;
        static inline final _Str_14469= 3;
        static inline final _Str_6370= 80;
        static inline final _Str_16834= 37;
        static inline final _Str_11600= 7;
        static inline final _Str_17373= 5;
        static inline final _Str_13135= 2000;
        static inline final _Str_16510= 100;

        var _questEngine:HabboQuestEngine;
        var _mainWindow:MainWindow;
        var _quests:Array<ASAny>;
        var _backgroundImageCache:Vector<BitmapData>;
        var _graphicEntityCache:Vector<BitmapData>;
        var _assetNameToIndexMap:Map;
        var _bgAssetNameArray:Array<ASAny>;
        var _imageGalleryHost:String;
        var _bgRenderer:CalendarBackgroundRenderer;
        var _entityWindows:Vector<IWindowContainer>;
        var _states:Array<ASAny>;
        var _leftArrow:CalendarArrowButton;
        var _rightArrow:CalendarArrowButton;
        var _containerWindow:IWindowContainer;
        var _entityWindowTemplate:IWindowContainer;
        var _backgroundSlice:IBitmapWrapperWindow;
        var _viewIndex:Int = -1;
        var _totalEntityCount:Int = -1;
        var _highestAvailableQuestIndex:Int = -1;
        var _maximumEntities:Int = 42;
        var _scrollTimer:Timer;
        var _scrollOffset:Int = 0;
        var _scrollDelta:Int = 0;
        var _scrollBgStartOffset:Int = 0;
        var _flashingPanelIndex:Int = -1;
        var _flashingOffsetMs:Int = 0;
        var _hoveringIndex:Int = -1;
        var _scrollLeftPressed:Bool = false;
        var _scrollRightPressed:Bool = false;
        var _dateRefreshTimer:Timer;
        var _lastDate:Int = -1;

        public function new(k:HabboQuestEngine, _arg_2:MainWindow)
        {
            this._questEngine = k;
            this._mainWindow = _arg_2;
        }

        static function _Str_21268(k:UInt, _arg_2:Int):UInt
        {
            var _local_3= Std.int(Math.min(0xFF, Math.max(0, (((ASCompat.toInt(k )>> 16) & 0xFF) + _arg_2))));
            var _local_4= Std.int(Math.min(0xFF, Math.max(0, (((ASCompat.toInt(k )>> 8) & 0xFF) + _arg_2))));
            var _local_5= Std.int(Math.min(0xFF, Math.max(0, ((ASCompat.toInt(k )& 0xFF) + _arg_2))));
            return (((_local_3 & 0xFF) << 16) + ((_local_4 & 0xFF) << 8)) + (_local_5 & 0xFF);
        }


        function _Str_22523():String
        {
            return this._imageGalleryHost;
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                this._questEngine.removeUpdateReceiver(this);
                this._Str_17476();
                if (this._bgRenderer != null)
                {
                    this._bgRenderer.dispose();
                    this._bgRenderer = null;
                }
                if (this._leftArrow != null)
                {
                    this._leftArrow.dispose();
                    this._leftArrow = null;
                }
                if (this._rightArrow != null)
                {
                    this._rightArrow.dispose();
                    this._rightArrow = null;
                }
                if (this._scrollTimer != null)
                {
                    this._scrollTimer.stop();
                    this._scrollTimer = null;
                }
                if (this._dateRefreshTimer != null)
                {
                    this._dateRefreshTimer.stop();
                    this._dateRefreshTimer = null;
                }
                this._backgroundImageCache = null;
                this._graphicEntityCache = null;
                this._states = null;
                this._assetNameToIndexMap = null;
                this._bgAssetNameArray = null;
                this._questEngine = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._questEngine == null;
        }

        public function _Str_8212(k:Array<ASAny>)
        {
            var _local_2= Date.now();
            this._lastDate = Std.int(_local_2.getDate());
            var _local_3= this._totalEntityCount;
            this._quests = [];
            this._highestAvailableQuestIndex = 0;
            var _local_4:QuestMessageData = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_4  = _tmp_;
                if (this._questEngine._Str_7575(_local_4))
                {
                    this._quests.push(_local_4);
                    if (this._highestAvailableQuestIndex < (_local_4.sortOrder - 1))
                    {
                        this._highestAvailableQuestIndex = (_local_4.sortOrder - 1);
                    }
                }
            }
            ASCompat.ASArray.sortOn(this._quests, ["sortOrder"], 0);
            this._maximumEntities = ASCompat.toInt(this._questEngine.configuration.getProperty("seasonalQuestCalendar.maximum.entities"));
            this._totalEntityCount = Std.int(Math.min(this._maximumEntities, ((this._highestAvailableQuestIndex + 1) + _Str_17255)));
            if (((!(_local_3 == -1)) && (this._totalEntityCount > _local_3)))
            {
                this._Str_20728();
            }
        }

        public function prepare(k:IFrameWindow)
        {
            var _local_2:IBitmapWrapperWindow = null;
            this._imageGalleryHost = this._mainWindow._Str_22087();
            this._containerWindow = cast(k.findChildByName("calendar_cont"), IWindowContainer);
            this._backgroundSlice = cast(k.findChildByName("background_slice"), IBitmapWrapperWindow);
            this._entityWindowTemplate = cast(k.findChildByName("entity_template"), IWindowContainer);
            this._entityWindowTemplate.visible = false;
            this._bgRenderer = new CalendarBackgroundRenderer();
            this._leftArrow = new CalendarArrowButton(this._questEngine.assets, cast(k.findChildByName("button_left"), IBitmapWrapperWindow), CalendarArrowButton._Str_14486, this._Str_20617);
            this._rightArrow = new CalendarArrowButton(this._questEngine.assets, cast(k.findChildByName("button_right"), IBitmapWrapperWindow), CalendarArrowButton._Str_13915, this._Str_20617);
            _local_2 = cast(k.findChildByName("stripe_mask_left"), IBitmapWrapperWindow);
            _local_2.bitmap = cast(this._questEngine.assets.getAssetByName("stripe_mask_L").content, BitmapData);
            _local_2 = cast(k.findChildByName("stripe_mask_right"), IBitmapWrapperWindow);
            _local_2.bitmap = cast(this._questEngine.assets.getAssetByName("stripe_mask_R").content, BitmapData);
            if (this._viewIndex == -1)
            {
                this._Str_25787(this._mainWindow._Str_5472);
            }
            this._Str_20728();
            var _local_3= Date.now();
            this._lastDate = Std.int(_local_3.getDate());
            this._dateRefreshTimer = new Timer(((1000 * 60) * _Str_17373));
            this._dateRefreshTimer.addEventListener(TimerEvent.TIMER, (this._Str_20564 : ASAny));
            this._dateRefreshTimer.start();
            this._Str_20564(new TimerEvent(TimerEvent.TIMER));
            this._questEngine.registerUpdateReceiver(this, 1);
            this._scrollTimer = new Timer(10, 10);
        }

        public function close()
        {
            this._Str_17476();
            if (this._bgRenderer != null)
            {
                this._bgRenderer._Str_17621(new Vector<BitmapData>());
            }
        }

        public function refresh()
        {
            var k:QuestMessageData = null;
            var _local_2 = 0;
            var _local_3 = 0;
            final _iter_ = this._quests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                _local_2 = (k.sortOrder - 1);
                _local_3 = ASCompat.toInt(k._Str_6695 ? CalendarEntityStateEnums._Str_6598 : ASCompat.toInt(this._states[_local_2]));
                if (_local_3 != this._states[_local_2])
                {
                    this._Str_10587(k.sortOrder, _local_3);
                    this._Str_12604(_local_2, false);
                    if (((_local_3 == CalendarEntityStateEnums._Str_6598) && (this._flashingPanelIndex == _local_2)))
                    {
                        this._Str_23591();
                    }
                }
            }
            this._Str_17497();
            this._Str_18525();
        }

        public function _Str_25787(k:Int)
        {
            this._Str_17875(Std.int(Math.max(0, Math.min((k - _Str_14469), this._Str_20265))));
        }

        function _Str_20728()
        {
            var _local_5:QuestMessageData = null;
            var _local_7 = 0;
            var _local_8 = false;
            var _local_9 = 0;
            var k= Std.int(Math.fceil((this._totalEntityCount / _Str_11600)) + 1);
            this._bgAssetNameArray = ASCompat.allocArray(k);
            this._backgroundImageCache = new Vector<BitmapData>(k);
            this._graphicEntityCache = new Vector<BitmapData>(this._totalEntityCount);
            this._states = ASCompat.allocArray(this._totalEntityCount);
            var _local_2= new Vector<BitmapData>();
            var _local_3 = 0;
            while (_local_3 < k)
            {
                _local_2.push(new BitmapData(640, 320, false, 0xFFFFFF));
                _local_3++;
            }
            this._bgRenderer._Str_17621(_local_2);
            var _local_4= this._Str_19819;
            while (_local_4 <= this._Str_21863)
            {
                this._Str_19830(_local_4);
                _local_4++;
            }
            this._assetNameToIndexMap = new Map();
            final _iter_ = this._quests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                if (_local_5.sortOrder <= this._maximumEntities)
                {
                    _local_7 = (_local_5._Str_6695 ? CalendarEntityStateEnums._Str_6598 : CalendarEntityStateEnums._Str_4670);
                    _local_8 = (((_local_5.sortOrder - 1) >= this._Str_16038) && ((_local_5.sortOrder - 1) <= this._Str_13332));
                    this._Str_10587(_local_5.sortOrder, _local_7, (!_local_8));
                }
            }
            if (this._quests.length < this._totalEntityCount)
            {
                _local_9 = (this._highestAvailableQuestIndex + 1);
                while (_local_9 < this._totalEntityCount)
                {
                    this._Str_10587((_local_9 + 1), CalendarEntityStateEnums._Str_10437, (_local_9 > this._Str_13332));
                    _local_9++;
                }
            }
            var _local_6 = 0;
            while (_local_6 < this._totalEntityCount)
            {
                if (this._states[_local_6] == null)
                {
                    this._Str_10587((_local_6 + 1), CalendarEntityStateEnums._Str_11118, ((_local_6 < this._Str_16038) || (_local_6 > this._Str_13332)));
                }
                _local_6++;
            }
        }

        function _Str_17497()
        {
            var _local_4 = 0;
            var _local_5:BitmapData = null;
            if (!this._Str_20367())
            {
                return;
            }
            var k= new Array<ASAny>();
            var _local_2= new Vector<BitmapData>();
            var _local_3 = 0;
            while (_local_3 < this._backgroundImageCache.length)
            {
                _local_5 = this._backgroundImageCache[_local_3];
                if (_local_5 != null)
                {
                    _local_2.push(_local_5);
                }
                else
                {
                    _local_2.push(new BitmapData(640, 320, false, 0xFFFFFF));
                    k.push(_local_3);
                }
                _local_3++;
            }
            this._bgRenderer._Str_17621(_local_2);
            this._Str_21328();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_4  = ASCompat.toInt(_tmp_);
                this._Str_19830(_local_4);
            }
        }

        function _Str_17476()
        {
            var k:IWindow = null;
            if (this._entityWindows == null)
            {
                return;
            }
            final _iter_ = this._entityWindows; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this._containerWindow.removeChild(k);
                k.dispose();
            }
            this._entityWindows = null;
        }

        function _Str_18525()
        {
            var _local_2:BitmapData = null;
            var _local_3:IWindow = null;
            var _local_4:IWindow = null;
            var _local_5 = 0;
            var _local_6:IWindowContainer = null;
            var _local_7 = 0;
            var _local_8:IWindow = null;
            var _local_9:IBitmapWrapperWindow = null;
            if (!this._Str_19327())
            {
                return;
            }
            this._Str_17476();
            if (this._entityWindows == null)
            {
                this._entityWindows = new Vector<IWindowContainer>();
            }
            var k= new Array<ASAny>();
            final _iter_ = this._graphicEntityCache; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_6 = cast(this._entityWindowTemplate.clone(), IWindowContainer);
                _local_7 = this._entityWindows.length;
                if (_local_2 != null)
                {
                    _local_9 = Std.downcast(_local_6.findChildByName("entity_bitmap") , IBitmapWrapperWindow);
                    _local_9.width = _local_2.width;
                    _local_9.height = _local_2.height;
                    _local_9.bitmap = _local_2.clone();
                }
                else
                {
                    k.push(_local_7);
                }
                _local_8 = _local_6.findChildByName("entity_mouse_region");
                _local_8.procedure = this._Str_25473;
                if ((((this._states[_local_7] == CalendarEntityStateEnums._Str_10437) || (this._states[_local_7] == CalendarEntityStateEnums._Str_6598)) || (this._states[_local_7] == CalendarEntityStateEnums._Str_11118)))
                {
                    _local_8.visible = false;
                }
                _local_6.visible = true;
                this._containerWindow.addChild(_local_6);
                this._entityWindows.push(_local_6);
                this._Str_12604(_local_7, false);
            }
            this._Str_18500();
            this._Str_16447();
            _local_3 = this._containerWindow.findChildByName("stripe_mask_left");
            this._containerWindow.setChildIndex(_local_3, (this._containerWindow.numChildren - 1));
            _local_3 = this._containerWindow.findChildByName("stripe_mask_right");
            this._containerWindow.setChildIndex(_local_3, (this._containerWindow.numChildren - 1));
            _local_4 = this._containerWindow.findChildByName("button_left");
            this._containerWindow.setChildIndex(_local_4, (this._containerWindow.numChildren - 1));
            _local_4 = this._containerWindow.findChildByName("button_right");
            this._containerWindow.setChildIndex(_local_4, (this._containerWindow.numChildren - 1));
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_5  = ASCompat.toInt(_tmp_);
                this._Str_10587((_local_5 + 1), ASCompat.toInt(this._states[_local_5]));
            }
            if (this._states[(this._mainWindow._Str_5472 - 1)] == CalendarEntityStateEnums._Str_4670)
            {
                this._Str_25266((this._mainWindow._Str_5472 - 1));
            }
        }

        var _Str_16038(get,never):Int;
function  get__Str_16038():Int
        {
            var k= (this._viewIndex - 1);
            return (k < 0) ? 0 : k;
        }

        var _Str_13332(get,never):Int;
function  get__Str_13332():Int
        {
            var k= ((this._viewIndex + _Str_11600) + 1);
            var _local_2= (this._totalEntityCount - 1);
            return (k > _local_2) ? _local_2 : k;
        }

        function _Str_19327():Bool
        {
            if (this._graphicEntityCache == null)
            {
                return false;
            }
            var k= this._Str_16038;
            while (k <= this._Str_13332)
            {
                if (this._graphicEntityCache[k] == null)
                {
                    return false;
                }
                k++;
            }
            return true;
        }

        var _Str_19819(get,never):Int;
function  get__Str_19819():Int
        {
            var k= this._Str_9194(this._viewIndex);
            var _local_2= this._bgRenderer._Str_17008(k);
            return (_local_2 < 0) ? 0 : _local_2;
        }

        var _Str_21863(get,never):Int;
function  get__Str_21863():Int
        {
            var k= this._Str_9194(this._viewIndex);
            return this._bgRenderer._Str_17008((k + 640));
        }

        function _Str_20367():Bool
        {
            if (this._backgroundImageCache == null)
            {
                return false;
            }
            var k= this._Str_9194(this._viewIndex);
            var _local_2= this._Str_19819;
            while (_local_2 <= this._Str_21863)
            {
                if (this._backgroundImageCache[_local_2] == null)
                {
                    return false;
                }
                _local_2++;
            }
            return true;
        }

        function _Str_12604(k:Int, _arg_2:Bool)
        {
            var _local_8:BitmapData = null;
            var _local_9:String = null;
            if (((this._entityWindows == null) || (this._entityWindows.length < (k - 1))))
            {
                return;
            }
            var _local_3= cast(this._entityWindows[k].findChildByName("entity_indicator"), IBorderWindow);
            var _local_4= ASCompat.toUInt(CalendarEntityStateEnums._Str_15574[ASCompat.toInt(this._states[k])]);
            if (_arg_2)
            {
                _local_4 = (_local_4 + 0x202020);
            }
            if (this._flashingPanelIndex != k)
            {
                _local_3.color = _local_4;
            }
            var _local_5= cast(this._entityWindows[k].findChildByName("entity_indicator_status"), IBitmapWrapperWindow);
            if (this._states[k] == CalendarEntityStateEnums._Str_6598)
            {
                _local_8 = cast(this._questEngine.assets.getAssetByName("calendar_quest_complete").content, BitmapData);
                _local_5.width = _local_8.width;
                _local_5.height = _local_8.height;
                _local_5.bitmap = _local_8.clone();
            }
            else
            {
                _local_5.bitmap = null;
            }
            var _local_6= Std.downcast(_local_3.findChildByName("entity_indicator_text") , ITextWindow);
            var _local_7= this._Str_19266(k);
            if (_local_7 != null)
            {
                _local_6.text = this._questEngine._Str_15926(_local_7);
            }
            else
            {
                _local_9 = QuestMessageData._Str_18415(((this._questEngine._Str_9628() + "_") + Std.string(k + 1)));
                _local_6.text = this._questEngine._Str_21680(_local_9);
            }
        }

        function _Str_10587(k:Int, _arg_2:Int, _arg_3:Bool=false)
        {
            var _local_4= (DAY + Std.string(k));
            switch (_arg_2)
            {
                case CalendarEntityStateEnums._Str_4670
                   | CalendarEntityStateEnums._Str_10437
                   | CalendarEntityStateEnums._Str_11118:
                    _local_4 = (_local_4 + _UNCOMPLETE);
                    
                case CalendarEntityStateEnums._Str_6598:
                    _local_4 = (_local_4 + _COMPLETED);
                    
            }
            this._states[(k - 1)] = _arg_2;
            this._assetNameToIndexMap.setProperty(_local_4, (k - 1));
            var _local_5= this._questEngine.assets.getAssetByName(_local_4);
            if (_local_5 != null)
            {
                this._Str_19114(_local_4);
                this._Str_18525();
            }
            else
            {
                if (!_arg_3)
                {
                    this._Str_21142(_local_4, this._Str_23214);
                }
            }
        }

        function _Str_19830(k:Int)
        {
            var _local_2= (BACKGROUND_ + Std.string(k + 1));
            this._bgAssetNameArray[k] = _local_2;
            var _local_3= this._questEngine.assets.getAssetByName(_local_2);
            if (_local_3 != null)
            {
                this._Str_20095(_local_2);
                this._Str_17497();
            }
            else
            {
                this._Str_21142(_local_2, this._Str_22625);
            }
        }

        function _Str_21142(k:String, _arg_2:ASFunction)
        {
            var _local_3:ASAny = ((this._Str_22523() + k) + ".png");
            var _local_4= new URLRequest(_local_3);
            var _local_5= this._questEngine.assets.loadAssetFromFile(k, _local_4, "image/png");
            if (((_local_5 != null) && (!_local_5.disposed)))
            {
                _local_5.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, _arg_2);
                _local_5.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, _arg_2);
            }
        }

        function _Str_22625(k:AssetLoaderEvent)
        {
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            if (_local_2 != null)
            {
                this._Str_20095(_local_2.assetName);
            }
            this._Str_17497();
        }

        function _Str_23214(k:AssetLoaderEvent)
        {
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            if (_local_2 != null)
            {
                this._Str_19114(_local_2.assetName);
            }
            this._Str_18525();
        }

        function _Str_20095(k:String)
        {
            var _local_2= this._bgAssetNameArray.indexOf(k);
            if (_local_2 == -1)
            {
                return;
            }
            var _local_3= this._questEngine.assets.getAssetByName(k);
            this._backgroundImageCache[_local_2] = ((_local_3 != null) ? ASCompat.dynamicAs(_local_3.content , BitmapData) : new BitmapData(640, 320));
        }

        function _Str_19114(k:String)
        {
            var _local_2= this._questEngine.assets.getAssetByName(k);
            var _local_3:Int = this._assetNameToIndexMap.getValue(k);
            if (((_local_3 == -1) || (_local_3 >= this._graphicEntityCache.length)))
            {
                return;
            }
            this._graphicEntityCache[_local_3] = ((_local_2 != null) ? ASCompat.dynamicAs(_local_2.content , BitmapData) : new BitmapData(1, 1, true, 0));
        }

        function _Str_18500()
        {
            if (this._entityWindows == null)
            {
                return;
            }
            var k = 0;
            while (k < this._entityWindows.length)
            {
                this._entityWindows[k].x = ((((k - this._viewIndex) * _Str_6370) + this._scrollOffset) + _Str_16834);
                k++;
            }
        }

        function _Str_9194(k:Int):Int
        {
            return k * _Str_6370;
        }

        function _Str_21328()
        {
            var k= this._bgRenderer._Str_16235(this._Str_9194(this._viewIndex), this._containerWindow.width);
            this._backgroundSlice.x = 0;
            this._backgroundSlice.width = k.width;
            this._backgroundSlice.height = k.height;
            this._backgroundSlice.bitmap = k.clone();
        }

        function _Str_23116(k:Int)
        {
            var _local_2:BitmapData = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            if (k < this._viewIndex)
            {
                _local_3 = (this._viewIndex - k);
                _local_4 = this._Str_9194(k);
                _local_2 = this._bgRenderer._Str_16235(_local_4, (this._containerWindow.width + (_Str_6370 * _local_3)));
                this._scrollBgStartOffset = -(_Str_6370 * _local_3);
            }
            else
            {
                _local_5 = (k - this._viewIndex);
                _local_6 = ((_Str_6370 * _local_5) + this._containerWindow.width);
                _local_2 = this._bgRenderer._Str_16235(this._Str_9194(this._viewIndex), _local_6);
                this._scrollBgStartOffset = 0;
            }
            this._backgroundSlice.x = this._scrollBgStartOffset;
            if (_local_2 != null)
            {
                this._backgroundSlice.width = _local_2.width;
                this._backgroundSlice.height = _local_2.height;
                this._backgroundSlice.bitmap = _local_2.clone();
            }
        }

        function _Str_25210()
        {
            this._backgroundSlice.x = (this._scrollBgStartOffset + this._scrollOffset);
        }

        function _Str_17875(k:Int)
        {
            if (((k < 0) || (k >= this._totalEntityCount)))
            {
                return;
            }
            if (((!(this._scrollTimer == null)) && this._scrollTimer.running))
            {
                return;
            }
            if (!this._Str_19327())
            {
                this._viewIndex = k;
                this._Str_21747();
                return;
            }
            var _local_2= this._viewIndex;
            this._viewIndex = k;
            if (this._Str_20367())
            {
                this._viewIndex = _local_2;
                this._Str_23116(k);
                this._Str_16447(true, (k - this._viewIndex));
                this._scrollDelta = Std.int(-(_Str_6370 * (k - this._viewIndex)) / 10);
                this._scrollTimer = new Timer(10, 10);
                this._scrollTimer.addEventListener(TimerEvent.TIMER, (this.onTimer : ASAny));
                this._scrollTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimer : ASAny));
                this._scrollTimer.start();
            }
            else
            {
                this._viewIndex = _local_2;
            }
        }

        var _Str_20265(get,never):Int;
function  get__Str_20265():Int
        {
            return this._maximumEntities - 7;
        }

        function _Str_21747()
        {
            if (this._viewIndex > 0)
            {
                this._leftArrow.activate();
            }
            else
            {
                this._leftArrow.deactivate();
            }
            if (this._viewIndex < Math.min(((this._totalEntityCount - _Str_14469) - 1), this._Str_20265))
            {
                this._rightArrow.activate();
            }
            else
            {
                this._rightArrow.deactivate();
            }
        }

        function _Str_16447(k:Bool=false, _arg_2:Int=0)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            if (this._entityWindows != null)
            {
                _local_3 = (this._viewIndex - 1);
                if ((k && (_arg_2 < 0)))
                {
                    _local_3 = (_local_3 + _arg_2);
                }
                _local_4 = ((this._viewIndex + _Str_11600) + 1);
                if ((k && (_arg_2 > 0)))
                {
                    _local_4 = (_local_4 + _arg_2);
                }
                _local_5 = 0;
                while (_local_5 < this._entityWindows.length)
                {
                    if (((_local_5 < _local_3) || (_local_5 > _local_4)))
                    {
                        this._entityWindows[_local_5].visible = false;
                    }
                    else
                    {
                        this._entityWindows[_local_5].visible = true;
                        if (((_local_5 == _local_3) || (_local_5 == _local_4)))
                        {
                            this._entityWindows[_local_5].getChildByName("entity_mouse_region").visible = false;
                        }
                        else
                        {
                            if (this._states[_local_5] == CalendarEntityStateEnums._Str_4670)
                            {
                                this._entityWindows[_local_5].getChildByName("entity_mouse_region").visible = true;
                            }
                        }
                    }
                    _local_5++;
                }
            }
        }

        function onTimer(k:TimerEvent)
        {
            switch (k.type)
            {
                case TimerEvent.TIMER:
                    this._scrollOffset = (this._scrollOffset + this._scrollDelta);
                    this._Str_25210();
                    this._Str_18500();
                    return;
                case TimerEvent.TIMER_COMPLETE:
                    this._scrollOffset = 0;
                    if (this._scrollDelta > 0)
                    {
                        this._viewIndex = (this._viewIndex - 1);
                    }
                    else
                    {
                        this._viewIndex = (this._viewIndex + 1);
                    }
                    this._Str_21328();
                    this._Str_18500();
                    this._Str_21747();
                    this._Str_16447();
                    this._scrollTimer.removeEventListener(TimerEvent.TIMER, (this.onTimer : ASAny));
                    this._scrollTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimer : ASAny));
                    return;
            }
        }

        function _Str_20617(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.DOWN)
            {
                switch (_arg_2.name)
                {
                    case "button_left":
                        this._scrollLeftPressed = true;
                        
                    case "button_right":
                        this._scrollRightPressed = true;
                        
                }
            }
            if (((k.type == WindowMouseEvent.UP) || (k.type == WindowMouseEvent.UP_OUTSIDE)))
            {
                this._scrollLeftPressed = false;
                this._scrollRightPressed = false;
            }
        }

        function _Str_25473(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            var _local_4:QuestMessageData = null;
            if (_arg_2.name == "entity_mouse_region")
            {
                _local_3 = this._entityWindows.indexOf(Std.downcast(_arg_2.parent , IWindowContainer));
                if (k.type == WindowMouseEvent.CLICK)
                {
                    _local_4 = this._Str_19266(_local_3);
                    if (_local_4 != null)
                    {
                        this._questEngine._Str_3398._Str_11417._Str_8199(_local_4, true);
                    }
                }
                if (k.type == WindowMouseEvent.OVER)
                {
                    this._Str_12604(_local_3, true);
                    this._hoveringIndex = _local_3;
                }
                if (k.type == WindowMouseEvent.OUT)
                {
                    this._Str_12604(_local_3, false);
                    this._hoveringIndex = -1;
                }
            }
        }

        function _Str_19266(k:Int):QuestMessageData
        {
            var _local_2:QuestMessageData = null;
            final _iter_ = this._quests; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if ((_local_2.sortOrder - 1) == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function update(k:UInt)
        {
            var _local_2 = 0;
            var _local_3 = Math.NaN;
            var _local_4:IBorderWindow = null;
            var _local_5 = Math.NaN;
            if (((!(this._entityWindows == null)) && (!(this._flashingPanelIndex == -1))))
            {
                _local_2 = ASCompat.toInt(CalendarEntityStateEnums._Str_15574[ASCompat.toInt(this._states[this._flashingPanelIndex])]);
                _local_3 = ((this._flashingOffsetMs % _Str_13135) / _Str_13135);
                _local_3 = Math.abs((2 * ((_local_3 > 0.5) ? --_local_3 : _local_3)));
                _local_4 = cast(this._entityWindows[this._flashingPanelIndex].findChildByName("entity_indicator"), IBorderWindow);
                if (_local_4 != null)
                {
                    _local_5 = (_local_3 * _Str_16510);
                    if (this._hoveringIndex == this._flashingPanelIndex)
                    {
                        _local_5 = (_local_5 + 20);
                    }
                    _local_4.color = _Str_21268(_local_2, Std.int(_local_5));
                }
                this._flashingOffsetMs = ASCompat.toInt(this._flashingOffsetMs + k);
            }
            if (this._scrollTimer != null)
            {
                if (((this._scrollLeftPressed && (!this._scrollTimer.running)) && (this._scrollOffset == 0)))
                {
                    if (((this._viewIndex > 0) && (!this._leftArrow._Str_21953())))
                    {
                        this._Str_17875((this._viewIndex - 1));
                    }
                }
                if (((this._scrollRightPressed && (!this._scrollTimer.running)) && (this._scrollOffset == 0)))
                {
                    if (((this._viewIndex < this._highestAvailableQuestIndex) && (!this._rightArrow._Str_21953())))
                    {
                        this._Str_17875((this._viewIndex + 1));
                    }
                }
            }
        }

        function _Str_25266(k:Int)
        {
            if (((k < 0) || (k >= this._totalEntityCount)))
            {
                return;
            }
            this._flashingPanelIndex = k;
            this._flashingOffsetMs = 0;
        }

        function _Str_23591()
        {
            this._flashingPanelIndex = -1;
        }

        function _Str_20564(k:TimerEvent)
        {
            var _local_2= Date.now();
            if (this._lastDate != _local_2.getDate())
            {
                this._questEngine.requestSeasonalQuests();
            }
            this._lastDate = Std.int(_local_2.getDate());
        }
    }

