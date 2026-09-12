package com.sulake.habbo.ui.widget.poll
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.communication.messages.parser.poll.PollQuestion;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.communication._enum.poll.QuestionType;
    import com.sulake.habbo.communication.messages.parser.poll.QuestionChoice;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.components.ISelectableWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetPollMessage;

     class PollContentDialog implements IPollDialog
    {
        var _id:Int = -1;
        var _disposed:Bool = false;
        var _window:IFrameWindow;
        var _widget:RoomPollWidget;
        var _cancelWindow:IFrameWindow;
        var _started:Bool = false;
        var _questions:Array<ASAny>;
        var _question:Int = -1;
        var _answerableQuestions:Int = 0;
        var _parentQuestionId:Int = -1;
        var _npsPoll:Bool = false;
        var _nextQuestionType:Int = 0;
        var _currentQuestion:PollQuestion = null;

        public function new(k:Int, _arg_2:String, _arg_3:Array<ASAny>, _arg_4:RoomPollWidget, _arg_5:Bool)
        {
            var _local_7:ITextWindow = null;
            var _local_8:IWindow = null;
            var _local_9:IWindow = null;
            var _local_10:IWindow = null;
            this._id = k;
            this._questions = _arg_3;
            this._widget = _arg_4;
            this._npsPoll = _arg_5;
            this._Str_22698();
            var _local_6= Std.downcast(this._widget.assets.getAssetByName("poll_question") , XmlAsset);
            if (_local_6 != null)
            {
                this._window = Std.downcast(this._widget.windowManager.buildFromXML(((_local_6.content : com.sulake.core.utils.xml.XML) )) , IFrameWindow);
                _local_7 = Std.downcast(this._window.findChildByName("poll_question_headline") , ITextWindow);
                if (_local_7 != null)
                {
                    _local_7.text = _arg_2;
                }
                this._window.center();
                _local_8 = this._window.findChildByName("header_button_close");
                if (_local_8 != null)
                {
                    _local_8.addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
                }
                _local_9 = this._window.findChildByName("poll_question_button_ok");
                if (_local_9 != null)
                {
                    _local_9.addEventListener(WindowMouseEvent.CLICK, this._Str_6167);
                }
                _local_10 = this._window.findChildByName("poll_question_cancel");
                if (_local_10 != null)
                {
                    _local_10.addEventListener(WindowMouseEvent.CLICK, this._Str_26455);
                }
            }
        }

        public function start()
        {
            if (!this._started)
            {
                this._started = true;
                this._Str_15945();
            }
        }

        function onCloseHandler(k:WindowEvent)
        {
            this._Str_19369();
        }

        function _Str_6167(k:WindowEvent)
        {
            this._Str_25169();
        }

        function _Str_26455(k:WindowEvent)
        {
            this._Str_19369();
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._cancelWindow != null)
            {
                this._cancelWindow.dispose();
                this._cancelWindow = null;
            }
            this._widget = null;
            this._questions = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function _Str_15945()
        {
            var k:ITextWindow = null;
            var _local_2:IWindowContainer = null;
            var _local_3:IItemListWindow = null;
            var _local_4:String = null;
            var _local_5 = 0;
            this._currentQuestion = this._Str_23856();
            if (this._currentQuestion != null)
            {
                if (this._window != null)
                {
                    k = Std.downcast(this._window.findChildByName("poll_question_text") , ITextWindow);
                    if (k != null)
                    {
                        k.text = this._currentQuestion.questionText;
                    }
                    k = Std.downcast(this._window.findChildByName("poll_question_number") , ITextWindow);
                    if (k != null)
                    {
                        k.text = "${poll_question_number}";
                        _local_4 = k.text;
                        _local_4 = ASCompat.stringReplace(_local_4, "%number%", (this._question + 1));
                        _local_4 = ASCompat.stringReplace(_local_4, "%count%", this._answerableQuestions);
                        k.text = _local_4;
                    }
                    _local_2 = Std.downcast(this._window.findChildByName("poll_question_answer_container") , IWindowContainer);
                    if (_local_2 != null)
                    {
                        while (_local_2.numChildren > 0)
                        {
                            _local_2.getChildAt(0).dispose();
                        }
                        _local_2.invalidate();
                    }
                    switch (this._currentQuestion.questionType)
                    {
                        case QuestionType.RADIO_BUTTON:
                            this._Str_24518(_local_2, this._currentQuestion.questionChoices);
                            
                        case QuestionType.CHECKBOX:
                            this._parser6(_local_2, this._currentQuestion.questionChoices);
                            
                        case QuestionType.TEXTLINE:
                            this._Str_22247(_local_2);
                            
                        case QuestionType.TEXTAREA:
                            this._Str_23290(_local_2);
                            
                        default:
                            this._Str_15945();
                    }
                    _local_3 = Std.downcast(this._window.findChildByName("poll_content_wrapper") , IItemListWindow);
                    if (_local_3 != null)
                    {
                        _local_5 = Std.int(_local_3.scrollableRegion.height - _local_3.visibleRegion.height);
                        this._window.height = (this._window.height + _local_5);
                        this._window.center();
                    }
                }
            }
            else
            {
                this._widget._Str_24255(this._id);
            }
        }

        function _Str_23856():PollQuestion
        {
            var k:PollQuestion = null;
            var _local_2 = 0;
            var _local_3:PollQuestion = null;
            if (((this._npsPoll && (this._parentQuestionId >= 0)) && (!(this._nextQuestionType == PollQuestion._Str_12458))))
            {
                k = this._questions[this._parentQuestionId];
                _local_2 = 0;
                while (_local_2 < k.children.length)
                {
                    _local_3 = k.children[_local_2];
                    if (((_local_3 != null) && (_local_3.questionCategory == this._nextQuestionType)))
                    {
                        this._parentQuestionId = -1;
                        return _local_3;
                    }
                    _local_2++;
                }
            }
            this._question++;
            if (this._question < this._questions.length)
            {
                this._parentQuestionId = this._question;
                return this._questions[this._question];
            }
            return null;
        }

        function _Str_24518(k:IWindowContainer, _arg_2:Vector<QuestionChoice>)
        {
            var _local_3= Std.downcast(this._widget.assets.getAssetByName("poll_answer_radiobutton_input") , XmlAsset);
            if (_local_3 == null)
            {
                throw new ASError('Asset for poll widget hot found: "poll_answer_radiobutton_input"!');
            }
            var _local_4= Std.downcast(this._widget.windowManager.buildFromXML(((_local_3.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (_local_4 != null)
            {
                this._Str_21700(_arg_2, _local_4);
                k.addChild(_local_4);
            }
        }

        function _Str_23831(k:PollQuestion):Array<ASAny>
        {
            var _local_3:ISelectorWindow = null;
            var _local_4:ISelectableWindow = null;
            var _local_5:QuestionChoice = null;
            var _local_2= new Array<ASAny>();
            if (this._window != null)
            {
                _local_3 = Std.downcast(this._window.findChildByName("poll_answer_selector") , ISelectorWindow);
                if (_local_3 != null)
                {
                    _local_4 = _local_3.getSelected();
                    if (_local_4 != null)
                    {
                        _local_5 = k.questionChoices[_local_4.id];
                        if (this._npsPoll)
                        {
                            this._nextQuestionType = _local_5._Str_19972;
                        }
                        else
                        {
                            this._nextQuestionType = PollQuestion._Str_12458;
                        }
                        _local_2.push(_local_5.value);
                    }
                }
            }
            return _local_2;
        }

        function _parser6(k:IWindowContainer, _arg_2:Vector<QuestionChoice>)
        {
            var _local_3= Std.downcast(this._widget.assets.getAssetByName("poll_answer_checkbox_input") , XmlAsset);
            if (_local_3 == null)
            {
                throw new ASError('Asset for poll widget hot found: "poll_answer_checkbox_input"!');
            }
            var _local_4= Std.downcast(this._widget.windowManager.buildFromXML(((_local_3.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (_local_4 != null)
            {
                this._Str_21700(_arg_2, _local_4);
                k.addChild(_local_4);
            }
        }

        function _Str_22504(k:PollQuestion):Array<ASAny>
        {
            var _local_3:IItemListWindow = null;
            var _local_4 = 0;
            var _local_5:IWindowContainer = null;
            var _local_6:ICheckBoxWindow = null;
            var _local_2= new Array<ASAny>();
            if (this._window != null)
            {
                _local_3 = Std.downcast(this._window.findChildByName("poll_answer_itemlist") , IItemListWindow);
                if (_local_3 != null)
                {
                    _local_4 = 0;
                    while (_local_4 < _local_3.numListItems)
                    {
                        _local_5 = Std.downcast(_local_3.getListItemAt(_local_4) , IWindowContainer);
                        if (_local_5 != null)
                        {
                            _local_6 = Std.downcast(_local_5.findChildByName("poll_answer_checkbox") , ICheckBoxWindow);
                            if (_local_6 != null)
                            {
                                if (_local_6.testStateFlag(WindowState.SELECTED))
                                {
                                    _local_2.push(k.questionChoices[_local_4].value);
                                }
                            }
                        }
                        _local_4++;
                    }
                }
            }
            return _local_2;
        }

        function _Str_21700(k:Vector<QuestionChoice>, _arg_2:IWindowContainer)
        {
            var _local_4:IWindowContainer = null;
            var _local_5 = 0;
            var _local_6:ITextWindow = null;
            var _local_7:IWindow = null;
            var _local_3= Std.downcast(_arg_2.findChildByName("poll_answer_itemlist") , IItemListWindow);
            if (_local_3 != null)
            {
                _local_4 = Std.downcast(_arg_2.findChildByName("poll_answer_entity") , IWindowContainer);
                if (_local_4 != null)
                {
                    _local_5 = 0;
                    while (_local_5 < (k.length - 1))
                    {
                        _local_5++;
                        _local_3.addListItem(_local_4.clone());
                    }
                    _local_5 = 0;
                    while (_local_5 < k.length)
                    {
                        _local_4 = Std.downcast(_local_3.getListItemAt(_local_5) , IWindowContainer);
                        _local_6 = Std.downcast(_local_4.findChildByName("poll_answer_entity_text") , ITextWindow);
                        if (_local_6 != null)
                        {
                            _local_6.text = k[_local_5].choiceText;
                        }
                        _local_7 = _local_4.findChildByTag("POLL_SELECTABLE_ITEM");
                        if (_local_7 != null)
                        {
                            _local_7.id = _local_5;
                        }
                        _local_5++;
                    }
                }
            }
        }

        function _Str_22247(k:IWindowContainer)
        {
            var _local_2= Std.downcast(this._widget.assets.getAssetByName("poll_answer_text_input") , XmlAsset);
            if (_local_2 == null)
            {
                throw new ASError('Asset for poll widget hot found: "poll_answer_text_input"!');
            }
            k.addChild(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )));
        }

        function _Str_21937():Array<ASAny>
        {
            var _local_2:ITextWindow = null;
            var k= new Array<ASAny>();
            if (this._window != null)
            {
                _local_2 = Std.downcast(this._window.findChildByName("poll_answer_input") , ITextWindow);
                if (_local_2 != null)
                {
                    k.push(_local_2.text);
                }
            }
            else
            {
                throw new ASError("Invalid or disposed poll dialog!");
            }
            return k;
        }

        function _Str_23290(k:IWindowContainer)
        {
            this._Str_22247(k);
        }

        function _Str_23417():Array<ASAny>
        {
            return this._Str_21937();
        }

        function _Str_25263()
        {
            this._widget._Str_12823(this._id);
        }

        function _Str_25169()
        {
            var answerArray:Array<ASAny> = null;
            var answerValue = 0;
            var question:PollQuestion = null;
            if ((this._npsPoll && (this._currentQuestion != null)))
            {
                question = this._currentQuestion;
            }
            else
            {
                question = this._questions[this._question];
            }
            this._nextQuestionType = PollQuestion._Str_12458;
            switch (question.questionType)
            {
                case QuestionType.RADIO_BUTTON:
                    answerArray = this._Str_23831(question);
                    
                case QuestionType.CHECKBOX:
                    answerArray = this._Str_22504(question);
                    if (answerArray.length < 0)
                    {
                        this._widget.windowManager.alert("${win_error}", "${poll_alert_answer_missing}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:WindowEvent)
                        {
                            k.dispose();
                        });
                        return;
                    }
                    if (answerArray.length > question.questionChoices.length)
                    {
                        this._widget.windowManager.alert("${win_error}", "${poll_alert_invalid_selection}", 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:WindowEvent)
                        {
                            k.dispose();
                        });
                        return;
                    }
                    
                case QuestionType.TEXTLINE:
                    answerArray = this._Str_21937();
                    
                case QuestionType.TEXTAREA:
                    answerArray = this._Str_23417();
                    
                default:
                    throw new ASError((("Unknown poll question type: " + Std.string(question.questionType)) + "!"));
            }
            var answers= new Array<ASAny>();
            var message= new RoomWidgetPollMessage(RoomWidgetPollMessage.RWPM_ANSWER, this._id);
            message.questionId = question.questionId;
            if (question.questionChoices.length > 0)
            {
                if (checkNullIteratee(answerArray)) for (_tmp_ in answerArray)
                {
answerValue  = ASCompat.toInt(_tmp_);
                    answers.push(answerValue);
                }
            }
            else
            {
                answers.push(answerArray);
            }
            message.answers = answers;
            this._widget.messageListener.processWidgetMessage(message);
            this._Str_15945();
        }

        function _Str_19369()
        {
            var k:XmlAsset = null;
            var _local_2:IWindow = null;
            var _local_3:IWindow = null;
            var _local_4:IWindow = null;
            if (this._cancelWindow == null)
            {
                k = Std.downcast(this._widget.assets.getAssetByName("poll_cancel_confirm") , XmlAsset);
                this._cancelWindow = Std.downcast(this._widget.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) ), 2) , IFrameWindow);
                this._cancelWindow.center();
                _local_2 = this._cancelWindow.findChildByName("header_button_close");
                if (_local_2 != null)
                {
                    _local_2.addEventListener(WindowMouseEvent.CLICK, this._Str_24544);
                }
                _local_3 = this._cancelWindow.findChildByName("poll_cancel_confirm_button_ok");
                if (_local_3 != null)
                {
                    _local_3.addEventListener(WindowMouseEvent.CLICK, this._Str_22892);
                }
                _local_4 = this._cancelWindow.findChildByName("poll_cancel_confirm_button_cancel");
                if (_local_4 != null)
                {
                    _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_24800);
                }
            }
        }

        function _Str_16903()
        {
            if (this._cancelWindow != null)
            {
                this._cancelWindow.dispose();
                this._cancelWindow = null;
            }
        }

        function _Str_24544(k:WindowEvent)
        {
            this._Str_16903();
        }

        function _Str_22892(k:WindowEvent)
        {
            this._Str_16903();
            this._Str_25263();
        }

        function _Str_24800(k:WindowEvent)
        {
            this._Str_16903();
        }

        function _Str_22698()
        {
            var k:PollQuestion = null;
            this._answerableQuestions = this._questions.length;
            final _iter_ = this._questions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                if (k.children.length > 0)
                {
                    this._answerableQuestions++;
                }
            }
        }
    }

