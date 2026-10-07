package com.sulake.habbo.avatar.structure
;
    import com.sulake.habbo.avatar.structure.animation.AnimationAction;
    import com.sulake.habbo.avatar.actions.IActionDefinition;
    import com.sulake.habbo.avatar.structure.parts.*;

     class AnimationData implements IFigureSetData 
    {
        var _actions:ASDictionary<ASAny,ASAny>;

        public function new()
        {
            this._actions = new ASDictionary<ASAny,ASAny>();
        }

        public function parse(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            if (k == null)
            {
                return false;
            }
            final _iter_ = k.child("action"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._actions[_local_2.attribute("id").toString()] = new AnimationAction(_local_2);
            }
            return true;
        }

        public function _Str_1017(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            if (k == null)
            {
                return false;
            }
            final _iter_ = k.child("action"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._actions[_local_2.attribute("id").toString()] = new AnimationAction(_local_2);
            }
            return true;
        }

        public function getAction(k:IActionDefinition):AnimationAction
        {
            return this._actions[k.id];
        }

        public function getFrameCount(k:IActionDefinition):Int
        {
            var _local_2= this.getAction(k);
            if (_local_2 == null)
            {
                return 0;
            }
            return _local_2._Str_2185;
        }
    }

