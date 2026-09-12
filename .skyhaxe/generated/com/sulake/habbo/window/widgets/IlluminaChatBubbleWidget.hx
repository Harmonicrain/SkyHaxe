package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ILabelWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.habbo.window._enum._Str_3724;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.habbicons.assets.HabbiconAssetManager;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.geom.Matrix;

     class IlluminaChatBubbleWidget implements IIlluminaChatBubbleWidget
    {
        public static inline final ILLUMINA_CHAT_BUBBLE= "illumina_chat_bubble";
        static final FLIPPED_KEY:String = (ILLUMINA_CHAT_BUBBLE + ":flipped");
        static final USER_NAME_KEY:String = (ILLUMINA_CHAT_BUBBLE + ":user_name");
        static final FIGURE_KEY:String = (ILLUMINA_CHAT_BUBBLE + ":figure");
        static final MESSAGE_KEY:String = (ILLUMINA_CHAT_BUBBLE + ":message");
        static inline final MESSAGE_SEPARATOR= "\t";
        static inline final HABBICON_SIZE= 80;
        static inline final HABBICON_SCALE= 2;
        static inline final HABBICON_DIRECTION_LEFT= -1;
        static inline final HABBICON_DIRECTION_RIGHT= 1;
        static inline final PENDING_MESSAGE_BLEND= 0.45;
        static inline final PENDING_MESSAGE_TEXT_COLOR:UInt = 0x8A8A8A;
        static inline final MESSAGE_TEXT_COLOR:UInt = 0;
        static inline final RESIZING_OFFSETS= 10;
        static final _Str_13641:PropertyStruct = new PropertyStruct(FLIPPED_KEY, false, PropertyStruct.BOOLEAN);
        static final _Str_13288:PropertyStruct = new PropertyStruct(USER_NAME_KEY, "", PropertyStruct.STRING);
        static final figureProperty:PropertyStruct = new PropertyStruct(FIGURE_KEY, "", PropertyStruct.STRING);
        static final _Str_13034:PropertyStruct = new PropertyStruct(MESSAGE_KEY, "", PropertyStruct.STRING);

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _root:IWindowContainer;
        var _flipped:Bool = false;
        var _userName:ILabelWindow;
        var _avatarWrapper:IWindow;
        var _avatarWidget:IAvatarImageWidget;
        var _bubbleWrapper:IWindow;
        var _spacedMessageContainer:IItemListWindow;
        var _messageContainer:IItemListWindow;
        var _messageTemplate:ITextWindow;
        var _habbiconTemplate:IWindowContainer;
        var _messages:Vector<ChatBubbleMessage>;
        var _awaitingConfirmationIds:Array<ASAny>;
        var _postTime:_Str_5483;
        var _offline:IRegionWindow;
        var _arrowPoint:IStaticBitmapWrapperWindow;
        var _refreshing:Bool = false;
        var _underline:Bool = false;
        var _habbiconListenerAdded:Bool = false;
        var _lastResizeStep:Int = -1;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._flipped = ASCompat.toBool(_Str_13641.value);
            this._messages = new Vector<ChatBubbleMessage>(0);
            this._awaitingConfirmationIds = [];
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("illumina_chat_bubble_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._messageContainer = Std.downcast(this._root.findChildByName("message_container") , IItemListWindow);
            this._messageTemplate = Std.downcast(this._messageContainer.getListItemByName("message_template") , ITextWindow);
            this._messageContainer.removeListItem(this._messageTemplate);
            this._habbiconTemplate = Std.downcast(this._messageContainer.getListItemByName("habbicon_template") , IWindowContainer);
            this._messageContainer.removeListItem(this._habbiconTemplate);
            this._spacedMessageContainer = Std.downcast(this._root.findChildByName("spaced_message_container") , IItemListWindow);
            this._userName = Std.downcast(this._root.findChildByName("user_name") , ILabelWindow);
            var _local_3= Std.downcast(this._root.findChildByName("user_avatar") , IWidgetWindow);
            this._avatarWrapper = _local_3.parent;
            this._avatarWidget = Std.downcast(_local_3.widget , IAvatarImageWidget);
            this._bubbleWrapper = this._root.findChildByName("bubble_wrapper");
            this._postTime = Std.downcast(cast(this._root.findChildByName("post_time"), IWidgetWindow).widget , _Str_5483);
            this._offline = Std.downcast(this._root.findChildByName("offline_placeholder") , IRegionWindow);
            this._offline.height = 0;
            this._arrowPoint = Std.downcast(this._root.findChildByName("arrow_point") , IStaticBitmapWrapperWindow);
            this._root.findChildByName("message_region").setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, false);
            this._root.procedure = this._Str_24924;
            this.userName = ASCompat.toString(_Str_13288.value);
            this.figure = ASCompat.toString(figureProperty.value);
            this.setMessages(getMessagesFromProperty(ASCompat.toString(_Str_13034.value)));
            this._widgetWindow.rootWindow = this._root;
            this._widgetWindow.setParamFlag(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN);
            this._root.width = this._widgetWindow.width;
        }

        public static function getMessagesFromProperty(k:String):Array<ASAny>
        {
            var _local_2:Array<ASAny> = (cast k.split(MESSAGE_SEPARATOR));
            if (((_local_2.length == 1) && (_local_2[0] == "")))
            {
                return [];
            }
            return _local_2;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this.removeHabbiconListener();
                if (this._messageContainer != null)
                {
                    this.disposeMessageWindows();
                }
                if (this._messageTemplate != null)
                {
                    this._messageTemplate.dispose();
                    this._messageTemplate = null;
                }
                if (this._habbiconTemplate != null)
                {
                    this._habbiconTemplate.dispose();
                    this._habbiconTemplate = null;
                }
                this._messageContainer = null;
                this._spacedMessageContainer = null;
                this._messages.length = 0;
                this._awaitingConfirmationIds.resize(0);
                if (this._root != null)
                {
                    this._root.dispose();
                    this._root = null;
                }
                if (this._widgetWindow != null)
                {
                    this._widgetWindow.rootWindow = null;
                    this._widgetWindow = null;
                }
                this._windowManager = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return EmptyIterator.INSTANCE;
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            if (this._disposed)
            {
                return k;
            }
            k.push(_Str_13641.withValue(this.flipped));
            k.push(_Str_13288.withValue(this.userName));
            k.push(figureProperty.withValue(this.figure));
            k.push(_Str_13034.withValue(this.getSerializedMessages().join(MESSAGE_SEPARATOR)));
            return k;
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (this._disposed)
            {
                return k;
            }
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case FLIPPED_KEY:
                        this.flipped = ASCompat.toBool(_local_2.value);
                        
                    case USER_NAME_KEY:
                        this.userName = ASCompat.toString(_local_2.value);
                        
                    case FIGURE_KEY:
                        this.figure = ASCompat.toString(_local_2.value);
                        
                    case MESSAGE_KEY:
                        this.setMessages(getMessagesFromProperty(ASCompat.toString(_local_2.value)));
                        
                }
            }
