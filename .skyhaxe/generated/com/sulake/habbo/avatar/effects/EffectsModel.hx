package com.sulake.habbo.avatar.effects
;
    import com.sulake.habbo.avatar.common.CategoryBaseModel;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryModel;
    import com.sulake.habbo.avatar.HabboAvatarEditor;
    import com.sulake.habbo.avatar.IHabboAvatarEditorAvatarEffect;

     class EffectsModel extends CategoryBaseModel implements IAvatarEditorCategoryModel 
    {
        public static inline final EFFECTS= "effects";

        var _selectedIndex:ASDictionary<ASAny,ASAny>;
        var _effectsParamView:EffectsParamView;

        public function new(k:HabboAvatarEditor)
        {
            this._selectedIndex = new ASDictionary<ASAny,ASAny>();
            super(k);
        }

        override function init()
        {
            super.init();
            _isInitialized = true;
            if (_view == null)
            {
                _view = new EffectsView(this);
                this._effectsParamView = new EffectsParamView(this, controller.manager.windowManager, controller.manager.assets);
                if (_view != null)
                {
                    _view.init();
                }
            }
        }

        public var effects(get,never):Array<ASAny>;
public function  get_effects():Array<ASAny>
        {
            if (controller.manager.inventory == null)
            {
                return [];
            }
            return controller.manager.inventory.getAvatarEffects();
        }

        override public function selectPart(k:String, _arg_2:Int)
        {
            var _local_4:ASAny = null;
            var _local_5:IHabboAvatarEditorAvatarEffect = null;
            this._Str_20089(k, ASCompat.toInt(this._selectedIndex[k]), false);
            var _local_3= controller.figureData.avatarEffectType;
            if (((_arg_2 == -1) && (!(_local_3 == -1))))
            {
                _arg_2 = cast(_view, EffectsView)._Str_17454(_local_3);
                final _iter_ = this.effects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    if (_local_4.type == _local_3)
                    {
                        _local_5 = cast(_local_4, IHabboAvatarEditorAvatarEffect);
                        _local_5.Selected = true;
                        break;
                    }
                }
            }
            else
            {
                if ((((_arg_2 == -1) && (_local_3 == -1)) || (_arg_2 == 0)))
                {
                    _arg_2 = 0;
                    controller.setAvatarEffectType(-1);
                    this._effectsParamView.updateView(null);
                }
                else
                {
                    _local_5 = cast(this.effects[(_arg_2 - 1)], IHabboAvatarEditorAvatarEffect);
                    _local_5.Selected = true;
                    controller.setAvatarEffectType(_local_5.type);
                }
            }
            this._selectedIndex[k] = _arg_2;
            this._Str_20089(k, _arg_2, true);
            this._effectsParamView.updateView(_local_5);
        }

        function _Str_20089(k:String, _arg_2:Int, _arg_3:Bool)
        {
            cast(_view, EffectsView)._Str_8706(k, _arg_2, _arg_3);
        }
    }

