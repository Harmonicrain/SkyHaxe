package com.sulake.habbo.ui.widget.roomchat
;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.display.BitmapData;
    import com.sulake.habbo.ui.widget.events.RoomWidgetChatUpdateEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Rectangle;
    import com.sulake.habbo.ui.widget.enums.SystemChatStyleEnum;
    import flash.text.TextFormat;
    import com.sulake.core.window.components.ILabelWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import com.sulake.habbo.avatar.pets.PetTypeEnum;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.utils.HabboWebTools;

     class RoomChatItem 
    {
        public static inline final _Str_15992:Float = 18;
        static inline final _Str_9962= 6;
        static inline final _Str_15961= 6;
        static inline final _Str_5706= 35;
        static inline final _Str_13391= 26;
        static inline final NAME= "name";
        static inline final MESSAGE= "message";
        static inline final POINTER= "pointer";
        static inline final BACKGROUND= "background";
        static inline final _Str_17786= "${chat.history.drag.tooltip}";

        var _widget:RoomChatWidget;
        var _windowManager:IHabboWindowManager;
        var _localizations:IHabboLocalizationManager;
        var _window:IRegionWindow;
        var _assetLibrary:IAssetLibrary;
        var _id:String;
        var _siteUrl:String;
        var _aboveLevels:Int = 0;
        var _screenLevel:Int = -1;
        var _chatType:Int = 0;
        var _chatStyle:Int = 0;
        var _senderId:Int = 0;
        var _senderName:String;
        var _message:String;
        var _messageLinks:Array<ASAny>;
        var _messageLinkPositions:Array<ASAny>;
        var _timeStamp:Int = 0;
        var _senderX:Float = Math.NaN;
        var _senderImage:BitmapData;
        var _senderColor:UInt = 0;
        var _roomId:Int = 0;
        var _userType:Int = 0;
        var _petType:Int = 0;
        var _senderCategory:Int = 0;
        var _width:Float = 0;
        var _rendered:Bool = false;
        var _topOffset:Float = 0;
        var _originalBackgroundYOffset:Float = 0;
        var _x:Float = 0;
        var _y:Float = 0;
        var _dragTooltipEnabled:Bool = false;

        public function new(k:RoomChatWidget, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:String, _arg_5:IHabboLocalizationManager, _arg_6:String)
        {
            this._senderName = "";
            this._message = "";
            this._widget = k;
            this._windowManager = _arg_2;
            this._assetLibrary = _arg_3;
            this._id = _arg_4;
            this._localizations = _arg_5;
            this._siteUrl = _arg_6;
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
                this._widget = null;
                this._windowManager = null;
                this._localizations = null;
                this._senderImage = null;
            }
        }

        public function _Str_13182(k:RoomWidgetChatUpdateEvent)
        {
            this._chatType = k.chatType;
            this._chatStyle = k.styleId;
            this._senderId = k.userId;
            this._senderName = k.userName;
            this._senderCategory = k._Str_23083;
            this._message = k.text;
            this._messageLinks = k.links;
            this._senderX = k._Str_24184;
            this._senderImage = k._Str_23069;
            this._senderColor = k._Str_24330;
            this._roomId = k.roomId;
            this._userType = k.userType;
            this._petType = k._Str_4355;
            this._Str_13126();
        }

        
        public var message(get,set):String;
public function  set_message(k:String):String        {
            return this._message = k;
        }

        public var senderName(never,set):String;
public function  set_senderName(k:String):String        {
            return this._senderName = k;
        }

        public var _Str_25766(never,set):BitmapData;
public function  set__Str_25766(k:BitmapData):BitmapData        {
            return this._senderImage = k;
        }

        public var _Str_23108(never,set):UInt;
public function  set__Str_23108(k:UInt):UInt        {
            return this._senderColor = k;
        }

        public var chatType(never,set):Int;
public function  set_chatType(k:Int):Int        {
            return this._chatType = k;
        }

        public var view(get,never):IWindowContainer;
