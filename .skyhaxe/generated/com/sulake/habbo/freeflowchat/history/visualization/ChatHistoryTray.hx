package com.sulake.habbo.freeflowchat.history.visualization
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
	import com.sulake.habbo.freeflowchat.history.visualization.ChatHistoryScrollView;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import com.sulake.habbo.freeflowchat.history.visualization._enum.ChatHistoryLayoutEnum;
    import flash.events.Event;
    import com.sulake.habbo.freeflowchat.viewer._enum.ChatBubbleWidth;
    import flash.events.MouseEvent;

     class ChatHistoryTray implements IDisposable implements  IUpdateReceiver 
    {
        static inline final ANIMATION_DURATION_MS= 140;

        var _rootDisplayObject:DisplayObjectContainer;
        var _registeredStage:Stage;
        var _component:HabboFreeFlowChat;
        var _scrollView:ChatHistoryScrollView;
        var _tab:Sprite;
        var _tabBg:Bitmap;
        var _tabHandle:Bitmap;
        var _bg:Bitmap;
        var _openedWidth:Int = 0;
        var _currentWidth:Float = 0;
        var _isOpen:Bool = false;
        var _isAnimating:Bool = false;
        var _isRegisteredForUpdates:Bool = false;
        var _animationStartWidth:Float = 0;
        var _animationTargetWidth:Int = 0;
        var _animationElapsed:Int = 0;
        // Cached tray_bar asset width. NGHWin's F5 reload can dispose the shared asset-library
        // BitmapData while a tray still references it; a later stage resize then reads the disposed
        // BitmapData.width and throws ArgumentError #2015, aborting the client. Capture the (fixed)
        // width once at construction (while valid) and never touch the live BitmapData in
        // resize/applyTrayWidth. May never hits this (it doesn't dispose these assets mid-session).
        var _tabBgWidth:Int = 0;

        public function new(k:HabboFreeFlowChat, _arg_2:ChatHistoryScrollView)
        {
            this._component = k;
            this._scrollView = _arg_2;
            this._rootDisplayObject = new Sprite();
            this._tabBg = new Bitmap();
            this._tabBg.bitmapData = cast(this._component.assets.getAssetByName("tray_bar").content, BitmapData);
            this._tabBgWidth = this._tabBg.bitmapData.width;
            this._tabBg.width = this._tabBgWidth;
            this._tabBg.height = 0;
            this._tabBg.scaleX = 1;
            this._tabBg.x = -this._tabBgWidth;
            this._tabHandle = new Bitmap();
            this._tabHandle.bitmapData = cast(this._component.assets.getAssetByName("tray_handle_open").content, BitmapData);
            this._tabHandle.scaleX = 1;
            this._tabHandle.scaleY = 1;
            this._tabHandle.x = -ChatHistoryLayoutEnum._Str_10590;
            this._tabHandle.y = 350;
            this._tabHandle.visible = false;
            this._tab = new Sprite();
            this._tab.scaleX = 1;
            this._tab.scaleY = 1;
            this._tab.visible = true;
            this._tab.addChild(this._tabBg);
            this._tab.addChild(this._tabHandle);
            this._rootDisplayObject.addChild(this._tab);
            this._bg = new Bitmap();
            this._bg.bitmapData = new BitmapData(1, 1, true, 0xA224231E);
            this._bg.width = 0;
            this._bg.height = 0;
            this._rootDisplayObject.addChild(this._bg);
            this._rootDisplayObject.addEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
            this._openedWidth = ((ChatBubbleWidth.NORMAL + ChatHistoryLayoutEnum._Str_7140) + 1);
            this.applyTrayWidth(0);
        }

        public function dispose()
        {
            this._component.disableRoomMouseEventsLeftOfX(0);
            this.removeUpdateRegistration();
            if (this._rootDisplayObject != null)
            {
                this._scrollView._Str_15425();
                if (this._registeredStage != null)
                {
                    this._registeredStage.removeEventListener(MouseEvent.CLICK, (this._Str_20390 : ASAny));
                }
            }
            this._rootDisplayObject = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._rootDisplayObject == null;
        }

        public var _Str_5128(get,never):DisplayObjectContainer;
public function  get__Str_5128():DisplayObjectContainer
        {
            return this._rootDisplayObject;
        }

        public function resize(k:Int, _arg_2:Int)
        {
            this._tab.height = (_arg_2 - ChatHistoryLayoutEnum._Str_7235);
            this._tabBg.height = (_arg_2 - ChatHistoryLayoutEnum._Str_7235);
            this._bg.height = (_arg_2 - ChatHistoryLayoutEnum._Str_7235);
            this._tab.scaleY = 1;
            this._tabHandle.scaleY = 1;
            this._tabHandle.y = (_arg_2 - ChatHistoryLayoutEnum._Str_16016);
            this.applyTrayWidth(Std.int(Math.fround(this._currentWidth)));
        }

        function onAddedToStage(k:Event)
        {
            this.resize(this._component.chatViewWidth, this._component.chatViewHeight);
            this._rootDisplayObject.stage.addEventListener(MouseEvent.CLICK, (this._Str_20390 : ASAny));
            this._registeredStage = this._rootDisplayObject.stage;
        }

        public function _Str_19537()
        {
            if (this._isOpen)
            {
                this.startClosing();
            }
            else
            {
                this.startOpening();
            }
        }

        function _Str_20390(k:Event)
        {
            if (((!(this._rootDisplayObject != null)) || (!(this._rootDisplayObject.stage != null))))
            {
                return;
            }
            var _local_2= cast(k, MouseEvent);
            var _local_3= ((((this._tabHandle.x <= _local_2.stageX) && (_local_2.stageX <= (this._tabHandle.x + this._tabHandle.width))) && (this._tabHandle.y <= _local_2.stageY)) && (_local_2.stageY <= (this._tabHandle.y + this._tabHandle.height)));
            if ((this._tabHandle.visible && (!this._isAnimating)) && _local_3)
            {
                this._Str_19537();
            }
        }

        public function update(k:UInt)
        {
            var _local_2 = Math.NaN;
            var _local_3 = Math.NaN;
            var _local_4 = Math.NaN;
            if (this._isAnimating)
            {
                this._animationElapsed = ASCompat.toInt(this._animationElapsed + k);
                _local_2 = Math.min(1, (this._animationElapsed / ANIMATION_DURATION_MS));
                _local_3 = (1 - Math.pow((1 - _local_2), 3));
                _local_4 = (this._animationStartWidth + ((this._animationTargetWidth - this._animationStartWidth) * _local_3));
                this.applyTrayWidth(Std.int(Math.fround(_local_4)));
                if (_local_2 >= 1)
                {
                    this._isAnimating = false;
                    this.applyTrayWidth(this._animationTargetWidth);
                    if (this._animationTargetWidth == 0)
                    {
                        this.finishClosing();
                    }
                    this.refreshUpdateRegistration();
                }
            }
        }

        function startOpening()
        {
            this._isOpen = true;
            if (this._scrollView._Str_5128.parent != this._rootDisplayObject)
            {
                this._rootDisplayObject.addChild(this._scrollView._Str_5128);
            }
            if (!this._scrollView.isActive)
            {
                this._scrollView._Str_24783();
                this._scrollView._Str_24280();
            }
            this._scrollView._Str_24219();
            this._tabHandle.bitmapData = cast(this._component.assets.getAssetByName("tray_handle_close").content, BitmapData);
            this.beginWidthAnimation(this._openedWidth);
        }

        function startClosing()
        {
            this._isOpen = false;
            this._scrollView._Str_15425();
            this.beginWidthAnimation(0);
        }

        function finishClosing()
        {
            if (this._scrollView._Str_5128.parent == this._rootDisplayObject)
            {
                this._rootDisplayObject.removeChild(this._scrollView._Str_5128);
            }
            this._scrollView._Str_17611();
            this._tabHandle.bitmapData = cast(this._component.assets.getAssetByName("tray_handle_open").content, BitmapData);
            this._tabHandle.visible = false;
            this.applyTrayWidth(0);
        }

        function beginWidthAnimation(k:Int)
        {
            this._animationStartWidth = this._currentWidth;
            this._animationTargetWidth = k;
            this._animationElapsed = 0;
            this._isAnimating = (this._animationStartWidth != this._animationTargetWidth);
            if (!this._isAnimating)
            {
                this.applyTrayWidth(k);
                if (k == 0)
                {
                    this.finishClosing();
                }
                this.refreshUpdateRegistration();
                return;
            }
            this.refreshUpdateRegistration();
        }

        function applyTrayWidth(k:Int)
        {
            var _local_2= Std.int(Math.max(0, Math.min(this._openedWidth, k)));
            this._currentWidth = _local_2;
            this._bg.width = _local_2;
            this._tabBg.x = (_local_2 > 0) ? _local_2 : -this._tabBgWidth;
            this._tabHandle.visible = (_local_2 > 0);
            this._tabHandle.x = ((_local_2 - ChatHistoryLayoutEnum._Str_10590) + this._tabBgWidth);
            this._scrollView._Str_20800 = _local_2;
            this._component.disableRoomMouseEventsLeftOfX((_local_2 > 0) ? (_local_2 + this._tabBgWidth) : 0);
        }

        function refreshUpdateRegistration()
        {
            if ((this._isAnimating && (!this._isRegisteredForUpdates)))
            {
                this._component.registerUpdateReceiver(this, 1);
                this._isRegisteredForUpdates = true;
            }
            else
            {
                if (((!this._isAnimating) && this._isRegisteredForUpdates))
                {
                    this.removeUpdateRegistration();
                }
            }
        }

        function removeUpdateRegistration()
        {
            if ((this._isRegisteredForUpdates && (this._component != null)))
            {
                this._component.removeUpdateReceiver(this);
            }
            this._isRegisteredForUpdates = false;
        }
    }

