package com.sulake.habbo.roomevents.wired_menu
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.window.widgets._Str_18605;

    /**
     * July's permanent-variable holder preview used by the management detail
     * window. User and bot figures use the avatar widget; pets use the pet
     * widget. Clicking an avatar opens its profile, as it does in July.
     */
     final class WiredMenuPermanentVariablePreviewer
        implements IDisposable
    {
        var _container:IWindowContainer;
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _userId:Int = -1;
        var _disposed:Bool = false;

        public function new(
            container:IWindowContainer,
            roomEvents:HabboUserDefinedRoomEvents)
        {
            this._container = container;
            this._roomEvents = roomEvents;
            this.clear();
            var region= this.avatarRegion;
            if (region != null)
            {
                region.addEventListener(WindowMouseEvent.CLICK,
                    this.onAvatarClicked);
            }
        }

        public function clear()
        {
            this._userId = -1;
            this.hide("avatar_preview");
            this.hide("pet_preview");
            this.hide("avatar_preview_region");
        }

        public function showPet(figure:String)
        {
            this.clear();
            var preview=
                Std.downcast(this.find("pet_preview") , IWidgetWindow);
            if (preview != null && Std.is(preview.widget , _Str_18605))
            {
                (cast(preview.widget, _Str_18605)).figure = figure;
                preview.visible = true;
                center(preview);
            }
        }

        public function showUser(figure:String, userId:Int=-1)
        {
            this.clear();
            var preview=
                Std.downcast(this.find("avatar_preview") , IWidgetWindow);
            if (preview != null && Std.is(preview.widget , IAvatarImageWidget))
            {
                (cast(preview.widget, IAvatarImageWidget)).figure = figure;
                preview.visible = true;
                center(preview);
            }
            this._userId = userId;
            var region= this.avatarRegion;
            if (region != null)
            {
                region.visible = userId != -1;
            }
        }

        function onAvatarClicked(event:WindowMouseEvent)
        {
            if (this._roomEvents != null && this._userId != -1)
            {
                this._roomEvents.send(
                    new GetExtendedProfileMessageComposer(this._userId, true));
            }
        }

        static function center(window:IWindow)
        {
            if (window != null && window.parent != null)
            {
                window.x = Std.int((window.parent.width - window.width) / 2);
                window.y = Std.int((window.parent.height - window.height) / 2);
            }
        }

        function find(name:String):IWindow
        {
            return this._container == null ? null :
                this._container.findChildByName(name);
        }

        function hide(name:String)
        {
            var window= this.find(name);
            if (window != null)
            {
                window.visible = false;
            }
        }

        var avatarRegion(get,never):IRegionWindow;
function  get_avatarRegion():IRegionWindow
        {
            return Std.downcast(this.find("avatar_preview_region") , IRegionWindow);
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            var region= this.avatarRegion;
            if (region != null)
            {
                region.removeEventListener(WindowMouseEvent.CLICK,
                    this.onAvatarClicked);
            }
            this.clear();
            this._container = null;
            this._roomEvents = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }

