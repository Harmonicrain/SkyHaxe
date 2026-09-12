package com.sulake.habbo.help
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.window.widgets._Str_4466;
    import com.sulake.core.window.components.IWidgetWindow;

     class SafetyBookletController implements IDisposable 
    {
        static inline final _Str_7835= 0;
        static inline final _Str_20665= 7;

        var _habboHelp:HabboHelp;
        var _dialog:IModalDialog;
        var _window:IWindowContainer;
        var _disposed:Bool = false;
        var _currentPage:Int = 0;

        public function new(k:HabboHelp)
        {
            this._habboHelp = k;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this.closeWindow();
                if (this._habboHelp != null)
                {
                    this._habboHelp = null;
                }
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function _Str_24968()
        {
            this.closeWindow();
            this._dialog = this._habboHelp.getModalXmlWindow("safety_booklet");
            this._window = cast(this._dialog.rootWindow, IWindowContainer);
            this._window.procedure = this.onWindowEvent;
            this._Str_7910(SafetyBookletController._Str_7835);
            this._habboHelp.tracking.trackEventLog("Quiz", "", "talent.quiz.open");
        }

        public function closeWindow()
        {
            this._window = null;
            if (this._dialog != null)
            {
                this._dialog.dispose();
                this._dialog = null;
            }
        }

        function onWindowEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if (((this._disposed || (!(this._window != null))) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close":
                    this.closeWindow();
                    return;
                case "next_button":
                    this._Str_7910(Std.int(Math.min(SafetyBookletController._Str_20665, (this._currentPage + 1))));
                    this._habboHelp.tracking.trackEventLog("Quiz", ("" + Std.string(this._currentPage)), "talent.quiz.change_page");
                    this._habboHelp.trackGoogle("safetyBooklet", ("clickNextPage_" + Std.string(this._currentPage)));
                    return;
                case "back_button"
                   | "previous_button":
                    this._Str_7910(Std.int(Math.max(SafetyBookletController._Str_7835, (this._currentPage - 1))));
                    this._habboHelp.tracking.trackEventLog("Quiz", ("" + Std.string(this._currentPage)), "talent.quiz.change_page");
                    this._habboHelp.trackGoogle("safetyBooklet", ("clickPrevPage_" + Std.string(this._currentPage)));
                    return;
                case "quiz_button":
                    this._habboHelp.trackGoogle("safetyBooklet", "clickQuiz");
                    this._habboHelp.showSafetyQuiz();
                    return;
                case "ok_button":
                    this._habboHelp.trackGoogle("safetyBooklet", "clickOk");
                    this._habboHelp.showSafetyQuiz();
                    this._habboHelp._Str_21195();
                    return;
            }
        }

        function _Str_7910(k:Int)
        {
            this._currentPage = k;
            this._window.findChildByName("safety.quiz.explanation").visible = (!this._habboHelp._Str_19563);
            if (this._currentPage < SafetyBookletController._Str_20665)
            {
                if (this._currentPage == SafetyBookletController._Str_7835)
                {
                    this._window.findChildByName("previous_button").visible = false;
                }
                else
                {
                    this._window.findChildByName("previous_button").visible = true;
                }
                cast(this._window.findChildByName("illustration"), IStaticBitmapWrapperWindow).assetUri = (("${image.library.url}safetyquiz/page_" + Std.string(this._currentPage)) + ".png");
                cast(this._window.findChildByName("safety_image"), IStaticBitmapWrapperWindow).assetUri = "${image.library.url}safetyquiz/safety_off.png";
                cast(cast(this._window.findChildByName("page_widget"), IWidgetWindow).widget, _Str_4466).position = (this._currentPage + 1);
                this._window.findChildByName("title").caption = (("${safety.booklet.page." + Std.string(this._currentPage)) + ".title}");
                this._window.findChildByName("description").caption = (("${safety.booklet.page." + Std.string(this._currentPage)) + ".description}");
                this._window.findChildByName("page_container").visible = true;
                this._window.findChildByName("final_page").visible = false;
                this._window.findChildByName("final_page_no_questions").visible = false;
                this._window.findChildByName("page_container").invalidate();
            }
            else
            {
                cast(this._window.findChildByName("illustration"), IStaticBitmapWrapperWindow).assetUri = "${image.library.url}safetyquiz/page_end.png";
                cast(this._window.findChildByName("safety_image"), IStaticBitmapWrapperWindow).assetUri = "${image.library.url}safetyquiz/safety_on.png";
                cast(cast(this._window.findChildByName("page_widget"), IWidgetWindow).widget, _Str_4466).position = 0;
                this._window.findChildByName("page_container").visible = false;
                if (this._habboHelp._Str_19563)
                {
                    this._window.findChildByName("final_page_no_questions").visible = true;
                    this._window.findChildByName("final_page_no_questions").invalidate();
                }
                else
                {
                    this._window.findChildByName("final_page").visible = true;
                    this._window.findChildByName("final_page").invalidate();
                }
            }
        }
    }

