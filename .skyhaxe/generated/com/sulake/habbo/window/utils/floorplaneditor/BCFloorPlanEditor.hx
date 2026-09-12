package com.sulake.habbo.window.utils.floorplaneditor
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.FloorHeightMapEvent;
    import com.sulake.habbo.communication.messages.incoming.room.layout.RoomEntryTileMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.layout.RoomOccupiedTilesMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomVisualizationSettingsEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.BuildersClubSubscriptionStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.perk.PerkAllowancesEvent;
    import com.sulake.core.window.components.IFrameWindow;
    import flash.utils.Timer;
    import com.sulake.habbo.room.events.RoomEngineEvent;
    import flash.events.TimerEvent;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.habbo.communication.messages.outgoing.room.layout.GetRoomEntryTileMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.layout.GetOccupiedTilesMessageComposer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.InteractiveController;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.habbo.communication.messages.outgoing.room.layout.UpdateFloorPropertiesMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.geom.Point;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.core.window.components.IScrollbarWindow;
    import com.sulake.habbo.window.utils.floorplaneditor.binaryData.*;

     class BCFloorPlanEditor implements IUpdateReceiver 
    {
        public static var _Str_13244:Class<Dynamic> = BCFloorPlanEditor__Str_13244;
        public static var _Str_12857:Class<Dynamic> = BCFloorPlanEditor__Str_12857;
        static inline final _Str_15936:UInt = 2000;
        static inline final _Str_14397= 16;

        var _windowManager:HabboWindowManagerComponent;
        var _floorHeightMapMessageEvent:FloorHeightMapEvent;
        var _entryTileDataMessageEvent:RoomEntryTileMessageEvent;
        var _occupiedTilesMessageEvent:RoomOccupiedTilesMessageEvent;
        var _roomVisualizationSettingsMessageEvent:RoomVisualizationSettingsEvent;
        var _buildersClubSubscriptionStatusMessageEvent:BuildersClubSubscriptionStatusMessageEvent;
        var _perkAllowancesMessageEvent:PerkAllowancesEvent;
        var _floorPlanCache:FloorPlanCache;
        var _floorPlanPreviewer:FloorPlanPreviewer;
        var _heightMapEditor:HeightMapEditor;
        var _importExportDialog:ImportExportDialog;
        var _lastReceivedMapEvent:FloorHeightMapEvent;
        var _editorWindow:IFrameWindow;
        var _drawModes:Array<ASAny>;
        var _drawMode:String;
        var _floorThickness:Int = 0;
        var _wallThickness:Int = 0;
        var _msSinceLastPreviewUpdate:UInt = 0;
        var _bcSecondsLeft:Int = 0;
        var _bcSecondsCountdownTimer:Timer;
        var _largeFloorPlansAllowed:Bool = false;
        var _fixedWallsHeight:Int = 0;
        var _colorMapMouseDown:Bool = false;
        var _wallHeightSliderMouseDown:Bool = false;

        public function new(k:HabboWindowManagerComponent)
        {
            this._drawModes = ["add_tile", "remove_tile", "increase_height", "decrease_height", "set_enter_tile"];
            this._drawMode = this._drawModes[0];
            this._floorPlanCache = new FloorPlanCache(this);
            this._windowManager = k;
            if (this._windowManager.communication != null)
            {
                this._floorHeightMapMessageEvent = new FloorHeightMapEvent(this.onFloorHeightMap);
                this._entryTileDataMessageEvent = new RoomEntryTileMessageEvent(this.onEntryTileData);
                this._occupiedTilesMessageEvent = new RoomOccupiedTilesMessageEvent(this.onOccupiedTiles);
                this._roomVisualizationSettingsMessageEvent = new RoomVisualizationSettingsEvent(this.onRoomVisualizationSettings);
                this._buildersClubSubscriptionStatusMessageEvent = new BuildersClubSubscriptionStatusMessageEvent(this._Str_22764);
                this._perkAllowancesMessageEvent = new PerkAllowancesEvent(this.onPerkAllowances);
                this._windowManager.communication.addHabboConnectionMessageEvent(this._floorHeightMapMessageEvent);
                this._windowManager.communication.addHabboConnectionMessageEvent(this._buildersClubSubscriptionStatusMessageEvent);
                this._windowManager.communication.addHabboConnectionMessageEvent(this._entryTileDataMessageEvent);
                this._windowManager.communication.addHabboConnectionMessageEvent(this._occupiedTilesMessageEvent);
                this._windowManager.communication.addHabboConnectionMessageEvent(this._roomVisualizationSettingsMessageEvent);
                this._windowManager.communication.addHabboConnectionMessageEvent(this._perkAllowancesMessageEvent);
            }
            if (k.roomEngine != null)
            {
                k.roomEngine.events.addEventListener(RoomEngineEvent.DISPOSED, this.onRoomDisposed);
            }
            k.registerUpdateReceiver(this, 0);
        }

        public static function _Str_8298(k:Int):Int
        {
            switch (k)
            {
                case 0:
                    return -2;
                case 1:
                    return -1;
                case 3:
                    return 1;
                default:
                    return 0;
            }
        }


        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            if (this._floorHeightMapMessageEvent != null)
            {
                this._windowManager.communication.removeHabboConnectionMessageEvent(this._floorHeightMapMessageEvent);
                this._windowManager.communication.removeHabboConnectionMessageEvent(this._entryTileDataMessageEvent);
                this._windowManager.communication.removeHabboConnectionMessageEvent(this._occupiedTilesMessageEvent);
                this._windowManager.communication.removeHabboConnectionMessageEvent(this._roomVisualizationSettingsMessageEvent);
                this._windowManager.communication.removeHabboConnectionMessageEvent(this._buildersClubSubscriptionStatusMessageEvent);
                this._windowManager.communication.removeHabboConnectionMessageEvent(this._perkAllowancesMessageEvent);
                this._floorHeightMapMessageEvent = null;
                this._entryTileDataMessageEvent = null;
                this._occupiedTilesMessageEvent = null;
                this._roomVisualizationSettingsMessageEvent = null;
            }
            if (((this.windowManager.roomEngine != null) && (!this.windowManager.roomEngine.disposed)))
            {
                this.windowManager.roomEngine.events.removeEventListener(RoomEngineEvent.DISPOSED, this.onRoomDisposed);
            }
            this._windowManager.removeUpdateReceiver(this);
            this._windowManager = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._windowManager == null;
        }

        function _Str_22764(k:BuildersClubSubscriptionStatusMessageEvent)
        {
            var _local_2= k.getParser();
            this._bcSecondsLeft = _local_2.secondsRemaining;
            if (this._bcSecondsCountdownTimer == null)
            {
                this._bcSecondsCountdownTimer = new Timer(10000);
                this._bcSecondsCountdownTimer.addEventListener(TimerEvent.TIMER, (this._Str_23706 : ASAny));
                this._bcSecondsCountdownTimer.start();
            }
        }

        function _Str_23706(k:TimerEvent)
        {
            this._bcSecondsLeft = (this._bcSecondsLeft - 10);
            if (((this._editorWindow != null) && this._editorWindow.visible))
            {
                if (((this._bcSecondsLeft > 0) || this._windowManager.sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE)))
                {
                    this._editorWindow.findChildByName("save").enable();
                }
                else
                {
                    this._editorWindow.findChildByName("save").disable();
                }
            }
        }

        
        public var visible(get,set):Bool;
