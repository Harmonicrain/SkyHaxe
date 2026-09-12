package com.sulake.habbo.avatar.wardrobe
;
    import com.sulake.habbo.avatar.IOutfit;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar.HabboAvatarEditor;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.avatar.figuredata.FigureData;
    import flash.display.BitmapData;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.habbo.avatar.figuredata.FigureDataView;
    import flash.geom.Matrix;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class WardrobeSlot implements IOutfit implements  IAvatarImageListener
    {
        var _habboAvatarEditor:HabboAvatarEditor;
        var _figure:String;
        var _gender:String;
        var _Str_3886:Bool = false;
        var _view:IWindowContainer;
        var _Str_5246:IBitmapWrapperWindow;
        var _id:Int = 0;
        var _disposed:Bool = false;

        public function new(k:IWindow, _arg_2:HabboAvatarEditor, _arg_3:Int, _arg_4:Bool, _arg_5:String=null, _arg_6:String=null)
        {
            this._habboAvatarEditor = _arg_2;
            this._id = _arg_3;
            this._Str_13142(k);
            this.update(_arg_5, _arg_6, _arg_4);
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public function update(k:String, _arg_2:String, _arg_3:Bool)
        {
            switch (_arg_2)
            {
                case FigureData.M
                   | "m"
                   | "M":
                    _arg_2 = FigureData.M;
                    
                case FigureData.F
                   | "f"
                   | "F":
                    _arg_2 = FigureData.F;
                    
            }
            this._figure = k;
            this._gender = _arg_2;
            this._Str_3886 = _arg_3;
            this.updateView();
        }

        function _Str_13142(k:IWindow)
        {
            this._view = Std.downcast(k.clone() , IWindowContainer);
            this._view.procedure = this.eventHandler;
            this._view.visible = false;
            this._Str_5246 = Std.downcast(this._view.findChildByName("image") , IBitmapWrapperWindow);
        }

        public function dispose()
        {
            this._habboAvatarEditor = null;
            this._figure = null;
            this._gender = null;
            this._Str_5246 = null;
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function updateView()
        {
            var k:BitmapData = null;
            var _local_6:IAvatarImage = null;
            var _local_7:BitmapDataAsset = null;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_2= true;
            var _local_3= this._habboAvatarEditor.manager.getBoolean("zoom.enabled");
            if ((ASCompat.stringAsBool(this._figure) && this._Str_3886))
            {
                _local_6 = this._habboAvatarEditor.manager.avatarRenderManager.createAvatarImage(this.figure, (_local_3 ? AvatarScaleType.LARGE : AvatarScaleType.SMALL), this._gender, this);
                if (_local_6 != null)
                {
                    _local_6.setDirection(AvatarSetType.FULL, FigureDataView._Str_9887);
k = _local_6.getCroppedImage(AvatarSetType.FULL, (_local_3 ? 0.5 : 1));
                    _local_6.dispose();
                }
            }
            else
            {
                _local_7 = Std.downcast(this._habboAvatarEditor.manager.windowManager.assets.getAssetByName("avatar_editor_wardrobe_empty_slot") , BitmapDataAsset);
                if (_local_7 != null)
                {
                    k = ASCompat.dynamicAs(_local_7.content , BitmapData);
                    _local_2 = false;
                }
            }
            if (k == null)
            {
                return;
            }
            if (this._Str_5246 != null)
            {
                if (this._Str_5246.bitmap != null)
                {
                    this._Str_5246.bitmap.dispose();
                }
                this._Str_5246.bitmap = new BitmapData(this._Str_5246.width, this._Str_5246.height, true, 0);
                _local_8 = Std.int((this._Str_5246.width - k.width) / 2);
                _local_9 = Std.int((this._Str_5246.height - k.height) / 2);
                this._Str_5246.bitmap.draw(k, new Matrix(1, 0, 0, 1, _local_8, _local_9));
            }
            if (_local_2)
            {
                k.dispose();
            }
            var _local_4= Std.downcast(this._view.findChildByName("set_button") , IContainerButtonWindow);
            if (_local_4 != null)
            {
                _local_4.visible = this._Str_3886;
            }
            var _local_5= Std.downcast(this._view.findChildByName("get_button") , IContainerButtonWindow);
            if (_local_5 != null)
            {
                _local_5.visible = (this._Str_3886 && (!(this._figure == null)));
            }
        }

        function eventHandler(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (!this._habboAvatarEditor.verifyClubLevel())
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "set_button":
                    this._figure = this._habboAvatarEditor.figureData.getFigureString();
                    this._gender = this._habboAvatarEditor.gender;
                    this._habboAvatarEditor.handler._Str_25374(this._id, this);
                    this.updateView();
                    return;
                case "get_button"
                   | "get_figure":
                    if (ASCompat.stringAsBool(this._figure))
                    {
                        this._habboAvatarEditor.loadAvatarInEditor(this._figure, this._gender, this._habboAvatarEditor.clubMemberLevel);
                    }
                    return;
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

        public var view(get,never):IWindowContainer;
public function  get_view():IWindowContainer
        {
            return this._view;
        }

        public function avatarImageReady(k:String)
        {
            this.updateView();
        }
    }




