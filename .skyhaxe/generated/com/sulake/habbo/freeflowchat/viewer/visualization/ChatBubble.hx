package com.sulake.habbo.freeflowchat.viewer.visualization
;
    import flash.display.Sprite;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.habbo.freeflowchat.data.ChatItem;
    import flash.display.Bitmap;
    import flash.text.TextField;
    import com.sulake.habbo.freeflowchat.viewer.visualization.style.IChatStyleInternal;
    import flash.display.BitmapData;
    import com.sulake.habbo.freeflowchat.viewer._enum.ChatBubbleWidth;
    import flash.text.AntiAliasType;
    import flash.text.GridFitType;
    import flash.events.TextEvent;
    import com.sulake.habbo.session.events.RoomSessionChatEvent;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextFormat;

     class ChatBubble extends Sprite 
    {
        public static inline final _Str_7976:UInt = 300;
        public static inline final _Str_16761= 15;

        static inline final _Str_10527= 85;
        static inline final _Str_16997= 190;
        static inline final _Str_6907:UInt = 150;
        static inline final MAX_HEIGHT:UInt = 108;
        static inline final _Str_10539= 28;
        static inline final _Str_11116= 15;

        var _component:HabboFreeFlowChat;
        var _chatItem:ChatItem;
        var _background:Sprite;
        var _pointer:Bitmap;
        var _emblem:Bitmap;
        var _face:Bitmap;
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

        public function new(k:ChatItem, _arg_2:IChatStyleInternal, _arg_3:BitmapData, _arg_4:String, _arg_5:UInt, _arg_6:HabboFreeFlowChat, _arg_7:Int=-1, _arg_8:Bool=false, _arg_9:Int=-1)
        {
            var _local_18 = 0;
            var _local_19 = 0;
            var _local_20:Array<ASAny> = null;
            var _local_21:String = null;
            var _local_22:String = null;
            var _local_23:String = null;
            var _local_24 = 0;
            var _local_25:BitmapData = null;
            super();
            this._component = _arg_6;
            this._chatItem = k;
            this._style = _arg_2;
            this._background = _arg_2.getNewBackgroundSprite(_arg_5);
            this._pointer = (_arg_2._Str_4931 ? null : new Bitmap(_arg_2.pointer));
            this._useDesktopMargins = _arg_8;
            var _local_26= Std.int(ChatBubble.MAX_HEIGHT * _arg_6.chatFontSizeScale);
            var _local_10= ASCompat.toInt(_Str_7976);
            if (_arg_7 != -1)
            {
                _local_10 = ChatBubbleWidth.fromValue(_arg_7);
            }
            else
            {
                if (_arg_6.roomChatSettings != null)
                {
                    _local_10 = ChatBubbleWidth.fromValue(_arg_6.roomChatSettings.bubbleWidth);
                }
            }
            _local_10 = (_local_10 - _Str_16761);
            this.cacheAsBitmap = true;
            var _local_11= Std.int((_local_10 - _arg_2.textFieldMargins.x) - _arg_2.textFieldMargins.width);
            this._textField = new TextField();
            this._textField.width = _local_11;
            this._textField.multiline = true;
            this._textField.wordWrap = true;
            this._textField.selectable = false;
            this._textField.thickness = -15;
            this._textField.sharpness = 80;
            this._textField.antiAliasType = AntiAliasType.ADVANCED;
            this._textField.embedFonts = true;
            this._textField.gridFitType = GridFitType.PIXEL;
            this._textField.cacheAsBitmap = true;
            this._textField.defaultTextFormat = this.createScaledTextFormat(_arg_2.textFormat, _arg_6.chatFontSizeScale);
            this._textField.styleSheet = this._style.styleSheet;
            this._textField.addEventListener(TextEvent.LINK, (this._Str_10834 : ASAny));
			// this._textField.background = true;
            var _local_12:ASAny = (k.chatType == RoomSessionChatEvent.CHAT_TYPE_SPEAK);
            var _local_13:ASAny = (k.chatType == RoomSessionChatEvent.CHAT_TYPE_SHOUT);
            var _local_14= (((!_local_12) && (!_local_13)) && (!this._style._Str_4931));
            if (_local_14)
            {
                this._textField.alpha = 0.6;
            }
            var _local_15= ((_local_14 ? "<i>" : "") + (this._style._Str_4931 ? "" : (("<b>" + _arg_4) + ": </b>")));
            _local_15 = (((_local_15 + (_local_13 ? "<b>" : "")) + k.text) + (_local_13 ? "</b>" : ""));
            _local_15 = (_local_15 + (_local_14 ? "</i>" : ""));
            if (((k.links == null) || (k.links[0] == null)))
            {
                this._textField.htmlText = _local_15;
            }
            else
            {
                _local_19 = -1;
                _local_20 = new Array<ASAny>();
                _local_18 = 0;
                while (_local_18 < k.links.length)
                {
                    _local_21 = k.links[_local_18][0][1];
                    _local_22 = (((('<a href="' + _local_21) + '">') + _local_21) + "</a>");
                    _local_23 = (("{" + Std.string(_local_18)) + "}");
                    _local_24 = k.text.indexOf(_local_23);
                    _local_19 = (_local_24 + _local_22.length);
                    _local_20.push(([_local_24, _local_19] : Array<Dynamic>));
                    _local_15 = ASCompat.stringReplace(_local_15, _local_23, _local_22);
                    _local_18++;
                }
                this._textField.htmlText = _local_15;
            }
            var _local_16= Std.int(Math.min(_local_10, ((this._textField.textWidth + _arg_2.textFieldMargins.x) + _arg_2.textFieldMargins.width)));
            var _local_17= Std.int((this._textField.textHeight + _arg_2.textFieldMargins.y) + _arg_2.textFieldMargins.height);
            var _local_27= this._textField.numLines > 1;
            if (!this._style.isSystemStyle)
            {
                _local_17 = Std.int(Math.min(_local_26, _local_17));
            }
            if (_arg_9 != -1)
            {
                _local_17 = Std.int(Math.max(_arg_9, _local_17));
            }
            _local_16 = Std.int(Math.max(_local_16, this._background.width));
            _local_17 = Std.int(Math.max(_local_17, this._background.height));
            this._background.width = _local_16;
            this._background.height = _local_17;
            this._background.x = 0;
            this._background.y = 0;
            this._background.cacheAsBitmap = true;
            addChild(this._background);
            var _local_28= _arg_2.getEmblem(_local_27);
            var _local_29= _arg_2.getEmblemOffset(_local_27);
            if (((_local_28 != null) && (_local_29 != null)))
            {
                this._emblem = new Bitmap(_local_28);
                this._emblem.x = _local_29.x;
                this._emblem.y = _local_29.y;
                addChild(this._emblem);
            }
            if (!this._style._Str_4931)
            {
                this._pointer.x = Math.max(_arg_2.getPointerLeftMargin(ChatBubble._Str_10539), Math.min((_local_16 - _arg_2.getPointerRightMargin(ChatBubble._Str_11116)), this._Str_10783));
                this._pointer.y = (_local_17 - _arg_2.pointerOffsetToBubbleBottom);
                addChild(this._pointer);
            }
            if (((!(_arg_3 == null)) && (!(_arg_2.faceOffset == null))))
            {
                if (_arg_3.height > _local_17)
                {
                    _local_25 = new BitmapData(_arg_3.width, _local_17);
                    _local_25.copyPixels(_arg_3, new Rectangle(0, (_arg_3.height - _local_17), _arg_3.width, _local_17), new Point(0, 0));
                }
                else
                {
                    _local_25 = _arg_3;
                }
                this._face = new Bitmap(_local_25);
                this._face.x = (_arg_2.faceOffset.x - (_local_25.width / 2));
                this._face.y = Math.max(1, (_arg_2.faceOffset.y - (_local_25.height / 2)));
                addChild(this._face);
            }
            this._textField.width = Math.min(_local_11, (this._textField.textWidth + this._style.textFieldMargins.width));
            this._textField.height = (this._textField.textHeight + this._style.textFieldMargins.height);
            this._textField.x = _arg_2.textFieldMargins.x;
            this._textField.y = _arg_2.textFieldMargins.y;
            addChild(this._textField);
            if (((!this._style.isSystemStyle) && (this._textField.textHeight > _local_26)))
            {
                this._clipMask = new Sprite();
                this._clipMask.graphics.clear();
                this._clipMask.graphics.beginFill(0xFFFFFF);//(this._textField.textColor);
                this._clipMask.graphics.drawRect(0, 0, (this._textField.textWidth + 5), (_local_26 - _arg_2.textFieldMargins.height));
                this._textField.mask = this._clipMask;
                addChild(this._clipMask);
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
            this.addEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
        }

        public function dispose()
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, (this.onAddedToStage : ASAny));
            this.removeEventListener(MouseEvent.CLICK, (this.onMouseClick : ASAny));
            if (this._clipMask != null)
            {
                removeChild(this._clipMask);
            }
            if (this._textField != null)
            {
                this._textField.removeEventListener(TextEvent.LINK, (this._Str_10834 : ASAny));
            }
            removeChild(this._textField);
            if (((!(this._face == null)) && (!(this._style.faceOffset == null))))
            {
                removeChild(this._face);
            }
            if (((this._emblem != null) && (this._emblem.parent != null)))
            {
                removeChild(this._emblem);
            }
            if (((this._pointer != null) && (this._pointer.parent != null)))
            {
                removeChild(this._pointer);
            }
            removeChild(this._background);
            this._clipMask = null;
            this._textField = null;
            this._emblem = null;
            this._face = null;
            this._pointer = null;
            this._background = null;
            this._style = null;
        }

        function _Str_10834(k:TextEvent)
        {
            if ((ASCompat.stringAsBool(k.text) && (k.text.length > 0)))
            {
                this._component.context.createLinkEvent(k.text);
            }
        }

        public var _Str_22234(get,never):Float;
