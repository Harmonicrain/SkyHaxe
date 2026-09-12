package com.sulake.habbo.freeflowchat.history.visualization
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.habbo.freeflowchat.history.ChatHistoryBuffer;
	import com.sulake.habbo.freeflowchat.history.visualization.ChatHistoryScrollBar;
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import com.sulake.habbo.freeflowchat.history.visualization.entry.BitmapSpriteWithUserId;
    import flash.geom.Rectangle;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.display.BitmapData;
    import com.sulake.habbo.freeflowchat.history.visualization.entry.IChatHistoryEntryBitmap;
    import com.sulake.habbo.freeflowchat.history.visualization._enum.ChatHistoryLayoutEnum;
    import flash.events.MouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.habbo.freeflowchat.history.*;

     class ChatHistoryScrollView implements IDisposable 
    {
        var _component:HabboFreeFlowChat;
        var _historyBuffer:ChatHistoryBuffer;
        var _rootDisplayObject:DisplayObjectContainer;
        var _registeredStage:Stage;
        var _bufferDisplays:Vector<BitmapSpriteWithUserId>;
        var _topY:Int = 0;
        var _viewPort:Rectangle;
        var _visibleWidth:Int = 0;
        var _dragStartY:Int = 0;
        var _dragStartTopY:Int = 0;
        var _clipMask:Sprite;
        var _isActive:Bool = false;
        var _scrollBar:ChatHistoryScrollBar;
        var _ignore:Bitmap;
        var _currentIgnored:BitmapSpriteWithUserId;

        public function new(k:HabboFreeFlowChat, _arg_2:ChatHistoryBuffer)
        {
            this._component = k;
            this._historyBuffer = _arg_2;
            this._rootDisplayObject = new Sprite();
            this._rootDisplayObject.x = 0;
            this._rootDisplayObject.y = 0;
            this._rootDisplayObject.addEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
            this._scrollBar = new ChatHistoryScrollBar(this, k);
            this._ignore = new Bitmap();
            this._ignore.bitmapData = cast(this._component.assets.getAssetByName("close_x").content, BitmapData);
            this._currentIgnored = null;
        }

        public function dispose()
        {
            this._Str_15425();
            this._Str_17611();
            this._clipMask = null;
            this._ignore = null;
            this._currentIgnored = null;
            if (this._rootDisplayObject != null)
            {
                this._rootDisplayObject.removeEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
                this._rootDisplayObject = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return (this._clipMask == null) && (this._rootDisplayObject == null);
        }

        public var _Str_5128(get,never):DisplayObjectContainer;
public function  get__Str_5128():DisplayObjectContainer
        {
            return this._rootDisplayObject;
        }

        public function _Str_24280()
        {
            var _local_3:BitmapSpriteWithUserId = null;
            var _local_4:IChatHistoryEntryBitmap = null;
            if (this._historyBuffer == null)
            {
                return;
            }
            this._Str_17611();
            this._bufferDisplays = new Vector<BitmapSpriteWithUserId>(this._historyBuffer.entries.length);
            var k = 0;
            var _local_2= -this._topY;
            while (k < this._historyBuffer.entries.length)
            {
                _local_3 = new BitmapSpriteWithUserId();
                _local_4 = this._historyBuffer.entries[k];
                _local_3.roomId = _local_4.roomId;
                _local_3.userId = _local_4.userId;
                _local_3.bitmapData = _local_4.bitmap;
                _local_3._Str_6123 = _local_4._Str_6123;
                _local_3.userName = _local_4.userName;
                _local_2 = Std.int(_local_2 - _local_4.overlap.y);
                _local_3.y = _local_2;
                _local_3.x = ChatHistoryLayoutEnum._Str_10820;
                _local_2 = (_local_2 + _local_3.bitmapData.height);
                _local_2 = (_local_2 - ChatHistoryLayoutEnum._Str_6853);
                this._bufferDisplays[k] = _local_3;
                this._rootDisplayObject.addChild(this._bufferDisplays[k]);
                k++;
            }
            this._rootDisplayObject.addChild(this._scrollBar.displayObject);
            this._isActive = true;
        }

        public function _Str_17611()
        {
            var k:Bitmap = null;
            if (this.disposed)
            {
                return;
            }
            final _iter_ = this._bufferDisplays; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this._rootDisplayObject.removeChild(k);
                k.bitmapData = null;
            }
            if (this._currentIgnored != null)
            {
                this._rootDisplayObject.removeChild(this._ignore);
                this._currentIgnored = null;
            }
            this._bufferDisplays = new Vector<BitmapSpriteWithUserId>(0);
            if (((!(this._scrollBar.displayObject == null)) && (this._scrollBar.displayObject.parent == this._rootDisplayObject)))
            {
                this._rootDisplayObject.removeChild(this._scrollBar.displayObject);
            }
            this._isActive = false;
        }

        public function _Str_24219()
        {
            this._Str_15425();
            this._rootDisplayObject.stage.addEventListener(MouseEvent.MOUSE_DOWN, (this._Str_4596 : ASAny));
            this._registeredStage = this._rootDisplayObject.stage;
            this._registeredStage.addEventListener(MouseEvent.MOUSE_WHEEL, (this._Str_4596 : ASAny));
            this._registeredStage.addEventListener(Event.RESIZE, (this._Str_11094 : ASAny));
        }

        public function _Str_15425()
        {
            if (this._registeredStage != null)
            {
                this._registeredStage.removeEventListener(MouseEvent.MOUSE_DOWN, (this._Str_4596 : ASAny));
                this._registeredStage.removeEventListener(MouseEvent.MOUSE_MOVE, (this._Str_4596 : ASAny), true);
                this._registeredStage.removeEventListener(MouseEvent.MOUSE_UP, (this._Str_4596 : ASAny));
                this._registeredStage.removeEventListener(MouseEvent.MOUSE_WHEEL, (this._Str_4596 : ASAny));
                this._registeredStage.removeEventListener(Event.RESIZE, (this._Str_11094 : ASAny));
            }
        }

        
        public var _Str_7317(get,set):Int;
public function  get__Str_7317():Int
        {
            return this._topY;
        }

        public var _Str_18682(get,never):Int;
public function  get__Str_18682():Int
        {
            return this._historyBuffer.totalHeight;
        }
public function  set__Str_7317(k:Int):Int        {
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4:IChatHistoryEntryBitmap = null;
            k = this.clampTopY(k);
            this._topY = k;
            if (this._bufferDisplays != null)
            {
                _local_2 = 0;
                _local_3 = -this._topY;
                while (_local_2 < this._historyBuffer.entries.length)
                {
                    if (this._bufferDisplays.length <= _local_2) break;
                    _local_4 = this._historyBuffer.entries[_local_2];
                    _local_3 = Std.int(_local_3 - _local_4.overlap.y);
                    this._bufferDisplays[_local_2].y = _local_3;
                    _local_3 = (_local_3 + (_local_4.bitmap.height - ChatHistoryLayoutEnum._Str_6853));
                    _local_2++;
                }
            }
            if (this._currentIgnored != null)
            {
                this._ignore.y = (this._currentIgnored.y + ((this._currentIgnored.height - this._ignore.height) / 2));
            }
            this._scrollBar._Str_20818();
return k;
        }

        public function _Str_23438(k:IChatHistoryEntryBitmap)
        {
            var _local_2= new BitmapSpriteWithUserId();
            _local_2.bitmapData = k.bitmap;
            _local_2.y = (((-this._topY + this._historyBuffer.totalHeight) - k.bitmap.height) + ChatHistoryLayoutEnum._Str_6853);
            _local_2.x = ChatHistoryLayoutEnum._Str_10820;
            _local_2.userId = k.userId;
            _local_2.roomId = k.roomId;
            _local_2._Str_6123 = k._Str_6123;
            _local_2.userName = k.userName;
            this._bufferDisplays.push(_local_2);
            this._rootDisplayObject.addChild(this._bufferDisplays[(this._bufferDisplays.length - 1)]);
            this._Str_7317 = this._topY;
        }

        public function _Str_25251(k:Int)
        {
            var _local_2:Bitmap = null;
            if (((this._bufferDisplays != null) && (this._bufferDisplays.length > 0)))
            {
                this._rootDisplayObject.removeChild(this._bufferDisplays[0]);
                this._bufferDisplays.splice(0, 1);
                final _iter_ = this._bufferDisplays; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    _local_2.y = (_local_2.y - k);
                }
                this._Str_7317 = (this._topY - k);
            }
        }

        
        public var viewPort(get,set):Rectangle;