return k;
        }

        
        public var flipped(get,set):Bool;
public function  get_flipped():Bool
        {
            return this._flipped;
        }
public function  set_flipped(k:Bool):Bool        {
            if (this._flipped == k)
            {
                return k;
            }
            this._flipped = k;
            this.refreshHabbicons();
            this.refresh();
return k;
        }

        
        public var userName(get,set):String;
public function  get_userName():String
        {
            return this._userName.caption.substring(0, -1);
        }
public function  set_userName(k:String):String        {
            this._userName.caption = (k + ":");
return k;
        }

        
        public var userId(get,set):Int;
public function  get_userId():Int
        {
            return this._avatarWidget.userId;
        }
public function  set_userId(k:Int):Int        {
            return this._avatarWidget.userId = k;
        }

        
        public var figure(get,set):String;
public function  get_figure():String
        {
            return this._avatarWidget.figure;
        }
public function  set_figure(k:String):String        {
            return this._avatarWidget.figure = k;
        }

        
        public var message(get,set):String;
public function  get_message():String
        {
            return this.getSerializedMessages().join("\n");
        }
public function  set_message(k:String):String        {
            this.setMessages([k]);
return k;
        }

        
        public var habbiconId(get,set):Int;
public function  get_habbiconId():Int
        {
            var _local_2:ChatBubbleMessage = null;
            var k = 0;
            while (k < this._messages.length)
            {
                _local_2 = this._messages[k];
                if (_local_2.type == ChatBubbleMessage.TYPE_HABBICON)
                {
                    return _local_2.habbiconId;
                }
                k++;
            }
            return 0;
        }
