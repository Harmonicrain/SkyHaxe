package com.sulake.habbo.avatar.figuredata
;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.window.widgets.IRoomPreviewerWidget;
    import com.sulake.habbo.room.preview.RoomPreviewer;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
	import com.sulake.habbo.avatar.figuredata.FigureData;

     class FigureDataView implements IAvatarImageListener 
    {
        public static inline final _Str_9887= 4;

        var _widget:IRoomPreviewerWidget;
        var _roomPreviewer:RoomPreviewer;
        var _model:FigureData;
        var _figureString:String;
        var _isDisposed:Bool = false;

        public function new(k:FigureData)
        {
            this._model = k;
            this._widget = Std.downcast(k.avatarEditor.view._Str_25244().widget , IRoomPreviewerWidget);
            this._roomPreviewer = this._widget.roomPreviewer;
            this._roomPreviewer.updateRoomWallsAndFloorVisibility(false, false);
        }

        public function update(k:String, _arg_2:Int=0, _arg_3:Int=4)
        {
            var _local_4:IAvatarImage = null;
            this._figureString = k;
            if (this._roomPreviewer.isRoomEngineReady)
            {
                this._roomPreviewer.addAvatarIntoRoom(k, _arg_2);
                this._roomPreviewer.updateAvatarDirection(_arg_3, _arg_3);
                this._roomPreviewer.updatePreviewRoomView(true);
                this._roomPreviewer.updateRoomEngine();
            }
            else
            {
                _local_4 = this._model.avatarEditor.manager.avatarRenderManager.createAvatarImage(k, AvatarScaleType.LARGE, null, this);
this._widget.showPreview(_local_4.getCroppedImage(AvatarSetType.FULL));
            }
        }

        public function avatarImageReady(k:String)
        {
            var _local_2:IAvatarImage = null;
            if (k == this._figureString)
            {
                _local_2 = this._model.avatarEditor.manager.avatarRenderManager.createAvatarImage(this._figureString, AvatarScaleType.LARGE, null, this);
this._widget.showPreview(_local_2.getCroppedImage(AvatarSetType.FULL));
            }
        }

        public function dispose()
        {
            this._isDisposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }
    }


