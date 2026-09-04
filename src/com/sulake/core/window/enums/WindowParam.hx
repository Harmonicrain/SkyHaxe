package com.sulake.core.window.enums;

/**
 * Layout `params` bit flags, ported from `com/sulake/core/window/enum/WindowParam.as`.
 *
 * These are not decoration: the login button's `params="918545"` is what makes it shrink to its
 * caption and stay centred while doing it, and the internal skin layouts express their whole
 * geometry through the named equivalents in `ParamCodeTable`.
 *
 * Several of these are deliberately zero -- `RELATIVE_*_SCALE_FIXED`, `ON_RESIZE_ALIGN_LEFT`,
 * `ON_RESIZE_ALIGN_TOP`. Alignment is the *absence* of the other bits, so it must always be read
 * by masking with the `_HORIZONTAL` / `_VERTICAL` groups and comparing, never by testing one bit.
 */
class WindowParam {
	public static inline var NULL = 0;
	public static inline var INPUT_EVENT_PROCESSOR = 1 << 0;
	public static inline var ROUTE_INPUT_EVENTS_TO_PARENT = INPUT_EVENT_PROCESSOR | (1 << 1);
	public static inline var OBSERVE_PARENT_INPUT_EVENTS = INPUT_EVENT_PROCESSOR | (1 << 2);
	public static inline var INTERNAL_EVENT_HANDLING = INPUT_EVENT_PROCESSOR | (1 << 3);
	public static inline var USE_PARENT_GRAPHIC_CONTEXT = 1 << 4;
	public static inline var BOUND_TO_PARENT_RECT = 1 << 5;

	public static inline var RELATIVE_HORIZONTAL_SCALE_FIXED = 0;
	public static inline var RELATIVE_HORIZONTAL_SCALE_MOVE = 1 << 6;
	public static inline var RELATIVE_HORIZONTAL_SCALE_STRETCH = 1 << 7;
	public static inline var RELATIVE_HORIZONTAL_SCALE_CENTER =
		RELATIVE_HORIZONTAL_SCALE_MOVE | RELATIVE_HORIZONTAL_SCALE_STRETCH;
	public static inline var RELATIVE_HORIZONTAL_SCALE_MASK = RELATIVE_HORIZONTAL_SCALE_CENTER;

	public static inline var RELATIVE_VERTICAL_SCALE_FIXED = 0;
	public static inline var RELATIVE_VERTICAL_SCALE_MOVE = 1 << 10;
	public static inline var RELATIVE_VERTICAL_SCALE_STRETCH = 1 << 11;
	public static inline var RELATIVE_VERTICAL_SCALE_CENTER =
		RELATIVE_VERTICAL_SCALE_MOVE | RELATIVE_VERTICAL_SCALE_STRETCH;
	public static inline var RELATIVE_VERTICAL_SCALE_MASK = RELATIVE_VERTICAL_SCALE_CENTER;

	public static inline var RELATIVE_SCALE_FIXED = 0;
	public static inline var RELATIVE_SCALE_MOVE =
		RELATIVE_HORIZONTAL_SCALE_MOVE | RELATIVE_VERTICAL_SCALE_MOVE;
	public static inline var RELATIVE_SCALE_STRETCH =
		RELATIVE_HORIZONTAL_SCALE_STRETCH | RELATIVE_VERTICAL_SCALE_STRETCH;
	public static inline var RELATIVE_SCALE_CENTER =
		RELATIVE_HORIZONTAL_SCALE_CENTER | RELATIVE_VERTICAL_SCALE_CENTER;

	public static inline var HORIZONTAL_MOUSE_SCALING_TRIGGER = 1 << 12;
	public static inline var VERTICAL_MOUSE_SCALING_TRIGGER = 1 << 13;
	public static inline var MOUSE_SCALING_TRIGGER =
		HORIZONTAL_MOUSE_SCALING_TRIGGER | VERTICAL_MOUSE_SCALING_TRIGGER;
	public static inline var MOUSE_DRAGGING_TARGET = 1 << 15;
	public static inline var MOUSE_DRAGGING_TRIGGER = (1 << 8) | INPUT_EVENT_PROCESSOR;
	public static inline var DRAGGABLE_WITH_MOUSE = MOUSE_DRAGGING_TARGET | MOUSE_DRAGGING_TRIGGER;
	public static inline var MOUSE_SCALING_TARGET = 1 << 16;
	public static inline var SCALABLE_WITH_MOUSE = MOUSE_SCALING_TARGET | MOUSE_SCALING_TRIGGER;

