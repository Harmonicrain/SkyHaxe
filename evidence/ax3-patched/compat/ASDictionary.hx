#if flash
private typedef Dictionary<K,V> = flash.utils.Dictionary;
#else
private typedef Dictionary<K,V> = ASDictionaryData<K,V>;
#end

abstract ASDictionary<K,V>(Dictionary<K,V>) from Dictionary<K,V> to Dictionary<K,V> {
	public extern inline function new(weakKeys : Bool = false) {
		this = new Dictionary<K,V>(weakKeys);
	}

	@:op([]) public inline function get(key:K):Null<V> {
		#if flash
		return untyped this[key];
		#else
		return this.get(key);
		#end
	}

	@:op([]) public inline function set(key:K, value:V):Null<V> {
		#if flash
		return untyped this[key] = value;
		#else
		return this.set(key, value);
		#end
	}

	public inline function exists(key:K):Bool {
		#if flash
		return untyped __in__(key, this);
		#else
		return this.exists(key);
		#end
	}

	public inline function remove(key:K):Bool {
		#if flash
		return untyped __delete__(this, key);
		#else
		return this.remove(key);
		#end
	}

	public inline function keys() {
		#if flash
		return new NativePropertyIterator<K>(this);
		#else
		return this.iterator();
		#end
	}

	public inline function iterator() {
		#if flash
		return new NativeValueIterator<V>(this);
		#else
		return this.each();
		#end
	}

	public inline function keyValueIterator() {
		#if flash
		return new NativePropertyValueIterator<K,V>(this);
		#else
		return this.keyValueIterator();
		#end
	}

	public static inline function asDictionary<K,V>(v:Any):Null<Dictionary<K,V>> {
		#if flash
		return flash.Lib.as(v, flash.utils.Dictionary);
		#else
		return Std.isOfType(v, ASDictionaryData) ? cast v : null;
		#end
	}

	public static final type = #if flash flash.utils.Dictionary #else ASDictionaryData #end;
}

#if !flash
private class ASDictionaryData<K,V> {
	final entries:Array<{key:K, value:V}> = [];
	public function new(weakKeys:Bool = false) {}
	public function get(key:K):Null<V> {
		for (entry in entries) if (entry.key == key) return entry.value;
		// Flash Dictionary returns undefined for a missing key. Number(undefined) is NaN;
		// Number(null) is 0 and incorrectly forces animated furniture to animation zero.
		return js.Syntax.code("undefined");
	}
	public function set(key:K, value:V):V { for (entry in entries) if (entry.key == key) { entry.value = value; return value; } entries.push({key:key, value:value}); return value; }
	public function exists(key:K):Bool { for (entry in entries) if (entry.key == key) return true; return false; }
	public function remove(key:K):Bool { for (index in 0...entries.length) if (entries[index].key == key) { entries.splice(index, 1); return true; } return false; }
	public function iterator():Iterator<K> return [for (entry in entries) entry.key].iterator();
	public function each():Iterator<V> return [for (entry in entries) entry.value].iterator();
	public function keyValueIterator():KeyValueIterator<K,V> { var copy=entries.copy(); var index=0; return {hasNext:function() return index<copy.length, next:function(){var entry=copy[index++]; return {key:entry.key,value:entry.value};}}; }
}
#end
