package com.sulake.habbo.session
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.perk.PerkAllowancesEvent;
    import com.sulake.habbo.communication.messages.parser.perk.Perk;
    import com.sulake.habbo.session.events.PerksUpdatedEvent;

     class PerkManager implements IDisposable 
    {
        var _ready:Bool = false;
        var _sessionDataManager:SessionDataManager;
        var _perkAllowancesMessageEvent:IMessageEvent;
        var _perks:ASDictionary<ASAny,ASAny>;

        public function new(k:SessionDataManager)
        {
            this._perks = new ASDictionary<ASAny,ASAny>();
            this._sessionDataManager = k;
            if (this._sessionDataManager.communication != null)
            {
                this._perkAllowancesMessageEvent = this._sessionDataManager.communication.addHabboConnectionMessageEvent(new PerkAllowancesEvent(this.onPerkAllowances));
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._sessionDataManager == null;
        }

        public function dispose()
        {
var k:String  = null;            var k:String = null;
            if (this.disposed)
            {
                return;
            }
            if (this._perks != null)
            {
                final _iter_ = this._perks; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
k = _tmp_;
                    this._perks.remove(k);
                }
                this._perks = null;
            }
            if (this._sessionDataManager.communication != null)
            {
                this._sessionDataManager.communication.removeHabboConnectionMessageEvent(this._perkAllowancesMessageEvent);
            }
            this._perkAllowancesMessageEvent = null;
            this._sessionDataManager = null;
        }

        public var isReady(get,never):Bool;
public function  get_isReady():Bool
        {
            return this._ready;
        }

        public function isPerkAllowed(k:String):Bool
        {
            return this._perks.exists(k ) && ASCompat.toBool(this._perks[k].isAllowed);
        }

        public function hasPerk(k:String):Bool
        {
            return this._perks.exists(k );
        }

        public function getPerkErrorMessage(k:String):String
        {
            var _local_2:Perk = this._perks[k];
            return (_local_2 != null) ? _local_2.errorMessage : "";
        }

        function onPerkAllowances(k:PerkAllowancesEvent)
        {
            var _local_2:Perk = null;
            final _iter_ = k.getParser()._Str_23301(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._perks[_local_2.code] = _local_2;
            }
            this._ready = true;
            this._sessionDataManager.events.dispatchEvent(new PerksUpdatedEvent());
        }
    }