public function  get_viewPort():Rectangle
        {
            return this._viewPort;
        }
public function  set_viewPort(k:Rectangle):Rectangle        {
            this._viewPort = k;
            this._rootDisplayObject.width = k.width;
            this._rootDisplayObject.height = k.height;
            this._rootDisplayObject.scaleX = 1;
            this._rootDisplayObject.scaleY = 1;
            if (this._clipMask == null)
            {
                this._clipMask = new Sprite();
                this._rootDisplayObject.addChild(this._clipMask);
            }
            this._clipMask.graphics.clear();
            this._clipMask.graphics.beginFill(0xFFFFFF);
            this._clipMask.graphics.drawRect(0, 0, this.viewPort.width, this.viewPort.height);
            this._rootDisplayObject.mask = this._clipMask;
            this._scrollBar.displayObject.x = (this._viewPort.width - ChatHistoryScrollBar._Str_14287);
            this._Str_12498 = Std.int(k.height);
            this._Str_7317 = this._topY;
return k;
        }

        public var _Str_12498(never,set):Int;
public function  set__Str_12498(k:Int):Int        {
            this._rootDisplayObject.y = (k - this._viewPort.height);
            this._scrollBar.height = k;
            this._scrollBar.displayObject.y = (this._viewPort.height - k);
return k;
        }

        public var _Str_20800(never,set):Int;