public function  set_visible(k:Bool):Bool        {
            if (((this._editorWindow == null) || this._editorWindow.disposed))
            {
                this._Str_25134();
            }
            this._editorWindow.visible = k;
            if (k)
            {
                this._windowManager.communication.connection.send(new GetRoomEntryTileMessageComposer());
                this._windowManager.communication.connection.send(new GetOccupiedTilesMessageComposer());
                this._Str_21392();
                this._Str_25182();
                this._Str_17511(this._fixedWallsHeight);
            }
            else
            {
                this._heightMapEditor._Str_12874 = false;
            }
return k;
        }
public function  get_visible():Bool
        {
            return (!(this._editorWindow == null)) && this._editorWindow.visible;
        }

        function _Str_25134()
        {
            var k= ASCompat.asByteArray(Type.createInstance(_Str_13244, []) );
            var _local_2= new com.sulake.core.utils.xml.XML(k.readUTFBytes(k.length));
            this._editorWindow = Std.downcast(this._windowManager.buildFromXML(_local_2, 1) , IFrameWindow);
            this._editorWindow.procedure = this._Str_16600;
            this._editorWindow.findChildByName("tile_height_colormap").procedure = this._Str_23239;
            this._editorWindow.findChildByName("wall_height_slider").procedure = this._Str_24859;
            this._editorWindow.center();
            this._floorPlanPreviewer = new FloorPlanPreviewer(this);
            this._heightMapEditor = new HeightMapEditor(this);
            k = ASCompat.asByteArray(Type.createInstance(_Str_12857, []) );
            this._importExportDialog = new ImportExportDialog(this, new com.sulake.core.utils.xml.XML(k.readUTFBytes(k.length)));
            this._floorPlanPreviewer.updatePreview();
            this._heightMapEditor._Str_9032();
            this._Str_23811(this._heightMapEditor._Str_17977);
            this._Str_20209("add_tile");
            cast(this._editorWindow.findChildByName("heightmap_wrapper"), IItemListWindow).disableAutodrag = true;
            cast(this._editorWindow.findChildByName("preview_wrapper"), IItemListWindow).disableAutodrag = true;
            if (((!this._windowManager.sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE)) && (this._bcSecondsLeft <= 0)))
            {
                this._editorWindow.findChildByName("save").disable();
            }
        }

        public function update(k:UInt)
        {
            var _local_2:String = null;
            if (((!(this._drawMode == "")) && (this._editorWindow != null)))
            {
                final _iter_ = this._drawModes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (this._drawMode == _local_2)
                    {
                        cast(this._editorWindow.findChildByName(_local_2), InteractiveController).state = (ASCompat.toInt(cast(this._editorWindow.findChildByName(_local_2), InteractiveController).state )| ASCompat.toInt(WindowState.PRESSED));
                    }
                    else
                    {
                        cast(this._editorWindow.findChildByName(_local_2), InteractiveController).state = (ASCompat.toInt(cast(this._editorWindow.findChildByName(_local_2), InteractiveController).state )& (~ASCompat.toInt(WindowState.PRESSED)));
                    }
                }
            }
            this._msSinceLastPreviewUpdate = (this._msSinceLastPreviewUpdate + k);
            if (((this._msSinceLastPreviewUpdate > _Str_15936) && (this._floorPlanPreviewer != null)))
            {
                this._floorPlanPreviewer.updatePreview();
                this._msSinceLastPreviewUpdate = 0;
            }
        }

        var _Str_18668(get,never):Bool;
