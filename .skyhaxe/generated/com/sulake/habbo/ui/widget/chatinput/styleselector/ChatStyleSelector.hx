package com.sulake.habbo.ui.widget.chatinput.styleselector
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.ui.widget.chatinput.RoomChatInputView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import flash.display.Shape;
    import com.sulake.habbo.session.ISessionDataManager;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class ChatStyleSelector implements IDisposable 
    {
        static inline final _Str_17267= 1;
        static inline final _Str_16506= 6;
        static final FONT_SIZE_LABELS:Array<ASAny> = ["S", "M", "L", "XL", "XXL"];
        static var _Str_1007:ChatStyleGridEntry = null;
        static var _Str_6012:Bool = false;
        static var _fontSizeMode:Int = 0;

        var _roomChatInputView:RoomChatInputView;
        var _container:IWindowContainer;
        var _Str_3334:ChatStyleGridView;
        var _Str_2514:Vector<ChatStyleGridEntry>;
        var _Str_11421:IWindow;
        var _fontSizeTemplate:IWindow;
        var _Str_4357:Shape;

        public function new(k:RoomChatInputView, _arg_2:IWindowContainer, _arg_3:ISessionDataManager)
        {
            this._Str_2514 = new Vector<ChatStyleGridEntry>();
            this._roomChatInputView = k;
            this._Str_3334 = new ChatStyleGridView(this, this._roomChatInputView.sessionDataManager);
            this._Str_11421 = this.buildTemplateWindow("chatinput_chatstyle_template_xml");
            this._fontSizeTemplate = this.buildTemplateWindow("chatinput_chatfontsize_template_xml");
            this._container = _arg_2;
            this._container.procedure = this._Str_12416;
            if (((this._Str_3334.window != null) && (this._roomChatInputView._Str_22667 != null)))
            {
                this._roomChatInputView._Str_22667.addChild(this._Str_3334.window);
                this._Str_3334.window.x = 0;
                this._Str_3334.window.y = 0;
            }
            this._roomChatInputView._Str_22667.visible = false;
            this.createFontSizeOptions();
        }

        public function dispose()
        {
            while (this._Str_2514.length > 1)
            {
                this._Str_2514.pop();
            }
            this._Str_2514 = null;
            this._Str_3334.dispose();
            this._Str_3334 = null;
            this._fontSizeTemplate = null;
            if (((this._Str_4357 != null) && (this._Str_4357.parent != null)))
            {
                this._Str_4357.parent.removeChild(this._Str_4357);
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._Str_3334 == null;
        }

        public var _Str_20286(get,never):RoomChatInputView;
public function  get__Str_20286():RoomChatInputView
        {
            return this._roomChatInputView;
        }

        public function addItem(k:Int, _arg_2:BitmapData)
        {
            if (((this._Str_3334 == null) || (this._Str_3334.grid == null)) || (this._Str_11421 == null))
            {
                return;
            }
            this._Str_2514.push(new ChatStyleGridEntry(k, _arg_2));
            var _local_3= this._Str_22807(_arg_2);
            if (_local_3 == null)
            {
                return;
            }
            this._Str_3334.grid.addGridItem(_local_3);
            _local_3.findChildByName("background_color").visible = false;
        }

        public var _Str_22824(get,never):Int;
public function  get__Str_22824():Int
        {
            if ((_Str_6012 && (this.selected != null)))
            {
                _Str_6012 = false;
                return this.selected.id;
            }
            return -1;
        }

        public var _Str_26237(get,never):BitmapData;
public function  get__Str_26237():BitmapData
        {
            if (this.selected != null)
            {
                return this.selected.bitmap;
            }
            return null;
        }

        public function _Str_24820(k:Int=-1)
        {
            var _local_2= this.getEntryById(k);
            if (((_local_2 == null) && (!(k == 0))))
            {
                _local_2 = this.getEntryById(0);
            }
            this.selected = ((_local_2 != null) ? _local_2 : this.selected);
            _Str_6012 = false;
            if (this._roomChatInputView.widget.handler.container.freeFlowChat != null)
            {
                this.initFontSizeSelection(this._roomChatInputView.widget.handler.container.freeFlowChat.chatFontSizeMode);
            }
        }

        public var _Str_22746(never,set):Int;
public function  set__Str_22746(k:Int):Int        {
            if (((this._Str_3334 == null) || (this._Str_3334.grid == null)) || (this._Str_11421 == null))
            {
                return k;
            }
            k = Std.int(Math.min(k, _Str_16506));
            var _local_2= (((k - 1) * (this._Str_11421.width + _Str_17267)) + this._Str_11421.width);
            if (k > 1)
            {
                this._Str_3334.grid.width = _local_2;
            }
            else
            {
                this._Str_3334.grid.width = (this._Str_11421.width + 16);
            }
return k;
        }

        
        var selected(get,set):ChatStyleGridEntry;
function  set_selected(k:ChatStyleGridEntry):ChatStyleGridEntry        {
            if (k == null)
            {
                return k;
            }
            _Str_1007 = k;
            _Str_6012 = true;
            var _local_2= this._roomChatInputView.widget._Str_13265.chatStyleLibrary.getStyle(k.id);
            if (this._roomChatInputView.window.findChildByName("chat_bg_preview") == null)
            {
                return k;
            }
            var _local_3= _local_2.getNewBackgroundSprite(0xFFFFFF);
            var _local_4= cast(this._roomChatInputView.window.findChildByName("chat_bg_preview"), IDisplayObjectWrapper);
            _local_3.width = (_local_4.width + _local_2.overlap.width);
            _local_3.height = ((_local_4.height + _local_2.overlap.y) + _local_2.overlap.height);
            _local_3.y = (_local_3.y - _local_2.overlap.y);
            if (this._Str_4357 == null)
            {
                this._Str_4357 = new Shape();
            }
            else
            {
                this._Str_4357.graphics.clear();
            }
            this._Str_4357.graphics.beginFill(0xFF0000);
            this._Str_4357.graphics.drawRect(0, 0, (_local_3.width - 28), _local_3.height);
            _local_4.setDisplayObject(_local_3);
            if (_local_3.parent != null)
            {
                _local_3.parent.addChild(this._Str_4357);
                this._Str_4357.x = (_local_3.x + 28);
                this._Str_4357.y = _local_3.y;
                _local_3.mask = this._Str_4357;
            }
            this._roomChatInputView._Str_24855(ASCompat.asUint(_local_2.textFormat.color ));
return k;
        }
function  get_selected():ChatStyleGridEntry
        {
            if ((((_Str_1007 == null) || (!this.hasEntry(_Str_1007))) && (this._Str_2514.length > 0)))
            {
                _Str_1007 = this._Str_2514[(this._Str_2514.length - 1)];
            }
            return _Str_1007;
        }

        function getEntryById(k:Int):ChatStyleGridEntry
        {
            var _local_2:ChatStyleGridEntry = null;
            if (this._Str_2514 == null)
            {
                return null;
            }
            final _iter_ = this._Str_2514; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (((_local_2 != null) && (_local_2.id == k)))
                {
                    return _local_2;
                }
            }
            return null;
        }

        function hasEntry(k:ChatStyleGridEntry):Bool
        {
            var _local_2:ChatStyleGridEntry = null;
            if (((k == null) || (this._Str_2514 == null)))
            {
                return false;
            }
            final _iter_ = this._Str_2514; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2 == k)
                {
                    return true;
                }
            }
            return false;
        }

        function _Str_22807(k:BitmapData):IWindowContainer
        {
            if (this._Str_11421 == null)
            {
                return null;
            }
            var _local_2= cast(this._Str_11421.clone(), IWindowContainer);
            var _local_3= cast(_local_2.findChildByName("bubble_preview"), IBitmapWrapperWindow);
            _local_3.bitmap = k;
            _local_3.center();
            _local_2.procedure = this._Str_25202;
            return _local_2;
        }

        public function _Str_19515()
        {
            if (((this._Str_3334 != null) && (this._Str_3334.window != null)) && this._Str_3334.window.visible)
            {
                this._Str_3334._Str_25385(this._container);
            }
        }

        public function setMenuOpen(k:Bool)
        {
            if (this._roomChatInputView._Str_22667 != null)
            {
                this._roomChatInputView._Str_22667.visible = k;
            }
            if (((this._Str_3334 != null) && (this._Str_3334.window != null)))
            {
                this._Str_3334.window.visible = k;
            }
            if (k)
            {
                this._Str_19515();
            }
        }

        function _Str_12416(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = false;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _fontSizeMode = this.clampFontSize(this._roomChatInputView.widget.handler.container.freeFlowChat.chatFontSizeMode);
                this.updateFontSizeSelectionHighlight();
                _local_3 = (!this._roomChatInputView._Str_22667.visible);
                this._roomChatInputView._Str_22667.visible = _local_3;
                this._Str_3334.window.visible = _local_3;
                this._Str_19515();
            }
        }

        function _Str_25202(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = this._Str_3334.grid.getGridItemIndex(_arg_2);
                this._Str_23446(_arg_2);
                this.selected = this._Str_2514[_local_3];
            }
            if (k.type == WindowMouseEvent.OVER)
            {
                cast(_arg_2, IWindowContainer).findChildByName("background_color").color = 0xFFD0D0D0;
            }
            if (k.type == WindowMouseEvent.OUT)
            {
                cast(_arg_2, IWindowContainer).findChildByName("background_color").color = 0xFFFFFFFF;
            }
        }

        function _Str_23446(k:IWindow)
        {
            var _local_2 = 0;
            while ((_local_2 : UInt) < this._Str_3334.grid.numGridItems)
            {
                cast(this._Str_3334.grid.getGridItemAt(_local_2), IWindowContainer).findChildByName("background_color").visible = false;
                _local_2++;
            }
            cast(k, IWindowContainer).findChildByName("background_color").visible = true;
        }

        function buildTemplateWindow(k:String):IWindow
        {
            var _local_2= Std.downcast(this._roomChatInputView.widget.assets.getAssetByName(k) , XmlAsset);
            if (((_local_2 == null) || (_local_2.content == null)))
            {
                return null;
            }
            return this._roomChatInputView.widget.windowManager.buildFromXML((_local_2.content : com.sulake.core.utils.xml.XML) );
        }

        function createFontSizeOptions()
        {
            var k = 0;
            if (((this._Str_3334 == null) || (this._Str_3334.fontSizeList == null)) || (this._fontSizeTemplate == null))
            {
                return;
            }
            while (k < FONT_SIZE_LABELS.length)
            {
                this._Str_3334.fontSizeList.addListItem(this.getFontSizeItemWindowWrapper(FONT_SIZE_LABELS[k], k));
                k++;
            }
            this.updateFontSizeSelectionHighlight();
        }

        function getFontSizeItemWindowWrapper(k:String, _arg_2:Int):IWindowContainer
        {
            var _local_3= cast(this._fontSizeTemplate.clone(), IWindowContainer);
            _local_3.id = _arg_2;
            cast(_local_3.findChildByName("label"), ITextWindow).caption = k;
            _local_3.procedure = this.fontSizeItemWindowProc;
            return _local_3;
        }

        function initFontSizeSelection(k:Int)
        {
            _fontSizeMode = this.clampFontSize(k);
            this.updateFontSizeSelectionHighlight();
        }

        function fontSizeItemWindowProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3= this.resolveFontSizeItem(_arg_2);
            if (_local_3 == null)
            {
                return;
            }
            if (k.type == WindowMouseEvent.CLICK)
            {
                _fontSizeMode = this.clampFontSize(_local_3.id);
                this._roomChatInputView.widget.handler.container.freeFlowChat.chatFontSizeMode = _fontSizeMode;
                this.updateFontSizeSelectionHighlight();
            }
            if (k.type == WindowMouseEvent.OVER)
            {
                _local_3.findChildByName("background_color").color = 0xFFD0D0D0;
            }
            if (k.type == WindowMouseEvent.OUT)
            {
                _local_3.findChildByName("background_color").color = 0xFFFFFFFF;
            }
        }

        function updateFontSizeSelectionHighlight()
        {
            var _local_2 = 0;
            var _local_3:IWindowContainer = null;
            var _local_4:ITextWindow = null;
            if (((this._Str_3334 == null) || (this._Str_3334.fontSizeList == null)))
            {
                return;
            }
            var _local_1= this._Str_3334.fontSizeList;
            while (_local_2 < _local_1.numListItems)
            {
                _local_3 = cast(_local_1.getListItemAt(_local_2), IWindowContainer);
                _local_3.findChildByName("background_color").visible = _local_3.id == _fontSizeMode;
                _local_4 = Std.downcast(_local_3.findChildByName("label") , ITextWindow);
                if (_local_4 != null)
                {
                    _local_4.textColor = _local_3.id == _fontSizeMode ? 0x333333 : 0x999999;
                }
                _local_2++;
            }
        }

        function resolveFontSizeItem(k:IWindow):IWindowContainer
        {
            var _local_2= k;
            while ((((_local_2 != null) && (_local_2.parent != null)) && ((_local_2.parent.parent : ASAny) != (this._Str_3334.fontSizeList : ASAny))))
            {
                _local_2 = _local_2.parent;
            }
            return Std.downcast(_local_2 , IWindowContainer);
        }

        function clampFontSize(k:Int):Int
        {
            if (k < 0)
            {
                return 0;
            }
            if (k > 4)
            {
                return 4;
            }
            return k;
        }
    }

