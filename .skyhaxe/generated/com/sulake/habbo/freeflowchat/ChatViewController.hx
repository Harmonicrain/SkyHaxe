package com.sulake.habbo.freeflowchat
;
    import com.sulake.core.runtime.IDisposable;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import com.sulake.habbo.freeflowchat.viewer.ChatFlowViewer;
    import com.sulake.habbo.freeflowchat.history.visualization.ChatHistoryTray;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;

     class ChatViewController implements IDisposable 
    {
        var _rootDisplayObject:DisplayObjectContainer;
        var _registeredStage:Stage;
        var _component:HabboFreeFlowChat;
        var _flowViewer:ChatFlowViewer;
        var _pulldown:ChatHistoryTray;
        var _flowViewerDisplayObject:DisplayObject;
        var _pulldownDisplayObject:DisplayObject;

        public function new(k:HabboFreeFlowChat, _arg_2:ChatFlowViewer, _arg_3:ChatHistoryTray)
        {
            this._component = k;
            this._flowViewer = _arg_2;
            this._pulldown = _arg_3;
            this._flowViewerDisplayObject = this._flowViewer._Str_5128;
            this._pulldownDisplayObject = this._pulldown._Str_5128;
            this._rootDisplayObject = new Sprite();
            this._rootDisplayObject.addChild(this._flowViewerDisplayObject);
            this._rootDisplayObject.addChild(this._pulldownDisplayObject);
            this._rootDisplayObject.addEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
        }

        public function dispose()
        {
            if (this._rootDisplayObject != null)
            {
                this._component.removeUpdateReceiver(this._pulldown);
                if (this._registeredStage != null)
                {
                    this._registeredStage.removeEventListener(Event.RESIZE, (this._Str_11094 : ASAny));
                }
                this._rootDisplayObject.removeChild(this._pulldownDisplayObject);
                this._rootDisplayObject.removeChild(this._flowViewerDisplayObject);
                this._rootDisplayObject.removeEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
                this._rootDisplayObject = null;
                this._pulldownDisplayObject = null;
                this._flowViewerDisplayObject = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._rootDisplayObject == null;
        }

        public var _Str_5128(get,never):DisplayObject;
public function  get__Str_5128():DisplayObject
        {
            return this._rootDisplayObject;
        }

        function onAddedToStage(k:Event)
        {
            this._registeredStage = this._rootDisplayObject.stage;
            this._registeredStage.addEventListener(Event.RESIZE, (this._Str_11094 : ASAny));
            this.resizeChatView();
            this._component.registerUpdateReceiver(this._pulldown, 200);
        }

        function _Str_11094(k:Event)
        {
            this.resizeChatView();
        }

        function resizeChatView()
        {
            var width= this._component.chatViewWidth;
            var height= this._component.chatViewHeight;
            this._pulldown.resize(width, height);
            this._flowViewer.resize(width, height);
        }
    }