public function  set_habbiconId(k:Int):Int        {
            if (k <= 0)
            {
                return k;
            }
            this.disposeMessageWindows();
            this._messages.length = 0;
            this._awaitingConfirmationIds.resize(0);
            this.appendMessage(ChatBubbleMessage.habbicon(k));
return k;
        }

        public var numMessages(get,never):Int;
public function  get_numMessages():Int
        {
            return this._messages.length;
        }

        public function getMessage(k:Int):ChatBubbleMessage
        {
            if (((k < 0) || (k >= this._messages.length)))
            {
                return null;
            }
            return this._messages[k];
        }

        public function setMessage(k:Int, _arg_2:ChatBubbleMessage)
        {
            var _local_5:IWindow = null;
            if (((_arg_2 == null) || (k < 0)))
            {
                return;
            }
            while (k >= this.numMessages)
            {
                this.appendMessage(ChatBubbleMessage.text(""));
            }
            var _local_3= ASCompat.toInt(this._awaitingConfirmationIds[k]);
            var _local_4= this._messages[k];
            this._messages[k] = _arg_2;
            if (_local_4.type != _arg_2.type)
            {
                _local_5 = this._messageContainer.removeListItemAt(k);
                if (_local_5 != null)
                {
                    _local_5.dispose();
                }
                this._messageContainer.addListItemAt(this.createMessageWindow(_arg_2), k);
            }
            else
            {
                this.updateMessageWindow(k, _arg_2);
            }
            this.setAwaitingConfirmationId(k, _local_3);
        }

        public function appendMessage(k:ChatBubbleMessage, _arg_2:Bool=false, _arg_3:Int=0)
        {
            var _local_4 = 0;
            if (k == null)
            {
                return;
            }
            if (_arg_2)
            {
                _local_4 = 0;
                this._messages.insertAt(_local_4, k);
                this._messageContainer.addListItemAt(this.createMessageWindow(k), 0);
                this._awaitingConfirmationIds.insert(_local_4, _arg_3);
            }
            else
            {
                _local_4 = this.numMessages;
                this._messages.push(k);
                this._messageContainer.addListItem(this.createMessageWindow(k));
                this._awaitingConfirmationIds.push(_arg_3);
            }
            this.setAwaitingConfirmationId(_local_4, _arg_3);
        }

        public function appendTextMessage(k:String, _arg_2:Bool=false, _arg_3:Int=0)
        {
            this.appendMessage(ChatBubbleMessage.text(k), _arg_2, _arg_3);
        }

        public function appendHabbiconMessage(k:Int, _arg_2:Bool=false, _arg_3:Int=0)
        {
            this.appendMessage(ChatBubbleMessage.habbicon(k), _arg_2, _arg_3);
        }

        public function setAwaitingConfirmationId(k:Int, _arg_2:Int)
        {
            if (((k < 0) || (k >= this._messages.length)))
            {
                return;
            }
            this.applyConfirmationVisual(k, _arg_2);
            this._awaitingConfirmationIds[k] = _arg_2;
        }

        public function clearAwaitingConfirmationId(k:Int)
        {
            this.setAwaitingConfirmationId(k, 0);
        }

        public function getAwaitingConfirmationId(k:Int):Int
        {
            if (((k < 0) || (k >= this._awaitingConfirmationIds.length)))
            {
                return 0;
            }
            return ASCompat.toInt(this._awaitingConfirmationIds[k]);
        }

        public var underline(never,set):Bool;
public function  set_underline(k:Bool):Bool        {
            var _local_3:ITextWindow = null;
            this._underline = k;
            var _local_2 = 0;
            while (_local_2 < this._messageContainer.numListItems)
            {
                _local_3 = Std.downcast(this._messageContainer.getListItemAt(_local_2) , ITextWindow);
                if (_local_3 != null)
                {
                    _local_3.underline = k;
                }
                _local_2++;
            }
return k;
        }

        
        public var timeStamp(get,set):Float;
public function  get_timeStamp():Float
        {
            return this._postTime.timeStamp;
        }
public function  set_timeStamp(k:Float):Float        {
            return this._postTime.timeStamp = k;
        }

        public var friendOnlineStatus(never,set):Bool;
