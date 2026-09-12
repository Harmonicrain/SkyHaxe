package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.parser.room.bots.BotSkillData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.ui.widget.avatarinfo.botskills.BotSkillsEnum;
    import com.sulake.core.assets.XmlAsset;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.RemoveBotFromFlatMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.bots.CommandBotComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class RentableBotMenuView extends AvatarContextInfoButtonView 
    {
        var _data:RentableBotInfoData;

        public function new(k:AvatarInfoWidget)
        {
            super(k);
            _Str_3403 = false;
        }

        public static function setup(k:RentableBotMenuView, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:RentableBotInfoData)
        {
            k._data = _arg_6;
            AvatarContextInfoButtonView.setup(k, _arg_2, _arg_3, _arg_4, _arg_5, false);
        }


        override public function dispose()
        {
            if (window != null)
            {
                window.removeEventListener(WindowMouseEvent.OVER, onMouseOverOut);
                window.removeEventListener(WindowMouseEvent.OUT, onMouseOverOut);
            }
            this._data = null;
            super.dispose();
        }

        function _Str_2771()
        {
            var _local_7:BotSkillData = null;
            var _local_8:Array<ASAny> = null;
            var _local_9:IWindowContainer = null;
            var _local_10 = 0;
            if (((!(window != null)) || (!(this._data != null))))
            {
                return;
            }
            var k= Std.downcast(window.findChildByName("buttons") , IItemListWindow);
            if (k == null)
            {
                return;
            }
            var _local_2= Std.downcast(_buttons.getListItemByName("link_template") , IWindowContainer);
            var _local_3= Std.downcast(_buttons.getListItemByName("nux_proceed_1") , IWindowContainer);
            k.procedure = this.buttonEventProc;
            this.ensureTextButton("wired_inspect",
                "${infostand.button.wired_inspect}");
            k.autoArrangeItems = false;
            var _local_4= k.numListItems;
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                k.getListItemAt(_local_5).visible = false;
                _local_5++;
            }
            var _local_6= (this._data.amIOwner || this._data.amIAnyRoomController);
            showButton("pick", ((this._data.botSkills != null) ? ((this._data.botSkills.indexOf(BotSkillsEnum.NO_PICK_UP) == -1) && _local_6) : _local_6));
            if (this._data.botSkills != null)
            {
                showButton("donate_to_all", (!(this._data.botSkills.indexOf(BotSkillsEnum.DONATE_TO_ALL) == -1)));
                showButton("donate_to_user", (!(this._data.botSkills.indexOf(BotSkillsEnum.DONATE_TO_USER) == -1)));
                if (this._data.amIOwner)
                {
                    showButton("change_bot_name", (!(this._data.botSkills.indexOf(BotSkillsEnum.CHANGE_BOT_NAME) == -1)));
                    showButton("change_bot_motto", (!(this._data.botSkills.indexOf(BotSkillsEnum.CHANGE_BOT_MOTTO) == -1)));
                    showButton("dress_up", (!(this._data.botSkills.indexOf(BotSkillsEnum.DRESS_UP) == -1)));
                    showButton("random_walk", (!(this._data.botSkills.indexOf(BotSkillsEnum.RANDOM_WALK) == -1)));
                    showButton("setup_chat", (!(this._data.botSkills.indexOf(BotSkillsEnum.SETUP_CHAT) == -1)));
                    showButton("dance", (!(this._data.botSkills.indexOf(BotSkillsEnum.DANCE) == -1)));
                }
                showButton("nux_take_tour", (!(this._data.botSkills.indexOf(BotSkillsEnum.NUX_TAKE_TOUR) == -1)));
            }
            showButton("wired_inspect",
                this.widget.handler.container.userDefinedRoomEvents
                    .showInspectButton());
            final _iter_ = this._data._Str_10833; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_7  = _tmp_;
                if (_local_7.id == BotSkillsEnum.INCLIENT_LINK)
                {
                    _local_9 = Std.downcast(_local_2.clone() , IWindowContainer);
                    _local_8 = (cast _local_7.data.split(","));
                    if (_local_8.length == 2)
                    {
                        _local_9.findChildByName("label").caption = _local_8[0];
                        _local_9.name = (":link " + _local_8[1]);
                        _local_9.visible = true;
                        k.addListItem(_local_9);
                    }
                }
                if (_local_7.id == BotSkillsEnum.NUX_PROCEED)
                {
                    if (_local_7.data == "")
                    {
                        showButton("nux_proceed_1", true);
                    }
                    else
                    {
                        _local_8 = (cast _local_7.data.split(","));
                        if (_local_8.length == 2)
                        {
                            _local_10 = ASCompat.parseInt(_local_8[1]);
                            if (_local_10 == 1)
                            {
                                showButton("nux_proceed_1", true);
                                cast(k.getListItemByName("nux_proceed_1"), IWindowContainer).findChildByName("label").caption = _local_8[0];
                            }
                            else
                            {
                                _local_9 = Std.downcast(_local_3.clone() , IWindowContainer);
                                _local_9.visible = true;
                                _local_9.name = ("nux_proceed_" + Std.string(_local_10));
                                _local_9.findChildByName("label").caption = _local_8[0];
                                k.addListItemAt(_local_9, ((k.getListItemIndex(k.getListItemByName("nux_proceed_1")) + _local_10) - 1));
                            }
                        }
                    }
                }
                if (_local_7.id == BotSkillsEnum.NAVIGATOR_SEARCH)
                {
                    _local_9 = Std.downcast(_local_2.clone() , IWindowContainer);
                    _local_8 = (cast _local_7.data.split(","));
                    if (_local_8.length == 2)
                    {
                        _local_9.findChildByName("label").caption = _local_8[0];
                        _local_9.name = (":link navigator/search/" + _local_8[1]);
                        _local_9.visible = true;
                        k.addListItem(_local_9);
                    }
                }
            }
            k.autoArrangeItems = true;
            k.visible = true;
        }

        override function updateWindow()
        {
            var k:com.sulake.core.utils.xml.XML = null;
            if ((((!(_widget != null)) || (!(_widget.assets != null))) || (!(_widget.windowManager != null))))
            {
                return;
            }
            if (com.sulake.habbo.ui.widget.contextmenu.ContextInfoView._Str_3452)
            {
                activeView = createMinimizedView();
            }
            else
            {
                if (window == null)
                {
                    k = ((cast(_widget.assets.getAssetByName("avatar_menu_widget"), XmlAsset).content : com.sulake.core.utils.xml.XML) );
                    _window = Std.downcast(_widget.windowManager.buildFromXML(k, 0) , IWindowContainer);
                    if (window == null)
                    {
                        return;
                    }
                    window.addEventListener(WindowMouseEvent.OVER, onMouseOverOut);
                    window.addEventListener(WindowMouseEvent.OUT, onMouseOverOut);
                    window.findChildByName("minimize").addEventListener(WindowMouseEvent.CLICK, _Str_4457);
                    window.findChildByName("minimize").addEventListener(WindowMouseEvent.OVER, onMinimizeButtonEvent);
                    window.findChildByName("minimize").addEventListener(WindowMouseEvent.OUT, onMinimizeButtonEvent);
                }
                _buttons = Std.downcast(window.findChildByName("buttons") , IItemListWindow);
                _buttons.procedure = this.buttonEventProc;
                window.findChildByName("name").caption = _userName;
                window.visible = false;
                activeView = window;
                this._Str_2771();
            }
        }

        override function buttonEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4:Point = null;
            var _local_5:Rectangle = null;
            var _local_6:String = null;
            var _local_7:String = null;
            if (disposed)
            {
                return;
            }
            if (((!(window != null)) || window.disposed))
            {
                return;
            }
            var _local_3 = false;
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (_arg_2.name == "button")
                {
                    _local_5 = null;
                    switch (_arg_2.parent.name)
                    {
                        case "wired_inspect":
                            this.widget.handler.container
                                .userDefinedRoomEvents.inspectObject(
                                    1, this._data.roomIndex);
                            _local_3 = true;
                            
                        case "pick":
                            _local_3 = true;
                            this.widget.handler.container.connection.send(new RemoveBotFromFlatMessageComposer(this._data.id));
                            
                        case "setup_chat":
                            _local_3 = true;
                            _local_5 = new Rectangle();
                            window.getGlobalRectangle(_local_5);
                            _local_4 = new Point((_local_5.x + (_local_5.width / 2)), (_local_5.y + _local_5.height));
                            this.widget._Str_21992(this._data.id, BotSkillsEnum.SETUP_CHAT, _local_4);
                            
                        case "random_walk":
                            _local_3 = true;
                            this.widget.handler.container.connection.send(new CommandBotComposer(this._data.id, BotSkillsEnum.RANDOM_WALK, ""));
                            
                        case "dress_up":
                            _local_3 = true;
                            this.widget.handler.container.connection.send(new CommandBotComposer(this._data.id, BotSkillsEnum.DRESS_UP, ""));
                            
                        case "dance":
                            _local_3 = true;
                            this.widget.handler.container.connection.send(new CommandBotComposer(this._data.id, BotSkillsEnum.DANCE, ""));
                            
                        case "donate_to_all":
                            _local_3 = true;
                            this.widget.handler.container.connection.send(new CommandBotComposer(this._data.id, BotSkillsEnum.DONATE_TO_ALL, ""));
                            
                        case "donate_to_user":
                            _local_3 = true;
                            this.widget.handler.container.connection.send(new CommandBotComposer(this._data.id, BotSkillsEnum.DONATE_TO_USER, ""));
                            
                        case "nux_take_tour":
                            _local_3 = true;
                            this.widget.component.context.createLinkEvent("help/tour");
                            this.widget.handler.container.connection.send(new CommandBotComposer(this._data.id, BotSkillsEnum.NUX_TAKE_TOUR, ""));
                            
                        case "change_bot_motto":
                            _local_3 = true;
                            _local_5 = new Rectangle();
                            window.getGlobalRectangle(_local_5);
                            _local_4 = new Point((_local_5.x + (_local_5.width / 2)), (_local_5.y + _local_5.height));
                            this.widget._Str_21992(this._data.id, BotSkillsEnum.CHANGE_BOT_MOTTO, _local_4);
							
						case "change_bot_name":
                            _local_3 = true;
                            _local_5 = new Rectangle();
                            window.getGlobalRectangle(_local_5);
                            _local_4 = new Point((_local_5.x + (_local_5.width / 2)), (_local_5.y + _local_5.height));
                            this.widget._Str_21992(this._data.id, BotSkillsEnum.CHANGE_BOT_NAME, _local_4);
                            
                    }
                    if (_arg_2.parent.name.indexOf(":link ") != -1)
                    {
                        _local_6 = _arg_2.parent.name.substr(6, (_arg_2.parent.name.length - 6));
                        this.widget.component.context.createLinkEvent(_local_6);
                        _local_3 = true;
                    }
                    if (_arg_2.parent.name.indexOf("nux_proceed_") != -1)
                    {
                        _local_7 = _arg_2.parent.name.substr(12, (_arg_2.parent.name.length - 12));
                        this.widget.handler.container.connection.send(new CommandBotComposer(this._data.id, BotSkillsEnum.NUX_PROCEED, _local_7));
                        _local_3 = true;
                    }
                }
                this._Str_2771();
            }
            else
            {
                super.buttonEventProc(k, _arg_2);
            }
            if (_local_3)
            {
                _widget.removeView(this, false);
            }
        }

        var widget(get,never):AvatarInfoWidget;
function  get_widget():AvatarInfoWidget
        {
            return Std.downcast(_widget , AvatarInfoWidget);
        }
    }




