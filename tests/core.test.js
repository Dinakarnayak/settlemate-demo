const test=require('node:test');
const assert=require('node:assert/strict');
const {normaliseState,currentWeekShifts,weeklyHours,localISO}=require('../core.js');
const now=new Date(2026,10,26,12);
const fresh={onboarded:false,step:0,name:'Dinakar',country:'IN',tab:'home',xp:20,streak:5,limit:20,budget:650,checks:0,scamText:'',tasks:[{t:'GP',d:'Find a practice',done:false}],shifts:[],spend:[{c:'Food',a:10}],joined:[]};
test('restores saved preferences and defaults missing values',()=>{const s=normaliseState(fresh,JSON.stringify({name:'Alex',darkMode:true}),now);assert.equal(s.name,'Alex');assert.equal(s.darkMode,true);assert.equal(s.budget,650);});
test('malformed storage safely falls back to defaults',()=>{const s=normaliseState(fresh,'{bad json',now);assert.equal(s.name,'Dinakar');assert.equal(s.tab,'home');});
test('clamps numbers and rejects invalid navigation values',()=>{const s=normaliseState(fresh,{xp:-1,limit:500,budget:'NaN',tab:'javascript:alert(1)'},now);assert.equal(s.xp,0);assert.equal(s.limit,80);assert.equal(s.budget,650);assert.equal(s.tab,'home');});
test('counts only shifts in the current Monday-to-Sunday week',()=>{const a=[{j:'A',h:5,date:'2026-11-23'},{j:'B',h:4,date:'2026-11-26'},{j:'Old',h:8,date:'2026-11-15'},{j:'Next',h:7,date:'2026-11-30'}];assert.equal(weeklyHours(a,now),9);assert.equal(currentWeekShifts(a,now).length,2);});
test('migrates legacy weekday-only shifts into the current week',()=>{const s=normaliseState(fresh,{shifts:[{j:'Warehouse',h:6,day:'Mon'}]},now);assert.equal(s.shifts[0].date,'2026-11-23');assert.equal(weeklyHours(s.shifts,now),6);});
test('bounds profile and pasted message lengths',()=>{const s=normaliseState(fresh,{name:'N'.repeat(100),scamText:'x'.repeat(20000)},now);assert.equal(s.name.length,60);assert.equal(s.scamText.length,12000);});
test('formats local calendar dates without UTC drift',()=>assert.equal(localISO(new Date(2026,10,26,23,30)),'2026-11-26'));

const fs=require('node:fs');
const vm=require('node:vm');
test('both browser entry points contain valid inline JavaScript',()=>{
  for(const file of ['index.html','app/index.html']){
    const html=fs.readFileSync(require('node:path').join(__dirname,'..',file),'utf8');
    const start=html.indexOf('<script>');
    const end=html.indexOf('</script>',start);
    assert.ok(start>=0&&end>start,file+' should have an inline application script');
    new vm.Script(html.slice(start+8,end),{filename:file});
  }
});