public function  set__Str_20800(k:Int):Int        {
            this._visibleWidth = k;
            this._scrollBar.displayObject.x = (this._visibleWidth - ChatHistoryScrollBar._Str_14287);
return k;
        }

        public function _Str_24783()
        {
            this._Str_7317 = 0;
        }

        public var isActive(get,never):Bool;
public function  get_isActive():Bool
        {
            return this._isActive;
        }

        function _Str_25157(k:Int):BitmapSpriteWithUserId
        {
            var _local_2:BitmapSpriteWithUserId = null;
            final _iter_ = this._bufferDisplays; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (((k >= _local_2.y) && (k <= (_local_2.y + _local_2.height))))
                {
                    return _local_2;
                }
            }
            return null;
        }

        function _Str_4596(k:Event)
        {
            var _local_2:MouseEvent = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5:BitmapSpriteWithUserId = null;
            if (((!(this._rootDisplayObject != null)) || (!(this._rootDisplayObject.stage != null))))
            {
                return;
            }
            _local_2 = cast(k, MouseEvent);
            switch (_local_2.type)
            {
                case MouseEvent.MOUSE_DOWN:
                    if (((_local_2.stageY < (this._rootDisplayObject.y + this._viewPort.height)) && (_local_2.stageX < this._scrollBar.displayObject.x)))
                    {
                        this._scrollBar._Str_20615();
                        this._dragStartY = Std.int(_local_2.stageY);
                        this._dragStartTopY = this._Str_7317;
                        this._registeredStage.addEventListener(MouseEvent.MOUSE_MOVE, (this._Str_4596 : ASAny), true);
                        this._registeredStage.addEventListener(MouseEvent.MOUSE_UP, (this._Str_4596 : ASAny));
                    }
                    return;
                case MouseEvent.MOUSE_MOVE:
                    _local_3 = Std.int(_local_2.stageY - this._dragStartY);
                    this._Str_7317 = (this._dragStartTopY - _local_3);
                    k.stopImmediatePropagation();
                    return;
                case MouseEvent.MOUSE_WHEEL:
                    if (((((_local_2.stageY >= this._rootDisplayObject.y) && (_local_2.stageY < (this._rootDisplayObject.y + this._viewPort.height))) && (_local_2.stageX >= this._rootDisplayObject.x)) && (_local_2.stageX < (this._rootDisplayObject.x + this._scrollBar.displayObject.x))))
                    {
                        this._Str_7317 = (this._topY - (_local_2.delta * 40));
                        k.stopImmediatePropagation();
                    }
                    return;
                case MouseEvent.MOUSE_UP:
                    this._registeredStage.removeEventListener(MouseEvent.MOUSE_MOVE, (this._Str_4596 : ASAny), true);
                    this._registeredStage.removeEventListener(MouseEvent.MOUSE_UP, (this._Str_4596 : ASAny));
                    _local_4 = Std.int(_local_2.stageY - this._dragStartY);
                    if (((_local_4 < 1) && (_local_4 > -1)))
                    {
                        if (this._Str_23688(Std.int(_local_2.stageX), Std.int(_local_2.stageY)))
                        {
                            return;
                        }
                        _local_5 = this._Str_25157(Std.int(_local_2.stageY));
                        if (_local_5 != null)
                        {
                            this._Str_23890(_local_5);
                            this._Str_23554(_local_5);
                        }
                    }
                    return;
            }
        }

        function clampTopY(k:Int):Int
        {
            var _local_2 = 0;
            if (((this._historyBuffer == null) || (this._viewPort == null)))
            {
                return Std.int(Math.max(0, k));
            }
            _local_2 = Std.int(Math.max(0, (this._historyBuffer.totalHeight - this._viewPort.height)));
            return Std.int(Math.max(0, Math.min(_local_2, k)));
        }

        function onAddedToStage(k:Event)
        {
            this.viewPort = new Rectangle(0, 0, this._component.chatViewWidth, (this._component.chatViewHeight - ChatHistoryLayoutEnum._Str_7235));
        }

        function _Str_11094(k:Event)
        {
            if (this._registeredStage != null)
            {
                this.viewPort = new Rectangle(0, 0, this._component.chatViewWidth, (this._component.chatViewHeight - ChatHistoryLayoutEnum._Str_7235));
            }
        }

        function _Str_23890(k:BitmapSpriteWithUserId)
        {
            if (this._component == null)
            {
                return;
            }
            this._component.selectAvatar(k.roomId, k.userId);
        }

        function _Str_23554(k:BitmapSpriteWithUserId)
        {
            if (((!(this._component != null)) || (k == this._currentIgnored)))
            {
                return;
            }
            if (((!k._Str_6123) || this._component.sessionDataManager.isIgnored(k.userName)))
            {
                if (this._currentIgnored != null)
                {
                    this._rootDisplayObject.removeChild(this._ignore);
                    this._currentIgnored = null;
                }
                return;
            }
            this._ignore.x = ((k.x + k.width) + 5);
            this._ignore.y = (k.y + ((k.height - this._ignore.height) / 2));
            this._rootDisplayObject.addChild(this._ignore);
            this._currentIgnored = k;
        }

        function _Str_23688(k:Int, _arg_2:Int):Bool
        {
            if ((((((this._currentIgnored == null) || (k < this._ignore.x)) || (k > (this._ignore.x + this._ignore.width))) || (_arg_2 < this._ignore.y)) || (_arg_2 > (this._ignore.y + this._ignore.height))))
            {
                return false;
            }
            this._component.localizations.registerParameter("chat.ignore_user.confirm.info", "username", this._currentIgnored.userName);
            var _local_3= this._component.localizations.getLocalization("chat.ignore_user.confirm.title");
            var _local_4= this._component.localizations.getLocalization("chat.ignore_user.confirm.info");
            this._component.windowManager.confirmWithModal(_local_3, _local_4, 0, this._Str_22950);
            return true;
        }

        function _Str_22950(k:IConfirmDialog, _arg_2:WindowEvent)
        {
            k.dispose();
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
            {
                this._component.sessionDataManager.ignoreUser(this._currentIgnored.userName);
            }
            if (this._currentIgnored != null)
            {
                this._rootDisplayObject.removeChild(this._ignore);
                this._currentIgnored = null;
            }
        }
    }