public function  get_view():IWindowContainer
        {
            return this._window;
        }

        
        public var screenLevel(get,set):Int;
public function  get_screenLevel():Int
        {
            return this._screenLevel;
        }

        
        public var timeStamp(get,set):Int;
public function  get_timeStamp():Int
        {
            return this._timeStamp;
        }

        
        public var _Str_7368(get,set):Float;
public function  get__Str_7368():Float
        {
            return this._senderX;
        }
public function  set__Str_7368(k:Float):Float        {
            return this._senderX = k;
        }

        public var width(get,never):Float;
public function  get_width():Float
        {
            return this._width;
        }

        public var height(get,never):Float;
public function  get_height():Float
        {
            return _Str_15992;
        }
public function  get_message():String
        {
            return this._message;
        }

        
        public var x(get,set):Float;
public function  get_x():Float
        {
            return this._x;
        }

        
        public var y(get,set):Float;
public function  get_y():Float
        {
            return this._y;
        }

        
        public var aboveLevels(get,set):Int;
public function  get_aboveLevels():Int
        {
            return this._aboveLevels;
        }
public function  set_aboveLevels(k:Int):Int        {
            return this._aboveLevels = k;
        }
public function  set_screenLevel(k:Int):Int        {
            return this._screenLevel = k;
        }
public function  set_timeStamp(k:Int):Int        {
            return this._timeStamp = k;
        }
public function  set_x(k:Float):Float        {
            this._x = k;
            if (this._window != null)
            {
                this._window.x = Std.int(k);
            }
return k;
        }
public function  set_y(k:Float):Float        {
            this._y = k;
            if (this._window != null)
            {
                this._window.y = Std.int((k - this._topOffset) + this._originalBackgroundYOffset);
            }
return k;
        }

        public function _Str_22279()
        {
            var k:IWindow = null;
            if (this._window != null)
            {
                k = this._window.findChildByName("pointer");
                if (k != null)
                {
                    k.visible = false;
                }
            }
        }

        public function _Str_23410(k:Float)
        {
            if (((!(this._window != null)) || this._window.disposed))
            {
                return;
            }
            var _local_2= Std.downcast(this._window.findChildByName("pointer") , IBitmapWrapperWindow);
            var _local_3= Std.downcast(this._window.findChildByName("middle") , IBitmapWrapperWindow);
            if (((_local_3 == null) || (_local_2 == null)))
            {
                return;
            }
            _local_2.visible = true;
            k = (k + (this._window.width / 2));
            k = Math.min(k, (_local_3.rectangle.right - _local_2.width));
            k = Math.max(k, _local_3.rectangle.left);
            _local_2.x = Std.int(k);
        }

        public function _Str_23373(k:Float, _arg_2:Float, _arg_3:Float, _arg_4:Float, _arg_5:Float):Bool
        {
            var _local_6= new Rectangle(this._x, this._y, this.width, k);
            var _local_7= new Rectangle(_arg_2, _arg_3, _arg_4, _arg_5);
            return _local_6.intersects(_local_7);
        }

        public function hideView()
        {
            if (this._window != null)
            {
                this._window.dispose();
            }
            this._window = null;
            this._rendered = false;
        }

        var _Str_21943(get,never):Bool;
