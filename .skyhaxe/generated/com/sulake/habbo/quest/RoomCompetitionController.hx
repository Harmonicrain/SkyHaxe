package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import com.sulake.core.utils.Map;
    import flash.events.TimerEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication._enum.CompetitionVotingInfoResult;
    import com.sulake.habbo.communication.messages.incoming.competition.CompetitionVotingInfoMessageEvent;
    import com.sulake.habbo.communication.messages.parser.competition.CompetitionEntrySubmitResultMessageParser;
    import com.sulake.habbo.communication.messages.incoming.competition.CompetitionEntrySubmitResultEvent;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.room.utils.Vector3d;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.habbo.communication.messages.outgoing.competition.RoomCompetitionInitMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomEntryInfoMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.competition.SubmitRoomToCompetitionMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.habbo.communication.messages.outgoing.talent.GetTalentTrackMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.competition.VoteForRoomMessageComposer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IItemGridWindow;

     class RoomCompetitionController implements IDisposable implements  IGetImageListener 
    {
        static inline final _Str_13545= 270;
        static inline final _Str_17846= 200;
        static inline final _Str_16853= 4;

        var _window:IWindowContainer;
        var _questEngine:HabboQuestEngine;
        var _goalCode:String;
        var _competitionId:Int = 0;
        var _remainingVotes:Int = 0;
        var _submit:Bool = false;
        var _dontShowAgain:Bool = false;
        var _hideTimer:Timer;
        var _result:Int = 0;
        var _requiredFurniIndexByCallbackId:Map;

        public function new(k:HabboQuestEngine)
        {
            this._hideTimer = new Timer(3000, 1);
            this._requiredFurniIndexByCallbackId = new Map();
            this._questEngine = k;
            this._hideTimer.addEventListener(TimerEvent.TIMER, (this._Str_6823 : ASAny));
        }

        public function dispose()
        {
            this._questEngine = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._hideTimer != null)
            {
                this._hideTimer.removeEventListener(TimerEvent.TIMER, (this._Str_6823 : ASAny));
                this._hideTimer.reset();
                this._hideTimer = null;
            }
            if (this._requiredFurniIndexByCallbackId != null)
            {
                this._requiredFurniIndexByCallbackId.dispose();
                this._requiredFurniIndexByCallbackId = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._window == null;
        }

        function setText(k:IWindow, _arg_2:String, _arg_3:String)
        {
            var _local_4= ((_arg_2 + ".") + _arg_3);
            var _local_5= this._questEngine.localization.getLocalization(_local_4, "");
            if (_local_5 == "")
            {
                _local_4 = _arg_2;
                _local_5 = this._questEngine.localization.getLocalization(_local_4, "");
            }
            if (_local_5 == "")
            {
                k.visible = false;
            }
            else
            {
                k.visible = true;
                this._questEngine.localization.registerParameter(_local_4, "competition_name", this._Str_23583());
                this._questEngine.localization.registerParameter(_local_4, "votes", ("" + Std.string(this._remainingVotes)));
                k.caption = (("${" + _local_4) + "}");
            }
        }

        public function _Str_16392(k:CompetitionVotingInfoMessageEvent)
        {
            this._remainingVotes = k.getParser().votesRemaining;
            var _local_2= k.getParser().isVotingAllowedForUser;
            var _local_3= k.getParser().resultCode;
            this.refreshContent(k.getParser().goalId, false, k.getParser().goalCode, Std.string(_local_3));
            this._Str_6512(((_local_3 == CompetitionVotingInfoResult.REQUIRED_PERK_MISSING) ? this._Str_24392 : this._Str_24761));
            this._Str_4365().procedure = this.onVote;
            this._Str_4365().visible = ((this._remainingVotes > 0) && _local_2);
            this._Str_19349().visible = _local_2;
        }

        public function _Str_17737(k:CompetitionEntrySubmitResultEvent)
        {
            if (k.getParser().result == CompetitionEntrySubmitResultMessageParser.ROOM_TOO_OLD)
            {
                return;
            }
            this.refreshContent(k.getParser().goalId, true, k.getParser().goalCode, ("" + Std.string(k.getParser().result)));
            this._result = k.getParser().result;
            if (this._result == CompetitionEntrySubmitResultMessageParser.ASK_FOR_CONFIRM)
            {
                this._Str_6512(null);
                this._Str_4365().procedure = this.onConfirm;
            }
            else
            {
                if (this._result == CompetitionEntrySubmitResultMessageParser.ASK_FOR_ACCEPT_RULES)
                {
                    this._Str_6512(this._Str_16143);
                    this._Str_4365().procedure = this.onAccept;
                }
                else
                {
                    if (this._result == CompetitionEntrySubmitResultMessageParser.ASK_FOR_SUBMIT)
                    {
                        this._Str_6512(this._Str_16143);
                        this._Str_4365().procedure = this.onSubmit;
                    }
                    else
                    {
                        if (this._result == CompetitionEntrySubmitResultMessageParser.PREREQUISITES_NOT_MET)
                        {
                            this._Str_6512(this._Str_17730);
                            this._Str_4365().visible = false;
                            this._Str_24292(k);
                            this._Str_21297().visible = true;
                        }
                        else
                        {
                            if (this._result == CompetitionEntrySubmitResultMessageParser.SUBMITTED)
                            {
                                this._Str_6512(this._Str_16143);
                                this._Str_4365().procedure = this.onClose;
                            }
                            else
                            {
                                if (this._result == CompetitionEntrySubmitResultMessageParser.ROOM_DOOR_NOT_OPEN)
                                {
                                    this._Str_6512(null);
                                    this._Str_4365().procedure = null;
                                    this._Str_4365().visible = false;
                                }
                                else
                                {
                                    if (this._result == CompetitionEntrySubmitResultMessageParser.ROOM_TOO_OLD)
                                    {
                                        this._Str_6512(null);
                                        this._Str_4365().procedure = this._Str_24144;
                                        this._Str_4365().visible = true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        function _Str_6512(k:ASFunction)
        {
            this._Str_18216().procedure = k;
            this._Str_18216().setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, (!(k == null)));
        }

        public function refreshContent(k:Int, _arg_2:Bool, _arg_3:String, _arg_4:String)
        {
            this._competitionId = k;
            this._goalCode = _arg_3;
            this._submit = _arg_2;
            this.prepare();
            this._Str_22878((_arg_2 ? "submit" : "vote"), _arg_4);
            this._Str_4365().visible = true;
            this._Str_25612();
            this._Str_24091();
            this._Str_21297().visible = false;
            this._window.findChildByName("dont_show_again_container").visible = false;
            this._window.findChildByName("normal_container").visible = true;
        }

        function _Str_25612()
        {
            this._Str_24025().visible = (!this._submit);
            this._Str_25551().visible = this._submit;
        }

        function _Str_24091()
        {
            this._window.visible = true;
            var k= this._window.desktop.rectangle;
            this._window.x = _Str_13545;
            this._window.y = _Str_16853;
            this._window.width = Std.int((k.width - _Str_13545) - _Str_17846);
            this._window.activate();
        }

        function _Str_24292(k:CompetitionEntrySubmitResultEvent)
        {
            var _local_4:String = null;
            var _local_5:Array<ASAny> = null;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_8:IWindowContainer = null;
            var _local_9:ImageResult = null;
            var _local_2= k.getParser().requiredFurnis;
            var _local_3 = 0;
            while (_local_3 < _local_2.length)
            {
                _local_4 = _local_2[_local_3];
                _local_5 = (cast _local_4.split("*"));
                _local_6 = _local_5[0];
                _local_7 = ((_local_5.length > 1) ? _local_5[1] : "");
                _local_8 = this._Str_21902((_local_3 + 1));
                if (_local_4 == null)
                {
                    _local_8.visible = false;
                }
                else
                {
                    _local_8.visible = true;
                    _local_8.findChildByName("tick_icon").visible = (!k.getParser().isMissing(_local_4));
                    _local_9 = this._questEngine.roomEngine.getGenericRoomObjectImage(_local_6, _local_7, new Vector3d(180, 0, 0), 1, this);
                    if (_local_9.id != 0)
                    {
                        this._requiredFurniIndexByCallbackId.add(_local_9.id, _local_3);
                    }
                    this._Str_21013(_local_3, _local_9.data);
                }
                _local_3++;
            }
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if (this._requiredFurniIndexByCallbackId.getValue(k) != null)
            {
                this._Str_21013(ASCompat.toInt(this._requiredFurniIndexByCallbackId.getValue(k)), _arg_2);
                this._requiredFurniIndexByCallbackId.remove(k);
            }
        }

        public function imageFailed(k:Int)
        {
        }

        function _Str_21013(k:Int, _arg_2:BitmapData)
        {
            var _local_3= this._Str_21902((k + 1));
            var _local_4= cast(_local_3.findChildByName("furni_icon"), IBitmapWrapperWindow);
            var _local_5= new BitmapData(_local_4.width, _local_4.height, true, 0);
            if (_arg_2 != null)
            {
                _local_5.copyPixels(_arg_2, _arg_2.rect, new Point(((_local_5.width - _arg_2.width) / 2), ((_local_5.height - _arg_2.height) / 2)));
                _local_4.bitmap = _local_5;
            }
        }

        function _Str_23583():String
        {
            var k:ASAny = (("roomcompetition." + this._goalCode) + ".name");
            return this._questEngine.localization.getLocalization(k, k);
        }

        function _Str_22878(k:String, _arg_2:String)
        {
            this.setText(this._Str_17393(), ("roomcompetition.caption." + k), _arg_2);
            this.setText(this._Str_25844(), ("roomcompetition.info." + k), _arg_2);
            this.setText(this._Str_4365(), ("roomcompetition.button." + k), _arg_2);
            this.setText(this._Str_19349(), ("roomcompetition.buttoninfo." + k), _arg_2);
            this.onResize();
        }

        function onResize()
        {
            this._Str_18216().y = Std.int((this._Str_17393().y + this._Str_17393().textHeight) + 5);
        }

        public function onRoomExit()
        {
            this.close();
        }

        public function onRoomEnter(k:RoomEntryInfoMessageEvent)
        {
            this.close();
            var _local_2= k.getParser();
            var _local_3= ((this._questEngine.getInteger("new.identity", 0) == 0) || (!this._questEngine.getBoolean("new.identity.hide.ui")));
            if (((!this._dontShowAgain) && _local_3))
            {
                this._submit = _local_2.owner;
                this._questEngine.send(new RoomCompetitionInitMessageComposer());
            }
        }

        public function sendRoomCompetitionInit()
        {
            this._questEngine.send(new RoomCompetitionInitMessageComposer());
        }

        public function _Str_21523()
        {
            if ((((!(this._window == null)) && this._window.visible) && this._submit))
            {
                this._questEngine.send(new SubmitRoomToCompetitionMessageComposer(this._goalCode, SubmitRoomToCompetitionMessageComposer.CONFIRM_LEVEL_NOT_ACCEPTED));
            }
        }

        function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
            this._goalCode = "";
        }

        function prepare()
        {
            var k = 0;
            if (this._window == null)
            {
                k = 1;
                this._window = cast(this._questEngine.getXmlWindow("RoomCompetition", k), IWindowContainer);
                this._window.findChildByName("close_region").procedure = this.onClose;
                this._questEngine.windowManager.getWindowContext(k).getDesktopWindow().addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onDesktopResized);
                this._window.findChildByName("dont_show_again_region").procedure = this._Str_24295;
            }
        }

        function _Str_17730(k:WindowEvent, _arg_2:IWindow=null)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._questEngine.catalog.openCatalogPage(this._questEngine.getProperty((("competition." + this._goalCode) + ".catalogPage")));
            }
        }

        function _Str_24144(k:WindowEvent, _arg_2:IWindow=null)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._questEngine.navigator.open();
            }
        }

        function _Str_16143(k:WindowEvent, _arg_2:IWindow=null)
        {
            var _local_3:HabboToolbarEvent = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = new HabboToolbarEvent(HabboToolbarEvent.HTE_TOOLBAR_CLICK);
                _local_3.iconId = HabboToolbarIconEnum.RECEPTION;
                this._questEngine.toolbar.events.dispatchEvent(_local_3);
            }
        }

        function _Str_24761(k:WindowEvent, _arg_2:IWindow=null)
        {
        }

        function _Str_24392(k:WindowEvent, _arg_2:IWindow=null)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._questEngine.tracking.trackTalentTrackOpen(this._questEngine.sessionDataManager.currentTalentTrack, "roomcompetition");
                this._questEngine.send(new GetTalentTrackMessageComposer(this._questEngine.sessionDataManager.currentTalentTrack));
            }
        }

        function onAccept(k:WindowEvent, _arg_2:IWindow=null)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._questEngine.send(new SubmitRoomToCompetitionMessageComposer(this._goalCode, SubmitRoomToCompetitionMessageComposer.CONFIRM_LEVEL_NOT_SUBMITTED));
            }
        }

        function onSubmit(k:WindowEvent, _arg_2:IWindow=null)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._questEngine.send(new SubmitRoomToCompetitionMessageComposer(this._goalCode, SubmitRoomToCompetitionMessageComposer.CONFIRM_LEVEL_NOT_CONFIRMED));
            }
        }

        function onConfirm(k:WindowEvent, _arg_2:IWindow=null)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._questEngine.send(new SubmitRoomToCompetitionMessageComposer(this._goalCode, SubmitRoomToCompetitionMessageComposer.CONFIRM_LEVEL_COMMIT));
            }
        }

        function onVote(k:WindowEvent, _arg_2:IWindow=null)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._questEngine.send(new VoteForRoomMessageComposer(this._goalCode));
            }
        }

        function onClose(k:WindowEvent, _arg_2:IWindow=null)
        {
            var _local_3:String = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                if ((this._submit && (this._result == CompetitionEntrySubmitResultMessageParser.SUBMITTED)))
                {
                    this.close();
                    return;
                }
                _local_3 = ("roomcompetition.dontshowagain.info." + (this._submit ? "submit" : "vote"));
                this._window.findChildByName("dont_show_info_txt").caption = this._questEngine.localization.getLocalization(_local_3, _local_3);
                this._window.findChildByName("dont_show_again_container").visible = true;
                this._window.findChildByName("normal_container").visible = false;
                this._hideTimer.reset();
                this._hideTimer.start();
            }
        }

        function _Str_24295(k:WindowEvent, _arg_2:IWindow=null)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._dontShowAgain = true;
                this.close();
            }
        }

        function _Str_18216():IWindow
        {
            return this._window.findChildByName("info_region");
        }

        function _Str_25844():IWindow
        {
            return this._window.findChildByName("info_txt");
        }

        function _Str_19349():IWindow
        {
            return this._window.findChildByName("button_info_txt");
        }

        function _Str_4365():IWindow
        {
            return this._window.findChildByName("action_button");
        }

        function _Str_17393():ITextWindow
        {
            return cast(this._window.findChildByName("caption_txt"), ITextWindow);
        }

        function _Str_21297():IWindow
        {
            return this._window.findChildByName("required_furnis_itemgrid");
        }

        function _Str_24025():IWindow
        {
            return this._window.findChildByName("vote_image");
        }

        function _Str_25551():IWindow
        {
            return this._window.findChildByName("submit_image");
        }

        function _Str_21902(k:Int):IWindowContainer
        {
            var _local_4 = 0;
            var _local_2= cast(this._window.findChildByName("required_furnis_itemgrid"), IItemGridWindow);
            var _local_3= cast(_local_2.getGridItemAt(0), IWindowContainer);
            if (_local_2.numGridItems < (k : UInt))
            {
                _local_4 = 0;
                while ((_local_4 : UInt) < (k - _local_2.numGridItems))
                {
                    _local_2.addGridItem(_local_3.clone());
                    _local_4++;
                }
            }
            return cast(_local_2.getGridItemAt((k - 1)), IWindowContainer);
        }

        function onDesktopResized(k:WindowEvent)
        {
            if (((!(this._window == null)) && this._window.visible))
            {
                this.onResize();
            }
        }

        public var _Str_23471(never,set):Bool;
public function  set__Str_23471(k:Bool):Bool        {
            return this._dontShowAgain = k;
        }

        function _Str_6823(k:TimerEvent)
        {
            this.close();
        }
    }

