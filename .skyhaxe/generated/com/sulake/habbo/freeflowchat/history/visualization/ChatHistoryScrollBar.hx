package com.sulake.habbo.freeflowchat.history.visualization
;
	import com.sulake.habbo.freeflowchat.history.visualization.ChatHistoryScrollView;
    import flash.display.Sprite;
    import flash.display.Stage;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.MouseEvent;

     class ChatHistoryScrollBar 
    {
        public static inline final _Str_14287= 0;

        var _scrollView:ChatHistoryScrollView;
        var _displayObject:Sprite;
        var _background:Sprite;
        var _thumbTrack:Sprite;
        var _dragStartY:Int = 0;
        var _dragStartBufferTopY:Int = 0;
        var _registeredStage:Stage;

        public function new(k:ChatHistoryScrollView, _arg_2:HabboFreeFlowChat)
        {
            this._scrollView = k;
            this._thumbTrack = HabboFreeFlowChat.create9SliceSprite(new Rectangle(2, 2, 1, 1), ASCompat.dynamicAs(_arg_2.assets.getAssetByName("scrollbar_thumb").content , BitmapData));
            this._thumbTrack.x = 2;
            this._thumbTrack.y = 2;
            this._background = HabboFreeFlowChat.create9SliceSprite(new Rectangle(2, 2, 5, 5), ASCompat.dynamicAs(_arg_2.assets.getAssetByName("scrollbar_back").content , BitmapData));
            this._displayObject = new Sprite();
            this._displayObject.addChild(this._background);
            this._displayObject.addChild(this._thumbTrack);
            this._thumbTrack.addEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
            this._thumbTrack.addEventListener(Event.REMOVED_FROM_STAGE, (this.onRemovedFromStage : ASAny));
            this._thumbTrack.addEventListener(MouseEvent.MOUSE_DOWN, (this._Str_24838 : ASAny));
        }

        public var height(never,set):Int;
public function  set_height(k:Int):Int        {
            this._background.height = k;
            this._Str_20818();
return k;
        }

        public var displayObject(get,never):Sprite;
public function  get_displayObject():Sprite
        {
            return this._displayObject;
        }

        public function _Str_20818()
        {
            var k = 0;
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4 = Math.NaN;
            if (((this._scrollView == null) || (this._scrollView.viewPort == null)))
            {
                return;
            }
            k = Std.int(Math.max(1, this._scrollView._Str_18682));
            _local_2 = Std.int(Math.max(1, this._scrollView.viewPort.height));
            _local_3 = Std.int(Math.max(0, (k - _local_2)));
            this._thumbTrack.visible = (_local_3 > 0);
            if (!this._thumbTrack.visible)
            {
                return;
            }
            this._thumbTrack.height = Math.min((this._background.height - 4), Math.max(5, Std.int(((this._background.height - 4) * (_local_2 / k)))));
            _local_4 = (_local_3 > 0) ? (this._scrollView._Str_7317 / _local_3) : 0;
            this._thumbTrack.y = (2 + Std.int((((this._background.height - 4) - this._thumbTrack.height) * _local_4)));
        }

        function onAddedToStage(k:Event)
        {
            this._registeredStage = this._thumbTrack.stage;
        }

        function onRemovedFromStage(k:Event)
        {
            this._registeredStage = null;
        }

        function _Str_24838(k:Event)
        {
            this._dragStartY = Std.int(cast(k, MouseEvent).stageY);
            this._dragStartBufferTopY = this._scrollView._Str_7317;
            this._registeredStage.addEventListener(MouseEvent.MOUSE_UP, (this._Str_4596 : ASAny));
            this._registeredStage.addEventListener(MouseEvent.MOUSE_MOVE, (this._Str_4596 : ASAny));
            k.stopImmediatePropagation();
        }

        function _Str_4596(k:Event)
        {
            var _local_2:MouseEvent = null;
            var _local_3 = Math.NaN;
            var _local_4 = 0;
            _local_2 = cast(k, MouseEvent);
            switch (_local_2.type)
            {
                case MouseEvent.MOUSE_MOVE:
                    _local_3 = ((this._scrollView._Str_18682 - this._scrollView.viewPort.height) / Math.max(1, this._background.height));
                    _local_4 = Std.int((_local_2.stageY - this._dragStartY) * _local_3);
                    this._scrollView._Str_7317 = (this._dragStartBufferTopY + _local_4);
                    
                case MouseEvent.MOUSE_UP:
                    this._Str_20615();
                    
            }
            k.stopImmediatePropagation();
        }

        public function _Str_20615()
        {
            if (this._registeredStage != null)
            {
                this._registeredStage.removeEventListener(MouseEvent.MOUSE_UP, (this._Str_4596 : ASAny));
                this._registeredStage.removeEventListener(MouseEvent.MOUSE_MOVE, (this._Str_4596 : ASAny));
            }
        }
    }