	public static inline var EXPAND_TO_ACCOMMODATE_CHILDREN = 1 << 17;
	public static inline var RESIZE_TO_ACCOMMODATE_CHILDREN =
		(1 << 14) | EXPAND_TO_ACCOMMODATE_CHILDREN;

	public static inline var ON_ACCOMMODATE_ALIGN_LEFT = 0;
	public static inline var ON_ACCOMMODATE_ALIGN_RIGHT = 1 << 18;
	public static inline var ON_ACCOMMODATE_ALIGN_CENTER =
		(1 << 19) | ON_ACCOMMODATE_ALIGN_RIGHT;
	public static inline var ON_ACCOMMODATE_ALIGN_TOP = 0;
	public static inline var ON_ACCOMMODATE_ALIGN_BOTTOM = 1 << 20;
	public static inline var ON_ACCOMMODATE_ALIGN_MIDDLE =
		(1 << 21) | ON_ACCOMMODATE_ALIGN_BOTTOM;
	public static inline var ON_ACCOMMODATE_ALIGN_CONTENT =
		ON_ACCOMMODATE_ALIGN_CENTER | ON_ACCOMMODATE_ALIGN_MIDDLE;

	// The resize-align names are aliases of the accommodate-align ones in the AS3 too.
	public static inline var ON_RESIZE_ALIGN_LEFT = ON_ACCOMMODATE_ALIGN_LEFT;
	public static inline var ON_RESIZE_ALIGN_RIGHT = ON_ACCOMMODATE_ALIGN_RIGHT;
	public static inline var ON_RESIZE_ALIGN_CENTER = ON_ACCOMMODATE_ALIGN_CENTER;
	public static inline var ON_RESIZE_ALIGN_TOP = ON_ACCOMMODATE_ALIGN_TOP;
	public static inline var ON_RESIZE_ALIGN_BOTTOM = ON_ACCOMMODATE_ALIGN_BOTTOM;
	public static inline var ON_RESIZE_ALIGN_MIDDLE = ON_ACCOMMODATE_ALIGN_MIDDLE;
	public static inline var ON_RESIZE_ALIGN_HORIZONTAL =
		ON_RESIZE_ALIGN_LEFT | ON_RESIZE_ALIGN_CENTER | ON_RESIZE_ALIGN_RIGHT;
	public static inline var ON_RESIZE_ALIGN_VERTICAL =
		ON_RESIZE_ALIGN_TOP | ON_RESIZE_ALIGN_MIDDLE | ON_RESIZE_ALIGN_BOTTOM;

	public static inline var REFLECT_HORIZONTAL_RESIZE_TO_PARENT = 1 << 22;
	public static inline var REFLECT_VERTICAL_RESIZE_TO_PARENT = 1 << 23;
	public static inline var REFLECT_RESIZE_TO_PARENT =
		REFLECT_HORIZONTAL_RESIZE_TO_PARENT | REFLECT_VERTICAL_RESIZE_TO_PARENT;

	public static inline var PARENT_WINDOW = INPUT_EVENT_PROCESSOR;
	public static inline var CHILD_WINDOW = INPUT_EVENT_PROCESSOR | BOUND_TO_PARENT_RECT;
	public static inline var EMBEDDED_CONTROLLER = INPUT_EVENT_PROCESSOR | BOUND_TO_PARENT_RECT
		| ROUTE_INPUT_EVENTS_TO_PARENT | USE_PARENT_GRAPHIC_CONTEXT;

	public static inline var FORCE_CLIPPING = 1 << 30;
	/** 1 << 31 overflows a Haxe Int; the AS3 value is a uint. */
	public static inline var INHERIT_CAPTION = 1 << 30 << 1;
}