function  get__Str_18668():Bool
        {
            return cast(this._editorWindow.findChildByName("walls_fixed_height_enabled_checkbox"), ICheckBoxWindow).Selected;
        }

        function _Str_16600(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "header_button_close"
                       | "cancel":
                        this.visible = false;
                        
                    case "refresh":
                        this._floorPlanPreviewer.updatePreview();
                        
                    case "save":
                        this._floorThickness = cast(this._editorWindow.findChildByName("floor_thickness_drop"), IDropMenuWindow).selection;
                        this._wallThickness = cast(this._editorWindow.findChildByName("wall_thickness_drop"), IDropMenuWindow).selection;
                        this._windowManager.communication.connection.send(new UpdateFloorPropertiesMessageComposer(this._floorPlanCache._Str_21406(), Std.int(this._floorPlanCache._Str_7642.x), Std.int(this._floorPlanCache._Str_7642.y), this._floorPlanCache._Str_6184, _Str_8298(this._wallThickness), _Str_8298(this._floorThickness), (this._Str_18668 ? this._fixedWallsHeight : -1)));
                        
                    case "reload":
                        this._floorPlanCache.onFloorHeightMap(this._lastReceivedMapEvent);
                        if (this._floorPlanPreviewer != null)
                        {
                            this._floorPlanPreviewer.updatePreview();
                        }
                        if (this._heightMapEditor != null)
                        {
                            this._heightMapEditor._Str_9032();
                        }
                        this._windowManager.communication.connection.send(new GetOccupiedTilesMessageComposer());
                        this._windowManager.communication.connection.send(new GetRoomEntryTileMessageComposer());
                        
                    case "import_export":
                        this._importExportDialog.visible = (!this._importExportDialog.visible);
                        
                    case "enterdirection_left":
                        this._floorPlanCache._Str_6184++;
                        this._Str_16217();
                        
                    case "enterdirection_right":
                        this._floorPlanCache._Str_6184--;
                        this._Str_16217();
                        
                    case "zoom":
                        if (this._heightMapEditor.zoomLevel == 1)
                        {
                            this._heightMapEditor.zoomLevel = 2;
                        }
                        else
                        {
                            this._heightMapEditor.zoomLevel = 1;
                        }
                        this._heightMapEditor._Str_9032();
                        
                    case "walls_fixed_height_enabled_checkbox":
                        this._Str_17114(this._Str_18668);
                        if ((this._Str_18668 && (this._fixedWallsHeight == -1)))
                        {
                            this._fixedWallsHeight = (ASCompat.parseInt(this._editorWindow.findChildByName("wall_height_number").caption) - 1);
                        }
                        
                }
                if (this._drawModes.indexOf(_arg_2.name) != -1)
                {
                    this._Str_20209(_arg_2.name);
                }
            }
        }

        public function _Str_26431(k:KeyboardEvent)
        {
            if (k.type == KeyboardEvent.KEY_DOWN)
            {
                switch (k.keyCode)
                {
                    case Keyboard.NUMPAD_ADD:
                        this._heightMapEditor._Str_9167++;
                        
                    case Keyboard.NUMPAD_SUBTRACT:
                        this._heightMapEditor._Str_9167++;
                        
                    case Keyboard.SHIFT:
                        if (this._heightMapEditor != null)
                        {
                            this._heightMapEditor._Str_12874 = true;
                        }
                        
                }
            }
            else
            {
                if (k.type == KeyboardEvent.KEY_UP)
                {
                    if (k.keyCode == Keyboard.SHIFT)
                    {
                        if (this._heightMapEditor != null)
                        {
                            this._heightMapEditor._Str_12874 = false;
                        }
                    }
                }
            }
        }

        function _Str_20209(k:String)
        {
            this._drawMode = k;
        }

        function _Str_23239(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:WindowMouseEvent = null;
            var _local_4:UInt = 0;
            if (k.type == WindowMouseEvent.DOWN)
            {
                this._colorMapMouseDown = true;
            }
            else
            {
                if (((k.type == WindowMouseEvent.UP) || (k.type == WindowMouseEvent.UP_OUTSIDE)))
                {
                    this._colorMapMouseDown = false;
                }
                else
                {
                    if (((k.type == WindowMouseEvent.CLICK) || (this._colorMapMouseDown && (k.type == WindowMouseEvent.MOVE))))
                    {
                        _local_3 = Std.downcast(k , WindowMouseEvent);
                        _local_4 = Std.int((_local_3.localX / this._editorWindow.findChildByName("tile_height_colormap").width) * this._heightMapEditor._Str_17977.length);
                        this._Str_19677(_local_4);
                        this._heightMapEditor._Str_9167 = ASCompat.toInt(_local_4);
                    }
                }
            }
        }

        public function _Str_19677(k:UInt)
        {
            this._editorWindow.findChildByName("tile_height_slider_track").x = Std.int(k * (this._editorWindow.findChildByName("tile_height_colormap").width / this._heightMapEditor._Str_17977.length));
        }

        public function updateColorSliderTrack(k:UInt)
        {
            this._Str_19677(k);
        }

        function _Str_24859(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:WindowMouseEvent = null;
            var _local_4:UInt = 0;
            if (k.type == WindowMouseEvent.DOWN)
            {
                this._wallHeightSliderMouseDown = true;
            }
            else
            {
                if (((k.type == WindowMouseEvent.UP) || (k.type == WindowMouseEvent.UP_OUTSIDE)))
                {
                    this._wallHeightSliderMouseDown = false;
                }
                else
                {
                    if (((k.type == WindowMouseEvent.CLICK) || (this._wallHeightSliderMouseDown && (k.type == WindowMouseEvent.MOVE))))
                    {
                        _local_3 = Std.downcast(k , WindowMouseEvent);
                        _local_4 = Std.int((_local_3.localX / this._editorWindow.findChildByName("wall_height_slider").width) * _Str_14397);
                        this._Str_17511(ASCompat.toInt(_local_4));
                        this._fixedWallsHeight = ASCompat.toInt(_local_4);
                    }
                }
            }
            k.stopPropagation();
        }

        public function _Str_17511(k:Int)
        {
            if (k == -1)
            {
                cast(this._editorWindow.findChildByName("walls_fixed_height_enabled_checkbox"), ICheckBoxWindow).unselect();
                this._Str_17114(false);
            }
            else
            {
                cast(this._editorWindow.findChildByName("walls_fixed_height_enabled_checkbox"), ICheckBoxWindow).select();
                this._Str_17114(true);
                this._editorWindow.findChildByName("wall_height_number").caption = Std.string((k + 1));
                this._editorWindow.findChildByName("wall_height_slider_track").x = Std.int(k * (this._editorWindow.findChildByName("wall_height_slider").width / _Str_14397));
            }
        }

        function _Str_17114(k:Bool)
        {
            if (k)
            {
                this._editorWindow.findChildByName("wall_height_text").enable();
                this._editorWindow.findChildByName("wall_height_number").enable();
                this._editorWindow.findChildByName("wall_height_slider").enable();
                this._editorWindow.findChildByName("wall_height_slider_track").enable();
                this._editorWindow.findChildByName("wall_height_text").blend = 1;
                this._editorWindow.findChildByName("wall_height_number").blend = 1;
                this._editorWindow.findChildByName("wall_height_slider").blend = 1;
                this._editorWindow.findChildByName("wall_height_slider_track").blend = 1;
            }
            else
            {
                this._editorWindow.findChildByName("wall_height_text").disable();
                this._editorWindow.findChildByName("wall_height_number").disable();
                this._editorWindow.findChildByName("wall_height_slider").disable();
                this._editorWindow.findChildByName("wall_height_slider_track").disable();
                this._editorWindow.findChildByName("wall_height_text").blend = 0.6;
                this._editorWindow.findChildByName("wall_height_number").blend = 0.6;
                this._editorWindow.findChildByName("wall_height_slider").blend = 0.6;
                this._editorWindow.findChildByName("wall_height_slider_track").blend = 0.6;
            }
        }

        function onFloorHeightMap(k:FloorHeightMapEvent)
        {
            this._lastReceivedMapEvent = k;
            this._floorPlanCache.onFloorHeightMap(k);
            this._fixedWallsHeight = k.getParser().fixedWallsHeight;
            if (this._floorPlanPreviewer != null)
            {
                this._floorPlanPreviewer.updatePreview();
            }
            if (this._heightMapEditor != null)
            {
                this._heightMapEditor._Str_9032();
            }
            if (this._editorWindow != null)
            {
                this._Str_17511(this._fixedWallsHeight);
            }
        }

        function onEntryTileData(k:RoomEntryTileMessageEvent)
        {
            if (this._editorWindow == null)
            {
                return;
            }
            var _local_2= k.getParser();
            this._floorPlanCache._Str_7642 = new Point(_local_2.x, _local_2.y);
            this._floorPlanCache._Str_6184 = ASCompat.toInt(_local_2.dir);
            if (this._heightMapEditor != null)
            {
                this._heightMapEditor._Str_9032();
            }
            this._Str_16217();
        }

        function onOccupiedTiles(k:RoomOccupiedTilesMessageEvent)
        {
            this._floorPlanCache.onOccupiedTiles(k);
            if (this._heightMapEditor != null)
            {
                this._heightMapEditor._Str_9032();
            }
        }

        function onRoomVisualizationSettings(k:RoomVisualizationSettingsEvent)
        {
            var _local_2= k.getParser();
            this._floorThickness = this._Str_10107(_local_2.floorThicknessMultiplier);
            this._wallThickness = this._Str_10107(_local_2.wallThicknessMultiplier);
            this._Str_21392();
        }

        function onPerkAllowances(k:PerkAllowancesEvent)
        {
            var _local_2= k.getParser();
            this._largeFloorPlansAllowed = _local_2.isPerkAllowed(PerkEnum.BUILDER_AT_WORK);
        }

        public function _Str_22370(k:BitmapData)
        {
            var _local_2= cast(this._editorWindow.findChildByName("preview_bitmap"), IBitmapWrapperWindow);
            _local_2.bitmap = k;
        }

        public function updatePreviewBitmap(k:BitmapData)
        {
            this._Str_22370(k);
        }

        function _Str_23811(k:Vector<Array<ASAny>>)
        {
            var _local_5 = 0;
            var _local_6:UInt = 0;
            var _local_2= Std.downcast(this._editorWindow.findChildByName("tile_height_colormap") , IBitmapWrapperWindow);
            _local_2.bitmap = new BitmapData(_local_2.width, _local_2.height, false, 0);
            var _local_3= new Rectangle(0, 0, 1, _local_2.height);
            var _local_4 = 0;
            while (_local_4 < _local_2.width)
            {
                _local_5 = Std.int((_local_4 / _local_2.width) * k.length);
                _local_6 = (((ASCompat.toInt(ASCompat.toUInt((0xFF * ASCompat.toNumber(k[_local_5][0]))) )<< 16) + (ASCompat.toInt(ASCompat.toUInt((0xFF * ASCompat.toNumber(k[_local_5][1]))) )<< 8)) + ASCompat.toUInt((0xFF * ASCompat.toNumber(k[_local_5][2]))));
                _local_3.x = _local_4;
                _local_2.bitmap.fillRect(_local_3, _local_6);
                _local_4++;
            }
        }

        function _Str_16217()
        {
            var k= Std.downcast(cast(this._editorWindow.findChildByName("enterdirection_ghost_avatar"), IWidgetWindow).widget , IAvatarImageWidget);
            k.direction = this._floorPlanCache._Str_6184;
        }

        function _Str_10107(k:Float):Int
        {
            switch (k)
            {
                case 0.25:
                    return 0;
                case 0.5:
                    return 1;
                case 2:
                    return 3;
                default:
                    return 2;
            }
        }

        function _Str_21392()
        {
            if (this._editorWindow != null)
            {
                cast(this._editorWindow.findChildByName("wall_thickness_drop"), IDropMenuWindow).selection = this._wallThickness;
                cast(this._editorWindow.findChildByName("floor_thickness_drop"), IDropMenuWindow).selection = this._floorThickness;
            }
        }

        function _Str_25182()
        {
            var k= Std.downcast(this._editorWindow.findChildByName("heightmap_scroll_horizontal") , IScrollbarWindow);
            var _local_2= Std.downcast(this._editorWindow.findChildByName("heightmap_scroll_vertical") , IScrollbarWindow);
            var _local_3= Std.downcast(this._editorWindow.findChildByName("preview_scroll_horizontal") , IScrollbarWindow);
            var _local_4= Std.downcast(this._editorWindow.findChildByName("preview_scroll_vertical") , IScrollbarWindow);
            k.scrollH = 0.5;
            _local_2.scrollV = 0.5;
            _local_3.scrollH = 0.5;
            _local_4.scrollV = 0.5;
        }

        function onRoomDisposed(k:RoomEngineEvent)
        {
            this.visible = false;
        }

        public var windowManager(get,never):HabboWindowManagerComponent;
