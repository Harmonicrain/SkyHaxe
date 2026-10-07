package com.sulake.habbo.notifications.singular
;
	import com.sulake.habbo.notifications.singular.HabboNotificationItemStyle;
	
     class HabboNotificationItem 
    {
        var _style:HabboNotificationItemStyle;
        var _content:String;
        var _controller:SingularNotificationController;

        public function new(k:String, _arg_2:HabboNotificationItemStyle, _arg_3:SingularNotificationController)
        {
            this._content = k;
            this._style = _arg_2;
            this._controller = _arg_3;
        }

        public var style(get,never):HabboNotificationItemStyle;
public function  get_style():HabboNotificationItemStyle
        {
            return this._style;
        }

        public var content(get,never):String;
public function  get_content():String
        {
            return this._content;
        }

        public var notificationId(get,never):String;
public function  get_notificationId():String
        {
            if (this._style == null || this._style.extraData == null)
            {
                return null;
            }
            return ASCompat.getDynamicProperty(this._style.extraData, "id");
        }

        public function dispose()
        {
            this._content = null;
            if (this._style != null)
            {
                this._style.dispose();
                this._style = null;
            }
            this._controller = null;
        }

        public function _Str_25246()
        {
            if (ASCompat.stringAsBool(this._style.internalLink))
            {
                this._controller.onInternalLink(this._style.internalLink);
            }
        }
    }

