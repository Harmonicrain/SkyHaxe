package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window._enum._Str_3724;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.quest.ILandingPageUserEntry;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.friendbar.landingview.*;

     class UserListWidget implements ILandingViewWidget 
    {
        var _landingView:HabboLandingView;
        var _container:IWindowContainer;
        var _popup:IWindowContainer;
        var _startOffset:Int = 150;
        var _avatarOffsetsY:Array<ASAny>;
        var _avatarContainerWidths:Array<ASAny>;
        var _avatarDirections:Array<ASAny>;

        public function new(k:HabboLandingView)
        {
            this._avatarOffsetsY = [0, 10, 5, 0, 5, 10, 0, 10, 5, 10];
            this._avatarContainerWidths = [];
            this._avatarDirections = [_Str_3724._Str_4519, _Str_3724._Str_8287, _Str_3724._Str_4519, _Str_3724._Str_4519, _Str_3724._Str_8287, _Str_3724._Str_4519, _Str_3724._Str_4519, _Str_3724._Str_4519, _Str_3724._Str_8287, _Str_3724._Str_4519];
            this._landingView = k;
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._container;
        }

        public function dispose()
        {
            this._landingView = null;
            this._container = null;
            if (this._popup != null)
            {
                this._popup.dispose();
                this._popup = null;
            }
        }

        public function initialize()
        {
            this._container = cast(this._landingView.getXmlWindow("user_list"), IWindowContainer);
            this.registerMessageListeners();
        }

        public function refresh()
        {
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._landingView == null;
        }

        public function refreshContent()
        {
            if (this.users == null)
            {
                this._container.visible = false;
                return;
            }
            this._container.visible = true;
            this._Str_3836();
            this._Str_20962();
        }

        function _Str_3836()
        {
            var _local_3:IWindowContainer = null;
            var _local_4:ILandingPageUserEntry = null;
            var _local_5:IWidgetWindow = null;
            var _local_6:IAvatarImageWidget = null;
            var k= this._startOffset;
            var _local_2 = 0;
            while (_local_2 < 10)
            {
                _local_3 = this._Str_25068(_local_2);
                if (_local_3 == null)
                {
                    _local_3 = this._Str_24841(_local_2);
                    this._container.addChild(_local_3);
                    _local_3.x = k;
                    k = (k + _local_3.width);
                }
                _local_4 = this.users[_local_2];
                _local_3.visible = (!(_local_4 == null));
                if (_local_4 != null)
                {
                    _local_5 = cast(_local_3.findChildByName("avatar_image_widget"), IWidgetWindow);
                    _local_6 = cast(_local_5.widget, IAvatarImageWidget);
                    _local_6.figure = _local_4.figure;
                }
                _local_2++;
            }
        }

        function _Str_25068(k:Int):IWindowContainer
        {
            return cast(this._container.getChildByID(k), IWindowContainer);
        }

        function _Str_24841(k:Int):IWindowContainer
        {
            var _local_2= cast(this._landingView.getXmlWindow("user_entry"), IWindowContainer);
            this._Str_24987(_local_2, k);
            _local_2.procedure = this._Str_6514;
            _local_2.id = k;
            if (this._avatarContainerWidths.length > k)
            {
                _local_2.width = ASCompat.toInt(this._avatarContainerWidths[k]);
            }
            var _local_3= _local_2.findChildByName("extra_link_region");
            _local_3.visible = this.hasExtraLink();
            _local_3.procedure = this._Str_23122;
            _local_3.id = k;
            return _local_2;
        }

        function _Str_24987(k:IWindowContainer, _arg_2:Int)
        {
            var _local_3= cast(k.findChildByName("avatar_image_widget"), IWidgetWindow);
            var _local_4= cast(_local_3.widget, IAvatarImageWidget);
            k.y = ASCompat.toInt(k.y + (this._avatarOffsetsY[_arg_2] + 70));
            if (this._avatarOffsetsY[_arg_2] < 0)
            {
                k.height = Std.int(k.height + -ASCompat.toNumber(this._avatarOffsetsY[_arg_2]));
            }
            _local_4.direction = ASCompat.toInt(this._avatarDirections[_arg_2]);
            k.findChildByName("extra_link_region").y = ASCompat.toInt(k.findChildByName("extra_link_region").y - ASCompat.toNumber(this._avatarOffsetsY[_arg_2]));
        }

        function getEntry(k:IWindow):ILandingPageUserEntry
        {
            var _local_2= k.id;
            return this.users[_local_2];
        }

        function _Str_6514(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3= this.getEntry(_arg_2);
            if (_local_3 == null)
            {
                return;
            }
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._landingView.send(new GetExtendedProfileMessageComposer(_local_3.userId));
            }
            else
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    this._Str_8168(_local_3, _arg_2);
                }
                else
                {
                    if (k.type == WindowMouseEvent.OUT)
                    {
                        this._Str_20962();
                    }
                }
            }
        }

        function _Str_23122(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:ILandingPageUserEntry = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = this.getEntry(_arg_2);
                if (_local_3 == null)
                {
                    return;
                }
                this.extraLinkClicked(_local_3);
            }
            else
            {
                this._Str_6514(k, _arg_2.parent);
            }
        }

        function _Str_8168(k:ILandingPageUserEntry, _arg_2:IWindow)
        {
            if (this._popup == null)
            {
                this._popup = cast(this._landingView.getXmlWindow(this.getPopupXml()), IWindowContainer);
                this._container.addChild(this._popup);
            }
            this.refreshPopup(k, this._popup);
            this._popup.y = Std.int(Math.max(0, (79 - this._popup.height)));
            this._popup.x = Std.int(_arg_2.x + ((_arg_2.width - this._popup.width) / 2));
            this._popup.visible = true;
        }

        function _Str_20962()
        {
            if (this.users.length > 0)
            {
                this._Str_8168(this.users[0], this._container.getChildByID(0));
            }
            else
            {
                if (this._popup != null)
                {
                    this._popup.visible = false;
                }
            }
        }

        var landingView(get,never):HabboLandingView;
function  get_landingView():HabboLandingView
        {
            return this._landingView;
        }

        function getText(k:String):String
        {
            return ("${" + k) + "}";
        }

        function registerMessageListeners()
        {
        }

        var users(get,never):Array<ASAny>;
function  get_users():Array<ASAny>
        {
            return null;
        }

        function refreshPopup(k:ILandingPageUserEntry, _arg_2:IWindowContainer)
        {
        }

        function getPopupXml():String
        {
            return null;
        }

        function hasExtraLink():Bool
        {
            return false;
        }

        function extraLinkClicked(k:ILandingPageUserEntry)
        {
        }

        var _Str_21503(never,set):Array<ASAny>;
function  set__Str_21503(k:Array<ASAny>):Array<ASAny>        {
            return this._avatarOffsetsY = k;
        }

        var _Str_20102(never,set):Array<ASAny>;
function  set__Str_20102(k:Array<ASAny>):Array<ASAny>        {
            return this._avatarContainerWidths = k;
        }

        public var _Str_19229(never,set):Int;
public function  set__Str_19229(k:Int):Int        {
            return this._startOffset = k;
        }
    }


