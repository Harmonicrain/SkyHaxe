package com.sulake.habbo.help
;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.widgets._Str_4466;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;

     class HabboWayController 
    {
        static inline final _Str_7835= 0;

        var _pageCount:Int = 0;
        var _currentPage:Int = 0;
        var _habboHelp:HabboHelp;
        var _dialog:IModalDialog;
        var _window:IWindowContainer;
        var _disposed:Bool = false;

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

        var _Str_16191(get,never):Int;
function  get__Str_16191():Int
        {
            return this._habboHelp.getInteger("help.habboway.page.count", 6);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function showHabboWay()
        {
            this.closeWindow();
            this._dialog = this._habboHelp.getModalXmlWindow("habbo_way");
            this._window = cast(this._dialog.rootWindow, IWindowContainer);
            this._window.procedure = this.onWindowEvent;
            cast(cast(this._window.findChildByName("page_widget"), IWidgetWindow).widget, _Str_4466).size = this._Str_16191;
            this._Str_7910(HabboWayController._Str_7835);
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
                    this._Str_7910(Std.int(Math.min(this._Str_16191, (this._currentPage + 1))));
                    this._habboHelp.trackGoogle("habboWay", ("clickNextPage_" + Std.string(this._currentPage)));
                    return;
                case "back_button"
                   | "previous_button":
                    this._Str_7910(Std.int(Math.max(HabboWayController._Str_7835, (this._currentPage - 1))));
                    this._habboHelp.trackGoogle("habboWay", ("clickPrevPage_" + Std.string(this._currentPage)));
                    return;
                case "quiz_button":
                    this._habboHelp.trackGoogle("habboWay", "clickQuiz");
                    this._habboHelp.showHabboWayQuiz();
                    return;
            }
        }

        function _Str_7910(k:Int)
        {
            this._currentPage = k;
            if (this._currentPage < this._Str_16191)
            {
                if (this._currentPage == HabboWayController._Str_7835)
                {
                    this._window.findChildByName("previous_button").visible = false;
                }
                else
                {
                    this._window.findChildByName("previous_button").visible = true;
                }
                cast(this._window.findChildByName("illustration"), IStaticBitmapWrapperWindow).assetUri = (("${image.library.url}habboway/page_" + Std.string(this._currentPage)) + ".png");
                cast(this._window.findChildByName("dove_image"), IStaticBitmapWrapperWindow).assetUri = "help_habboway_dove_off";
                cast(cast(this._window.findChildByName("page_widget"), IWidgetWindow).widget, _Str_4466).position = (this._currentPage + 1);
                this._window.findChildByName("correct_title").caption = (("${habbo.way.page." + Std.string(this._currentPage)) + ".correct.title}");
                this._window.findChildByName("correct_description").caption = (("${habbo.way.page." + Std.string(this._currentPage)) + ".correct.description}");
                this._window.findChildByName("wrong_title").caption = (("${habbo.way.page." + Std.string(this._currentPage)) + ".wrong.title}");
                this._window.findChildByName("wrong_description").caption = (("${habbo.way.page." + Std.string(this._currentPage)) + ".wrong.description}");
                this._window.findChildByName("page_container").visible = true;
                this._window.findChildByName("final_page").visible = false;
                this._window.findChildByName("page_container").invalidate();
            }
            else
            {
                cast(this._window.findChildByName("illustration"), IStaticBitmapWrapperWindow).assetUri = "${image.library.url}habboway/page_end.png";
                cast(this._window.findChildByName("dove_image"), IStaticBitmapWrapperWindow).assetUri = "help_habboway_dove_on";
                cast(cast(this._window.findChildByName("page_widget"), IWidgetWindow).widget, _Str_4466).position = 0;
                this._window.findChildByName("page_container").visible = false;
                this._window.findChildByName("final_page").visible = true;
                this._window.findChildByName("final_page").invalidate();
            }
        }
    }



