// Generated by Haxe 3.4.2
if (process.version < "v4.0.0") console.warn("Module " + (typeof(module) == "undefined" ? "" : module.filename) + " requires node.js version 4.0.0 or higher");
(function () { "use strict";
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	electron_CrashReporter.start({ companyName : "hxelectron (not a company)", submitURL : "https://github.com/fponticelli/hxelectron/issues"});
	var mainWindow = null;
	electron_main_App.on("window_all_closed",function(e) {
		if(process.platform != "darwin") {
			electron_main_App.quit();
		}
	});
	electron_main_App.on("ready",function(e1) {
		mainWindow = new electron_main_BrowserWindow({ width : 800, height : 600, backgroundColor : "#2e2c29"});
		mainWindow.on("closed",function() {
			if(process.platform != "darwin") {
				electron_main_App.quit();
			}
			mainWindow = null;
		});
		mainWindow.webContents.openDevTools();
		mainWindow.loadURL("file://" + __dirname + "/index.html");
		electron_main_IpcMain.on("test",function(event,test) {
			var content = "Some text to save into the file";
		});
		electron_main_IpcMain.on("OpenDialog",function(event1) {
			electron_main_Dialog.showOpenDialog(null,{ },function(fileNames) {
				haxe_Log.trace(fileNames,{ fileName : "Main.hx", lineNumber : 105, className : "Main", methodName : "main"});
				if(fileNames == null) {
					haxe_Log.trace("No file selected",{ fileName : "Main.hx", lineNumber : 108, className : "Main", methodName : "main"});
					return;
				}
				var filepath = fileNames[0];
				js_node_Fs.readFile(filepath,"utf-8",function(err,data) {
					if(err != null) {
						haxe_Log.trace("An error ocurred reading the file :" + err.message,{ fileName : "Main.hx", lineNumber : 116, className : "Main", methodName : "main"});
						return;
					}
					event1.sender.send("SEND_FILE_CONTENT",filepath,data);
				});
			});
		});
		electron_main_IpcMain.on("SAVE_FILE",function(event2,filepath1,content1) {
			haxe_Log.trace(filepath1,{ fileName : "Main.hx", lineNumber : 131, className : "Main", methodName : "main", customParams : [content1]});
			js_node_Fs.writeFile(filepath1,content1,function(err1) {
				if(err1 != null) {
					haxe_Log.trace("An error ocurred updating the file" + err1.message,{ fileName : "Main.hx", lineNumber : 135, className : "Main", methodName : "main"});
					haxe_Log.trace(err1,{ fileName : "Main.hx", lineNumber : 136, className : "Main", methodName : "main"});
					return;
				}
				haxe_Log.trace("The file has been succesfully saved",{ fileName : "Main.hx", lineNumber : 140, className : "Main", methodName : "main"});
			});
		});
		electron_main_IpcMain.on("asynchronous-message",function(event3,arg) {
			haxe_Log.trace(arg,{ fileName : "Main.hx", lineNumber : 147, className : "Main", methodName : "main"});
			event3.sender.send("asynchronous-reply","pong");
		});
		electron_main_IpcMain.on("synchronous-message",function(event4,arg1) {
			haxe_Log.trace(arg1,{ fileName : "Main.hx", lineNumber : 153, className : "Main", methodName : "main"});
			event4.returnValue = "pong";
		});
		electron_main_IpcMain.on("doorBell",function(event5,arg2) {
			haxe_Log.trace(arg2,{ fileName : "Main.hx", lineNumber : 160, className : "Main", methodName : "main"});
			event5.returnValue = "dong";
		});
	});
};
Math.__name__ = true;
var electron_CrashReporter = require("electron").crashReporter;
var electron_main_App = require("electron").app;
var electron_main_BrowserWindow = require("electron").BrowserWindow;
var electron_main_Dialog = require("electron").dialog;
var electron_main_IpcMain = require("electron").ipcMain;
var haxe_Log = function() { };
haxe_Log.__name__ = true;
haxe_Log.trace = function(v,infos) {
	js_Boot.__trace(v,infos);
};
var haxe_io_Bytes = function() { };
haxe_io_Bytes.__name__ = true;
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
};
js_Boot.__trace = function(v,i) {
	var msg = i != null ? i.fileName + ":" + i.lineNumber + ": " : "";
	msg += js_Boot.__string_rec(v,"");
	if(i != null && i.customParams != null) {
		var _g = 0;
		var _g1 = i.customParams;
		while(_g < _g1.length) {
			var v1 = _g1[_g];
			++_g;
			msg += "," + js_Boot.__string_rec(v1,"");
		}
	}
	var d;
	var tmp;
	if(typeof(document) != "undefined") {
		d = document.getElementById("haxe:trace");
		tmp = d != null;
	} else {
		tmp = false;
	}
	if(tmp) {
		d.innerHTML += js_Boot.__unhtml(msg) + "<br/>";
	} else if(typeof console != "undefined" && console.log != null) {
		console.log(msg);
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) {
					return o[0];
				}
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) {
						str += "," + js_Boot.__string_rec(o[i],s);
					} else {
						str += js_Boot.__string_rec(o[i],s);
					}
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g11 = 0;
			var _g2 = l;
			while(_g11 < _g2) {
				var i2 = _g11++;
				str1 += (i2 > 0 ? "," : "") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) {
			str2 += ", \n";
		}
		str2 += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "string":
		return o;
	default:
		return String(o);
	}
};
var js_node_Fs = require("fs");
var js_node_buffer_Buffer = require("buffer").Buffer;
String.__name__ = true;
Array.__name__ = true;
Main.main();
})();

//# sourceMappingURL=main.js.map