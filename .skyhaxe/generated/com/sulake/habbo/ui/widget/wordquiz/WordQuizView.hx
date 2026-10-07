package com.sulake.habbo.ui.widget.wordquiz
;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ILabelWindow;
    import com.sulake.core.utils.Map;
    import flash.events.TimerEvent;

     class WordQuizView 
    {
        public static inline final STATE_QUESTION= 0;
        public static inline final STATE_RESULT= 1;
        static inline final CONTAINER_IN_BOTTOM= false;
        static var _displayResultDuration:Int = 0;

        var _widget:WordQuizWidget;
        var _mainWindow:IWindowContainer;
        var _waitTimer:Timer;
        var _quizTopic:String;

        public function new(k:WordQuizWidget)
        {
            this._widget = k;
            _displayResultDuration = (this._widget.handler.container.config.getInteger("poll.word.quiz.result.view.seconds", 4) * 1000);
            if (CONTAINER_IN_BOTTOM)
            {
                this._mainWindow = Std.downcast(this._widget.windowManager.createWindow("wordquiz_container", "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.DEFAULT, (ASCompat.toInt(WindowParam.WINDOW_PARAM_RESIZE_TO_ACCOMMODATE_CHILDREN )| ASCompat.toInt(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN)), new Rectangle(0, 0, 2, 2), null, 0, 2) , IWindowContainer);
                this._mainWindow.width = this._mainWindow.desktop.width;
                this._mainWindow.height = this._mainWindow.desktop.height;
            }
        }

        public function dispose()
        {
            this._widget = null;
            this.removeWindow();
            if (this._mainWindow != null)
            {
                if (this._mainWindow.desktop != null)
                {
                    this._mainWindow.desktop.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onDesktopResized);
                }
                this._mainWindow.dispose();
                this._mainWindow = null;
            }
        }

        function getCorrectTextWidth(k:Int, _arg_2:String=null):Int
        {
            var _local_3:String = null;
            var _local_4:IWindowContainer = null;
            if (k == STATE_QUESTION)
            {
                _local_3 = "wordquiz_question_xml";
            }
            else
            {
                _local_3 = "wordquiz_result_xml";
            }
            _local_4 = Std.downcast(this._widget.windowManager.buildFromXML(((this._widget.assets.getAssetByName(_local_3).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            if (_local_4 == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            _local_4.findChildByName("quiz_topic").caption = _arg_2;
            _local_4.findChildByName("quiz_topic").width = 660;
            var _local_5:ASAny = cast(_local_4.findChildByName("quiz_topic"), ITextWindow).textWidth;
            _local_4.dispose();
            return ASCompat.toInt(_local_5);
        }

        public function createWindow(k:Int, _arg_2:String=null)
        {
            var _local_3:String = null;
            this.removeWindow();
            if (k == STATE_QUESTION)
            {
                _local_3 = "wordquiz_question_xml";
            }
            else
            {
                _local_3 = "wordquiz_result_xml";
            }
            if (CONTAINER_IN_BOTTOM)
            {
                this._mainWindow.buildFromXML(((this._widget.assets.getAssetByName(_local_3).content : com.sulake.core.utils.xml.XML) ));
            }
            else
            {
                this._mainWindow = Std.downcast(this._widget.windowManager.buildFromXML(((this._widget.assets.getAssetByName(_local_3).content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            }
            if (this._mainWindow == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            var _local_4= this._mainWindow.findChildByName("button_like");
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this.onLike);
            }
            _local_4 = this._mainWindow.findChildByName("button_dislike");
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this.onDislike);
            }
            if (_arg_2 != null)
            {
                this._quizTopic = _arg_2;
            }
            this._mainWindow.findChildByName("quiz_topic").caption = this._quizTopic;
            this._mainWindow.findChildByName("quiz_topic").width = Std.int(Math.min(660, (this.getCorrectTextWidth(k, this._quizTopic) + 6)));
            this._mainWindow.findChildByName("quiz_topic").y = 3;
            this.positionWindow();
            this._mainWindow.desktop.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onDesktopResized);
        }

        public function removeWindow()
        {
            if (((!(this._mainWindow != null)) || (this._mainWindow.numChildren == 0)))
            {
                return;
            }
            if (CONTAINER_IN_BOTTOM)
            {
                this._mainWindow.removeChildAt(0).dispose();
            }
            else
            {
                this._mainWindow.desktop.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onDesktopResized);
                this._mainWindow.dispose();
                this._mainWindow = null;
            }
            if (this._waitTimer != null)
            {
                this._waitTimer.reset();
                this._waitTimer = null;
            }
        }

        public var mainWindow(get,never):IWindow;
public function  get_mainWindow():IWindow
        {
            return this._mainWindow;
        }

        public function updateCounter(k:String)
        {
            if (((!(this._mainWindow != null)) || (!(this._mainWindow.findChildByName("countdown") != null))))
            {
                return;
            }
            if (k == "0")
            {
                k = "";
            }
            this._mainWindow.findChildByName("countdown").caption = k;
        }

        public function updateResults(k:Map)
        {
            if (((!(this._mainWindow != null)) || (!(k != null))))
            {
                return;
            }
            var _local_2= ASCompat.toInt((k.getValue(WordQuizWidget.VALUE_KEY_DISLIKE)!= null) ? ASCompat.toInt(k.getValue(WordQuizWidget.VALUE_KEY_DISLIKE) ): 0);
            var _local_3= Std.downcast(this._mainWindow.findChildByName("lbl_dislike_count") , ILabelWindow);
            if (_local_3 != null)
            {
                _local_3.text = Std.string(_local_2);
            }
            _local_2 = ASCompat.toInt((k.getValue(WordQuizWidget.VALUE_KEY_LIKE)!= null) ? ASCompat.toInt(k.getValue(WordQuizWidget.VALUE_KEY_LIKE) ): 0);
            _local_3 = Std.downcast(this._mainWindow.findChildByName("lbl_like_count") , ILabelWindow);
            if (_local_3 != null)
            {
                _local_3.text = Std.string(_local_2);
            }
        }

        public function displayResults(k:Map)
        {
            this.createWindow(WordQuizView.STATE_RESULT);
            this.updateResults(k);
            this._waitTimer = new Timer(_displayResultDuration);
            this._waitTimer.addEventListener(TimerEvent.TIMER, (this.onWaitTimer : ASAny));
            this._waitTimer.start();
        }

        function onWaitTimer(k:TimerEvent)
        {
            this.removeWindow();
        }

        function onLike(k:WindowMouseEvent)
        {
            this._widget.sendAnswer(1);
        }

        function onDislike(k:WindowMouseEvent)
        {
            this._widget.sendAnswer(0);
        }

        function onDesktopResized(k:WindowEvent)
        {
            this.positionWindow();
        }

        function positionWindow()
        {
            if (((!(this._mainWindow != null)) || (this._mainWindow.numChildren == 0)))
            {
                return;
            }
            var k= this._mainWindow.getChildAt(0);
            this._mainWindow.x = Std.int((this._mainWindow.desktop.width / 2) - (k.width / 2));
            this._mainWindow.y = 6;
        }
    }

