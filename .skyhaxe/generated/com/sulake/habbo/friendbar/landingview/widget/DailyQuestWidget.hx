package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISlotAwareWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces._Str_6397;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
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

     class DailyQuestWidget implements IDisposable implements  ILandingViewWidget implements  ISlotAwareWidget implements  _Str_6397 
    {
        var _landingView:HabboLandingView;
        var _container:IWindowContainer;
        var _data:QuestMessageData;
        var _easyQuestCount:Int = 0;
        var _hardQuestCount:Int = 0;
        var _index:Int = 0;
        var _hrdLineEndOrg:Int = 0;
        var _slot:Int = 0;
        var _configurationCode:String;

        public function new(k:HabboLandingView)
        {
            this._landingView = k;
        }

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


        public var _Str_12275(never,set):String;
public function  set__Str_12275(k:String):String        {
            return this._configurationCode = k;
        }

        public var slot(never,set):Int;
public function  set_slot(k:Int):Int        {
            return this._slot = k;
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._container;
        }

        public function dispose()
        {
            this._landingView = null;
            this._container = null;
            this._data = null;
        }

        public function initialize()
        {
            this._container = cast(this._landingView.getXmlWindow("daily_quest"), IWindowContainer);
            this._landingView.communicationManager.addHabboConnectionMessageEvent(new QuestDailyMessageEvent(this._Str_17705));
            this._container.findChildByName("accept_button").procedure = this.onAcceptButton;
            this._container.findChildByName("go_button").procedure = this.onGoButton;
            this._container.findChildByName("next_quest_region").procedure = this.onNextQuest;
            this._container.findChildByName("cancel_quest_region").procedure = this.onCancelQuest;
            this._container.findChildByName("easy_region").procedure = this.onEasyRegion;
            this._container.findChildByName("hard_region").procedure = this.onHardRegion;
            var k= this._container.findChildByName("hdr_line");
            this._hrdLineEndOrg = (k.x + k.width);
            GenericWidget._Str_18803(this._landingView, this._slot, this._configurationCode, this._container);
        }

        public function refresh()
        {
            this._index = 0;
            this._landingView.send(new GetDailyQuestMessageComposer(true, 0));
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._landingView == null;
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
            this._container.findChildByName("info_txt").caption = ((this._data != null) ? this._Str_14198("chaininfo") : this.getText("landing.view.quest.currenttask.alldone.info"));
            this._container.findChildByName("accept_button").visible = ((this._data != null) && (!this._data.accepted));
            this._container.findChildByName("next_quest_region").visible = (((this._data != null) && (!this._data.accepted)) && ((this._data.easy ? this._easyQuestCount : this._hardQuestCount) > 1));
            this._container.findChildByName("next_quest_txt").caption = this.getText(("landing.view.quest.nextquest." + (((this._data != null) && this._data.easy) ? "easy" : "hard")));
            this._container.findChildByName("title_txt").caption = this.getText(("landing.view.quest.title." + (((this._data != null) && this._data.accepted) ? "accepted" : "notaccepted")));
            HabboLandingView._Str_9079(this._container, "title_txt", "hdr_line");
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
            var _local_3= this._container.findChildByName("hdr_line");
            var _local_4= (k.visible ? (k.x - 5) : this._hrdLineEndOrg);
            _local_3.width = (_local_4 - _local_3.x);
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
    }

