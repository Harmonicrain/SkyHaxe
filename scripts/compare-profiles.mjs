#!/usr/bin/env node
import { readFile, writeFile } from "node:fs/promises";
import { basename, resolve } from "node:path";

const [baselinePath, candidatePath, outputPath] = process.argv.slice(2);
if (!baselinePath || !candidatePath) throw new Error("Usage: node scripts/compare-profiles.mjs BASELINE.json CANDIDATE.json [REPORT.md]");
const baseline = JSON.parse(await readFile(resolve(baselinePath), "utf8"));
const candidate = JSON.parse(await readFile(resolve(candidatePath), "utf8"));
const rows = [];
function add(label, before, after, unit = "ms") {
  const delta = before == null || after == null || before === 0 ? "n/a" : `${(((after - before) / before) * 100).toFixed(1)}%`;
  rows.push(`| ${label} | ${before ?? "unavailable"} | ${after ?? "unavailable"} | ${delta} |`);
}
add("Frame median", baseline.frames?.medianMs, candidate.frames?.medianMs);
add("Frame p95", baseline.frames?.p95Ms, candidate.frames?.p95Ms);
add("Frame p99", baseline.frames?.p99Ms, candidate.frames?.p99Ms);
add("Room update p95", baseline.sections?.roomUpdateMs?.p95Ms, candidate.sections?.roomUpdateMs?.p95Ms);
add("Room render p95", baseline.sections?.roomRenderMs?.p95Ms, candidate.sections?.roomRenderMs?.p95Ms);
add("Visualization update p95", baseline.sections?.visualizationUpdateMs?.p95Ms, candidate.sections?.visualizationUpdateMs?.p95Ms);
add("Depth sort p95", baseline.sections?.depthSortMs?.p95Ms, candidate.sections?.depthSortMs?.p95Ms);
add("Sprite update p95", baseline.sections?.spriteUpdateMs?.p95Ms, candidate.sections?.spriteUpdateMs?.p95Ms);
add("Avatar composition p95", baseline.sections?.avatarCompositionMs?.p95Ms, candidate.sections?.avatarCompositionMs?.p95Ms);
let graph = "";
if (outputPath && baseline.raw?.frameIntervalsMs?.length && candidate.raw?.frameIntervalsMs?.length) {
  const svgPath = resolve(outputPath).replace(/\.md$/i, "-frames.svg");
  const series = [baseline.raw.frameIntervalsMs, candidate.raw.frameIntervalsMs];
  const colors = ["#3b82f6", "#ef4444"];
  const width = 900, height = 260, pad = 36, maxY = Math.max(100, ...series.flat());
  const polylines = series.map((values, index) => {
    const points = values.map((value, i) => `${pad + i * (width - pad * 2) / Math.max(1, values.length - 1)},${height - pad - Math.min(value, maxY) * (height - pad * 2) / maxY}`).join(" ");
    return `<polyline fill="none" stroke="${colors[index]}" stroke-width="1.3" points="${points}"/>`;
  }).join("");
  const targetY = height - pad - 33.333 * (height - pad * 2) / maxY;
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}"><rect width="100%" height="100%" fill="#111827"/><line x1="${pad}" y1="${targetY}" x2="${width-pad}" y2="${targetY}" stroke="#9ca3af" stroke-dasharray="5 4"/><text x="${pad}" y="20" fill="#e5e7eb" font-family="sans-serif" font-size="13">Frame intervals (blue baseline, red candidate; dashed 33.3 ms target)</text>${polylines}</svg>`;
  await writeFile(svgPath, svg, "utf8");
  graph = `\n![Frame interval comparison](${basename(svgPath)})\n`;
}
const report = `# SkyHaxe profile comparison\n\nBaseline: \`${baselinePath}\`  \nCandidate: \`${candidatePath}\`\n${graph}\n| Metric | Baseline | Candidate | Change |\n|---|---:|---:|---:|\n${rows.join("\n")}\n\nGPU timer: ${candidate.metadata?.gpuTimer || "unavailable"}. Functional failures invalidate a run.\n`;
if (outputPath) await writeFile(resolve(outputPath), report, "utf8");
else process.stdout.write(report);
