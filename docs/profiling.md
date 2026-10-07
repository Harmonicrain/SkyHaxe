# SkyHaxe performance profiling

Profiling is compiled out of ordinary builds. Build the release-profile variant explicitly:

```powershell
$env:SKYHAXE_SOURCE_ROOT = 'C:\path\to\Habbo-Sky'
.\scripts\build.ps1 -Release -Profile
```

Serve that package normally, then run a benchmark with an authorised local test account:

```powershell
node scripts/profile-client.mjs --url http://localhost:8766/ --sso YOUR_TEST_TICKET `
  --scenario large-room-walk-normal --warmup 5000 --duration 15000 `
  --repetitions 3 --zoom 0 --walk 1 --output evidence/profiles
```

Run the same room at the other zoom level by changing the scenario name and passing the desired
client zoom scale (for example `--zoom 0.5`). The runner enters the client's own `:zoom` command.
The runner waits for the real room-ready lifecycle event, warms up, performs bounded walking clicks,
and writes JSON plus a screenshot. Tickets are used only to navigate the isolated browser and are not
written to the result.

Compare equivalent runs with:

```powershell
node scripts/compare-profiles.mjs baseline.json candidate.json evidence/profiles/comparison.md
```

The report covers frame percentiles, room update/render work, visualization, depth sorting, sprite
updates and avatar composition. Asset metrics come from the existing SWF loader. WebGL call/upload
counters are reported when the active renderer exposes them; GPU execution timing is explicitly
`unavailable` until timer-query support is verified. A disconnect, startup exception, or failure to
reach a room invalidates the run.
