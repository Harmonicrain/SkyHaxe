package com.sulake.habbo.freeflowchat.viewer.simulation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomChatSettings;
    import flash.geom.Point;
    import com.sulake.habbo.freeflowchat.viewer.visualization.PooledChatBubble;

     class ChatFlowStage implements IDisposable implements  IUpdateReceiver 
    {
        public static inline final _Str_7698= 19;
        static inline final _Str_18607= 5000;
        static inline final _Str_21041= 10000;
        static inline final _Str_14840= 20;
        static inline final _Str_18713= 15;
        static inline final _Str_16866:Float = 8;

        static inline final _Str_25857= 240;

        var _component:HabboFreeFlowChat;
        var _simulationTime:UInt = 0;
        var _lastCycleAt:UInt = 0;
        var _lastCleanUpAt:UInt = 0;
        var _gravity:ChatFlowGravity;
        var _bubbles:Vector<ChatBubbleSimulationEntity>;
        var _toRemove:Vector<ChatBubbleSimulationEntity>;
        var _lineByLineMode:Bool = false;
        var _scrollUpTimerDelay:Int = 10000;
        var _gravityEnabled:Bool = true;
        var _debugEnabled:Bool = false;
        var _oldChatAreaHeight:Int = 0;

        public function new(k:HabboFreeFlowChat)
        {
            this._gravity = new ChatFlowGravity();
            this._bubbles = new Vector<ChatBubbleSimulationEntity>(0);
            this._toRemove = new Vector<ChatBubbleSimulationEntity>(0);
            this._component = k;
            this._component.registerUpdateReceiver(this, 2);
            this._Str_18127();
        }

        public function _Str_18127()
        {
            if (this._component.roomChatSettings != null)
            {
                this._lineByLineMode = (this._component.roomChatSettings.mode == RoomChatSettings.CHAT_MODE_LINE_BY_LINE);
                this._gravityEnabled = (!this._lineByLineMode);
                switch (this._component.roomChatSettings.scrollSpeed)
                {
                    case RoomChatSettings.CHAT_SCROLL_SPEED_FAST:
                        this._scrollUpTimerDelay = 3000;
                        return;
                    case RoomChatSettings.CHAT_SCROLL_SPEED_NORMAL:
                        this._scrollUpTimerDelay = 6000;
                        return;
                    case RoomChatSettings.CHAT_SCROLL_SPEED_SLOW:
                        this._scrollUpTimerDelay = 12000;
                        return;
                }
            }
        }

        public function dispose()
        {
            if (!this.disposed)
            {
                if (this._component != null)
                {
                    this._component.removeUpdateReceiver(this);
                    this._component = null;
                }
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._component == null;
        }

        public function _Str_12872(k:PooledChatBubble):Point
        {
            var _local_2:ChatBubbleSimulationEntity = null;
            var _local_5 = 0;
            var _local_6 = Math.NaN;
            var _local_7 = Math.NaN;
            var _local_8:ChatBubbleSimulationWithLimitedWideRect = null;
            var _local_9 = 0;
            var _local_10 = Math.NaN;
            var _local_11:ChatBubbleSimulationEntity = null;
            if (this._oldChatAreaHeight == 0)
            {
                this._oldChatAreaHeight = this._component.chatFlowViewer._Str_12498;
            }
            if (((!this._lineByLineMode) && (k.width < ChatFlowStage._Str_25857)))
            {
                _local_2 = new ChatBubbleSimulationWithLimitedWideRect(k);
            }
            else
            {
                _local_2 = new ChatBubbleSimulationEntity(k, this._lineByLineMode);
            }
            var _local_3= new Point((k._Str_11643.x - (_local_2._Str_6163.width / 2)), this._component.chatFlowViewer._Str_12498);
            var _local_4= this._component.roomEngine.getRoomCanvasScreenOffset(k.roomId);
            if (_local_4 != null)
            {
                _local_3.x = (_local_3.x - _local_4.x);
            }
            _local_3.y = (_local_3.y - ((k.overlap != null) ? k.overlap.y : 0));
            _local_3.x = (_local_3.x - ((k.overlap != null) ? k.overlap.x : 0));
            _local_2.initializePosition(_local_3.x, _local_3.y);
            if ((this._gravityEnabled && (!this._lineByLineMode)))
            {
                _local_5 = 0;
                while (_local_5 < (_Str_14840 / 2))
                {
                    _local_10 = 0;
                    final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_11  = _tmp_;
                        _local_10 = (_local_10 + this._gravity._Str_20468(_local_2, _local_11, ChatFlowGravity._Str_16724, ChatFlowGravity._Str_16944));
                    }
                    _local_2.x = (_local_2.x + _local_10);
                    _local_5++;
                }
                _local_6 = _local_2.x;
                _local_9 = Std.int(k._Str_11643.x - ((_local_4 != null) ? _local_4.x : 0));
                if (_local_2.x > (_local_9 - ChatFlowGravity._Str_8857))
                {
                    _local_6 = (_local_9 - ChatFlowGravity._Str_8857);
                    if (_local_2._Str_20442)
                    {
                        _local_8 = cast(_local_2, ChatBubbleSimulationWithLimitedWideRect);
                        _local_7 = (_local_2.x - _local_6);
                        _local_8._Str_5036 = (_local_8._Str_5036 + _local_7);
                        _local_8._Str_5036 = Math.min(0, _local_8._Str_5036);
                    }
                }
                else
                {
                    if ((_local_2.x + _local_2._Str_6163.width) < (_local_9 + ChatFlowGravity._Str_8857))
                    {
                        _local_6 = ((_local_9 - _local_2._Str_6163.width) + ChatFlowGravity._Str_8857);
                        if (_local_2._Str_20442)
                        {
                            _local_8 = cast(_local_2, ChatBubbleSimulationWithLimitedWideRect);
                            _local_7 = (_local_2.x - _local_6);
                            _local_8._Str_5036 = (_local_8._Str_5036 + _local_7);
                            _local_8._Str_5036 = Math.max(-(_local_8._Str_10759.width - _local_8._Str_6163.width), _local_8._Str_5036);
                        }
                    }
                }
                _local_2.x = (_local_3.x = _local_6);
            }
            this._bubbles.push(_local_2);
            _local_3.x = (_local_3.x - ((k.overlap != null) ? k.overlap.x : 0));
            if (this._lineByLineMode)
            {
                this._lastCycleAt = this._simulationTime;
            }
            return _local_3;
        }

        public function update(k:UInt)
        {
            var _local_3:ChatBubbleSimulationEntity = null;
            this._simulationTime = (this._simulationTime + k);
            this._Str_19305();
            if ((this._lastCycleAt + this._scrollUpTimerDelay) < this._simulationTime)
            {
                this._Str_25140();
                this._lastCycleAt = this._simulationTime;
            }
            var _local_2 = 0;
            while (_local_2 < this._bubbles.length)
            {
                _local_3 = this._bubbles[_local_2];
                _local_3._Str_18740();
                if (!_local_3.isSpacer)
                {
                    _local_3.fullHeightCollision = false;
                    if (((_local_2 > 0) && _local_3._Str_25178))
                    {
                        _local_3.fullHeightCollision = true;
                        this._bubbles[(_local_2 - 1)].fullHeightCollision = true;
                    }
                }
                _local_2++;
            }
            if ((this._lastCleanUpAt + _Str_18607) < this._simulationTime)
            {
                this._Str_22963();
                this._lastCleanUpAt = this._simulationTime;
            }
        }

        public function clear()
        {
            var k:ChatBubbleSimulationEntity = null;
            final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k._Str_4702 = true;
            }
            this.update(0);
            this._component.chatFlowViewer.update(0);
        }

        function _Str_19305()
        {
            var k:Vector<ChatBubbleCollisionEvent> = null;
            var _local_2:ChatBubbleCollisionEvent = null;
            var _local_3:ChatBubbleSimulationEntity = null;
            var _local_4:ChatBubbleSimulationEntity = null;
            var _local_5:ChatBubbleSimulationEntity = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = Math.NaN;
            var _local_9 = Math.NaN;
            var _local_10 = Math.NaN;
            var _local_11 = Math.NaN;
            _local_6 = 0;
            while (_local_6 < _Str_14840)
            {
                k = new Vector<ChatBubbleCollisionEvent>(0);
                final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    _local_4._Str_23377();
                    final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_5  = _tmp_;
                        if (((!(_local_4 == _local_5)) && _local_4._Str_25372(_local_5)))
                        {
                            k.push(new ChatBubbleCollisionEvent(_local_4, _local_5));
                        }
                    }
                }
                if (k.length == 0)
                {
                    return;
                }
                if (this._lineByLineMode)
                {
                    if (checkNullIteratee(k)) for (_tmp_ in k)
                    {
_local_2  = _tmp_;
                        if (((!_local_2.first._Str_14539(_local_2._Str_6122)) && (!_local_2._Str_6122._Str_14539(_local_2.first))))
                        {
                            if (_local_2._Str_21189)
                            {
                                _local_2._Str_14418._Str_13455(-_local_2._Str_14418._Str_10759.height);
                            }
                            else
                            {
                                _local_7 = Std.int(_local_2.first._Str_23025(_local_2._Str_6122) ? Std.int(_local_2.top._Str_6163.bottom ): Std.int(_local_2.top._Str_10759.bottom));
                                _local_2.top._Str_13455(-((_local_7 - _local_2.bottom.y) + 1));
                            }
                        }
                        _local_2.first._Str_13441(_local_2._Str_6122);
                        _local_2._Str_6122._Str_13441(_local_2.first);
                    }
                }
                else
                {
                    if (checkNullIteratee(k)) for (_tmp_ in k)
                    {
_local_2  = _tmp_;
                        if (((!_local_2.first._Str_14539(_local_2._Str_6122)) && (!_local_2._Str_6122._Str_14539(_local_2.first))))
                        {
                            _local_8 = (Std.is(_local_2.left , ChatBubbleSimulationWithLimitedWideRect) ? (cast(_local_2.left, ChatBubbleSimulationWithLimitedWideRect)._Str_5036 + _local_2.left.x) : _local_2.left.x);
                            _local_9 = (Std.is(_local_2.right , ChatBubbleSimulationWithLimitedWideRect) ? (cast(_local_2.right, ChatBubbleSimulationWithLimitedWideRect)._Str_5036 + _local_2.right.x) : _local_2.right.x);
                            _local_10 = (Std.is(_local_2.left , ChatBubbleSimulationWithLimitedWideRect) ? _local_2.left._Str_10759.width : _local_2.left._Str_6163.width);
                            _local_11 = (Math.abs(((_local_8 + _local_10) - _local_9)) / 2);
                            if (_local_11 <= _Str_18713)
                            {
                                _local_2.left._Str_20224(-_local_11);
                                _local_2.right._Str_20224((_local_11 + 1));
                            }
                            else
                            {
                                if (_local_2._Str_21189)
                                {
                                    _local_2._Str_14418._Str_13455(-_local_2._Str_14418._Str_6163.height);
                                }
                                else
                                {
                                    _local_2.top._Str_13455(-((_local_2.top._Str_6163.bottom - _local_2.bottom.y) + 1));
                                }
                            }
                            _local_2.first._Str_13441(_local_2._Str_6122);
                            _local_2._Str_6122._Str_13441(_local_2.first);
                        }
                    }
                }
                final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_3  = _tmp_;
                    _local_3._Str_23082(Std.int(_Str_16866));
                }
                _local_6++;
            }
        }

        function _Str_25140()
        {
            var k:ChatBubbleSimulationEntity = null;
            var _local_2:ChatBubbleSimulationEntity = null;
            if (this._component.chatFlowViewer == null)
            {
                return;
            }
            final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (this._gravityEnabled)
                {
                    final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_2  = _tmp_;
                        if (k != _local_2)
                        {
                            k.x = (k.x + this._gravity._Str_20468(k, _local_2));
                        }
                    }
                }
                k.y = (k.y - _Str_7698);
            }
            if (this._lineByLineMode)
            {
                this._Str_12872(this._component.chatBubbleFactory._Str_25435(_Str_7698));
                this._bubbles[(this._bubbles.length - 1)].fullHeightCollision = true;
                this._bubbles[(this._bubbles.length - 1)].isSpacer = true;
            }
            this._Str_19305();
        }

        function _Str_22963()
        {
            var k:ChatBubbleSimulationEntity = null;
            var _local_2:ChatBubbleSimulationEntity = null;
            var _local_3 = 0;
            final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (((k._Str_6163.bottom < -10) || k._Str_4702))
                {
                    k._Str_4702 = true;
                    if (this._toRemove.indexOf(k) == -1)
                    {
                        this._toRemove.push(k);
                    }
                }
            }
            if (this._toRemove.length > 0)
            {
                final _iter_ = this._toRemove; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    _local_3 = this._bubbles.indexOf(_local_2);
                    _local_2.dispose();
                    this._bubbles.splice(_local_3, 1);
                }
                this._toRemove = new Vector<ChatBubbleSimulationEntity>(0);
            }
        }

        public function resize(k:Int, _arg_2:Int)
        {
            var _local_4:ChatBubbleSimulationEntity = null;
            var _local_5 = 0;
            var _local_6 = 0;
            if (this._component == null)
            {
                return;
            }
            if (this._component.chatFlowViewer == null)
            {
                return;
            }
            var _local_3= this._component.chatFlowViewer._Str_12498;
            if (this._oldChatAreaHeight != _local_3)
            {
                if (this._oldChatAreaHeight < _local_3)
                {
                    _local_5 = (_local_3 - this._oldChatAreaHeight);
                    final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_4  = _tmp_;
                        _local_4.y = (_local_4.y + _local_5);
                        _local_4._Str_18740(true);
                    }
                }
                else
                {
                    _local_6 = (this._oldChatAreaHeight - _local_3);
                    final _iter_ = this._bubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_4  = _tmp_;
                        _local_4.y = (_local_4.y - _local_6);
                        _local_4._Str_18740(true);
                    }
                }
            }
            this._oldChatAreaHeight = _local_3;
        }
    }

