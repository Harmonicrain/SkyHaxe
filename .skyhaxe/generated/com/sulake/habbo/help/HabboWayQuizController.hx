package com.sulake.habbo.help
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ISelectorListWindow;
    import com.sulake.core.window.components.ISelectableWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.help.QuizDataMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.QuizResultsMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.help.GetQuizQuestionsComposer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.help.PostQuizAnswersComposer;

     class HabboWayQuizController implements IDisposable 
    {
        static inline final HABBO_WAY_QUIZ_CODE= "HabboWay1";
        static inline final SAFETY_QUIZ_CODE= "SafetyQuiz1";
        static inline final PAGE_QUESTION= 1;
        static inline final PAGE_SUCCESS= 2;
        static inline final PAGE_FAILURE= 3;
        static inline final PAGE_ANALYSIS= 4;

        var _disposed:Bool = false;
        var _habboHelp:HabboHelp;
        var _dialog:IModalDialog;
        var _window:IWindowContainer;
        var _questionPane:IWindowContainer;
        var _answerList:ISelectorListWindow;
        var _answerTemplate:ISelectableWindow;
        var _analysisPane:IItemListWindow;
        var _explanationTemplate:IWindow;
        var _quizCode:String;
        var _questionIds:Array<ASAny>;
        var _answerIds:Array<ASAny>;
        var _answerOrders:Array<ASAny>;
        var _questionIdsForWrongAnswers:Array<ASAny>;
        var _currentQuestion:Int = 0;

        public function new(k:HabboHelp)
        {
            this._habboHelp = k;
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new QuizDataMessageEvent(this.onQuizData));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new QuizResultsMessageEvent(this.onQuizResults));
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._questionPane = null;
                this._answerList = null;
                if (this._answerTemplate != null)
                {
                    this._answerTemplate.dispose();
                    this._answerTemplate = null;
                }
                this._analysisPane = null;
                if (this._explanationTemplate != null)
                {
                    this._explanationTemplate.dispose();
                    this._explanationTemplate = null;
                }
                this.closeWindow();
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function showHabboWayQuiz()
        {
            this._habboHelp.sendMessage(new GetQuizQuestionsComposer(HABBO_WAY_QUIZ_CODE));
        }

        public function showSafetyQuiz()
        {
            this._habboHelp.sendMessage(new GetQuizQuestionsComposer(SAFETY_QUIZ_CODE));
        }

        function onQuizData(k:QuizDataMessageEvent)
        {
            var _local_2= k.getParser();
            this._habboHelp._Str_24844();
            this._habboHelp._Str_21195();
            this.showWindow(_local_2._Str_21852, _local_2._Str_25814);
        }

        function onQuizResults(k:QuizResultsMessageEvent)
        {
            var _local_2= k.getParser();
            this._questionIdsForWrongAnswers = _local_2._Str_23947;
            if (this._questionIdsForWrongAnswers.length == 0)
            {
                this.showPage(PAGE_SUCCESS);
            }
            else
            {
                this.showPage(PAGE_FAILURE);
            }
        }

        function showWindow(k:String, _arg_2:Array<ASAny>)
        {
            this.closeWindow();
            this._dialog = this._habboHelp.getModalXmlWindow("habbo_way_quiz");
            this._window = cast(this._dialog.rootWindow, IWindowContainer);
            this._window.procedure = this.onWindowEvent;
            this._questionPane = cast(this._window.findChildByName("question_pane"), IWindowContainer);
            this._answerList = cast(this._questionPane.findChildByName("answer_list"), ISelectorListWindow);
            this._answerTemplate = this._answerList.getSelectableAt(0);
            this._answerList.removeSelectable(this._answerTemplate);
            this._analysisPane = cast(this._window.findChildByName("analysis_pane"), IItemListWindow);
            this._explanationTemplate = this._analysisPane.getListItemAt(0);
            this._analysisPane.removeListItems();
            this._analysisPane.spacing = 4;
            this._quizCode = k;
            this._questionIds = _arg_2;
            this._answerIds = ASCompat.allocArray(this.questionCount);
            this._answerOrders = ASCompat.allocArray(this.questionCount);
            this.setCurrentQuestion(0);
            var _local_3= cast(cast(this._explanationTemplate, IItemListWindow).getListItemByName("explanation_container"), IWindowContainer);
            switch (this._quizCode)
            {
                case HABBO_WAY_QUIZ_CODE:
                    cast(this._window.findChildByName("question_illustration"), IStaticBitmapWrapperWindow).assetUri = "${image.library.url}habboway/quiz_question.png";
                    cast(this._window.findChildByName("indicator_image"), IStaticBitmapWrapperWindow).assetUri = "help_habboway_dove_on";
                    cast(this._window.findChildByName("success_illustration"), IStaticBitmapWrapperWindow).assetUri = "${image.library.url}habboway/quiz_success.png";
                    cast(_local_3.findChildByName("explanation_illustration"), IStaticBitmapWrapperWindow).assetUri = "help_habboway_dove_quizz";
                    
                case SAFETY_QUIZ_CODE:
                    cast(this._window.findChildByName("question_illustration"), IStaticBitmapWrapperWindow).assetUri = "${image.library.url}safetyquiz/question_illustration.png";
                    cast(this._window.findChildByName("indicator_image"), IStaticBitmapWrapperWindow).assetUri = "${image.library.url}safetyquiz/safety_on.png";
                    cast(this._window.findChildByName("failure_illustration"), IStaticBitmapWrapperWindow).assetUri = "${image.library.url}safetyquiz/result_failure.png";
                    cast(this._window.findChildByName("success_illustration"), IStaticBitmapWrapperWindow).assetUri = "${image.library.url}safetyquiz/result_success.png";
                    cast(_local_3.findChildByName("explanation_illustration"), IStaticBitmapWrapperWindow).assetUri = "${image.library.url}safetyquiz/safety_on.png";
                    
            }
            this.showPage(PAGE_QUESTION);
        }

        function closeWindow()
        {
            this._window = null;
            if (this._dialog != null)
            {
                this._dialog.dispose();
                this._dialog = null;
            }
        }

        function showPage(k:Int)
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:IItemListWindow = null;
            var _local_8:String = null;
            var _local_9:String = null;
            this._window.findChildByName("question_pane").visible = (k == PAGE_QUESTION);
            this._window.findChildByName("success_pane").visible = (k == PAGE_SUCCESS);
            this._window.findChildByName("failure_pane").visible = (k == PAGE_FAILURE);
            this._analysisPane.visible = (k == PAGE_ANALYSIS);
            this._window.findChildByName("prev_next_buttons").visible = (k == PAGE_QUESTION);
            this._window.findChildByName("failure_buttons").visible = (k == PAGE_FAILURE);
            this._window.findChildByName("exit_button_container").visible = ((k == PAGE_SUCCESS) || (k == PAGE_ANALYSIS));
            var _local_2= this._window.findChildByName("top_indicator");
            var _local_3= this._window.findChildByName("indicator_image");
            switch (k)
            {
                case PAGE_QUESTION:
                    this._window.caption = this.getFullLocalizationKey("question.title");
                    _local_3.visible = true;
                    _local_2.visible = true;
                    _local_2.caption = this._habboHelp.localization.getLocalizationWithParams(this.getRawLocalizationKey("question.page"), "", ["current_page", 1, "page_count", Std.string(this.questionCount)]);
                    _local_2.caption = this.getFullLocalizationKey("question.page");
                    return;
                case PAGE_SUCCESS:
                    this._window.caption = this.getFullLocalizationKey("success.title");
                    this._window.findChildByName("failure_advice").caption = this.getFullLocalizationKey("failure.advice");
                    this._window.findChildByName("success_results").caption = this._habboHelp.localization.getLocalizationWithParams(this.getRawLocalizationKey("success.results"), "", ["question_count", Std.string(this.questionCount)]);
                    _local_3.visible = false;
                    _local_2.visible = false;
                    _local_2.caption = "";
                    return;
                case PAGE_FAILURE:
                    _local_4 = (this._questionIds.length - this._questionIdsForWrongAnswers.length);
                    this._window.caption = this.getFullLocalizationKey("failure.title");
                    this._window.findChildByName("failure_advice").caption = this.getFullLocalizationKey("failure.advice");
                    this._window.findChildByName("failure_results").caption = this._habboHelp.localization.getLocalizationWithParams(this.getRawLocalizationKey("failure.results"), "", ["correct_count", Std.string(_local_4), "total_count", Std.string(this.questionCount)]);
                    _local_3.visible = false;
                    _local_2.visible = false;
                    _local_2.caption = "";
                    return;
                case PAGE_ANALYSIS:
                    this._window.caption = this.getFullLocalizationKey("analysis.title");
                    _local_3.visible = true;
                    _local_2.visible = true;
                    _local_2.caption = this.getFullLocalizationKey("analysis.top");
                    final _iter_ = this._questionIdsForWrongAnswers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_5  = ASCompat.toInt(_tmp_);
                        _local_6 = ASCompat.toInt(this._answerIds[this._questionIds.indexOf(_local_5)]);
                        _local_7 = cast(this._explanationTemplate.clone(), IItemListWindow);
                        _local_8 = (("${quiz." + this._quizCode) + ".");
                        _local_9 = (((("." + Std.string(_local_5)) + ".") + Std.string(_local_6)) + "}");
                        _local_7.getListItemByName("question").caption = (((_local_8 + "question.") + Std.string(_local_5)) + "}");
                        cast(_local_7.getListItemByName("answer_container"), IWindowContainer).findChildByName("answer").caption = ((_local_8 + "answer") + _local_9);
                        cast(_local_7.getListItemByName("explanation_container"), IWindowContainer).findChildByName("explanation").caption = ((_local_8 + "explanation") + _local_9);
                        this._analysisPane.addListItem(_local_7);
                    }
                    cast(this._analysisPane.getListItemAt((this._analysisPane.numListItems - 1)), IItemListWindow).getListItemByName("separator").dispose();
                    return;
            }
        }

        function onWindowEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if (((this._disposed || (this._window == null)) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            if (Std.is(_arg_2 , ISelectableWindow))
            {
                this._answerIds[this._currentQuestion] = ASCompat.toInt(_arg_2.name);
                this._window.findChildByName("next_dimmer").visible = false;
            }
            else
            {
                switch (_arg_2.name)
                {
                    case "header_button_close"
                       | "exit_button":
                        this.closeWindow();
                        return;
                    case "prev_button":
                        this.setCurrentQuestion((this._currentQuestion - 1));
                        return;
                    case "next_button":
                        this.setCurrentQuestion((this._currentQuestion + 1));
                        return;
                    case "review_button":
                        this.showPage(PAGE_ANALYSIS);
                        return;
                }
            }
        }

        function setCurrentQuestion(k:Int)
        {
            var _local_2 = 0;
            var _local_3:Array<ASAny> = null;
            var _local_4 = 0;
            var _local_5:ISelectableWindow = null;
            var _local_6:String = null;
            var _local_7:ISelectableWindow = null;
            var _local_8 = 0;
            var _local_9:ISelectableWindow = null;
            var _local_10 = 0;
            if (k >= this.questionCount)
            {
                this._habboHelp.sendMessage(new PostQuizAnswersComposer(this._quizCode, this._answerIds));
            }
            else
            {
                if (k >= 0)
                {
                    this._currentQuestion = k;
                    this._window.findChildByName("prev_dimmer").visible = (k <= 0);
                    this._window.findChildByName("next_dimmer").visible = (this._answerIds[this._currentQuestion] == null);
                    this._window.findChildByName("top_indicator").caption = this._habboHelp.localization.getLocalizationWithParams(this.getRawLocalizationKey("question.page"), "", ["current_page", Std.string((k + 1)), "page_count", Std.string(this.questionCount)]);
                    while (this._answerList.numSelectables > 0)
                    {
                        this._answerList.removeSelectable(this._answerList.getSelectableAt(0)).dispose();
                    }
                    _local_2 = ASCompat.toInt(this._questionIds[this._currentQuestion]);
                    _local_3 = [];
                    this._questionPane.findChildByName("question").caption = (((("${quiz." + this._quizCode) + ".question.") + Std.string(_local_2)) + "}");
                    _local_4 = 0;
                    while (true)
                    {
                        _local_6 = this._habboHelp.localization.getLocalization(((((("quiz." + this._quizCode) + ".answer.") + Std.string(_local_2)) + ".") + Std.string(_local_4)), "");
                        if (_local_6.length > 0)
                        {
                            _local_7 = cast(this._answerTemplate.clone(), ISelectableWindow);
                            _local_7.caption = _local_6;
                            _local_7.name = Std.string(_local_4);
                            _local_3.push(_local_7);
                        }
                        else
                        {
                            break;
                        }
                        _local_4++;
                    }
                    if (this._answerOrders[this._currentQuestion] == null)
                    {
                        this._answerOrders[this._currentQuestion] = ([] : Array<Dynamic>);
                        _local_8 = 0;
                        while (_local_8 < _local_4)
                        {
                            _local_9 = _local_3.splice(Std.int((Math.random() * _local_3.length)), 1)[0];
                            this._answerList.addSelectable(_local_9);
                            this._answerOrders[this._currentQuestion].push(ASCompat.toInt(_local_9.name));
                            _local_8++;
                        }
                    }
                    else
                    {
                        final _iter_:ASAny = this._answerOrders[this._currentQuestion]; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                        {
_local_10  = ASCompat.toInt(_tmp_);
                            this._answerList.addSelectable(_local_3[_local_10]);
                        }
                    }
                    _local_5 = this._answerList.getSelectableByName(ASCompat.toString(this._answerIds[this._currentQuestion]));
                    if (_local_5 != null)
                    {
                        _local_5.select();
                    }
                }
            }
        }

        var questionCount(get,never):Int;
function  get_questionCount():Int
        {
            return (this._questionIds != null) ? this._questionIds.length : 0;
        }

        function getFullLocalizationKey(k:String):String
        {
            return ("${" + this.getRawLocalizationKey(k)) + "}";
        }

        function getRawLocalizationKey(k:String):String
        {
            switch (this._quizCode)
            {
                case HABBO_WAY_QUIZ_CODE:
                    return "habbo.way.quiz." + k;
                default:
                    return (("quiz." + this._quizCode) + ".") + k;
            }
        }
    }

