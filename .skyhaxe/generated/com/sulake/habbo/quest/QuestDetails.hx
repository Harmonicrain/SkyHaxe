package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import flash.geom.Point;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.outgoing.quest.AcceptQuestMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.quest.ActivateQuestMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.quest.RejectQuestMessageComposer;

     class QuestDetails implements IDisposable 
    {
        static inline final _Str_7408= 56;
        static inline final _Str_2942= 5;
        static inline final _Str_8154= 5;
        static final _Str_15189:Point = new Point(8, 8);
        static final _Str_17957:Array<ASAny> = ["PLACE_ITEM", "PLACE_FLOOR", "PLACE_WALLPAPER", "PET_DRINK", "PET_EAT"];

        var _questEngine:HabboQuestEngine;
        var _window:IFrameWindow;
        var _openForNextQuest:Bool = false;
        var _quest:QuestMessageData;
        var _msecsToRefresh:Int = 0;
        var _goToRoomsOnActivate:Bool = false;

        public function new(k:HabboQuestEngine)
        {
            this._questEngine = k;
        }

        public function dispose()
        {
            this._questEngine = null;
            this._quest = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._questEngine == null;
        }

        public function _Str_4750(k:QuestMessageData)
        {
            if (this._openForNextQuest)
            {
                this._openForNextQuest = false;
                this._Str_8199(k);
            }
            else
            {
                if (((this._quest == null) || (!(this._quest.id == k.id))))
                {
                    this.close();
                }
            }
        }

        public function _Str_5657(k:QuestMessageData)
        {
            this.close();
        }

        public function _Str_5242()
        {
            this.close();
        }

        public function onRoomExit()
        {
            this.close();
        }

        function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        public function _Str_5386(k:QuestMessageData)
        {
            if (((this._window != null) && this._window.visible))
            {
                this._window.visible = false;
                return;
            }
            this._Str_8199(k);
        }

        public function _Str_8199(k:QuestMessageData, _arg_2:Bool=false)
        {
            var _local_9:IWindowContainer = null;
            this._quest = k;
            if (k == null)
            {
                return;
            }
            this._goToRoomsOnActivate = _arg_2;
            if (this._window == null)
            {
                this._window = cast(this._questEngine.getXmlWindow("QuestDetails"), IFrameWindow);
                this._window.findChildByTag("close").procedure = this._Str_25061;
                this._window.center();
                _local_9 = this._questEngine._Str_3398._Str_12832._Str_19203(this._Str_17443, this.onCancelQuest);
                _local_9.x = Std.int(_Str_15189.x);
                _local_9.y = Std.int(_Str_15189.y);
                this._window.content.addChild(_local_9);
                this._window.findChildByName("link_region").procedure = this._Str_24196;
            }
            _local_9 = cast(this._window.findChildByName("entry_container"), IWindowContainer);
            this._questEngine._Str_3398._Str_12832.refreshEntryDetails(_local_9, k);
            var _local_3:ASAny = (this._quest._Str_3935 > 0);
            var _local_4= cast(_local_9.findChildByName("hint_txt"), ITextWindow);
            var _local_5= this._Str_21971(_local_4);
            if (!_local_3)
            {
                _local_4.caption = this._questEngine._Str_23561(k);
                _local_4.height = Std.int(_local_4.textHeight + _Str_8154);
            }
            _local_4.visible = (!_local_3);
            var _local_6= (this._Str_21971(_local_4) - _local_5);
            var _local_7= this._Str_23863("link_region", ((_local_4.y + _local_4.height) + _Str_2942));
            var _local_8= cast(_local_9.findChildByName("quest_container"), IWindowContainer);
            _local_8.height = (_local_8.height + (_local_6 + _local_7));
            this._questEngine._Str_3398._Str_12832._Str_19570(_local_9);
            this._window.height = (_local_9.height + _Str_7408);
            this._window.visible = true;
            this._window.activate();
        }

        function _Str_23863(k:String, _arg_2:Int):Int
        {
            var _local_3= this._Str_20872();
            var _local_4= ((!_local_3) && this._Str_19961());
            var _local_5= (((!_local_3) && (!_local_4)) && this._Str_24222());
            var _local_6= ((_local_3 || _local_4) || _local_5);
            var _local_7= cast(this._window.findChildByName(k), IRegionWindow);
            _local_7.y = _arg_2;
            var _local_8 = 0;
            if ((_local_6 && (!_local_7.visible)))
            {
                _local_8 = (_Str_2942 + _local_7.height);
            }
            if (((!_local_6) && _local_7.visible))
            {
                _local_8 = (-_Str_2942 - _local_7.height);
            }
            _local_7.visible = _local_6;
            _local_7.findChildByName("link_catalog").visible = _local_3;
            _local_7.findChildByName("link_navigator").visible = _local_4;
            _local_7.findChildByName("link_room").visible = _local_5;
            return _local_8;
        }

        function _Str_20872():Bool
        {
            return (this._quest._Str_3935 < 1) && (_Str_17957.indexOf(this._quest.type) > -1);
        }

        function _Str_19961():Bool
        {
            var k= this._questEngine._Str_17631((this._quest._Str_9246() + ".searchtag"));
            var _local_2= this._questEngine._Str_17631((this._quest._Str_9246() + ".searchtag"));
            return (this._quest._Str_3935 < 1) && (k || _local_2);
        }

        function _Str_24222():Bool
        {
            return ((this._quest._Str_3935 < 1) && this._questEngine._Str_7575(this._quest)) && this._questEngine.hasQuestRoomsIds();
        }

        function _Str_21971(k:ITextWindow):Int
        {
            return k.visible ? k.height : 0;
        }

        function _Str_25061(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._window.visible = false;
            }
        }

        public var _Str_19749(never,set):Bool;
public function  set__Str_19749(k:Bool):Bool        {
            return this._openForNextQuest = k;
        }

        function _Str_24196(k:WindowEvent, _arg_2:IWindow=null)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (this._Str_20872())
                {
                    this._questEngine.openCatalog(this._quest);
                }
                else
                {
                    if (this._Str_19961())
                    {
                        this._questEngine.openNavigator(this._quest);
                    }
                    else
                    {
                        this._questEngine.goToQuestRooms();
                    }
                }
            }
        }

        public function update(k:UInt)
        {
            if (((this._window == null) || (!this._window.visible)))
            {
                return;
            }
            this._msecsToRefresh = ASCompat.toInt(this._msecsToRefresh - k);
            if (this._msecsToRefresh > 0)
            {
                return;
            }
            this._msecsToRefresh = NextQuestTimer._Str_10934;
            var _local_2= this._questEngine._Str_3398._Str_12832._Str_17692(this._window, this._quest);
            if (_local_2)
            {
                this._Str_8199(this._quest, this._goToRoomsOnActivate);
            }
        }

        function _Str_17443(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (this._questEngine._Str_6927)
                {
                    this._questEngine.send(new AcceptQuestMessageComposer(this._quest.id));
                }
                else
                {
                    this._questEngine.send(new ActivateQuestMessageComposer(this._quest.id));
                }
                this._window.visible = false;
                this._questEngine._Str_3398._Str_13628.close();
                if ((this._goToRoomsOnActivate && this._questEngine._Str_7575(this._quest)))
                {
                    this._questEngine.goToQuestRooms();
                }
            }
        }

        function onCancelQuest(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._questEngine.send(new RejectQuestMessageComposer());
            }
        }
    }

