package com.sulake.habbo.avatar.wardrobe
;
    import com.sulake.habbo.avatar.IOutfit;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar.HabboAvatarEditor;
    import com.sulake.habbo.avatar.figuredata.FigureData;
    import flash.display.BitmapData;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.habbo.avatar.figuredata.FigureDataView;

     class Outfit implements IOutfit implements  IAvatarImageListener 
    {
        var _controller:HabboAvatarEditor;
        var _figure:String;
        var _gender:String;
        var _view:OutfitView;
        var _isDisposed:Bool = false;

        public function new(k:HabboAvatarEditor, _arg_2:String, _arg_3:String)
        {
            this._controller = k;
            this._view = new OutfitView(k.manager.windowManager, k.manager.assets, (!(_arg_2 == "")));
            switch (_arg_3)
            {
                case FigureData.M
                   | "m"
                   | "M":
                    _arg_3 = FigureData.M;
                    
                case FigureData.F
                   | "f"
                   | "F":
                    _arg_3 = FigureData.F;
                    
            }
            this._figure = _arg_2;
            this._gender = _arg_3;
            this.update();
        }

        public function dispose()
        {
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this._figure = null;
            this._gender = null;
            this._isDisposed = true;
            this._controller = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public function update()
        {
            var _local_3:BitmapData = null;
            var k= this._controller.manager.getBoolean("zoom.enabled");
            var _local_2= this._controller.manager.avatarRenderManager.createAvatarImage(this.figure, (k ? AvatarScaleType.LARGE : AvatarScaleType.SMALL), this._gender, this);
            if (_local_2 != null)
            {
                _local_2.setDirection(AvatarSetType.FULL, FigureDataView._Str_9887);
                _local_3 = _local_2.getImage(AvatarSetType.FULL, true, (k ? 0.5 : 1));
                if (((this._view != null) && (_local_3 != null)))
                {
                    this._view._Str_25268(_local_3);
                }
                _local_2.dispose();
            }
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var gender(get,never):String;
public function  get_gender():String
        {
            return this._gender;
        }

        public var view(get,never):OutfitView;
public function  get_view():OutfitView
        {
            return this._view;
        }

        public function avatarImageReady(k:String)
        {
            this.update();
        }
    }

