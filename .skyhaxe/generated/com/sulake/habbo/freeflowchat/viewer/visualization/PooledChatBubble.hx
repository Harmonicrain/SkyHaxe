package com.sulake.habbo.freeflowchat.viewer.visualization
;
    import flash.display.Sprite;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.habbo.freeflowchat.data.ChatItem;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import com.sulake.habbo.freeflowchat.viewer.visualization.style.IChatStyleInternal;
    import flash.events.Event;
    import com.sulake.habbo.freeflowchat.viewer._enum.ChatBubbleWidth;
    import flash.text.AntiAliasType;
    import flash.text.GridFitType;
    import flash.events.TextEvent;
    import com.sulake.habbo.session.events.RoomSessionChatEvent;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;

     class PooledChatBubble extends Sprite 
    {
        public static inline final _Str_7976:UInt = 300;

        static inline final _Str_10527= 85;
        static inline final _Str_16997= 190;
        static inline final _Str_6907:UInt = 150;
        static inline final MAX_HEIGHT:UInt = 108;
        static inline final _Str_10539= 28;
        static inline final _Str_11116= 15;
        static inline final _Str_25378= 2000;

        var _component:HabboFreeFlowChat;
        var _chatItem:ChatItem;
        var _background:Sprite;
        var _pointer:Bitmap;
        var _emblem:Bitmap;
        var _face:Bitmap;
        var _faceBitmapData:BitmapData;
        var _textField:TextField;
        var _style:IChatStyleInternal;
        var _timeMs:UInt = 0;
        var _moveBeginMs:UInt = 0;
        var _moveTargetX:Int = 0;
        var _moveTargetY:Int = 0;
        var _moveOriginX:Int = 0;
        var _moveOriginY:Int = 0;
        var _moveDeltaXPerMs:Float = Math.NaN;
        var _moveDeltaYPerMs:Float = Math.NaN;
        var _readyToRecycle:Bool = false;
        var _roomPanOffsetX:Int = 0;
        var _proxyX:Int = 0;
        var _useDesktopMargins:Bool = false;
        var _hasHitDesktopMargin:Bool = false;
        var _clipMask:Sprite;
        var _timePointerPositionUpdateMs:UInt = 0;
        var _minHeight:Int = -1;

        public function new(k:HabboFreeFlowChat)
        {
            super();
            this._component = k;
            this._pointer = new Bitmap();
            this._emblem = new Bitmap();
            this._face = new Bitmap();
            this._textField = new TextField();
            this._clipMask = new Sprite();
            this.addEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
            this.addEventListener(Event.REMOVED_FROM_STAGE, (this.onRemovedFromStage : ASAny));
        }

        public var chatItem(never,set):ChatItem;
public function  set_chatItem(k:ChatItem):ChatItem        {
            return this._chatItem = k;
        }

        public var face(never,set):BitmapData;
public function  set_face(k:BitmapData):BitmapData        {
            return this._faceBitmapData = k;
        }

        public var style(never,set):IChatStyleInternal;
public function  set_style(k:IChatStyleInternal):IChatStyleInternal        {
            return this._style = k;
        }

        public function _Str_19209(k:String, _arg_2:UInt, _arg_3:Bool=false, _arg_4:Int=-1)
        {
            var _local_13 = 0;
            var _local_14 = 0;
            var _local_15:Array<ASAny> = null;
            var _local_16:String = null;
            var _local_17:String = null;
            var _local_18:String = null;
            var _local_19 = 0;
            var _local_20:BitmapData = null;
            this._background = this._style.getNewBackgroundSprite(_arg_2);
            this._pointer.bitmapData = this._style.pointer;
            this._useDesktopMargins = _arg_3;
            var _local_21= Std.int(PooledChatBubble.MAX_HEIGHT * this._component.chatFontSizeScale);
            var _local_5= ASCompat.toInt((this._component.roomChatSettings != null) ? ChatBubbleWidth.fromValue(this._component.roomChatSettings.bubbleWidth) : ASCompat.toInt(_Str_7976));
            var _local_6= Std.int((_local_5 - this._style.textFieldMargins.x) - this._style.textFieldMargins.width);
            this._textField.width = _local_6;
            this._textField.multiline = true;
            this._textField.wordWrap = true;
            this._textField.selectable = false;
            this._textField.thickness = -15;
            this._textField.sharpness = 80;
            this._textField.antiAliasType = AntiAliasType.ADVANCED;
            this._textField.embedFonts = true;
            this._textField.gridFitType = GridFitType.PIXEL;
            this._textField.cacheAsBitmap = (!this._style.allowHTML);
            this._textField.styleSheet = null;
            this._textField.defaultTextFormat = this.createScaledTextFormat(this._style.textFormat, this._component.chatFontSizeScale);
            this._textField.styleSheet = this._style.styleSheet;
            this._textField.addEventListener(TextEvent.LINK, (this._Str_10834 : ASAny));
            var _local_7:ASAny = (this._chatItem.chatType == RoomSessionChatEvent.CHAT_TYPE_SPEAK);
            var _local_8:ASAny = (this._chatItem.chatType == RoomSessionChatEvent.CHAT_TYPE_SHOUT);
            var _local_9= (((!_local_7) && (!_local_8)) && (!this._style._Str_4931));
            if (_local_9)
            {
                this._textField.alpha = 0.6;
            }
            else
            {
                this._textField.alpha = 1;
            }
            var _local_10= ((_local_9 ? "<i>" : "") + (this._style._Str_4931 ? "" : (("<b>" + k) + ": </b>")));
            _local_10 = (((_local_10 + (_local_8 ? "<b>" : "")) + this._chatItem.text) + (_local_8 ? "</b>" : ""));
            _local_10 = (_local_10 + (_local_9 ? "</i>" : ""));
            if (((this._chatItem.links == null) || (this._chatItem.links[0] == null)))
            {
                this._textField.htmlText = _local_10;
            }
            else
            {
                _local_14 = -1;
                _local_15 = new Array<ASAny>();
                _local_13 = 0;
                while (_local_13 < this._chatItem.links.length)
                {
                    _local_16 = this._chatItem.links[_local_13][0][1];
                    _local_17 = (((('<a href="' + _local_16) + '">') + _local_16) + "</a>");
                    _local_18 = (("{" + Std.string(_local_13)) + "}");
                    _local_19 = this._chatItem.text.indexOf(_local_18);
                    _local_14 = (_local_19 + _local_17.length);
                    _local_15.push(([_local_19, _local_14] : Array<Dynamic>));
                    _local_10 = ASCompat.stringReplace(_local_10, _local_18, _local_17);
                    _local_13++;
                }
                this._textField.htmlText = _local_10;
            }
            this._minHeight = _arg_4;
            var _local_11= Std.int(Math.min(_local_5, ((this._textField.textWidth + this._style.textFieldMargins.x) + this._style.textFieldMargins.width)));
            var _local_12= Std.int((this._textField.textHeight + this._style.textFieldMargins.y) + this._style.textFieldMargins.height);
            var _local_22= this._textField.numLines > 1;
            if (!this._style.isSystemStyle)
            {
                _local_12 = Std.int(Math.min(_local_21, _local_12));
            }
            if (_arg_4 != -1)
            {
                _local_12 = Std.int(Math.max(_arg_4, _local_12));
            }
            _local_11 = Std.int(Math.max(_local_11, this._background.width));
            _local_12 = Std.int(Math.max(_local_12, this._background.height));
            this._background.width = _local_11;
            this._background.height = _local_12;
            this._background.x = 0;
            this._background.y = 0;
            this._background.cacheAsBitmap = true;
            addChild(this._background);
            var _local_23= this._style.getEmblem(_local_22);
            var _local_24= this._style.getEmblemOffset(_local_22);
            if (((_local_23 != null) && (_local_24 != null)))
            {
                this._emblem.bitmapData = _local_23;
                this._emblem.x = _local_24.x;
                this._emblem.y = _local_24.y;
                addChild(this._emblem);
            }
            else
            {
                this._emblem.bitmapData = null;
            }
            if (!this._style._Str_4931)
            {
                this._pointer.x = Math.max(this._style.getPointerLeftMargin(PooledChatBubble._Str_10539), Math.min((_local_11 - this._style.getPointerRightMargin(PooledChatBubble._Str_11116)), this._Str_10783));
                this._pointer.y = (_local_12 - this._style.pointerOffsetToBubbleBottom);
                addChild(this._pointer);
            }
            if (((!(this._faceBitmapData == null)) && (!(this._style.faceOffset == null))))
            {
                if (this._faceBitmapData.height > _local_12)
                {
                    _local_20 = new BitmapData(this._faceBitmapData.width, _local_12);
                    _local_20.copyPixels(this._faceBitmapData, new Rectangle(0, (this._faceBitmapData.height - _local_12), this._faceBitmapData.width, _local_12), new Point(0, 0));
                }
                else
                {
                    _local_20 = this._faceBitmapData;
                }
                this._face.bitmapData = _local_20;
                this._face.x = (this._style.faceOffset.x - (_local_20.width / 2));
                this._face.y = Math.max(1, (this._style.faceOffset.y - (_local_20.height / 2)));
                addChild(this._face);
            }
            this._textField.width = Math.min(_local_6, (this._textField.textWidth + this._style.textFieldMargins.width));
            this._textField.height = (this._textField.textHeight + this._style.textFieldMargins.height);
            this._textField.x = this._style.textFieldMargins.x;
            this._textField.y = this._style.textFieldMargins.y;
            addChild(this._textField);
            if (((!this._style.isSystemStyle) && (this._textField.textHeight > _local_21)))
            {
                this._clipMask.graphics.clear();
                this._clipMask.graphics.beginFill(0xFFFFFF);
                this._clipMask.graphics.drawRect(0, 0, (this._textField.textWidth + 5), (_local_21 - this._style.textFieldMargins.height));
                this._clipMask.graphics.endFill();
                this._textField.mask = this._clipMask;
                addChild(this._clipMask);
                this._clipMask.x = this._textField.x;
                this._clipMask.y = this._textField.y;
            }
            else
            {
                this._clipMask.graphics.clear();
                this._textField.mask = null;
            }
            if ((this._style.isNotification && (!(this._face == null))) && (!(this._face.bitmapData == null)))
            {
                this._face.y = Math.max(1, (height / 2) - (this._face.bitmapData.height / 2));
                this._face.x = (this._face.x - 0.5);
                if (!this._style.isAnonymous)
                {
                    this._face.y = (this._face.y - ((this._pointer.height / 2) - 1));
                }
            }
            this.cacheAsBitmap = (!this._style.allowHTML);
            this._readyToRecycle = false;
            this._timeMs = 0;
            this._timePointerPositionUpdateMs = 0;
            visible = false;
        }

        public function _Str_23848()
        {
            this.cacheAsBitmap = false;
            this.removeEventListener(MouseEvent.CLICK, (this.onMouseClick : ASAny));
            if ((this._clipMask.parent : ASAny) == (this : ASAny))
            {
                this._Str_26452(this._clipMask);
            }
            this._Str_26452(this._textField);
            if (((!(this._style.faceOffset == null)) && ((this._face.parent : ASAny) == (this : ASAny))))
            {
                this._Str_26452(this._face);
                this._face.bitmapData = null;
            }
            if ((this._emblem.parent : ASAny) == (this : ASAny))
            {
                this._Str_26452(this._emblem);
                this._emblem.bitmapData = null;
            }
            if (((this._pointer != null) && (this._pointer.parent != null)))
            {
                this._Str_26452(this._pointer);
            }
            this._Str_26452(this._background);
            if (this._textField != null)
            {
                this._textField.removeEventListener(TextEvent.LINK, (this._Str_10834 : ASAny));
            }
        }

        function _Str_10834(k:TextEvent)
        {
            var _local_2:String = null;
            var _local_3:String = null;
            var _local_4:TextField = null;
            var _local_5:Point = null;
            var _local_6:Rectangle = null;
            var _local_7:String = null;
            if ((ASCompat.stringAsBool(k.text) && (k.text.length > 0)))
            {
                _local_2 = k.text;
                _local_3 = "highlight/";
                if (_local_2.indexOf(_local_3) > -1)
                {
                    _local_4 = ASCompat.dynamicAs(k.target , TextField);
                    _local_5 = new Point(_local_4.mouseX, _local_4.mouseY);
                    _local_5 = _local_4.localToGlobal(_local_5);
                    _local_6 = new Rectangle(_local_5.x, _local_5.y);
                    _local_7 = _local_2.substr((_local_2.indexOf(_local_3) + _local_3.length), _local_2.length);
                    this._component.windowManager.hideHint();
                    this._component.windowManager.showHint(_local_7.toUpperCase(), _local_6);
                }
                else
                {
                    this._component.context.createLinkEvent(k.text);
                }
            }
        }

        function _Str_26452(child:DisplayObject)
        {
            try
            {
                removeChild(child);
            }
            catch(error:ArgumentError)
            {
            }
        }

        public var _Str_22234(get,never):Float;
public function  get__Str_22234():Float
        {
            return this._style.isSystemStyle ? height : Math.min(Std.int(PooledChatBubble.MAX_HEIGHT * this._component.chatFontSizeScale), height);
        }

        function onAddedToStage(k:Event)
        {
            this.addEventListener(MouseEvent.CLICK, (this.onMouseClick : ASAny));
        }

        function onRemovedFromStage(k:Event)
        {
            this.removeEventListener(MouseEvent.CLICK, (this.onMouseClick : ASAny));
        }

        public function moveTo(k:Int, _arg_2:Int)
        {
            if (((!(this._moveTargetX == k)) || (!(this._moveTargetY == _arg_2))))
            {
                this._moveBeginMs = this._timeMs;
                this._moveOriginX = this._Str_3980;
                this._moveOriginY = Std.int(y);
                this._moveTargetX = k;
                this._moveTargetY = _arg_2;
                this._moveDeltaXPerMs = ((k - this._Str_3980) / PooledChatBubble._Str_6907);
                this._moveDeltaYPerMs = ((_arg_2 - y) / PooledChatBubble._Str_6907);
            }
        }

        public function _Str_12023(k:Int, _arg_2:Int)
        {
            this._moveTargetX = k;
            this._moveTargetY = _arg_2;
            this._Str_3980 = k;
            y = _arg_2;
        }

        public function update(k:UInt)
        {
            var _local_2:UInt = 0;
            this._timeMs = (this._timeMs + k);
            if (((!(this._Str_3980 == this._moveTargetX)) || (!(y == this._moveTargetY))))
            {
                _local_2 = (this._timeMs - this._moveBeginMs);
                if (((_local_2 < PooledChatBubble._Str_6907) && (_local_2 > 0)))
                {
                    this._Str_3980 = Std.int((this._moveOriginX + (_local_2 * this._moveDeltaXPerMs)));
                    y = Std.int((this._moveOriginY + (_local_2 * this._moveDeltaYPerMs)));
                }
                else
                {
                    this._Str_3980 = this._moveTargetX;
                    y = this._moveTargetY;
                }
            }
            if (this._timeMs > (this._timePointerPositionUpdateMs + PooledChatBubble._Str_25378))
            {
                this._Str_12210();
                this._timePointerPositionUpdateMs = this._timeMs;
            }
            if (((this._timeMs > PooledChatBubble._Str_6907) && (!visible)))
            {
                visible = true;
            }
        }

        
        public var _Str_3980(get,set):Int;
public function  get__Str_3980():Int
        {
            return this._proxyX;
        }
public function  set__Str_3980(k:Int):Int        {
            var _local_2 = 0;
            var _local_3 = 0;
            this._proxyX = k;
            if ((this._useDesktopMargins && (stage != null)))
            {
                _local_2 = (this._proxyX + this._roomPanOffsetX);
                this._hasHitDesktopMargin = false;
                _local_3 = Std.int((this._component.chatViewWidth - PooledChatBubble._Str_16997) - width);
                if (_local_2 > _local_3)
                {
                    _local_2 = _local_3;
                    this._hasHitDesktopMargin = true;
                }
                if (_local_2 < PooledChatBubble._Str_10527)
                {
                    _local_2 = PooledChatBubble._Str_10527;
                    this._hasHitDesktopMargin = true;
                }
                x = _local_2;
            }
            else
            {
                x = (this._proxyX + this._roomPanOffsetX);
            }
return k;
        }

        public function _Str_12210()
        {
            if (((this._pointer != null) && (this._pointer.parent != null)))
            {
                this._pointer.x = Math.max(this._style.getPointerLeftMargin(PooledChatBubble._Str_10539), Math.min((this._background.width - this._style.getPointerRightMargin(PooledChatBubble._Str_11116)), this._Str_10783));
                this._pointer.y = (this._background.height - this._style.pointerOffsetToBubbleBottom);
            }
        }

        function createScaledTextFormat(k:TextFormat, _arg_2:Float):TextFormat
        {
            var _local_3= new TextFormat();
            _local_3.align = k.align;
            _local_3.blockIndent = k.blockIndent;
            _local_3.bold = k.bold;
            _local_3.bullet = k.bullet;
            _local_3.color = k.color;
ASCompat.setTextFormatDisplay(            _local_3, ASCompat.textFormatDisplay(k));
            _local_3.font = k.font;
            _local_3.indent = k.indent;
            _local_3.italic = k.italic;
            _local_3.kerning = k.kerning;
            _local_3.leading = k.leading;
            _local_3.leftMargin = k.leftMargin;
            _local_3.letterSpacing = k.letterSpacing;
            _local_3.rightMargin = k.rightMargin;
            _local_3.size = Std.int(ASCompat.toNumber(k.size) * _arg_2);
            _local_3.tabStops = k.tabStops;
            _local_3.target = k.target;
            _local_3.underline = k.underline;
            _local_3.url = k.url;
            return _local_3;
        }

        
        public var _Str_4702(get,set):Bool;
public function  get__Str_4702():Bool
        {
            return this._readyToRecycle;
        }
public function  set__Str_4702(k:Bool):Bool        {
            this._readyToRecycle = k;
            if (k)
            {
                this.removeEventListener(MouseEvent.CLICK, (this.onMouseClick : ASAny));
            }
return k;
        }

        public var timeStamp(get,never):UInt;
public function  get_timeStamp():UInt
        {
            return this._chatItem.timeStamp;
        }

        public var component(never,set):HabboFreeFlowChat;
public function  set_component(k:HabboFreeFlowChat):HabboFreeFlowChat        {
            return this._component = k;
        }

        var _Str_10783(get,never):Int;
function  get__Str_10783():Int
        {
            return Std.int(this._Str_11643.x - this.x);
        }

        public var _Str_11643(get,never):Point;
public function  get__Str_11643():Point
        {
            if (this._chatItem._Str_12917)
            {
                return new Point(((this._component.chatViewWidth / 2) + ASCompat.toNumber(this._chatItem._Str_12917)), 500);
            }
            return this._component.getScreenPointFromRoomLocation(this._chatItem.roomId, this._chatItem._Str_20712);
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._chatItem.roomId;
        }

        public var _Str_18364(never,set):Int;
public function  set__Str_18364(k:Int):Int        {
            if (this._roomPanOffsetX != k)
            {
                this._roomPanOffsetX = k;
                this._Str_12023(this._moveTargetX, this._moveTargetY);
            }
return k;
        }

        function onMouseClick(k:MouseEvent)
        {
            if (((this._style != null) && this._style._Str_4931))
            {
                return;
            }
            if (!this._component.clickHasToPropagate(k))
            {
                this._component.selectAvatarWithChatItem(this._chatItem);
                k.stopImmediatePropagation();
            }
        }

        public var overlap(get,never):Rectangle;
public function  get_overlap():Rectangle
        {
            return this._style.overlap;
        }

        public var _Str_19538(get,never):Bool;
public function  get__Str_19538():Bool
        {
            return this._hasHitDesktopMargin;
        }

        public var minHeight(get,never):Int;
public function  get_minHeight():Int
        {
            return this._minHeight;
        }
    }

