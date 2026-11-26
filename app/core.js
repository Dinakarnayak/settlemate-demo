(function (root) {
  'use strict';
  const TABS = ['home','arrival','work','money','safe','discover','account','profile','terms'];
  const DAYS = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
  const finite = (v, fallback, min, max) => { const n=Number(v); return Number.isFinite(n) ? Math.min(max,Math.max(min,n)) : fallback; };
  const validDate = v => typeof v === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(v) && !Number.isNaN(Date.parse(v+'T00:00:00'));
  const localISO = d => d.getFullYear()+'-'+String(d.getMonth()+1).padStart(2,'0')+'-'+String(d.getDate()).padStart(2,'0');
  const weekStart = d => { const x=new Date(d.getFullYear(),d.getMonth(),d.getDate()); x.setDate(x.getDate()-((x.getDay()+6)%7)); return x; };
  const currentWeekShifts = (shifts, now=new Date()) => { const start=weekStart(now), end=new Date(start); end.setDate(end.getDate()+7); return (Array.isArray(shifts)?shifts:[]).filter(s=>s&&validDate(s.date)&&new Date(s.date+'T00:00:00')>=start&&new Date(s.date+'T00:00:00')<end); };
  const weeklyHours = (shifts, now=new Date()) => currentWeekShifts(shifts,now).reduce((n,s)=>n+finite(s.h,0,0,24),0);
  function normaliseState(fresh, saved, now=new Date()) {
    let parsed={}; try { const v=typeof saved==='string'?JSON.parse(saved):saved; if(v&&typeof v==='object'&&!Array.isArray(v)) parsed=v; } catch (_) {}
    const s={...fresh,...parsed};
    s.name=typeof s.name==='string'?s.name.slice(0,60):fresh.name;
    s.country=typeof s.country==='string'&&/^[A-Z]{2}$/.test(s.country)?s.country:fresh.country;
    s.tab=TABS.includes(s.tab)?s.tab:'home';
    s.xp=finite(s.xp,fresh.xp||0,0,1000000); s.streak=finite(s.streak,fresh.streak||0,0,3650);
    s.limit=finite(s.limit,fresh.limit||20,1,80); s.budget=finite(s.budget,fresh.budget||0,0,10000000);
    s.checks=finite(s.checks,0,0,1000000); s.step=finite(s.step,0,0,10);
    s.scamText=typeof s.scamText==='string'?s.scamText.slice(0,12000):'';
    s.tasks=(Array.isArray(s.tasks)?s.tasks:fresh.tasks||[]).filter(t=>t&&typeof t.t==='string').map(t=>({t:t.t.slice(0,120),d:typeof t.d==='string'?t.d.slice(0,300):'',done:Boolean(t.done)}));
    const today=new Date(now.getFullYear(),now.getMonth(),now.getDate());
    s.shifts=(Array.isArray(s.shifts)?s.shifts:fresh.shifts||[]).filter(x=>x&&typeof x==='object').map(x=>{
      let date=x.date;
      if(!validDate(date)){ const day=DAYS.indexOf(x.day); const d=new Date(today); if(day>=0) d.setDate(d.getDate()-((d.getDay()+6)%7)+((day+6)%7)); date=localISO(d); }
      const d=new Date(date+'T00:00:00'); return {j:typeof x.j==='string'?x.j.slice(0,80):'Shift',h:finite(x.h,0,0,24),day:DAYS[d.getDay()],date};
    }).filter(x=>x.h>0);
    s.spend=(Array.isArray(s.spend)?s.spend:fresh.spend||[]).filter(x=>x&&typeof x.c==='string').map(x=>({c:x.c.slice(0,60),a:finite(x.a,0,0,10000000)}));
    s.joined=Array.isArray(s.joined)?s.joined.filter(x=>typeof x==='string').slice(0,200):[];
    s.onboarded=Boolean(s.onboarded);
    return s;
  }
  const api={normaliseState,currentWeekShifts,weeklyHours,weekStart,localISO,validDate};
  root.SettleMateCore=api; if(typeof module!=='undefined'&&module.exports) module.exports=api;
})(typeof globalThis!=='undefined'?globalThis:this);