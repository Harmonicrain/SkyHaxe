package com.sulake.habbo.help
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.communication.messages.incoming.help.GuideTicketResolutionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideTicketCreationResultMessageEvent;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class ChatReviewReporterFeedbackCtrl implements IDisposable 
    {
        var _habboHelp:HabboHelp;
        var _window:IFrameWindow;

        public function new(k:HabboHelp)
        {
            this._habboHelp = k;
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new GuideTicketResolutionMessageEvent(this.onTicketResolved));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new GuideTicketCreationResultMessageEvent(this.onCreateResult));
        }

        public function dispose()
        {
            this._habboHelp = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._habboHelp == null;
        }

        function onTicketResolved(k:GuideTicketResolutionMessageEvent)
        {
            this.show(k.getParser().localizationCode);
        }

        function onCreateResult(k:GuideTicketCreationResultMessageEvent)
        {
            this.show(k.getParser().localizationCode);
        }

        public function show(k:String)
        {
            if (!this.enabled)
            {
                return;
            }
            this.prepare();
            this.setText("caption_txt", k, "caption");
            this.setText("body_txt", k, "body");
            this.setText("note_txt", k, "note");
            var _local_2= cast(this._window.findChildByName("caption_txt"), ITextWindow);
            this._window.findChildByName("body_txt").y = Std.int((_local_2.y + _local_2.textHeight) + 5);
            this._window.visible = true;
        }

        function setText(k:String, _arg_2:String, _arg_3:String)
        {
            var _local_4= ((("guide.bully.request.reporter." + _arg_2) + ".") + _arg_3);
            if (this._habboHelp.localization.getLocalization(_local_4, "") == "")
            {
                _local_4 = ("guide.bully.request.reporter." + _arg_3);
            }
            this._window.findChildByName(k).caption = (("${" + _local_4) + "}");
        }

        function prepare()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._habboHelp.getXmlWindow("chat_review_reporter_feedback"), IFrameWindow);
            this._window.procedure = this.windowProcedure;
            this._window.center();
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((!(k.type == WindowMouseEvent.CLICK)) || (this._window == null)) || this._window.disposed))
            {
                return;
            }
            if (((_arg_2.name == "close_button") || (_arg_2.name == "header_button_close")))
            {
                this._window.visible = false;
            }
        }

        var enabled(get,never):Bool;
function  get_enabled():Bool
        {
            return this._habboHelp.getBoolean("chatreviewreporterfeedbackctrl.enabled");
        }
    }