function  get__Str_21943():Bool
        {
            return this._chatStyle == SystemChatStyleEnum.GENERIC;
        }

        public function _Str_13126()
        {
            var messageWidth = 0;
            var userIconWindow:IBitmapWrapperWindow = null;
            var x1 = 0;
            var y1 = 0;
            var i = 0;
            var lastLinkEndPos = 0;
            var linkFormat:TextFormat = null;
            var filteredLink:String = null;
            var placeHolder:String = null;
            var placeholderPos = 0;
            var linkPos:Array<ASAny> = null;
            if (this._rendered)
            {
                return;
            }
            this._rendered = true;
            if (this._window != null)
            {
                return;
            }
            this._window = RoomChatWidget.chatBubbleFactory._Str_25575(this._chatStyle, this._chatType);
            if (this._window == null)
            {
                return;
            }
            this._window._Str_4074 = true;
            var background= Std.downcast(this._window.findChildByName(BACKGROUND) , IBitmapWrapperWindow);
            var nameWindow= Std.downcast(this._window.findChildByName(NAME) , ILabelWindow);
            var textWindow= Std.downcast(this._window.findChildByName(MESSAGE) , ITextWindow);
            var pointerWindow= Std.downcast(this._window.findChildByName(POINTER) , IBitmapWrapperWindow);
            var totalHeight:Float = this._window.height;
            var pointerBitmapData= RoomChatWidget.chatBubbleFactory._Str_23013(this._chatStyle);
            this._originalBackgroundYOffset = background.y;
            var textWindowOffsetX= ((textWindow.x <= _Str_13391) ? 0 : (textWindow.x - _Str_13391));
            if (this._senderImage != null)
            {
                this._topOffset = Math.max(0, ((this._senderImage.height - background.height) / 2));
                totalHeight = Math.max(totalHeight, this._senderImage.height);
                totalHeight = Math.max(totalHeight, background.height);
            }
            this._width = 0;
            this._window.x = Std.int(this._x);
            this._window.y = Std.int(this._y);
            this._window.width = 0;
            this._window.height = Std.int(totalHeight);
            this._Str_16939();
            this._Str_23110(this._window);
            if (((this._senderImage != null) && (!this._Str_21943)))
            {
                userIconWindow = Std.downcast(this._window.findChildByName("user_image") , IBitmapWrapperWindow);
                if (userIconWindow != null)
                {
                    userIconWindow.width = this._senderImage.width;
                    userIconWindow.height = this._senderImage.height;
                    userIconWindow.bitmap = this._senderImage;
                    userIconWindow.disposesBitmap = false;
                    x1 = Std.int(userIconWindow.x - (this._senderImage.width / 2));
                    y1 = Std.int(Math.max(0, ((background.height - this._senderImage.height) / 2)));
                    if (this._userType == RoomObjectTypeEnum.PET)
                    {
                        if (this._petType == PetTypeEnum.HORSE)
                        {
                            if (this._senderImage.height > background.height)
                            {
                                y1 = Std.int((this._senderImage.height - background.height) / 2);
                            }
                        }
                    }
                    userIconWindow.x = x1;
                    userIconWindow.y = (userIconWindow.y + y1);
                    this._width = (this._width + (userIconWindow.x + this._senderImage.width));
                }
            }
            if (nameWindow != null)
            {
                if (!this._Str_21943)
                {
                    nameWindow.text = (this._senderName + ": ");
                    nameWindow.y = Std.int(nameWindow.y + this._topOffset);
                    nameWindow.width = Std.int(nameWindow.textWidth + _Str_9962);
                }
                else
                {
                    nameWindow.text = "";
                    nameWindow.width = 0;
                }
                this._width = (this._width + nameWindow.width);
            }
            if (this._chatType == RoomWidgetChatUpdateEvent.CHAT_TYPE_RESPECT)
            {
                textWindow.text = this._localizations.registerParameter("widgets.chatbubble.respect", "username", this._senderName);
                this._width = _Str_5706;
            }
            else
            {
                if (this._chatType == RoomWidgetChatUpdateEvent.CHAT_TYPE_PETRESPECT)
                {
                    textWindow.text = this._localizations.registerParameter("widget.chatbubble.petrespect", "petname", this._senderName);
                    this._width = _Str_5706;
                }
                else
                {
                    if (this._chatType == RoomWidgetChatUpdateEvent.CHAT_TYPE_PETTREAT)
                    {
                        textWindow.text = this._localizations.registerParameter("widget.chatbubble.pettreat", "petname", this._senderName);
                        this._width = _Str_5706;
                    }
                    else
                    {
                        if (this._chatType == RoomWidgetChatUpdateEvent.CHAT_TYPE_PETREVIVE)
                        {
                            textWindow.text = this.message;
                            this._width = _Str_5706;
                        }
                        else
                        {
                            if (this._chatType == RoomWidgetChatUpdateEvent.CHAT_TYPE_PET_REBREED_FERTILIZE)
                            {
                                textWindow.text = this.message;
                                this._width = _Str_5706;
                            }
                            else
                            {
                                if (this._chatType == RoomWidgetChatUpdateEvent.CHAT_TYPE_PET_SPEED_FERTILIZE)
                                {
                                    textWindow.text = this.message;
                                    this._width = _Str_5706;
                                }
                                else
                                {
                                    if (this._chatType == RoomWidgetChatUpdateEvent.CHAT_TYPE_NOTIFY)
                                    {
                                        textWindow.text = this.message;
                                        this._width = _Str_5706;
                                    }
                                    else
                                    {
                                        if (this._messageLinks == null)
                                        {
                                            textWindow.text = this.message;
                                        }
                                        else
                                        {
                                            this._messageLinkPositions = new Array<ASAny>();
                                            lastLinkEndPos = -1;
                                            i = 0;
                                            while (i < this._messageLinks.length)
                                            {
                                                filteredLink = this._messageLinks[i][1];
                                                placeHolder = (("{" + Std.string(i)) + "}");
                                                placeholderPos = this._message.indexOf(placeHolder);
                                                lastLinkEndPos = (placeholderPos + filteredLink.length);
                                                this._messageLinkPositions.push(([placeholderPos, lastLinkEndPos] : Array<Dynamic>));
                                                this._message = ASCompat.stringReplace(this._message, placeHolder, filteredLink);
                                                i = (i + 1);
                                            }
                                            textWindow.text = this.message;
                                            textWindow.immediateClickMode = true;
                                            textWindow.setParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT, false);
                                            textWindow.setParamFlag(WindowParam.WINDOW_PARAM_FORCE_CLIPPING, true);
                                            linkFormat = textWindow.getTextFormat();
                                            switch (this._chatStyle)
                                            {
                                                case SystemChatStyleEnum.BOT:
                                                    linkFormat.color = 0xDDDDDD;
                                                    
                                                default:
                                                    linkFormat.color = 2710438;
                                            }
                                            linkFormat.underline = true;
                                            i = 0;
                                            while (i < this._messageLinkPositions.length)
                                            {
                                                linkPos = this._messageLinkPositions[i];
                                                try
                                                {
                                                    textWindow.setTextFormat(linkFormat, ASCompat.toInt(linkPos[0]), ASCompat.toInt(linkPos[1]));
                                                }
                                                catch(e:RangeError)
                                                {
                                                    Logger.log(["Chat message links were malformed. Could not set TextFormat"]);
                                                }
                                                i = (i + 1);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (textWindow.visible)
            {
                textWindow.x = Std.int(this._width + textWindowOffsetX);
                if (nameWindow != null)
                {
                    textWindow.x = (nameWindow.x + nameWindow.width);
                    if (nameWindow.width > _Str_9962)
                    {
                        textWindow.x = (textWindow.x - (_Str_9962 - 1));
                    }
                }
                textWindow.y = Std.int(textWindow.y + this._topOffset);
                messageWidth = Std.int(textWindow.textWidth);
                textWindow.width = (messageWidth + _Str_15961);
                this._width = (this._width + textWindow.width);
            }
            if (((!(pointerWindow == null)) && pointerWindow.visible))
            {
                pointerWindow.bitmap = pointerBitmapData;
                pointerWindow.disposesBitmap = false;
                pointerWindow.x = Std.int(this._width / 2);
                pointerWindow.y = Std.int(pointerWindow.y + this._topOffset);
            }
            var textWidth= textWindow.width;
            if (nameWindow != null)
            {
                textWidth = (textWidth + nameWindow.width);
            }
            var bitmap= RoomChatWidget.chatBubbleFactory._Str_25059(this._chatStyle, this._chatType, textWidth, background.height, this._senderColor);
            this._window.width = bitmap.width;
            this._window.y = Std.int(this._window.y - this._topOffset);
            this._window.y = Std.int(this._window.y + this._originalBackgroundYOffset);
            this._width = this._window.width;
            background.bitmap = bitmap;
            background.y = Std.int(this._topOffset);
        }

        public function _Str_16939()
        {
            this._dragTooltipEnabled = true;
            this._Str_20783();
        }

        public function _Str_22093()
        {
            this._dragTooltipEnabled = false;
            this._Str_20783();
        }

        function _Str_20783()
        {
            if (this._window == null)
            {
                return;
            }
            this._window.toolTipCaption = "";
            if (this._widget.isGameSession)
            {
                return;
            }
            if (this._dragTooltipEnabled)
            {
                this._window.toolTipCaption = _Str_17786;
            }
            this._window.toolTipDelay = 500;
        }

        function _Str_23110(k:IWindowContainer)
        {
            k.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, true);
            k.addEventListener(WindowMouseEvent.CLICK, this._Str_24326);
            k.addEventListener(WindowMouseEvent.DOWN, this._Str_22405);
            k.addEventListener(WindowMouseEvent.OVER, this._Str_23850);
            k.addEventListener(WindowMouseEvent.OUT, this._Str_23475);
            k.addEventListener(WindowMouseEvent.UP, this._Str_24323);
        }

        function _Str_22492(k:Int, _arg_2:Int):Bool
        {
            var _local_5 = 0;
            var _local_3= Std.downcast(this._window.getChildByName(MESSAGE) , ITextWindow);
            var _local_4= _local_3.getCharIndexAtPoint((k - _local_3.x), (_arg_2 - _local_3.y));
            if (_local_4 > -1)
            {
                _local_5 = 0;
                while (_local_5 < this._messageLinkPositions.length)
                {
                    if (((_local_4 >= this._messageLinkPositions[_local_5][0]) && (_local_4 <= this._messageLinkPositions[_local_5][1])))
                    {
                        if (this._messageLinks[_local_5][2] == 0)
                        {
                            HabboWebTools.open(this._messageLinks[_local_5][0]);
                        }
                        else
                        {
                            if (this._messageLinks[_local_5][2] == 1)
                            {
                                HabboWebTools.openWebPage((this._siteUrl + this._messageLinks[_local_5][0]), "habboMain");
                            }
                            else
                            {
                                HabboWebTools.openWebPage((this._siteUrl + this._messageLinks[_local_5][0]));
                            }
                        }
                        return true;
                    }
                    _local_5++;
                }
            }
            return false;
        }

        function _Str_24326(k:WindowMouseEvent)
        {
            if (((this._messageLinks != null) && (this._messageLinks.length > 0)))
            {
                if (this._Str_22492(Std.int(k.localX), Std.int(k.localY)))
                {
                    return;
                }
            }
            this._widget._Str_22991(this._senderId, this._senderName, this._senderCategory, this._roomId, k);
        }

        function _Str_22405(k:WindowMouseEvent)
        {
            this._widget._Str_24206(this._senderId, this._senderCategory, this._roomId, k);
        }

        function _Str_23850(k:WindowMouseEvent)
        {
            this._widget._Str_22868(this._senderId, this._senderCategory, this._roomId, k);
        }

        function _Str_23475(k:WindowMouseEvent)
        {
            this._widget._Str_25858(this._senderId, this._senderCategory, this._roomId, k);
        }

        function _Str_24323(k:WindowMouseEvent)
        {
            this._widget._Str_20437();
        }

        public var _Str_24439(get,never):Int;
public function  get__Str_24439():Int
        {
            return this._chatStyle;
        }

        public var _Str_26239(get,never):Float;
public function  get__Str_26239():Float
        {
            return this._originalBackgroundYOffset;
        }
    }

