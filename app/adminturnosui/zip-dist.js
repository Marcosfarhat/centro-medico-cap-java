const fs = require('fs');
const path = require('path');
const JSZip = require('jszip');

const zip = new JSZip();

function addFolder(dir, base) {
  fs.readdirSync(dir).forEach(f => {
    const full = path.join(dir, f);
    const rel = path.join(base, f).replace(/\\/g, '/');
    if (fs.statSync(full).isDirectory()) {
      addFolder(full, rel);
    } else if (f !== 'adminturnosui.zip') {
      zip.file(rel, fs.readFileSync(full));
    }
  });
}

addFolder('dist', '');

zip.generateAsync({ type: 'nodebuffer' }).then(buffer => {
  fs.writeFileSync('dist/adminturnosui.zip', buffer);
  console.log('Created dist/adminturnosui.zip');
});