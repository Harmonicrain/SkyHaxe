package com.sulake.habbo.friendbar.view.utils
;
    import com.sulake.core.runtime.IDisposable;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    import com.sulake.core.window.components.ITextWindow;

     class TextCropper implements IDisposable 
    {
        var _disposed:Bool = false;
        var _textField:TextField;
        var _textFormat:TextFormat;
        var _tailText:String = "...";
        var _tailSize:Int = 20;

        public function new()
        {
            this._textField = new TextField();
            this._textField.autoSize = TextFieldAutoSize.LEFT;
            this._textFormat = this._textField.defaultTextFormat;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._textField = null;
                this._disposed = true;
            }
        }

        public function crop(k:ITextWindow)
        {
            var _local_3 = 0;
            this._textFormat.font = k.fontFace;
            this._textFormat.size = k.fontSize;
            this._textFormat.bold = k.bold;
            this._textFormat.italic = k.italic;
            this._textField.setTextFormat(this._textFormat);
            this._textField.text = k.getLineText(0);
            var _local_2= Std.int(this._textField.textWidth);
            if (_local_2 > k.width)
            {
                _local_3 = this._textField.getCharIndexAtPoint((k.width - this._tailSize), (this._textField.textHeight / 2));
                k.text = (k.text.substring(0, _local_3) + this._tailText);
            }
        }
    }

