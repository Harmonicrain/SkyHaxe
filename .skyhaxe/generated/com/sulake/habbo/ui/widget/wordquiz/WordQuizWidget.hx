package com.sulake.habbo.ui.widget.wordquiz
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import flash.utils.Timer;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.ui.widget.events.RoomWidgetWordQuizUpdateEvent;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.session.events.RoomSessionWordQuizEvent;
    import com.sulake.habbo.ui.handler.WordQuizWidgetHandler;
    import flash.geom.Rectangle;
    import flash.events.TimerEvent;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetPollMessage;

     class WordQuizWidget extends RoomWidgetBase
    {
        static inline final WORDQUIZ_LIKE_XML= "wordquiz_like_xml";
        static inline final WORDQUIZ_UNLIKE_XML= "wordquiz_unlike_xml";
        static inline final SIGN_FADE_IN_TIME= 750;
        static inline final SIGN_FADE_OUT_TIME= 750;
        static inline final UPDATE_FREQUENCY= 40;
        public static inline final VALUE_KEY_DISLIKE= "0";
        public static inline final VALUE_KEY_LIKE= "1";

        var _view:WordQuizView;
        var _countdownUpTimer:Timer;
        var _countdownDownTimer:Timer;
        var _moveTimer:Timer;
        var _textIndex:Int = 0;
        var _showResultTime:Int = 0;
        var _countdown:Int = 0;
        var _pollId:Int = 0;
        var _question:ASDictionary<ASAny,ASAny>;
        var _currentQuestionId:Int = 0;
        var _showSignCounters:ASDictionary<ASAny,ASAny>;
        var _answerWindows:Vector<IWindowContainer>;
        var _yesWindowPool:Vector<IWindowContainer>;
        var _noWindowPool:Vector<IWindowContainer>;
        var _answerSent:Bool = false;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager)
        {
            this._showSignCounters = new ASDictionary<ASAny,ASAny>();
            this._answerWindows = new Vector<IWindowContainer>(0);
            this._yesWindowPool = new Vector<IWindowContainer>(0);
            this._noWindowPool = new Vector<IWindowContainer>(0);
            super(this.handler, _arg_2, _arg_3, _arg_4);
            _handler = k;
            this._view = new WordQuizView(this);
            this._showResultTime = (this.handler.container.config.getInteger("poll.word.quiz.answer.bubble.seconds", 3) * 1000);
        }

        override public function  get_mainWindow():IWindow
        {
            return (this._view != null) ? this._view.mainWindow : null;
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(RoomWidgetWordQuizUpdateEvent.RWPUW_NEW_QUESTION, this.newQuestion);
            k.addEventListener(RoomWidgetWordQuizUpdateEvent.RWPUW_QUESTION_ANSWERED, this.answeredQuestion);
            k.addEventListener(RoomWidgetWordQuizUpdateEvent.RWPUW_QUESION_FINSIHED, this.questionFinished);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(RoomSessionWordQuizEvent.RWPUW_NEW_QUESTION, this.newQuestion);
            k.removeEventListener(RoomSessionWordQuizEvent.RWPUW_QUESTION_ANSWERED, this.answeredQuestion);
            k.removeEventListener(RoomSessionWordQuizEvent.RWPUW_QUESION_FINSIHED, this.questionFinished);
            super.unregisterUpdateEvents(k);
        }

        public var handler(get,never):WordQuizWidgetHandler;
