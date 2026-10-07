import * as extracted from '/assets/habbo-text/native-core.mjs';
import { HabboTextEngine, normalizeStyle } from '/assets/habbo-text/text.mjs';
import * as oracle from '/build/font-reference/native-oracle.mjs';
function assert(value, message) { if (!value) throw new Error(message); }
function equalPixels(a, b, label) {
  assert(a.width === b.width && a.height === b.height, `Dimensions: ${label}`);
  assert(a.retainedPixels.length === b.retainedPixels.length, `Buffer length: ${label}`);
  for (let i=0;i<a.retainedPixels.length;i++) assert(a.retainedPixels[i]===b.retainedPixels[i], `Pixel byte ${i}: ${label}`);
}
export async function run() {
  const engine = await HabboTextEngine.load('/assets/habbo-text');
  const manifest = engine.manifest; let cases = 0, fallbackCases = 0;
  for (const font of manifest.fonts) {
    const face = [['ubuntu_regular','Ubuntu','400','normal'],['ubuntu_bold','Ubuntu','700','normal'],
      ['ubuntu_italic','Ubuntu','400','italic'],['ubuntu_bold_italic','Ubuntu','700','italic'],
      ['ubuntu_condensed','UbuntuCondensed','400','normal'],['ubuntuMedium','UbuntuMedium','700','normal'],
      ['ubuntuThick_bold','UbuntuThick','700','normal'],['volter','Volter','400','normal'],
      ['volterb','Volter Bold','400','normal']].find(f => f[0] === font.asset);
    oracle.registerTtf(...face.slice(1), await (await fetch('/assets/habbo-text/' + font.file)).arrayBuffer());
  }
  const profiles = [
    ['ubuntu_regular','Ubuntu',false,false], ['ubuntu_bold','Ubuntu',true,false],
    ['ubuntu_italic','Ubuntu',false,true], ['ubuntu_bold_italic','Ubuntu',true,true],
    ['ubuntu_condensed','UbuntuCondensed',false,false], ['volter','Volter',false,false], ['volterb','Volter Bold',false,false]
  ];
  for (const [asset,family,bold,italic] of profiles) {
    const profile = await (await fetch(`/assets/habbo-text/profiles/${asset}_air51.json`)).json();
    oracle.registerNative(family,bold?'700':'400',italic?'italic':'normal',profile);
    for (const size of [9,12,18]) for (const color of [0,0xffffff]) for (const thickness of [-15,100]) {
      const style=normalizeStyle({fontFamily:family,fontSize:size,bold,italic,color,thickness,sharpness:80});
      const text='Habbo AV café'; const label=JSON.stringify([asset,size,color,thickness]);
      assert(extracted.NativeText.measure(text,style) === oracle.NativeText.measure(text,style), `Width: ${label}`);
      assert(JSON.stringify(extracted.NativeText.metrics(style))===JSON.stringify(oracle.NativeText.metrics(style)),`Metrics: ${label}`);
      assert(JSON.stringify(engine.positions(text,style))===JSON.stringify(oracle.NativeText._r81e37669947234(text,style)),`Positions: ${label}`);
      equalPixels(extracted.NativeText.render(text,style),oracle.NativeText.render(text,style),label);cases++;
    }
  }
  const style=normalizeStyle({fontFamily:'Ubuntu',fontSize:12,thickness:-15,sharpness:80});
  for (const background of ['#fff','#102030','#77aa44','rgba(60,100,180,.4)']) {
    const a=document.createElement('canvas'), b=document.createElement('canvas');a.width=b.width=160;a.height=b.height=40;
    const ac=a.getContext('2d'),bc=b.getContext('2d');ac.fillStyle=bc.fillStyle=background;ac.fillRect(0,0,160,40);bc.fillRect(0,0,160,40);
    const metrics=engine.metrics(style);const baseline=2+metrics.ascent;
    assert(engine.drawRetained(ac,[{text:'Habbo',x:2,baseline,style}],{x:0,y:0,right:160,bottom:40}),'Retained path rejected');
    const image=bc.getImageData(0,0,160,40);oracle.NativeText.premultiply(image.data);
    oracle.NativeText._ree8b220e73c49e('Habbo',style,{pixels:image.data,width:160,height:40,offsetX:0,offsetY:0});
    oracle.NativeText._rba605347eb19cf(image.data);bc.putImageData(image,0,0);
    const ap=ac.getImageData(0,0,160,40).data,bp=bc.getImageData(0,0,160,40).data;
    for(let i=0;i<ap.length;i++)assert(ap[i]===bp[i],`Retained ${background} byte ${i}`);cases++;
  }
  for(const family of ['Ubuntu Medium','UbuntuThick','Ubuntu Bold Italic','Ubuntu condensed','Volter Bold']) {
    const s=normalizeStyle({fontFamily:family});assert(engine.hasGlyphs(s,'Habbo'),'Alias coverage '+family);assert(!engine.hasGlyphs(s,'\u{10FFFF}'),'Absent glyph '+family);
  }
  assert(engine.strategy('Habbo',normalizeStyle({...style,letterSpacing:1}))==='canvas','Letter spacing did not select fallback');
  assert(engine.strategy('Habbo',normalizeStyle({...style,fontSize:12.5}))==='canvas','Fractional size did not select fallback');
  assert(engine.strategy('Habbo',normalizeStyle({...style,antiAliasType:'normal'}))==='canvas','Normal Ubuntu did not select fallback');
  assert(engine.strategy('😀',style)==='canvas','Supplementary character did not select fallback');
  const positions=engine.positions('A😀B',style);assert(positions.length===5&&positions[1]===positions[2],'Surrogate caret boundary');
  const fallback = new oracle.VolterFallback();
  for (const family of ['Volter','Volter Bold']) for (const size of [9,12.5]) for (const spacing of [0,1]) {
    const s = normalizeStyle({fontFamily:family,fontSize:size,letterSpacing:spacing,antiAliasType:'advanced',thickness:100});
    const text='Habbo AV';
    const expected=fallback._r96ee8f119769f8(text,s);
    if (!oracle.NativeText.supports(s,text) && expected != null) {
      assert(engine.width(text,s)===expected,'Volter fallback width');
      const a=document.createElement('canvas'),b=document.createElement('canvas');a.width=b.width=160;a.height=b.height=45;
      const ac=a.getContext('2d'),bc=b.getContext('2d'),m=engine.metrics(s),y=20-m.ascent+m.baseline;
      engine.draw(ac,text,5,20,s);
      bc.font=`${s.bold?'bold ':''}${s.fontSize}px "${s.fontFamily}"`;bc.textBaseline='alphabetic';bc.fillStyle='#000000';
      const plain=()=>{let index=0;for(const c of text){bc.fillText(c,5+engine.positions(text,s)[index++],Math.round(y));}};
      if(!fallback._r9832c7c612cd08(bc,text,5,y,m,s,plain))plain();
      const ap=ac.getImageData(0,0,160,45).data,bp=bc.getImageData(0,0,160,45).data;
      for(let i=0;i<ap.length;i++)assert(ap[i]===bp[i],'Volter fallback pixel '+i);
      fallbackCases++;
    }
  }
  for(const family of ['UbuntuThick','Ubuntu Medium']) {
    const s=normalizeStyle({fontFamily:family,fontSize:12,leading:3});
    const reference=oracle.scaleTtfMetrics(oracle.ttfMetrics(s.fontFamily,s.bold?'700':'400','normal'),12,3);
    assert(JSON.stringify(engine.metrics(s))===JSON.stringify(reference),'TTF-only metrics '+family);fallbackCases++;
  }
  // Corrupt a fetched profile without changing its length: startup must fail integrity checks.
  const original=globalThis.fetch;let rejected=false;
  globalThis.fetch=async (...args)=>{const response=await original(...args);if(String(args[0]).endsWith('ubuntu_regular_air51.json')){const b=new Uint8Array(await response.arrayBuffer());b[100]^=1;return new Response(b,{status:200});}return response;};
  try{await HabboTextEngine.load('/assets/habbo-text');}catch(e){rejected=/integrity/.test(String(e));}finally{globalThis.fetch=original;}
  assert(rejected,'Corrupt profile was accepted');
  return {ok:true,referenceCases:cases,fallbackCases,fonts:manifest.fonts.length,stats:engine.stats()};
}
