package com.sulake.habbo.freeflowchat.viewer
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.habbo.freeflowchat.viewer.simulation.ChatFlowStage;
    import flash.display.DisplayObjectContainer;
    import com.sulake.habbo.freeflowchat.viewer.visualization.PooledChatBubble;
    import flash.display.Sprite;
    import flash.geom.Point;

     class ChatFlowViewer implements IDisposable implements  IUpdateReceiver 
    {
        static inline final _Str_22565= 230;

        var _component:HabboFreeFlowChat;
        var _chatFlowStage:ChatFlowStage;
        var _rootDisplayObject:DisplayObjectContainer;
        var _lastAddedToRoomId:Int = 0;
        var _lastCanvasOffsetX:Int = 0;
        var _runTime:UInt = 0;
        var _chatAreaVsScreenSize:Float = 0.25;
        var _bubbles:Vector<PooledChatBubble>;
        var _toRemove:Vector<PooledChatBubble>;

        public function new(k:HabboFreeFlowChat, _arg_2:ChatFlowStage)
        {
            this._bubbles = new Vector<PooledChatBubble>(0);
            this._toRemove = new Vector<PooledChatBubble>(0);
            this._rootDisplayObject = new Sprite();
            this._component = k;
            this._component.registerUpdateReceiver(this, 1);
            this._chatFlowStage = _arg_2;
        }

        public function dispose()
        {
            if (this._component != null)
            {
                this._component.removeUpdateReceiver(this);
                this._component = null;
            }
            this._chatFlowStage = null;
            this._rootDisplayObject = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return (this._rootDisplayObject == null) && (this._component == null);
        }

        public function _Str_12872(k:PooledChatBubble, _arg_2:Point)
        {
            k._Str_18364 = this._lastCanvasOffsetX;
            this._bubbles.push(k);
            this._rootDisplayObject.addChild(k);
            k._Str_12023(Std.int(_arg_2.x), Std.int(_arg_2.y));
            k._Str_12210();
            this._lastAddedToRoomId = k.roomId;
        }

        public function update(k:UInt)
        {
            var _local_3:PooledChatBubble = null;
            var _local_4:PooledChatBubble = null;
            var _local_5:PooledChatBubble = null;
            var _local_6 = 0;
            this._runTime = (this._runTime + k);
            var _local_2= this._component.roomEngine.getRoomCanvasScreenOffset(this._lastAddedToRoomId);
            if (_local_2 != null)
            {
                if (((!(_local_2.x == this._lastCanvasOffsetX)) && (this._bubbles.length > 0)))
                {
                    final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_4  = _tmp_;
                        _local_4._Str_18364 = Std.int(_local_2.x);
                    }
                }
                this._lastCanvasOffsetX = Std.int(_local_2.x);
            }
            final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_3.update(k);
                if (_local_3._Str_4702)
                {
                    this._toRemove.push(_local_3);
                }
            }
            if (this._toRemove.length > 0)
            {
                final _iter_ = this._toRemove; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_5  = _tmp_;
                    this._rootDisplayObject.removeChild(_local_5);
                    _local_6 = this._bubbles.indexOf(_local_5);
                    this._bubbles.splice(_local_6, 1);
                    _local_5._Str_23848();
                    this._component.chatBubbleFactory.recycle(_local_5);
                }
                this._toRemove = new Vector<PooledChatBubble>(0);
            }
        }

        public var _Str_5128(get,never):DisplayObjectContainer;
public function  get__Str_5128():DisplayObjectContainer
        {
            return this._rootDisplayObject;
        }

        public var _Str_12498(get,never):Int;
public function  get__Str_12498():Int
        {
            if (this._component == null)
            {
                return ChatFlowViewer._Str_22565;
            }
            return Std.int(this._component.chatViewHeight * this._chatAreaVsScreenSize);
        }

        public function resize(k:Int, _arg_2:Int)
        {
            if (this._chatFlowStage != null)
            {
                this._chatFlowStage.resize(k, _arg_2);
            }
        }
    }

