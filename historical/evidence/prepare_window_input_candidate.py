"""Apply explicit HTML5 mouse-input boundaries to generated window classes.

Original conversion output stays untouched. Recreate this overlay after every build;
fail if the generated source no longer matches the reviewed contract.
"""
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
OVERLAYS = (
    (
        REPO / ".toolchain/v21/generated/com/sulake/core/window",
        REPO / ".toolchain/v21/openfl/com/sulake/core/window",
    ),
    (
        REPO / ".toolchain/v32/generated/com/sulake/core/window",
        REPO / ".toolchain/v32/platform/com/sulake/core/window",
    ),
)


def main():
    prepared = []
    for source, target_root in OVERLAYS:
        if not source.exists():
            continue
        for relative in ("utils/MouseEventQueue.hx", "services/WindowMouseOperator.hx"):
            text = (source / relative).read_text(encoding="utf-8")
            if relative.endswith("MouseEventQueue.hx"):
                old = "_Str_4751.push(k);"
                new = """// OpenFL dispatches CLICK for the second release before DOUBLE_CLICK,
            // whereas Flash's window queue expects the second release to be represented by
            // DOUBLE_CLICK. Remove only that adjacent duplicate so MouseEventProcessor retains
            // its second MOUSE_DOWN target and accepts the double click.
            if (k.type == MouseEvent.DOUBLE_CLICK && _Str_4751.length > 0)
            {
                var previous = Std.downcast(_Str_4751[ASCompat.toInt(_Str_4751.length - 1)], MouseEvent);
                if (previous != null && previous.type == MouseEvent.CLICK
                    && previous.stageX == k.stageX && previous.stageY == k.stageY)
                {
                    _Str_4751.pop();
                }
            }
            // OpenFL recycles events and its clone omits stage coordinates.
            var snapshot:MouseEvent = cast k.clone();
            @:privateAccess snapshot.stageX = k.stageX;
            @:privateAccess snapshot.stageY = k.stageY;
            _Str_4751.push(snapshot);"""
            else:
                old = "this._root = k;"
                new = "this._root = k.stage != null ? k.stage : k; // Release must also reach drags outside the window host."
            if text.count(old) != 1:
                raise RuntimeError(f"Review changed generated input contract: {source}: {relative}")
            target = target_root / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(text.replace(old, new), encoding="utf-8", newline="\n")
            prepared.append(str(target.relative_to(REPO)))
    if not prepared:
        raise RuntimeError("No generated window source was available for an input overlay")
    print(f"Prepared {len(prepared)} generated window input overlays: event snapshots, "
          "Flash-compatible double clicks and stage release")


if __name__ == "__main__":
    main()
