package com.sulake.habbo.inventory.effects
;
    import com.sulake.habbo.inventory.IInventoryModel;
    import com.sulake.habbo.inventory.HabboInventory;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.habbo.communication.messages.outgoing.inventory.avatareffect.AvatarEffectActivatedComposer;
    import com.sulake.habbo.communication.messages.outgoing.inventory.avatareffect.AvatarEffectSelectedComposer;
    import com.sulake.habbo.inventory.IAvatarEffect;
    import com.sulake.core.window.IWindowContainer;

     class EffectsModel implements IInventoryModel 
    {
        public static inline final _Str_18210= -1;
        public static inline final _Str_16011= 0;
        public static inline final _Str_14844= 1;

        var _controller:HabboInventory;
        var _view:EffectsView;
        var _effects:Array<ASAny>;
        var _assets:IAssetLibrary;
        var _communication:IHabboCommunicationManager;
        var _activeEffectsProxy:EffectListProxy;
        var _inactiveEffectsProxy:EffectListProxy;
        var _disposed:Bool = false;
        var _lastActivatedEffect:Int = -1;

        public function new(k:HabboInventory, _arg_2:IHabboWindowManager, _arg_3:IHabboCommunicationManager, _arg_4:IAssetLibrary, _arg_5:IHabboLocalizationManager)
        {
            this._controller = k;
            this._effects = new Array<ASAny>();
            this._assets = _arg_4;
            this._communication = _arg_3;
            this._activeEffectsProxy = new EffectListProxy(this, 1);
            this._inactiveEffectsProxy = new EffectListProxy(this, 0);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var _Str_24332(get,never):Int;
public function  get__Str_24332():Int
        {
            return this._lastActivatedEffect;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._controller = null;
                if (this._view != null)
                {
                    this._view.dispose();
                }
                if (this._activeEffectsProxy != null)
                {
                    this._activeEffectsProxy.dispose();
                    this._activeEffectsProxy = null;
                }
                if (this._inactiveEffectsProxy != null)
                {
                    this._inactiveEffectsProxy.dispose();
                    this._inactiveEffectsProxy = null;
                }
                this._disposed = true;
            }
        }

        public function onInventoryOpen()
        {
        }

        public function initCategory(k:String)
        {
        }

        public function _Str_2428(k:Effect, _arg_2:Bool=true)
        {
            var _local_4:BitmapDataAsset = null;
            var _local_3= this._Str_5810(k.type);
            if (_local_3 != null)
            {
                _local_3.amount++;
            }
            else
            {
                _local_4 = cast(this._assets.getAssetByName((("fx_icon_" + Std.string(k.type)) + "_png")), BitmapDataAsset);
                if (_local_4 != null)
                {
                    k.icon = cast(_local_4.content, BitmapData);
                }
                this._effects.push(k);
            }
            if (_arg_2)
            {
                this._Str_4879();
            }
        }

        function _Str_5810(k:Int):Effect
        {
            var _local_3:Effect = null;
            var _local_2 = 0;
            while (_local_2 < this._effects.length)
            {
                _local_3 = this._effects[_local_2];
                if (_local_3.type == k)
                {
                    return _local_3;
                }
                _local_2++;
            }
            return null;
        }

        function _Str_23376(k:Int)
        {
            var _local_3:Effect = null;
            var _local_2 = 0;
            while (_local_2 < this._effects.length)
            {
                _local_3 = this._effects[_local_2];
                if (_local_3.type == k)
                {
                    this._effects.splice(_local_2, 1);
                    this._Str_4879();
                    return;
                }
                _local_2++;
            }
        }

        public function _Str_4879()
        {
            if (this._view != null)
            {
                this._view._Str_13242();
                this._view._Str_2944();
            }
        }

        public function requestEffectActivated(k:Int)
        {
            this._controller.communication.connection.send(new AvatarEffectActivatedComposer(k));
        }

        public function _Str_22417(k:Int)
        {
            var _local_2= this._Str_5810(k);
            if (_local_2 != null)
            {
                this.stopUsingAllEffects(false, false);
                _local_2.isActive = true;
                _local_2.isInUse = true;
                this._Str_4879();
            }
        }

        public function _Str_20338(k:Int)
        {
            this.stopUsingAllEffects(false, false, true);
            var _local_2= this._Str_5810(k);
            if (_local_2 == null)
            {
                return;
            }
            if (!_local_2.isActive)
            {
                this.requestEffectActivated(_local_2.type);
            }
            if (_local_2.isInUse == false)
            {
                _local_2.isInUse = true;
                this._controller.communication.connection.send(new AvatarEffectSelectedComposer(k));
                this._lastActivatedEffect = k;
                this._Str_4879();
            }
        }

        public function stopUsingEffect(k:Int, _arg_2:Bool=false)
        {
            var _local_3= this._Str_5810(k);
            if (_local_3 != null)
            {
                if (_local_3.isInUse == true)
                {
                    _local_3.isInUse = false;
                    if (_arg_2)
                    {
                        this._controller.communication.connection.send(new AvatarEffectSelectedComposer(-1));
                        this._lastActivatedEffect = -1;
                    }
                    this._Str_4879();
                }
            }
        }

        public function stopUsingAllEffects(k:Bool=true, _arg_2:Bool=true, _arg_3:Bool=false)
        {
            var _local_5:Effect = null;
            var _local_4 = 0;
            while (_local_4 < this._effects.length)
            {
                _local_5 = this._effects[_local_4];
                _local_5.isInUse = false;
                _local_4++;
            }
            if (k)
            {
                this._controller.communication.connection.send(new AvatarEffectSelectedComposer(-1));
            }
            if (_arg_2)
            {
                this._Str_4879();
            }
            if (_arg_3)
            {
                this._lastActivatedEffect = -1;
            }
        }

        public function _Str_19804(k:Int)
        {
            var _local_2= this._Str_5810(k);
            if (_local_2 != null)
            {
                if (_local_2.Selected)
                {
                    this.setEffectDeselected(k);
                }
                else
                {
                    this.setEffectSelected(k);
                }
                this._Str_4879();
            }
        }

        public function _Str_23964(k:Int):IAvatarEffect
        {
            return this._Str_5810(k) ;
        }

        public function setEffectSelected(k:Int)
        {
            var _local_2= this._Str_5810(k);
            if (_local_2 != null)
            {
                this._Str_22710(false);
                _local_2.Selected = true;
                this._Str_4879();
            }
        }

        public function setEffectDeselected(k:Int)
        {
            var _local_2= this._Str_5810(k);
            if (_local_2 != null)
            {
                _local_2.Selected = false;
                this._Str_4879();
            }
        }

        function _Str_22710(k:Bool=true)
        {
            var _local_3:Effect = null;
            var _local_2 = 0;
            while (_local_2 < this._effects.length)
            {
                _local_3 = this._effects[_local_2];
                _local_3.Selected = false;
                _local_2++;
            }
            if (k)
            {
                this._Str_4879();
            }
        }

        public function _Str_21540(k:Int=-1):Effect
        {
            var _local_4:Effect = null;
            var _local_2= this._Str_6532(k);
            var _local_3 = 0;
            while (_local_3 < _local_2.length)
            {
                _local_4 = _local_2[_local_3];
                if (_local_4.Selected)
                {
                    return _local_4;
                }
                _local_3++;
            }
            return null;
        }

        public function _Str_6532(k:Int=-1):Array<ASAny>
        {
            var _local_4:Effect = null;
            var _local_2:Array<ASAny> = [];
            var _local_3 = 0;
            while (_local_3 < this._effects.length)
            {
                _local_4 = this._effects[_local_3];
                if ((((_local_4.isActive && (k == _Str_14844)) || ((!_local_4.isActive) && (k == _Str_16011))) || (k == _Str_18210)))
                {
                    _local_2.push(_local_4);
                }
                _local_3++;
            }
            return _local_2;
        }

        public function _Str_24134(k:Int)
        {
            this._lastActivatedEffect = -1;
            var _local_2= this._Str_5810(k);
            if (_local_2 != null)
            {
                if (_local_2.amount > 1)
                {
                    _local_2._Str_24370();
                    this._Str_4879();
                }
                else
                {
                    this._Str_23376(_local_2.type);
                }
            }
        }

        public function _Str_11080(k:Int, _arg_2:Int=-1):Effect
        {
            var _local_3= this._Str_6532(_arg_2);
            if (((k < 0) || (k >= _local_3.length)))
            {
                return null;
            }
            var _local_4:Effect = _local_3[k];
            return _local_4;
        }

        public function getWindowContainer():IWindowContainer
        {
            return (this._view != null) ? this._view.getWindowContainer() : null;
        }

        public function onInventoryClose()
        {
        }

        public function onCategorySwitch(k:String)
        {
        }

        public function _Str_24964()
        {
            if (this._lastActivatedEffect != -1)
            {
                this._Str_20338(this._lastActivatedEffect);
            }
        }

        public function updateView()
        {
            if (((this._view != null) && (!this._view.disposed)))
            {
                this._view._Str_13242();
                this._view._Str_2944();
            }
        }

        public function onSubcategorySwitch(k:String)
        {
            this.setEffectSelected(ASCompat.toInt(k));
        }
    }

