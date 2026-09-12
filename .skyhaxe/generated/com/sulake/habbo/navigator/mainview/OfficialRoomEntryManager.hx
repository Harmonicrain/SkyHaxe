package com.sulake.habbo.navigator.mainview
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;
    import com.sulake.habbo.navigator.UserCountRenderer;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.navigator.Util;
    import com.sulake.habbo.communication.messages.incoming.navigator.OfficialRoomEntryData;
    import com.sulake.core.window.components.ITextWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.RoomSettingsFlatInfo;
    import com.sulake.habbo.navigator.domain.Tabs;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.communication.messages.outgoing.newnavigator.NavigatorAddCollapsedCategoryMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.newnavigator.NavigatorRemoveCollapsedCategoryMessageComposer;

     class OfficialRoomEntryManager implements IDisposable 
    {
        static inline final HOTTEST_GROUPS= "hottest_groups";
        static inline final _Str_18121= 267;
        static inline final _Str_19023= 65;
        static inline final _Str_20053= -70;
        static inline final THUMBNAIL_SIZE= 64;
        static inline final ENTRY_SIDE_PADDING= 5;
        static inline final DETAILS_OFFSET_X= 72;
        static inline final OFFICIAL_ROOT_SEARCH_CODE= "official_view";

        var _disposed:Bool = false;
        var _navigator:IHabboTransitionalNavigator;
        var _userCountRenderer:UserCountRenderer;

        public function new(k:IHabboTransitionalNavigator)        {
            this._navigator = k;
            this._userCountRenderer = new UserCountRenderer(this._navigator);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (this._userCountRenderer != null)
            {
                this._userCountRenderer.dispose();
                this._userCountRenderer = null;
            }
            this._disposed = true;
        }

        public function _Str_21717(k:IWindowContainer)
        {
            if (this._navigator.data._Str_5653 == null)
            {
                return;
            }
            var _local_2= "ad_footer";
            var _local_3= cast(k.getChildByName("ad_footer"), IWindowContainer);
            var _local_4= cast(_local_3.getChildByName("ad_cont"), IWindowContainer);
            if (_local_4.numChildren < 1)
            {
                _local_4.addChild(this._Str_9034(true));
            }
            var _local_5= cast(_local_4.getChildAt(0), IWindowContainer);
            this.refreshEntry(_local_5, true, this._navigator.data._Str_5653);
            _local_3.visible = true;
            this._navigator.data._Str_6357++;
        }

        public function _Str_9034(k:Bool):IWindowContainer
        {
            var _local_5:IBitmapWrapperWindow = null;
            var _local_2= cast(this._navigator.getXmlWindow("grs_official_room_row_phase_one"), IWindowContainer);
            var _local_3= cast(_local_2.findChildByName("image_cont"), IWindowContainer);
            var _local_4= (k ? "" : "_b");
            this._navigator.refreshButton(_local_3, ("rico_rnd_l" + _local_4), true, null, 0);
            this._navigator.refreshButton(_local_3, ("rico_rnd_r" + _local_4), true, null, 0);
            _local_5 = Std.downcast(_local_3.findChildByName("rico_rnd_m") , IBitmapWrapperWindow);
            _local_5.bitmap = this._navigator.getButtonImage("rico_rnd_m");
            _local_5.disposesBitmap = false;
            var _local_6= cast(_local_2.findChildByName("folder_cont"), IWindowContainer);
            this._navigator.refreshButton(_local_6, ("rico_rnd_l" + _local_4), true, null, 0);
            this._navigator.refreshButton(_local_6, ("rico_rnd_r" + _local_4), true, null, 0);
            _local_5 = Std.downcast(_local_6.findChildByName("rico_rnd_m") , IBitmapWrapperWindow);
            _local_5.bitmap = this._navigator.getButtonImage("rico_rnd_m");
            _local_5.disposesBitmap = false;
            _local_2.addEventListener(WindowMouseEvent.OVER, this._Str_22658);
            _local_2.addEventListener(WindowMouseEvent.OUT, this._Str_24237);
            _local_2.addEventListener(WindowMouseEvent.CLICK, this._Str_24488);
            _local_2.color = (k ? 0xFFFFFFFF : 0xFFDEE4F2);
            return _local_2;
        }

        public function refreshEntry(k:IWindowContainer, _arg_2:Bool, _arg_3:OfficialRoomEntryData)
        {
            Util.hideChildren(k);
            if (_arg_2)
            {
                k.id = _arg_3.index;
                if (_arg_3.type == OfficialRoomEntryData._Str_16098)
                {
                    this._Str_23826(k, _arg_3);
                }
                else
                {
                    this._Str_23189(k, _arg_3);
                }
                this.layoutEntry(k, _arg_3);
                k.visible = true;
            }
            else
            {
                k.height = 0;
                k.visible = false;
            }
        }

        function _Str_23189(k:IWindowContainer, _arg_2:OfficialRoomEntryData)
        {
            this._Str_24261(k, _arg_2);
            this._Str_25008(k, _arg_2);
            this.refreshUserCount(k, _arg_2);
            k.height = 68;
        }

        function _Str_23826(k:IWindowContainer, _arg_2:OfficialRoomEntryData)
        {
            var _local_3= cast(k.findChildByName("folder_cont"), IWindowContainer);
            _local_3.visible = true;
            var _local_4= cast(_local_3.findChildByName("folder_name_text"), ITextWindow);
            _local_4.text = this._Str_25165(_arg_2);
            var _local_5= cast(_local_3.findChildByName("arrow_label"), ITextWindow);
            _local_5.text = (_arg_2.open ? "${navigator.folder.hide}" : "${navigator.folder.show}");
            this._navigator.refreshButton(_local_3, "arrow_down_white", _arg_2.open, null, 0);
            this._navigator.refreshButton(_local_3, "arrow_right_white", (!_arg_2.open), null, 0);
            this._Str_24387(_local_3, _arg_2);
            k.height = 68;
            var _local_6= cast(k.findChildByName("folderNameContainer"), IWindowContainer);
            if (_local_4.text == "")
            {
                _local_6.visible = false;
                return;
            }
            _local_6.visible = true;
            if (!this._navigator.isPerkAllowed("NAVIGATOR_PHASE_ONE_2014"))
            {
                _local_6.width = Std.int(_local_4.textWidth + 20);
            }
        }

        function refreshUserCount(k:IWindowContainer, _arg_2:OfficialRoomEntryData)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            if ((_arg_2._Str_5386 && (_arg_2.type == OfficialRoomEntryData._Str_12025)))
            {
                _local_3 = 3;
                _local_4 = 34;
                _local_5 = 13;
                this._userCountRenderer.refreshUserCount(_arg_2._Str_23003, k, _arg_2.userCount, "${navigator.usercounttooltip.users}", ((k.width - _local_3) - _local_4), ((k.height - _local_3) - _local_5));
            }
        }

        function _Str_24261(k:IWindowContainer, _arg_2:OfficialRoomEntryData)
        {
            var _local_3= cast(k.findChildByName("image_cont"), IWindowContainer);
            _local_3.visible = true;
            _local_3.width = Std.int(_arg_2._Str_5386 ? _Str_19023 : Std.int(Math.max(_Str_18121, k.width - (ENTRY_SIDE_PADDING * 2))));
            this._Str_23785(_local_3, _arg_2);
            this._Str_25146(_local_3, _arg_2);
        }

        function layoutEntry(k:IWindowContainer, _arg_2:OfficialRoomEntryData)
        {
            var _local_3= cast(k.findChildByName("image_cont"), IWindowContainer);
            var _local_4= cast(k.findChildByName("folder_cont"), IWindowContainer);
            var _local_5= cast(k.findChildByName("details_container"), IWindowContainer);
            var _local_6:IWindowContainer = null;
            var _local_7:ITextWindow = null;
            var _local_8:IWindowContainer = null;

            if (_local_3 != null)
            {
                _local_3.x = ENTRY_SIDE_PADDING;
            }

            if (_local_4 != null)
            {
                _local_4.x = ENTRY_SIDE_PADDING;
                _local_4.width = Std.int(Math.max(_Str_18121, k.width - (ENTRY_SIDE_PADDING * 2)));

                _local_8 = cast(_local_4.findChildByName("arrowContainer"), IWindowContainer);
                if (_local_8 != null)
                {
                    _local_8.x = Std.int(Math.max(0, (_local_4.width - _local_8.width) - 2));
                }

                _local_6 = cast(k.findChildByName("folderNameContainer"), IWindowContainer);
                _local_7 = cast(_local_4.findChildByName("folder_name_text"), ITextWindow);

                if (_local_6 != null)
                {
                    _local_6.width = Std.int(Math.max(0, _local_4.width));
                }

                if ((_local_6 != null) && (_local_7 != null))
                {
                    _local_7.width = Std.int(Math.max(0, _local_6.width - 10));
                }
            }

            if (_local_5 != null)
            {
                _local_5.x = DETAILS_OFFSET_X;
                _local_5.width = Std.int(Math.max(0, k.width - _local_5.x - ENTRY_SIDE_PADDING));
            }
        }

        function _Str_23785(k:IWindowContainer, _arg_2:OfficialRoomEntryData)
        {
            var _local_3= cast(k.findChildByName("picTextContainer"), IWindowContainer);
            if (((_arg_2.picText == "") || _arg_2._Str_5386))
            {
                _local_3.visible = false;
                return;
            }
            var _local_4= 5;
            _local_3.visible = true;
            var _local_5= cast(_local_3.findChildByName("picText"), ITextWindow);
            _local_5.text = _arg_2.picText;
            _local_5.height = Std.int(_local_5.textHeight + 10);
            var _local_6:ASAny = (_local_5.textHeight > 10);
            _local_3.height = (_local_5.height + 4);
        }

        function _Str_24387(k:IWindowContainer, _arg_2:OfficialRoomEntryData)
        {
            var _local_3= cast(k.findChildByName("folder_image"), IBitmapWrapperWindow);
            _local_3.visible = false;
            if (_arg_2._Str_10304 != "")
            {
                this._Str_21174(_arg_2, _local_3);
            }
        }

        function _Str_25146(k:IWindowContainer, _arg_2:OfficialRoomEntryData)
        {
            var _local_3= cast(k.findChildByName("room_image"), IBitmapWrapperWindow);
            _local_3.visible = false;
            if (_arg_2._Str_10304 != "")
            {
                this._Str_21174(_arg_2, _local_3);
            }
            else
            {
                if (_arg_2._Str_5019 != null)
                {
                    this._Str_24128(k, _arg_2, _local_3);
                }
                else
                {
                    this._Str_24928(k, _arg_2, _local_3);
                }
            }
        }

        function _Str_21174(k:OfficialRoomEntryData, _arg_2:IBitmapWrapperWindow)
        {
            var _local_3= ("customImage." + k._Str_10304);
            if (_arg_2.tags[0] == _local_3)
            {
                _arg_2.visible = true;
                return;
            }
            Logger.log([("Loading custom image: " + k._Str_10304)]);
            _arg_2.x = 0;
            _arg_2.visible = false;
            var _local_4:OfficialRoomImageLoader = null;
            _arg_2.tags.splice(0, _arg_2.tags.length);
            _arg_2.tags.push(_local_3);
            if (k._Str_5386)
            {
                _local_4 = new OfficialRoomImageLoader(this._navigator, k._Str_10304, _arg_2, null, "image/gif", THUMBNAIL_SIZE, THUMBNAIL_SIZE, true);
            }
            else
            {
                _local_4 = new OfficialRoomImageLoader(this._navigator, k._Str_10304, _arg_2);
            }
            _local_4._Str_24517();
        }

        function _Str_24128(k:IWindowContainer, _arg_2:OfficialRoomEntryData, _arg_3:IBitmapWrapperWindow)
        {
            var _local_4= this.buildThumbnailUrl(_arg_2._Str_5019);
            var _local_5= this._navigator.data.getRoomThumbnailRefreshKey(_arg_2._Str_5019.flatId);
            if (((!(_local_5 == null)) && (!(_local_5 == ""))))
            {
                _local_4 = (_local_4 + ("?v=" + _local_5));
            }
            var _local_6= this._Str_25434(_arg_2._Str_5019, _local_5);
            if (_arg_3.tags[0] == _local_6)
            {
                _arg_3.visible = true;
                return;
            }
            Logger.log([("Loading guest room image: " + _local_4)]);
            _arg_3.x = 0;
            _arg_3.width = THUMBNAIL_SIZE;
            _arg_3.bitmap = new BitmapData(THUMBNAIL_SIZE, THUMBNAIL_SIZE);
            _arg_3.bitmap.fillRect(_arg_3.bitmap.rect, 0xFFFFFFFF);
            var _local_7= new OfficialRoomImageLoader(this._navigator, _local_6, _arg_3, _local_4, "image/png", THUMBNAIL_SIZE, THUMBNAIL_SIZE, true);
            _arg_3.tags.splice(0, _arg_3.tags.length);
            _arg_3.tags.push(_local_6);
            _local_7._Str_24517();
            _arg_3.visible = true;
        }

        function buildThumbnailUrl(k:GuestRoomData):String
        {
            if (((k.officialRoomPicRef != null) && (!this._navigator.getBoolean("new.navigator.official.room.thumbnails.in.amazon"))))
            {
                return (this._navigator.getProperty("image.library.url") + k.officialRoomPicRef);
            }
            return ((this._navigator.getProperty("navigator.thumbnail.url_base") + Std.string(k.flatId)) + ".png");
        }

        function _Str_25434(k:GuestRoomData, _arg_2:String):String
        {
            return (("guestRoomThumb_" + Std.string(k.flatId)) + (((_arg_2 != null) && (!(_arg_2 == ""))) ? ("_" + _arg_2) : ""));
        }

        function _Str_24928(k:IWindowContainer, _arg_2:OfficialRoomEntryData, _arg_3:IBitmapWrapperWindow)
        {
            var _local_4= "empty";
            if (_arg_3.tags[0] == _local_4)
            {
                _arg_3.visible = true;
                return;
            }
            Logger.log(["Redrawing empty image"]);
            _arg_3.x = 0;
            _arg_3.width = 64;
            _arg_3.bitmap = new BitmapData(64, 64, false, 0xFFCCCCCC);
            _arg_3.tags.splice(0, _arg_3.tags.length);
            _arg_3.tags.push(_local_4);
            _arg_3.visible = true;
        }

        function _Str_22658(k:WindowEvent)
        {
            var _local_2= k.target;
            this._Str_21153(_local_2, true);
        }

        function _Str_24237(k:WindowEvent)
        {
            var _local_2= k.target;
            this._Str_21153(_local_2, false);
        }

        function _Str_24488(k:WindowEvent)
        {
            var _local_2= k.target;
            this._Str_25371(_local_2);
        }

        function _Str_21153(k:IWindow, _arg_2:Bool)
        {
            var _local_5:IBitmapWrapperWindow = null;
            var _local_3= cast(k, IWindowContainer);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= cast(_local_3.findChildByName("enter_room"), IWindowContainer);
            if (_local_4 == null)
            {
                return;
            }
            if (_arg_2)
            {
                this._navigator.refreshButton(_local_4, "enter_room_l", true, null, 0);
                this._navigator.refreshButton(_local_4, "enter_room_r", true, null, 0);
                _local_5 = cast(_local_4.findChildByName("enter_room_m"), IBitmapWrapperWindow);
                if (_local_5.bitmap == null)
                {
                    _local_5.bitmap = this._navigator.getButtonImage("enter_room_m");
                    _local_5.disposesBitmap = false;
                }
                this._navigator.refreshButton(_local_4, "enter_room_a", true, null, 0);
            }
            _local_4.visible = _arg_2;
        }

        function _Str_25371(k:IWindow)
        {
            var _local_2= this.getEntry(k);
            if (_local_2 == null)
            {
                return;
            }
            if (_local_2._Str_5019 != null)
            {
                Logger.log([("ENTERING ROOM: " + Std.string(_local_2._Str_5019.flatId))]);
                if (_local_2._Str_5019.doorMode == RoomSettingsFlatInfo.DOORMODE_PASSWORD)
                {
                    this._navigator.passwordInput.show(_local_2._Str_5019);
                }
                else
                {
                    this._navigator.goToRoom(_local_2._Str_5019.flatId, true);
                }
            }
            else
            {
                if (_local_2.tag != null)
                {
                    Logger.log([("MAKING TAG SEARCH: " + _local_2.tag)]);
                    if (_local_2.tag == HOTTEST_GROUPS)
                    {
                        this._navigator.performGuildBaseSearch();
                    }
                    else
                    {
                        this._navigator.mainViewCtrl.startSearch(Tabs.TAB_SEARCH, Tabs.SEARCHTYPE_TAG_SEARCH, _local_2.tag);
                    }
                }
                else
                {
                    Logger.log([("FOLDER CLICKD: " + Std.string(_local_2.index))]);
                    _local_2._Str_16147();
                    this._Str_25532(_local_2);
                    this._navigator.mainViewCtrl.refresh();
                }
            }
        }

        function _Str_25532(k:OfficialRoomEntryData)
        {
            var _local_2= this._Str_25234(k);
            if (_local_2 == null)
            {
                return;
            }
            if (k.open)
            {
                this._navigator.send(new NavigatorRemoveCollapsedCategoryMessageComposer(_local_2));
            }
            else
            {
                this._navigator.send(new NavigatorAddCollapsedCategoryMessageComposer(_local_2));
            }
        }

        function _Str_25234(k:OfficialRoomEntryData):String
        {
            if (((k == null) || (!(k.type == OfficialRoomEntryData._Str_16098))))
            {
                return null;
            }
            var _local_2= k._Str_9428;
            if (((_local_2 == null) || (_local_2 == "")))
            {
                return null;
            }
            var _local_3= this._navigator.getText(("navigator.searchcode.title." + OFFICIAL_ROOT_SEARCH_CODE));
            if (((_local_2 == _local_3) || (_local_2 == "Public Rooms")))
            {
                return OFFICIAL_ROOT_SEARCH_CODE;
            }
            return _local_2;
        }

        function _Str_25165(k:OfficialRoomEntryData):String
        {
            var _local_2= this._Str_25234(k);
            if (_local_2 == null)
            {
                return "";
            }
            var _local_3= ("navigator.searchcode.title." + _local_2);
            var _local_4= this._navigator.getText(_local_3);
            return (_local_4 == _local_3) ? k._Str_9428 : _local_4;
        }

        function getEntry(k:IWindow):OfficialRoomEntryData
        {
            var _local_2= Std.downcast(k , IWindowContainer);
            if (((_local_2 == null) || (!(_local_2.name == "cont"))))
            {
                Logger.log(["Target not cont"]);
                return null;
            }
            Logger.log([("PARENT NAME: " + k.parent.name)]);
            return (_local_2.parent.name == "ad_cont") ? this._Str_23608() : this._Str_23984(_local_2);
        }

        function _Str_23608():OfficialRoomEntryData
        {
            return this._navigator.data._Str_5653;
        }

        function _Str_23984(k:IWindowContainer):OfficialRoomEntryData
        {
            var _local_3:OfficialRoomEntryData = null;
            if (this._navigator.data._Str_5645 == null)
            {
                Logger.log(["No official rooms data click"]);
                return null;
            }
            var _local_2= k.id;
            Logger.log([("Got index: " + Std.string(_local_2))]);
            final _iter_ = this._navigator.data._Str_5645.entries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.index == _local_2)
                {
                    return _local_3;
                }
            }
            Logger.log([((("No room found " + Std.string(_local_2)) + ", ") + Std.string(this._navigator.data._Str_5645.entries.length))]);
            return null;
        }

        function _Str_25008(k:IWindowContainer, _arg_2:OfficialRoomEntryData)
        {
            var _local_3= cast(k.findChildByName("details_container"), IWindowContainer);
            _local_3.visible = _arg_2._Str_5386;
            Logger.log([("Refreshing details: " + Std.string(_local_3.visible))]);
            if (!_arg_2._Str_5386)
            {
                return;
            }
            Util.hideChildren(_local_3);
            this._Str_22428(_local_3, _arg_2);
            this._Str_25192(_local_3, _arg_2);
        }

        function _Str_22428(k:IWindowContainer, _arg_2:OfficialRoomEntryData)
        {
            var _local_3= cast(k.getChildByName("entry_caption"), ITextWindow);
            _local_3.visible = true;
            _local_3.text = this._Str_24014(_arg_2);
        }

        function _Str_25192(k:IWindowContainer, _arg_2:OfficialRoomEntryData)
        {
            var _local_3= this._Str_22796(_arg_2);
            if (_local_3 == "")
            {
                return;
            }
            var _local_4= "entry_desc";
            var _local_5= cast(k.getChildByName(_local_4), ITextWindow);
            _local_5.text = _local_3;
            _local_5.visible = true;
        }

        public function _Str_24014(k:OfficialRoomEntryData):String
        {
            if (((!(k._Str_9428 == null)) && (!(k._Str_9428 == ""))))
            {
                return k._Str_9428;
            }
            if (k._Str_5019 != null)
            {
                return k._Str_5019.roomName;
            }
            if (((!(k.tag == null)) && (!(k.tag == ""))))
            {
                return k.tag;
            }
            return "NA";
        }

        public function _Str_22796(k:OfficialRoomEntryData):String
        {
            if (((!(k._Str_9428 == null)) && (!(k._Str_9428 == ""))))
            {
                return k._Str_22426;
            }
            if (k._Str_5019 != null)
            {
                return k._Str_5019.description;
            }
            return "";
        }
    }