public function  set_friendOnlineStatus(k:Bool):Bool        {
            this._offline.height = (k ? 0 : 16);
return k;
        }

        public function refresh()
        {
            var _local_2 = 0;
            var _local_3:IWindow = null;
            var _local_4:ITextWindow = null;
            if (this._refreshing)
            {
                return;
            }
            this._refreshing = true;
            this._root.limits.minWidth = this._root.width;
            this._root.limits.maxWidth = this._root.width;
            this._root.height = this._bubbleWrapper.bottom;
            this._bubbleWrapper.width = (this._root.width - this._avatarWrapper.width);
            var k= Std.int(this._bubbleWrapper.width / RESIZING_OFFSETS);
            if (k != this._lastResizeStep)
            {
                _local_2 = 0;
                while (_local_2 < this._messageContainer.numListItems)
                {
                    _local_3 = this._messageContainer.getListItemAt(_local_2);
                    _local_4 = Std.downcast(_local_3 , ITextWindow);
                    if (_local_4 != null)
                    {
                        _local_4.width = (this._bubbleWrapper.width - 5);
                    }
                    else
                    {
                        _local_3.width = HABBICON_SIZE;
                        _local_3.height = HABBICON_SIZE;
                    }
                    _local_2++;
                }
                this._lastResizeStep = k;
            }
            this._messageContainer.width = this._bubbleWrapper.width;
            this._spacedMessageContainer.width = this._bubbleWrapper.width;
            this._avatarWidget.direction = (this._flipped ? _Str_3724._Str_8287 : _Str_3724._Str_4519);
            if (this._flipped)
            {
                this._avatarWrapper.x = (this._root.width - this._avatarWrapper.width);
                this._arrowPoint.zoomX = 1;
                this._arrowPoint.x = this._avatarWrapper.x;
                this._bubbleWrapper.x = 0;
            }
            else
            {
                this._avatarWrapper.x = 0;
                this._arrowPoint.zoomX = -1;
                this._arrowPoint.x = (this._avatarWrapper.right - this._arrowPoint.width);
                this._bubbleWrapper.x = this._avatarWrapper.right;
            }
            this._root.limits.setEmpty();
            this._arrowPoint.invalidate();
            this._refreshing = false;
        }

        function setMessages(k:Array<ASAny>)
        {
            var _local_2:ASAny = null;
            this.disposeMessageWindows();
            this._messages.length = 0;
            this._awaitingConfirmationIds.resize(0);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                this.appendMessage((Std.is(_local_2 , ChatBubbleMessage) ? cast(_local_2, ChatBubbleMessage) : ChatBubbleMessage.text(ASCompat.toString(_local_2))));
            }
        }

        function getSerializedMessages():Array<ASAny>
        {
            var _local_3:ChatBubbleMessage = null;
            var k:Array<ASAny> = [];
            var _local_2 = 0;
            while (_local_2 < this.numMessages)
            {
                _local_3 = this.getMessage(_local_2);
                k.push(((_local_3.type == ChatBubbleMessage.TYPE_TEXT) ? _local_3.textValue : ""));
                _local_2++;
            }
            return k;
        }

        function createMessageWindow(k:ChatBubbleMessage):IWindow
        {
            var _local_2:IWindowContainer = null;
            if (k.type == ChatBubbleMessage.TYPE_HABBICON)
            {
                _local_2 = Std.downcast(this._habbiconTemplate.clone() , IWindowContainer);
                _local_2.visible = true;
                this.renderHabbicon(_local_2, k.habbiconId);
                return _local_2;
            }
            var _local_3= Std.downcast(this._messageTemplate.clone() , ITextWindow);
            _local_3.caption = k.textValue;
            if (this._underline)
            {
                _local_3.underline = true;
            }
            return _local_3;
        }

        function updateMessageWindow(k:Int, _arg_2:ChatBubbleMessage)
        {
            var _local_3= this._messageContainer.getListItemAt(k);
            if (_local_3 == null)
            {
                return;
            }
            if (_arg_2.type == ChatBubbleMessage.TYPE_HABBICON)
            {
                this.renderHabbicon(Std.downcast(_local_3 , IWindowContainer), _arg_2.habbiconId);
            }
            else
            {
                _local_3.caption = _arg_2.textValue;
            }
        }

        function renderHabbicon(k:IWindowContainer, _arg_2:Int)
        {
            if (k == null)
            {
                return;
            }
            k.width = HABBICON_SIZE;
            k.height = HABBICON_SIZE;
            var _local_3= Std.downcast(k.findChildByName("habbicon_bitmap") , IBitmapWrapperWindow);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.disposesBitmap = true;
            _local_3.bitmap = this.createHabbiconBitmap(_arg_2);
            _local_3.invalidate();
        }

        function createHabbiconBitmap(k:Int):BitmapData
        {
            var _local_4:Matrix = null;
            var _local_2= new BitmapData(HABBICON_SIZE, HABBICON_SIZE, true, 0);
            var _local_3= HabbiconAssetManager.getPreviewBitmap(k, false);
            if (_local_3 == null)
            {
                this.addHabbiconListener();
                return _local_2;
            }
            _local_4 = new Matrix();
            if (this.shouldMirrorHabbicon(k))
            {
                _local_4.scale(-HABBICON_SCALE, HABBICON_SCALE);
                _local_4.translate((_local_3.width * HABBICON_SCALE), 0);
            }
            else
            {
                _local_4.scale(HABBICON_SCALE, HABBICON_SCALE);
            }
            _local_2.draw(_local_3, _local_4, null, null, null, false);
            return _local_2;
        }

        function shouldMirrorHabbicon(k:Int):Bool
        {
            // Your own habbicons face left, the other party's face right. Our sheet is authored
            // left-facing (dir -1), so this is inverted against the live client, whose icons are
            // authored right-facing -- do not "restore" it to flipped ? LEFT : RIGHT.
            var _local_2= (this._flipped ? HABBICON_DIRECTION_RIGHT : HABBICON_DIRECTION_LEFT);
            var _local_3= HabbiconAssetManager.getDirection(k);
            return (((!(_local_2 == 0)) && (!(_local_3 == 0))) && (!(_local_2 == _local_3)));
        }

        function refreshHabbicons()
        {
            var _local_2:ChatBubbleMessage = null;
            if (this._messageContainer == null)
            {
                return;
            }
            var k = 0;
            while (k < this.numMessages)
            {
                _local_2 = this._messages[k];
                if (_local_2.type == ChatBubbleMessage.TYPE_HABBICON)
                {
                    this.renderHabbicon(Std.downcast(this._messageContainer.getListItemAt(k) , IWindowContainer), _local_2.habbiconId);
                }
                k++;
            }
        }

        function addHabbiconListener()
        {
            if (!this._habbiconListenerAdded)
            {
                HabbiconAssetManager.addEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
                this._habbiconListenerAdded = true;
            }
        }

        function removeHabbiconListener()
        {
            if (this._habbiconListenerAdded)
            {
                HabbiconAssetManager.removeEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
                this._habbiconListenerAdded = false;
            }
        }

        function onHabbiconAssetsLoaded(k:Event)
        {
            this.removeHabbiconListener();
            if (this._disposed)
            {
                return;
            }
            this.refreshHabbicons();
        }

        function applyConfirmationVisual(k:Int, _arg_2:Int)
        {
            var _local_5:IWindow = null;
            var _local_3= this._messageContainer.getListItemAt(k);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= Std.downcast(_local_3 , ITextWindow);
            var _local_6= (_arg_2 > 0);
            if (_local_4 != null)
            {
                _local_4.textColor = (_local_6 ? PENDING_MESSAGE_TEXT_COLOR : MESSAGE_TEXT_COLOR);
                return;
            }
            _local_3.blend = (_local_6 ? PENDING_MESSAGE_BLEND : 1);
            _local_5 = cast(_local_3, IWindowContainer).findChildByName("habbicon_bitmap");
            if (_local_5 != null)
            {
                _local_5.blend = (_local_6 ? PENDING_MESSAGE_BLEND : 1);
            }
        }

        function disposeMessageWindows()
        {
            var k:IWindow = null;
            while (this._messageContainer.numListItems > 0)
            {
                k = this._messageContainer.removeListItemAt(0);
                if (k != null)
                {
                    k.dispose();
                }
            }
        }

        function _Str_24924(k:WindowEvent, _arg_2:IWindow)
        {
            switch (k.type)
            {
                case WindowEvent.WINDOW_EVENT_RESIZED:
                    this.refresh();
                    return;
                case WindowEvent.WINDOW_EVENT_CHILD_RESIZED:
                    this.refresh();
                    return;
                case WindowMouseEvent.CLICK:
                    if (((this.userId > 0) && (_arg_2.name == "user_name_region")))
                    {
                        this._windowManager.communication.connection.send(new GetExtendedProfileMessageComposer(this.userId));
                    }
                    return;
            }
        }
    }

