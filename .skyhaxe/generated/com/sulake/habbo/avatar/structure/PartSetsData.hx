package com.sulake.habbo.avatar.structure
;
    import com.sulake.habbo.avatar.structure.parts.PartDefinition;
    import com.sulake.habbo.avatar.structure.parts.ActivePartSet;
    import com.sulake.habbo.avatar.actions.IActionDefinition;
    import com.sulake.habbo.avatar.actions.ActionDefinition;
    import com.sulake.habbo.avatar.structure.parts.*;

     class PartSetsData implements IFigureSetData 
    {
        var _parts:ASDictionary<ASAny,ASAny>;
        var _activePartSets:ASDictionary<ASAny,ASAny>;

        public function new()
        {
            this._parts = new ASDictionary<ASAny,ASAny>();
            this._activePartSets = new ASDictionary<ASAny,ASAny>();
        }

        public function parse(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var _local_3:com.sulake.core.utils.xml.XML = null;
            if (k == null)
            {
                return false;
            }
            final _iter_ = k.child("partSet").at(0).child("part"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._parts[_local_2.attribute("set-type").toString()] = new PartDefinition(_local_2);
            }
            final _iter_ = k.child("activePartSet"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                this._activePartSets[_local_3.attribute("id").toString()] = new ActivePartSet(_local_3);
            }
            return true;
        }

        public function _Str_1017(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var _local_3:com.sulake.core.utils.xml.XML = null;
            if (k == null)
            {
                return false;
            }
            final _iter_ = k.child("partSet").at(0).child("part"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._parts[_local_2.attribute("set-type").toString()] = new PartDefinition(_local_2);
            }
            final _iter_ = k.child("activePartSet"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                this._activePartSets[_local_3.attribute("id").toString()] = new ActivePartSet(_local_3);
            }
            return false;
        }

        public function getActiveParts(k:IActionDefinition):Array<ASAny>
        {
            var _local_2:ActivePartSet = this._activePartSets[k.activePartSet];
            if (_local_2 != null)
            {
                return _local_2.parts;
            }
            return [];
        }

        public function getPartDefinition(k:String):PartDefinition
        {
            return ASCompat.dynamicAs(this._parts[k] , PartDefinition);
        }

        public function addPartDefinition(k:com.sulake.core.utils.xml.XML):PartDefinition
        {
            var _local_2= k.attribute("set-type").toString();
            if (this._parts[_local_2] == null)
            {
                this._parts[_local_2] = new PartDefinition(k);
            }
            return this._parts[_local_2];
        }

        public var parts(get,never):ASDictionary<ASAny,ASAny>;
public function  get_parts():ASDictionary<ASAny,ASAny>
        {
            return this._parts;
        }

        public var activePartSets(get,never):ASDictionary<ASAny,ASAny>;
public function  get_activePartSets():ASDictionary<ASAny,ASAny>
        {
            return this._activePartSets;
        }

        public function getActivePartSet(k:ActionDefinition):ActivePartSet
        {
            return ASCompat.dynamicAs(this._activePartSets[k.activePartSet] , ActivePartSet);
        }
    }

