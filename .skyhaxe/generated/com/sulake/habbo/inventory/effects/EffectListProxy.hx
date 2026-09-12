package com.sulake.habbo.inventory.effects
;
    import com.sulake.habbo.inventory.common.IThumbListDataProvider;

     class EffectListProxy implements IThumbListDataProvider 
    {
        var _model:EffectsModel;
        var _filter:Int = 0;

        public function new(k:EffectsModel, _arg_2:Int)
        {
            this._model = k;
            this._filter = _arg_2;
        }

        public function dispose()
        {
            this._model = null;
        }

        public function _Str_22161():Array<ASAny>
        {
            return this._model._Str_6532(this._filter);
        }
    }

