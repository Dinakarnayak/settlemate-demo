const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

test('cross-device enhancement scripts are valid JavaScript', () => {
  for (const file of ['platform.js', 'app/platform.js']) {
    const source = fs.readFileSync(path.join(__dirname, '..', file), 'utf8');
    assert.match(source, /beforeinstallprompt/);
    assert.match(source, /displayMode/);
    assert.doesNotThrow(() => new Function(source), file);
  }
});

test('responsive styles define mobile, tablet, desktop and reduced-motion behavior', () => {
  for (const file of ['platform.css', 'app/platform.css']) {
    const css = fs.readFileSync(path.join(__dirname, '..', file), 'utf8');
    assert.match(css, /min-width:900px/);
    assert.match(css, /max-width:899px/);
    assert.match(css, /max-width:599px/);
    assert.match(css, /prefers-reduced-motion/);
  }
});

test('PWA offline cache includes the platform enhancement assets', () => {
  const sw = fs.readFileSync(path.join(__dirname, '..', 'app/sw.js'), 'utf8');
  assert.match(sw, /landed-v5/);
  assert.match(sw, /platform\.css/);
  assert.match(sw, /platform\.js/);
});