public function  get_windowManager():HabboWindowManagerComponent
        {
            return this._windowManager;
        }

        public var _Str_4964(get,never):IBitmapWrapperWindow;
public function  get__Str_4964():IBitmapWrapperWindow
        {
            return Std.downcast(this._editorWindow.findChildByName("heightmap_bitmap") , IBitmapWrapperWindow);
        }

        public var heightMapBitmapElement(get,never):IBitmapWrapperWindow;
public function  get_heightMapBitmapElement():IBitmapWrapperWindow
        {
            return this._Str_4964;
        }

        public var heightMapMouseCapturer(get,never):IRegionWindow;
public function  get_heightMapMouseCapturer():IRegionWindow
        {
            return Std.downcast(this._editorWindow.findChildByName("mouse_capturer") , IRegionWindow);
        }

        public var _Str_4134(get,never):FloorPlanCache;
public function  get__Str_4134():FloorPlanCache
        {
            return this._floorPlanCache;
        }

        public var floorPlanCache(get,never):FloorPlanCache;
public function  get_floorPlanCache():FloorPlanCache
        {
            return this._floorPlanCache;
        }

        public var _Str_11016(get,never):Array<ASAny>;
public function  get__Str_11016():Array<ASAny>
        {
            return this._drawModes;
        }

        public var drawModes(get,never):Array<ASAny>;
