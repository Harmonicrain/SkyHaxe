package com.sulake.habbo.roomevents.wired_menu
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.utils.IBitmapDataContainer;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.window.widgets._Str_18605;
    import com.sulake.room.utils.Vector3d;

    /**
     * July's Inspection preview adapted to the clean client's widget and room
     * image APIs. The selected holder is rendered locally; the inspection
     * packet remains the authority for which holder is currently active.
     */
     final class WiredMenuInspectionPreviewer implements IDisposable
    {
        var _container:IWindowContainer;
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _furniId:Int = 0;
        var _userIndex:Int = -1;
        var _disposed:Bool = false;

        public function new(
            container:IWindowContainer,
            roomEvents:HabboUserDefinedRoomEvents)
        {
            this._container = container;
            this._roomEvents = roomEvents;
            this.clear();
        }

        public function clear()
        {
            this._furniId = 0;
            this._userIndex = -1;
            this.hide("preview_instruction_furni");
            this.hide("preview_instruction_user");
            this.hide("preview_avatar");
            this.hide("preview_pet");
            this.hide("preview_image_bitmap");
            this.hide("global_placeholder");
            var image= this.previewImage;
            if (image != null)
            {
                image.disposesBitmap = true;
                image.bitmap = null;
            }
        }

        public function showFurniInstruction()
        {
            this.clear();
            this.show("preview_instruction_furni");
        }

        public function showUserInstruction()
        {
            this.clear();
            this.show("preview_instruction_user");
        }

        public function showGlobal()
        {
            this.clear();
            this.show("global_placeholder");
        }

        public function showUser(userIndex:Int)
        {
            if (userIndex == this._userIndex)
            {
                return;
            }
            this.clear();
            if (this._roomEvents == null
                || this._roomEvents.roomSession == null)
            {
                return;
            }
            var data= this._roomEvents.roomSession
                .userDataManager.getUserDataByIndex(userIndex);
            if (data == null)
            {
                return;
            }
            var widgetWindow:IWidgetWindow = null;
            if (data.type == 2)
            {
                widgetWindow = Std.downcast(this.find("preview_pet") , IWidgetWindow);
                if (widgetWindow != null && Std.is(widgetWindow.widget , _Str_18605))
                {
                    (cast(widgetWindow.widget, _Str_18605)).figure = data.figure;
                }
            }
            else
            {
                widgetWindow = Std.downcast(this.find("preview_avatar") , IWidgetWindow);
                if (widgetWindow != null
                    && Std.is(widgetWindow.widget , IAvatarImageWidget))
                {
                    (cast(widgetWindow.widget, IAvatarImageWidget)).figure =
                        data.figure;
                }
            }
            if (widgetWindow != null)
            {
                widgetWindow.visible = true;
                center(widgetWindow);
            }
            this._userIndex = userIndex;
        }

        public function showFurni(objectId:Int)
        {
var scale = Math.NaN;            if (objectId == this._furniId)
            {
                return;
            }
            this.clear();
            if (this._roomEvents == null
                || this._roomEvents.roomEngine == null
                || objectId == 0)
            {
                return;
            }
            var category= objectId > 0
                ? RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE
                : RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM;
            var visibleId= Std.int(Math.abs(objectId));
            var result= this._roomEvents.roomEngine
                .getRoomObjectImage(
                    this._roomEvents.roomEngine.activeRoomId,
                    visibleId, category, new Vector3d(180), 64, null);
            if (result == null || result.data == null)
            {
                return;
            }
            var image= this.previewImage;
            if (image == null)
            {
                return;
            }
            image.disposesBitmap = true;
            image.bitmap = result.data.clone();
            var bitmapContainer=
                ASCompat.reinterpretAs(image , IBitmapDataContainer);
            if (bitmapContainer != null)
            {
scale=
                    result.data.width >= this._container.width - 6
                    || result.data.height > this._container.height - 6
                    ? 0.5 : 1;
                bitmapContainer.zoomX = scale;
                bitmapContainer.zoomY = scale;
            }
            image.visible = true;
            center(image);
            this._furniId = objectId;
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

        function show(name:String)
        {
            var window= this.find(name);
            if (window != null)
            {
                window.visible = true;
            }
        }

        function hide(name:String)
        {
            var window= this.find(name);
            if (window != null)
            {
                window.visible = false;
            }
        }

        var previewImage(get,never):IBitmapWrapperWindow;
function  get_previewImage():IBitmapWrapperWindow
        {
            return Std.downcast(this.find("preview_image_bitmap") , IBitmapWrapperWindow);
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
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

