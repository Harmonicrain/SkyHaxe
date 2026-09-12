package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
;
 import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
 import com.sulake.core.communication.messages.IMessageDataWrapper;
  class TradeRequirementRulesDefinition { static inline final MAX_RULES=64;var _youGiveRule:Vector<TradeRequirementRule>;var _youGetRule:TradeRequirementRule;public function new(give:Vector<TradeRequirementRule>,get:TradeRequirementRule){_youGiveRule=give;_youGetRule=get;}
  public static function readFromMessage(data:IMessageDataWrapper):TradeRequirementRulesDefinition{var count = 0, i = 0;var give:Vector<TradeRequirementRule> = null;if(data.readBoolean()){count=WiredMessageDataValidator.readCount(data,4,MAX_RULES,"TradeRequirementRulesDefinition give rules");give=new Vector<TradeRequirementRule>();for(_tmp_ in 0...count){i=_tmp_;
give.push(TradeRequirementRule.readFromMessage(data));
};}var get:TradeRequirementRule=data.readBoolean()?TradeRequirementRule.readFromMessage(data):null;return new TradeRequirementRulesDefinition(give,get);}public var youGiveRule(get,never):Vector<TradeRequirementRule>;
public function  get_youGiveRule():Vector<TradeRequirementRule>{return _youGiveRule;}public var youGetRule(get,never):TradeRequirementRule;
public function  get_youGetRule():TradeRequirementRule{return _youGetRule;}public function addToComposer(out:Array<ASAny>){var r:TradeRequirementRule  = null;out.push(_youGiveRule!=null);if(_youGiveRule!=null){out.push(_youGiveRule.length);final _iter_ = _youGiveRule; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_){r = _tmp_;
r.addToComposer(out);
};}out.push(_youGetRule!=null);if(_youGetRule!=null)_youGetRule.addToComposer(out);}
 }