public function  get_drawModes():Array<ASAny>
        {
            return this._drawModes;
        }

        public var _Str_25243(get,never):String;
public function  get__Str_25243():String
        {
            return this._drawMode;
        }

        public var drawMode(get,never):String;
public function  get_drawMode():String
        {
            return this._drawMode;
        }

        public var _Str_20752(get,never):HeightMapEditor;
public function  get__Str_20752():HeightMapEditor
        {
            return this._heightMapEditor;
        }

        public var heightMapEditor(get,never):HeightMapEditor;
public function  get_heightMapEditor():HeightMapEditor
        {
            return this._heightMapEditor;
        }

        public var _Str_22461(get,never):Bool;
public function  get__Str_22461():Bool
        {
            return this._largeFloorPlansAllowed;
        }

        public var largeFloorPlansAllowed(get,never):Bool;
public function  get_largeFloorPlansAllowed():Bool
        {
            return this._largeFloorPlansAllowed;
        }

        public var _Str_24411(get,never):String;
public function  get__Str_24411():String
        {
            if (this._lastReceivedMapEvent != null)
            {
                return this._lastReceivedMapEvent.getParser().text;
            }
            return "";
        }

        public var floorThickness(get,never):Int;
public function  get_floorThickness():Int
        {
            return this._floorThickness;
        }

        public var wallThickness(get,never):Int;
public function  get_wallThickness():Int
        {
            return this._wallThickness;
        }

        public var _Str_22721(get,never):Int;
public function  get__Str_22721():Int
        {
            return this._bcSecondsLeft;
        }
    }