public function  get_handler():WordQuizWidgetHandler
        {
            return Std.downcast(_handler , WordQuizWidgetHandler);
        }

        override public function dispose()
        {
            var k:IWindowContainer = null;
            var _local_2 = 0;
            if (disposed)
            {
                return;
            }
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            if (this._countdownUpTimer != null)
            {
                this._countdownUpTimer.reset();
                this._countdownUpTimer = null;
            }
            if (this._countdownDownTimer != null)
            {
                this._countdownDownTimer.reset();
                this._countdownDownTimer = null;
            }
            if (this._moveTimer != null)
            {
                this._moveTimer.reset();
                this._moveTimer = null;
            }
            if (windowManager != null)
            {
                if (this._answerWindows != null)
                {
                    _local_2 = 0;
                    while (_local_2 < this._answerWindows.length)
                    {
                        k = this._answerWindows[_local_2] ;
                        if (k != null)
                        {
                            windowManager.removeWindow(k.name);
                        }
                        _local_2++;
                    }
                }
                final _iter_ = this._yesWindowPool; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    k.destroy();
                }
                this._yesWindowPool.length = 0;
                final _iter_ = this._noWindowPool; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    k.destroy();
                }
                this._noWindowPool.length = 0;
            }
            super.dispose();
        }

        function newQuestion(k:RoomWidgetWordQuizUpdateEvent)
        {
            this._pollId = k.id;
            this._question = k.question;
            this._answerSent = false;
            this._showSignCounters = new ASDictionary<ASAny,ASAny>();
            this.showNewQuestion(this._question, k.duration);
        }

        function questionFinished(k:RoomWidgetWordQuizUpdateEvent)
        {
            this.clearTimers();
            if ((((this._view != null) && (this._question != null)) && (this._question["id"] == k.questionId)))
            {
                this._view.displayResults(k.answerCounts);
            }
            var _local_2 = 0;
            while (_local_2 < this._answerWindows.length)
            {
                this.poolWindow(this._answerWindows[_local_2].name);
                _local_2++;
            }
            this._answerWindows.length = 0;
        }

        function poolWindow(k:String)
        {
            if (windowManager == null)
            {
                return;
            }
            windowManager.removeWindow(k);
        }

        function answeredQuestion(k:RoomWidgetWordQuizUpdateEvent)
        {
            var _local_7:IWindowContainer = null;
            if (this._view != null)
            {
                this._view.updateResults(k.answerCounts);
            }
            var _local_2= k.userId;
            var _local_3= k.value;
            var _local_4= ((_local_3 == VALUE_KEY_LIKE) ? this._yesWindowPool : this._noWindowPool);
            var _local_5= ((_local_3 == VALUE_KEY_LIKE) ? WORDQUIZ_LIKE_XML : WORDQUIZ_UNLIKE_XML);
            var _local_6= ((((Std.string(this._pollId) + "_") + Std.string(_local_2)) + "_") + _local_5);
            if (_local_4.length != 0)
            {
                _local_7 = _local_4.pop();
            }
            else
            {
                _local_7 = Std.downcast(windowManager.buildFromXML(((assets.getAssetByName(_local_5).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            }
            _local_7.name = _local_6;
            this._answerWindows.push(_local_7);
            this._showSignCounters[_local_6] = ((this._showResultTime + SIGN_FADE_IN_TIME) + SIGN_FADE_OUT_TIME);
            var _local_8= this.getAvatarRect(_local_2);
            if (_local_8 != null)
            {
                _local_7.x = Std.int(_local_8.left + 20);
                _local_7.y = Std.int(_local_8.top - 20);
            }
            if (this._moveTimer == null)
            {
                this._moveTimer = new Timer(UPDATE_FREQUENCY);
                this._moveTimer.addEventListener(TimerEvent.TIMER, (this.onLocationTimer : ASAny));
                this._moveTimer.start();
            }
            var _local_9= Std.downcast(_local_7.getChildByName("colored") , IBorderWindow);
            if (_local_9 != null)
            {
                _local_9.blend = 0;
            }
        }

        function onLocationTimer(k:TimerEvent)
        {
            var _local_3:IWindowContainer = null;
            var _local_4:Array<ASAny> = null;
            var _local_5 = 0;
            var _local_6:Rectangle = null;
            var _local_2 = 0;
            while (_local_2 < this._answerWindows.length)
            {
                _local_3 = this._answerWindows[_local_2];
                if (_local_3 != null)
                {
                    _local_4 = (cast this._answerWindows[_local_2].name.split("_"));
                    if (_local_4.length > 1)
                    {
                        _local_5 = ASCompat.toInt(_local_4[1]);
                        _local_6 = this.getAvatarRect(_local_5);
                        if (_local_6 != null)
                        {
                            _local_3.x = Std.int(_local_6.left + 29);
                            _local_3.y = Std.int(_local_6.top - 11);
                        }
                        else
                        {
                            this.poolWindow(this._answerWindows[_local_2].name);
                            return;
                        }
                        this.handleSignWindowVisibility(_local_3);
                    }
                }
                _local_2++;
            }
        }

        function handleSignWindowVisibility(k:IWindowContainer)
        {
            var _local_4 = Math.NaN;
            var _local_5 = 0;
            var _local_2= Std.downcast(k.getChildByName("colored") , IBorderWindow);
            var _local_3= Std.downcast(k.getChildByName("button_like") , IRegionWindow);
            if (((this._showSignCounters.exists(k.name) && (_local_2 != null)) && (_local_3 != null)))
            {
                _local_5 = ASCompat.toInt(this._showSignCounters[k.name]);
                _local_5 = (_local_5 - UPDATE_FREQUENCY);
                this._showSignCounters[k.name] = _local_5;
                if (_local_5 > (this._showResultTime + SIGN_FADE_OUT_TIME))
                {
                    _local_4 = ((SIGN_FADE_IN_TIME / UPDATE_FREQUENCY) * 0.01);
                    _local_2.blend = (_local_2.blend + _local_4);
                    _local_3.blend = _local_2.blend;
                }
                else
                {
                    if (_local_5 > SIGN_FADE_OUT_TIME)
                    {
                        _local_2.blend = 1;
                        _local_3.blend = 1;
                    }
                    else
                    {
                        if (((_local_5 < SIGN_FADE_OUT_TIME) && (_local_5 > 0)))
                        {
                            _local_4 = (SIGN_FADE_OUT_TIME / UPDATE_FREQUENCY);
                            k.blend = (k.blend - (_local_4 * 0.01));
                            k.y = Std.int(k.y - (20 + (70 - (k.blend * 120))));
                        }
                        else
                        {
                            if (_local_5 < 0)
                            {
                                k.y = Std.int(k.y - (20 + (70 - (k.blend * 120))));
                                this.poolWindow(k.name);
                            }
                        }
                    }
                }
            }
        }

        function getAvatarRect(k:Int):Rectangle
        {
            if (((((!(this.handler != null)) || (!(this.handler.container != null))) || (!(this.handler.container.roomSession != null))) || (!(this.handler.container.roomEngine != null))))
            {
                return null;
            }
            var _local_2= this.handler.container.roomSession.roomId;
            var _local_3= this.handler.container.roomSessionManager.getSession(_local_2).userDataManager.getUserData(k);
            if (_local_3 != null)
            {
                return this.handler.container.roomEngine.getRoomObjectBoundingRectangle(_local_2, _local_3.roomObjectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER, this.handler.container.getFirstCanvasId());
            }
            return null;
        }

        function onCountdownDownTimer(k:TimerEvent)
        {
            if (this._countdownDownTimer == null)
            {
                return;
            }
            this._countdown--;
            this._view.updateCounter(Std.string(this._countdown));
            if (this._countdown == 0)
            {
                this.clearTimers();
                this._view.removeWindow();
            }
        }

        function showNewQuestion(k:ASDictionary<ASAny,ASAny>, _arg_2:Int)
        {
            if (k == null)
            {
                return;
            }
            this._view.createWindow(WordQuizView.STATE_QUESTION, k["content"]);
            this._textIndex++;
            this._countdown = 4;
            this._currentQuestionId = ASCompat.toInt(k["id"]);
            if (_arg_2 > 0)
            {
                this._countdownDownTimer = new Timer(1000);
                this._countdown = Std.int(_arg_2 / 1000);
                this._countdownDownTimer.addEventListener(TimerEvent.TIMER, (this.onCountdownDownTimer : ASAny));
                this._countdownDownTimer.start();
                this._moveTimer = new Timer(UPDATE_FREQUENCY);
                this._moveTimer.addEventListener(TimerEvent.TIMER, (this.onLocationTimer : ASAny));
                this._moveTimer.start();
                this._view.updateCounter(Std.string(this._countdown));
            }
        }

        function clearTimers()
        {
            if (this._countdownDownTimer != null)
            {
                this._countdownDownTimer.reset();
                this._countdownDownTimer = null;
            }
            if (this._moveTimer != null)
            {
                this._moveTimer.reset();
                this._moveTimer = null;
            }
        }

        public function sendAnswer(k:Int)
        {
            this._view.removeWindow();
            if (this._answerSent)
            {
                return;
            }
            var _local_2= new RoomWidgetPollMessage(RoomWidgetPollMessage.RWPM_ANSWER, this._pollId);
            _local_2.questionId = ASCompat.asInt(this._question["id"] );
            var _local_3:Array<ASAny> = [];
            _local_3.push(("" + Std.string(k)));
            _local_2.answers = _local_3;
            messageListener.processWidgetMessage(_local_2);
            this._answerSent = true;
            this._view.createWindow(WordQuizView.STATE_RESULT);
        }
    }