public function  get__Str_22234():Float
        {
            return this._style.isSystemStyle ? height : Math.min(Std.int(ChatBubble.MAX_HEIGHT * this._component.chatFontSizeScale), height);
        }

        function onAddedToStage(k:Event)
        {
            this.addEventListener(MouseEvent.CLICK, (this.onMouseClick : ASAny));
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
                this._moveDeltaXPerMs = ((k - this._Str_3980) / ChatBubble._Str_6907);
                this._moveDeltaYPerMs = ((_arg_2 - y) / ChatBubble._Str_6907);
            }
        }

        public function _Str_12023(k:Int, _arg_2:Int)
        {
            this._moveTargetX = k;
            this._moveTargetY = _arg_2;
            this._Str_3980 = k;
            y = _arg_2;
            this._Str_12210();
        }

        public function update(k:UInt)
        {
            var _local_2:UInt = 0;
            this._timeMs = (this._timeMs + k);
            if (((!(this._Str_3980 == this._moveTargetX)) || (!(y == this._moveTargetY))))
            {
                _local_2 = (this._timeMs - this._moveBeginMs);
                if (_local_2 < ChatBubble._Str_6907)
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
            this._Str_12210();
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
                _local_3 = Std.int((this._component.chatViewWidth - ChatBubble._Str_16997) - width);
                if (_local_2 > _local_3)
                {
                    _local_2 = _local_3;
                    this._hasHitDesktopMargin = true;
                }
                if (_local_2 < ChatBubble._Str_10527)
                {
                    _local_2 = ChatBubble._Str_10527;
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
                this._pointer.x = Math.max(this._style.getPointerLeftMargin(ChatBubble._Str_10539), Math.min((this._background.width - this._style.getPointerRightMargin(ChatBubble._Str_11116)), this._Str_10783));
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

        public function _Str_23014(k:BitmapData)
        {
            k.draw(this);
        }
		
		public var textField(get,never):TextField;
public function  get_textField():TextField
		{
			return this._textField;
		}
    }

