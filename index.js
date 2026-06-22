const zl   = require("zip-lib"),
	  fs   = require("node:fs");

if(fs.existsSync(`pagebuilder.zip`)) {
	console.log(`Delete file pagebuilder.zip`);
	fs.unlinkSync(`pagebuilder.zip`);
}

const zip = new zl.Zip(),
	folders = [`assets`, `install`, `manager`];

for(var value of folders){
	zip.addFolder(`${value}`, `pagebuilder/${value}`);
}

zip.archive(`pagebuilder.zip`);
console.log(`Archive pagebuilder.zip`);
