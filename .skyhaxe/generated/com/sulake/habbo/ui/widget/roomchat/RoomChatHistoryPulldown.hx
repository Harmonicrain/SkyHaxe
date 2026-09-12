package com.sulake.habbo.ui.widget.roomchat
;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.display.BitmapData;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.utils.profiler.tracking.TrackedBitmapData;
    import flash.geom.Point;
	import com.sulake.core.window._enum.WindowParam;

     class RoomChatHistoryPulldown 
    {
        public static inline final STATE_FADE_OUT= 3;
        public static inline final STATE_FADE_IN= 2;
        public static inline final STATE_VISIBLE= 1;
        public static inline final STATE_HIDDEN= 0;
        public static inline final PULLDOWN_WINDOW_HEIGHT= 39;
        static inline final FADE_OUT_MS= 150;
        static inline final FADE_IN_MS= 250;

        var _widget:RoomChatWidget;
        var _windowManager:IHabboWindowManager;
        var _window:IWindowContainer;
        var _bgWindow:IBitmapWrapperWindow;
        var _containerWindow:IWindowContainer;
        var _region:IRegionWindow;
        var _assetLibrary:IAssetLibrary;
        var _lastWidth:Int = 0;
        var _state:Int = -1;
        var _grabBarBgBmp:BitmapData;
        var _grabBarGripBmp:BitmapData;
        var _grabBarHandleBmp:BitmapData;
        var _grabBarXBmp:BitmapData;
        var _grabBarXOverBmp:BitmapData;
        var _grabBarXPressedBmp:BitmapData;
        var _chatHistoryBgBmp:BitmapData;
        var _regionRightMargin:Int = 30;

        public function new(k:RoomChatWidget, _arg_2:IHabboWindowManager, _arg_3:IWindowContainer, _arg_4:IAssetLibrary)
        {
            this._widget = k;
            this._windowManager = _arg_2;
            this._assetLibrary = _arg_4;
            this._containerWindow = _arg_3;
            this._grabBarBgBmp = ASCompat.dynamicAs(Std.downcast(this._assetLibrary.getAssetByName("chat_grapbar_bg") , BitmapDataAsset).content , BitmapData);
            this._grabBarGripBmp = ASCompat.dynamicAs(Std.downcast(this._assetLibrary.getAssetByName("chat_grapbar_grip") , BitmapDataAsset).content , BitmapData);
            this._grabBarHandleBmp = ASCompat.dynamicAs(Std.downcast(this._assetLibrary.getAssetByName("chat_grapbar_handle") , BitmapDataAsset).content , BitmapData);
            this._grabBarXBmp = ASCompat.dynamicAs(Std.downcast(this._assetLibrary.getAssetByName("chat_grapbar_x") , BitmapDataAsset).content , BitmapData);
            this._grabBarXOverBmp = ASCompat.dynamicAs(Std.downcast(this._assetLibrary.getAssetByName("chat_grapbar_x_hi") , BitmapDataAsset).content , BitmapData);
            this._grabBarXPressedBmp = ASCompat.dynamicAs(Std.downcast(this._assetLibrary.getAssetByName("chat_grapbar_x_pr") , BitmapDataAsset).content , BitmapData);
            this._chatHistoryBgBmp = ASCompat.dynamicAs(Std.downcast(this._assetLibrary.getAssetByName("chat_history_bg") , BitmapDataAsset).content , BitmapData);
            this._bgWindow = Std.downcast(this._windowManager.createWindow("chat_history_bg", "", WindowType.WINDOW_TYPE_BITMAP_WRAPPER, HabboWindowStyle.DEFAULT, WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT, new Rectangle(0, 0, _arg_3.width, (_arg_3.height - PULLDOWN_WINDOW_HEIGHT)), null, 0, 0) , IBitmapWrapperWindow);
            this._containerWindow.addChild(this._bgWindow);
            this._window = Std.downcast(this._windowManager.createWindow("chat_pulldown", "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.DEFAULT, (ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR )| ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)), new Rectangle(0, (this._containerWindow.height - PULLDOWN_WINDOW_HEIGHT), _arg_3.width, PULLDOWN_WINDOW_HEIGHT), null, 0) , IWindowContainer);
            this._containerWindow.addChild(this._window);
            this._region = Std.downcast(this._windowManager.createWindow("REGIONchat_pulldown", "", WindowType.WINDOW_TYPE_REGION, HabboWindowStyle.NULL, (((ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR )| ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_FIXED)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_FIXED)), new Rectangle(0, 0, _arg_3.width, (_arg_3.height - PULLDOWN_WINDOW_HEIGHT)), null, 0) , IRegionWindow);
            if (this._region != null)
            {
                this._region.background = true;
                this._region.mouseThreshold = 0;
                this._region.addEventListener(WindowMouseEvent.DOWN, this.onPulldownMouseDown);
                this._containerWindow.addChild(this._region);
                this._region.toolTipCaption = "${chat.history.drag.tooltip}";
                this._region.toolTipDelay = 250;
            }
            var _local_5= Std.downcast(_arg_4.getAssetByName("chat_history_pulldown") , XmlAsset);
            this._window.buildFromXML(((_local_5.content : com.sulake.core.utils.xml.XML) ));
            this._window.addEventListener(WindowMouseEvent.DOWN, this.onPulldownMouseDown);
            var _local_6= Std.downcast(this._window.findChildByName("GrapBarX") , IBitmapWrapperWindow);
            if (_local_6 != null)
            {
                _local_6.mouseThreshold = 0;
                _local_6.addEventListener(WindowMouseEvent.CLICK, this.onCloseButtonClicked);
                _local_6.addEventListener(WindowMouseEvent.UP, this.onCloseButtonMouseUp);
                _local_6.addEventListener(WindowMouseEvent.DOWN, this.onCloseButtonMouseDown);
                _local_6.addEventListener(WindowMouseEvent.OVER, this.onCloseButtonMouseOver);
                _local_6.addEventListener(WindowMouseEvent.OUT, this.onCloseButtonMouseOut);
            }
            this._window.background = true;
            this._window.color = 0;
            this._window.mouseThreshold = 0;
            this.state = STATE_HIDDEN;
            this.buildWindowGraphics();
        }

        public function dispose()
        {
            if (this._region != null)
            {
                this._region.dispose();
                this._region = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._bgWindow != null)
            {
                this._bgWindow.dispose();
                this._bgWindow = null;
            }
        }

        public function update(k:UInt)
        {
            switch (this.state)
            {
                case STATE_FADE_IN:
                    this._bgWindow.blend = (this._bgWindow.blend + (k / FADE_IN_MS));
                    this._window.blend = (this._window.blend + (k / FADE_IN_MS));
                    if (this._window.blend >= 1)
                    {
                        this.state = STATE_VISIBLE;
                    }
                    return;
                case STATE_FADE_OUT:
                    this._bgWindow.blend = (this._bgWindow.blend - (k / FADE_OUT_MS));
                    this._window.blend = (this._window.blend - (k / FADE_OUT_MS));
                    if (this._window.blend <= 0)
                    {
                        this.state = STATE_HIDDEN;
                    }
                    return;
            }
        }

        
        public var state(get,set):Int;
public function  set_state(k:Int):Int        {
            if (k == this._state)
            {
                return k;
            }
            switch (k)
            {
                case STATE_VISIBLE:
                    if (this._state == STATE_HIDDEN)
                    {
                        this.set_state (STATE_FADE_IN);
                    }
                    else
                    {
                        if (((this._window == null) || (this._bgWindow == null)))
                        {
                            return k;
                        }
                        this._window.visible = true;
                        this._bgWindow.visible = true;
                        this._region.visible = true;
                        this._state = k;
                    }
                    return k;
                case STATE_HIDDEN:
                    if (((this._window == null) || (this._bgWindow == null)))
                    {
                        return k;
                    }
                    this._window.visible = false;
                    this._bgWindow.visible = false;
                    this._region.visible = false;
                    this._state = k;
                    return k;
                case STATE_FADE_IN:
                    if (((this._window == null) || (this._bgWindow == null)))
                    {
                        return k;
                    }
                    this._window.blend = 0;
                    this._bgWindow.blend = 0;
                    this._window.visible = true;
                    this._bgWindow.visible = true;
                    this._state = k;
                    return k;
                case STATE_FADE_OUT:
                    if (((this._window == null) || (this._bgWindow == null)))
                    {
                        return k;
                    }
                    this._window.blend = 1;
                    this._bgWindow.blend = 1;
                    this._state = k;
                    return k;
            }
return k;
        }
public function  get_state():Int
        {
            return this._state;
        }

        public function containerResized(k:Rectangle)
        {
            if (this._window != null)
            {
                this._window.x = 0;
                this._window.y = (this._containerWindow.height - PULLDOWN_WINDOW_HEIGHT);
                this._window.width = this._containerWindow.width;
            }
            if (this._region != null)
            {
                this._region.x = 0;
                this._region.y = (this._containerWindow.height - PULLDOWN_WINDOW_HEIGHT);
                this._region.width = (this._containerWindow.width - this._regionRightMargin);
            }
            if (this._bgWindow != null)
            {
                this._bgWindow.rectangle = this._containerWindow.rectangle;
                this._bgWindow.height = (this._bgWindow.height - PULLDOWN_WINDOW_HEIGHT);
            }
            this.buildWindowGraphics();
        }

        function buildWindowGraphics()
        {
            var width = 0;
            var height = 0;
            var state = 0;
            var destBgBitmap:BitmapData = null;
            var destGripLBitmap:BitmapData = null;
            var destGripRBitmap:BitmapData = null;
            if (this._window == null)
            {
                return;
            }
            if (this._lastWidth == this._window.width)
            {
                return;
            }
            this._lastWidth = this._window.width;
            var barBg= Std.downcast(this._window.findChildByName("grapBarBg") , IBitmapWrapperWindow);
            var barX= Std.downcast(this._window.findChildByName("GrapBarX") , IBitmapWrapperWindow);
            var barGripL= Std.downcast(this._window.findChildByName("grapBarGripL") , IBitmapWrapperWindow);
            var barGripR= Std.downcast(this._window.findChildByName("grapBarGripR") , IBitmapWrapperWindow);
            var barHandle= Std.downcast(this._window.findChildByName("grapBarHandle") , IBitmapWrapperWindow);
            var gripMargin= 5;
            if (((!(barX == null)) && (!(barHandle == null))))
            {
                barHandle.bitmap = this._grabBarHandleBmp;
                barHandle.disposesBitmap = false;
                barX.bitmap = this._grabBarXBmp;
                barX.disposesBitmap = false;
                this._regionRightMargin = (this._window.width - barX.x);
            }
            barGripL.width = (barHandle.x - gripMargin);
            barGripL.x = 0;
            barGripR.x = ((barHandle.x + barHandle.width) + gripMargin);
            barGripR.width = ((barX.x - gripMargin) - barGripR.x);
            if (barGripL.width < 0)
            {
                barGripL.width = 0;
            }
            if (barGripR.width < 0)
            {
                barGripR.width = 0;
            }
            state = 0;
            if ((((!(barBg == null)) && (!(barGripL == null))) && (!(barGripR == null))))
            {
                try
                {
                    state = 1;
                    width = barBg.width;
                    height = barBg.height;
                    if (((width > 0) && (height > 0)))
                    {
                        destBgBitmap = new TrackedBitmapData(this, width, height);
                        this.tileBitmapHorz(this._grabBarBgBmp, destBgBitmap);
                        barBg.disposesBitmap = true;
                        barBg.bitmap = destBgBitmap;
                    }
                    state = 2;
                    width = barGripL.width;
                    height = barGripL.height;
                    if (((width > 0) && (height > 0)))
                    {
                        destGripLBitmap = new TrackedBitmapData(this, width, height);
                        this.tileBitmapHorz(this._grabBarGripBmp, destGripLBitmap);
                        barGripL.disposesBitmap = true;
                        barGripL.bitmap = destGripLBitmap;
                    }
                    state = 3;
                    width = barGripR.width;
                    height = barGripR.height;
                    if (((width > 0) && (height > 0)))
                    {
                        destGripRBitmap = new TrackedBitmapData(this, width, height);
                        this.tileBitmapHorz(this._grabBarGripBmp, destGripRBitmap);
                        barGripR.disposesBitmap = true;
                        barGripR.bitmap = destGripRBitmap;
                    }
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    throw new ASError(((((((e.message + " width:") + Std.string(width)) + " height:") + Std.string(height)) + " state:") + Std.string(state)), e.errorID);
                }
 }            }
            if (this._bgWindow == null)
            {
                return;
            }
            this._bgWindow.bitmap = this._chatHistoryBgBmp;
            this._bgWindow.disposesBitmap = false;
        }

        function tileBitmapHorz(k:BitmapData, _arg_2:BitmapData)
        {
            var _local_3= Std.int(_arg_2.width / k.width);
            var _local_4= new Point();
            var _local_5 = 0;
            while (_local_5 < (_local_3 + 1))
            {
                _local_4.x = (_local_5 * k.width);
                _arg_2.copyPixels(k, k.rect, _local_4);
                _local_5++;
            }
        }

        function onPulldownMouseDown(k:WindowMouseEvent)
        {
            if (this._widget != null)
            {
                this._widget.onPulldownMouseDown(k);
            }
        }

        function onCloseButtonClicked(k:WindowMouseEvent)
        {
            if (this._widget != null)
            {
                this._widget._Str_24607(k);
            }
        }

        function onCloseButtonMouseOver(k:WindowMouseEvent)
        {
            if (this._window == null)
            {
                return;
            }
            if (!this._window.visible)
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("GrapBarX") , IBitmapWrapperWindow);
            if (_local_2 != null)
            {
                _local_2.disposesBitmap = false;
                _local_2.bitmap = this._grabBarXOverBmp;
            }
        }

        function onCloseButtonMouseOut(k:WindowMouseEvent)
        {
            if (this._window == null)
            {
                return;
            }
            if (!this._window.visible)
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("GrapBarX") , IBitmapWrapperWindow);
            if (_local_2 != null)
            {
                _local_2.disposesBitmap = false;
                _local_2.bitmap = this._grabBarXBmp;
            }
        }

        function onCloseButtonMouseDown(k:WindowMouseEvent)
        {
            if (this._window == null)
            {
                return;
            }
            if (!this._window.visible)
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("GrapBarX") , IBitmapWrapperWindow);
            if (_local_2 != null)
            {
                _local_2.disposesBitmap = false;
                _local_2.bitmap = this._grabBarXPressedBmp;
            }
        }

        function onCloseButtonMouseUp(k:WindowMouseEvent)
        {
            if (this._window == null)
            {
                return;
            }
            if (!this._window.visible)
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("GrapBarX") , IBitmapWrapperWindow);
            if (_local_2 != null)
            {
                _local_2.disposesBitmap = false;
                _local_2.bitmap = this._grabBarXOverBmp;
            }
        }
    }

