package com.sulake.habbo.ui.widget.poll
;
    import com.sulake.core.runtime.IDisposable;

     class PollSession implements IDisposable
    {
        var _id:Int = -1;
        var _roomPollWidget:RoomPollWidget;
        var _pollDialog:IPollDialog;
        var _pollContentDialog:IPollDialog;
        var _endMessage:String = "";
        var _disposed:Bool = false;

        public function new(k:Int, _arg_2:RoomPollWidget)
        {
            this._id = k;
            this._roomPollWidget = _arg_2;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._pollDialog != null)
            {
                this._pollDialog.dispose();
                this._pollDialog = null;
            }
            if (this._pollContentDialog != null)
            {
                this._pollContentDialog.dispose();
                this._pollContentDialog = null;
            }
            this._roomPollWidget = null;
            this._disposed = true;
        }

        public function _Str_6059(k:String, _arg_2:String)
        {
            this._Str_22133();
            this._pollDialog = new PollOfferDialog(this._id, k, _arg_2, this._roomPollWidget);
            this._pollDialog.start();
        }

        public function _Str_22133()
        {
            if (Std.is(this._pollDialog , PollOfferDialog))
            {
                if (!this._pollDialog.disposed)
                {
                    this._pollDialog.dispose();
                }
                this._pollDialog = null;
            }
        }

        public function _Str_24948(k:String, _arg_2:String, _arg_3:Array<ASAny>, _arg_4:Bool)
        {
            this._Str_22133();
            this._Str_25482();
            this._endMessage = _arg_2;
            this._pollContentDialog = new PollContentDialog(this._id, k, _arg_3, this._roomPollWidget, _arg_4);
            this._pollContentDialog.start();
        }

        public function _Str_25482()
        {
            if (Std.is(this._pollContentDialog , PollContentDialog))
            {
                if (!this._pollContentDialog.disposed)
                {
                    this._pollContentDialog.dispose();
                }
                this._pollContentDialog = null;
            }
        }

        public function _Str_24541()
        {
            this._roomPollWidget.windowManager.alert("${poll_thanks_title}", this._endMessage, 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
            {
                k.dispose();
            });
        }
    }

