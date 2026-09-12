package com.sulake.habbo.friendbar.landingview.widget.elements
;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IElementHandler;
    import com.sulake.habbo.friendbar.landingview.interfaces.elements.IFloatingElement;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.habbo.friendbar.landingview.widget.GenericWidget;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestDailyMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.quest.GetDailyQuestMessageComposer;
    import com.sulake.habbo.communication.messages.parser.quest.QuestDailyParser;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.quest.ActivateQuestMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.quest.CancelQuestMessageComposer;

     class DailyQuestElementHandler implements IElementHandler implements  IFloatingElement implements  IDisposable 
    {
        var _landingView:HabboLandingView;
        var _widget:GenericWidget;
        var _window:IWindowContainer;
        var _container:IWindowContainer;
        var _data:QuestMessageData;
        var _easyQuestCount:Int = 0;
        var _hardQuestCount:Int = 0;
        var _index:Int = 0;
        var _isFloating:Bool = false;
        var _disposed:Bool = false;
        var _campaignCode:String = "";
        var _chainCode:String = "";


        public static function _Str_5055(k:IWindowContainer, _arg_2:Int)
        {
            var _local_5:IWindow = null;
            var _local_3 = 0;
            var _local_4 = 0;
            while (_local_4 < k.numChildren)
            {
                _local_5 = k.getChildAt(_local_4);
                _local_5.x = _local_3;
                _local_3 = (_local_3 + (_local_5.width + _arg_2));
                _local_4++;
            }
        }


        public function initialize(k:HabboLandingView, _arg_2:IWindow, _arg_3:Array<ASAny>, _arg_4:GenericWidget)
        {
            this._widget = _arg_4;
            this._landingView = k;
            this._window = Std.downcast(_arg_2 , IWindowContainer);
            if (_arg_3.length > 2)
            {
                this._isFloating = (_arg_3[2] == "true");
            }
            if (_arg_3.length > 3)
            {
                _arg_2.x = ASCompat.toInt(_arg_3[3]);
            }
            if (_arg_3.length > 4)
            {
                _arg_2.y = ASCompat.toInt(_arg_3[4]);
            }
            if (_arg_3.length > 5)
            {
                this._campaignCode = _arg_3[5];
            }
            if (_arg_3.length > 6)
            {
                this._chainCode = _arg_3[6];
            }
            k.communicationManager.addHabboConnectionMessageEvent(new QuestDailyMessageEvent(this._Str_17705));
            this._container = Std.downcast(_arg_2 , IWindowContainer);
            this._container.findChildByName("accept_button").procedure = this.onAcceptButton;
            this._container.findChildByName("go_button").procedure = this.onGoButton;
            this._container.findChildByName("next_quest_region").procedure = this.onNextQuest;
            this._container.findChildByName("cancel_quest_region").procedure = this.onCancelQuest;
            this._container.findChildByName("easy_region").procedure = this.onEasyRegion;
            this._container.findChildByName("hard_region").procedure = this.onHardRegion;
        }

        public function dispose()
        {
            this._landingView = null;
            this._disposed = true;
        }

        public function _Str_7806(k:Bool):Bool
        {
            return this._isFloating;
        }

        public function refresh()
        {
            this._index = 0;
            this._landingView.send(new GetDailyQuestMessageComposer(true, 0));
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function _Str_17705(k:IMessageEvent)
        {
            var _local_2= cast(k.parser, QuestDailyParser);
            this._data = _local_2.quest;
            this._easyQuestCount = _local_2._Str_20037;
            this._hardQuestCount = _local_2._Str_19915;
            this.refreshContent();
        }

        function refreshContent()
        {
            this._container.findChildByName("caption_txt").caption = ((this._data != null) ? this._Str_14198("chaincaption") : this.getText("landing.view.quest.currenttask.alldone.caption"));
            this._container.findChildByName("accept_button").visible = ((this._data != null) && (!this._data.accepted));
            this._container.findChildByName("next_quest_region").visible = (((this._data != null) && (!this._data.accepted)) && ((this._data.easy ? this._easyQuestCount : this._hardQuestCount) > 1));
            this._container.findChildByName("next_quest_txt").caption = this.getText(("landing.view.quest.nextquest." + (((this._data != null) && this._data.easy) ? "easy" : "hard")));
            this._container.findChildByName("cancel_quest_region").visible = ((this._data != null) && this._data.accepted);
            this._container.findChildByName("current_quest_border").visible = ((this._data != null) && this._data.accepted);
            if (this._data != null)
            {
                this._landingView.localizationManager.registerParameter("landing.view.quest.currenttask", "task", this.getQuestName());
            }
            var k= cast(this._container.findChildByName("difficulty_container"), IWindowContainer);
            var _local_2= (k.x + k.width);
            k.visible = ((((this._data != null) && (!this._data.accepted)) && (this._easyQuestCount > 0)) && (this._hardQuestCount > 0));
            this._Str_10427("easy_region", ((this._data != null) && (!this._data.easy)));
            this._Str_10427("hard_region", ((this._data != null) && this._data.easy));
            _Str_5055(k, 5);
            k.width = (k.findChildByName("hard_region").x + k.findChildByName("hard_region").width);
            k.x = (_local_2 - k.width);
        }

        function _Str_10427(k:String, _arg_2:Bool)
        {
            var _local_3= cast(this._container.findChildByName(k), IWindowContainer);
            var _local_4= cast(_local_3.findChildByName("label_txt"), ITextWindow);
            _local_4.width = Std.int(_local_4.textWidth);
            _local_4.underline = _arg_2;
            _local_3.width = _local_4.width;
        }

        function _Str_17892(k:String):String
        {
            return (((("quests." + this._data._Str_6549) + ".") + this._data._Str_19427) + ".") + k;
        }

        function _Str_14198(k:String):String
        {
            var _local_2= this._Str_17892(k);
            return ("${" + _local_2) + "}";
        }

        function getText(k:String):String
        {
            return ("${" + k) + "}";
        }

        function onGoButton(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._landingView.goToRoom();
            }
        }

        function onEasyRegion(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.moveChildrenToRow(true);
            }
        }

        function onHardRegion(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.moveChildrenToRow(false);
            }
        }

        public function getQuestName():String
        {
            var k:ASAny = (this._data._Str_5688() + ".name");
            return ("${" + k) + "}";
        }

        function onAcceptButton(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._landingView.send(new ActivateQuestMessageComposer(this._data.id));
            }
        }

        function onNextQuest(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._index++;
                this.moveChildrenToRow(this._data.easy);
            }
        }

        function onCancelQuest(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._landingView.send(new CancelQuestMessageComposer());
            }
        }

        function moveChildrenToRow(k:Bool)
        {
            this._landingView.send(new GetDailyQuestMessageComposer(k, this._index));
        }
public function new(){}
    }

