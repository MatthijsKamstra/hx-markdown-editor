import electron.main.App;
import electron.main.BrowserWindow;
import electron.CrashReporter;

import js.Node;
// import js.npm.Express;

class Main {

	static function main() {

		electron.CrashReporter.start({
			companyName : "hxelectron (not a company)",
			submitURL : "https://github.com/fponticelli/hxelectron/issues"
		});

		// Keep a global reference of the window object, if you don't, the window will
		// be closed automatically when the JavaScript object is garbage collected.
		var mainWindow = null;


		// Quit when all windows are closed.
		App.on( 'window_all_closed', function(e) {
			// On OS X it is common for applications and their menu bar
			// to stay active until the user quits explicitly with Cmd + Q
			if (Node.process.platform != 'darwin')
				App.quit();
		});

		// This method will be called when Electron has finished
		// initialization and is ready to create browser windows.
		App.on( 'ready', function(e) {
			// Create the browser window.
			mainWindow = new BrowserWindow({width: 800, height: 600});

			// Emitted when the window is closed.
			mainWindow.on( closed, function() {
				if( js.Node.process.platform != 'darwin' )
					electron.main.App.quit();
				// Dereference the window object, usually you would store windows
				// in an array if your app supports multi windows, this is the time
				// when you should delete the corresponding element.
				mainWindow = null;
			});

			// Open the DevTools.
			mainWindow.webContents.openDevTools();

			// and load the index.html of the app.
			mainWindow.loadURL('file://' + js.Node.__dirname + '/index.html');
			// mainWindow.loadURL( 'file://' + js.Node.__dirname + '/app.html' );
			// mainWindow.loadURL('http://localhost:3000');


			// win.loadURL( 'file://' + js.Node.__dirname + '/index.html' );
		});
	}

}
