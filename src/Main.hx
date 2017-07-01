import electron.main.App;
import electron.main.BrowserWindow;
import electron.CrashReporter;

import electron.main.IpcMain;
import electron.main.Dialog;
import electron.main.Menu;
import electron.main.MenuItem;
import electron.main.GlobalShortcut;

// import js.Browser.*;

import js.Node;
import js.Node.console;
// import js.Node.;
// import js.npm.Express;
import js.node.Fs;

import model.constant.Channel;

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
			mainWindow = new BrowserWindow({
				width: 800,
				height: 600,
				backgroundColor: '#2e2c29',
				// frame: false,
				// titleBarStyle: 'hidden'
			});

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


			// GlobalShortcut.register('CommandOrControl+X', function (){
			// 	trace('CommandOrControl+X is pressed');
			// });
			// // Check whether a shortcut is registered.
			// console.log(GlobalShortcut.isRegistered('CommandOrControl+X'));

			// IpcMain.on('show-dialog', function (event, type:Dynamic) {
			// 	Dialog.showMessageBox(mainWindow, {
			// 		type: type,
			// 		message: 'Hello, how are you?'
			// 	});
			// });

			// new MainMenu();

			IpcMain.on('test', function (event, test) {
				var content = "Some text to save into the file";

				// // You can obviously give a direct path without use the dialog (C:/Program Files/path/myfileexample.txt)
				// Dialog.showSaveDialog( function (fileName) {
				// 	if (fileName == null){
				// 		trace("You didn't save the file");
				// 		return;
				// 	}

				// 	// fileName is a string that contains the path and filename created in the save file dialog.
				// 	Fs.writeFile(fileName, content, function  (err) {
				// 		if(err != null){
				// 			trace("An error ocurred creating the file "+ err.message);
				// 		}

				// 		trace("The file has been succesfully saved");
				// 	});
				// });
			});

			IpcMain.on(Channel.OPEN_DIALOG, function (event){
				Dialog.showOpenDialog({}, function (fileNames) {
					// fileNames is an array that contains all the selected

					trace(fileNames);

					if(fileNames == null){
						trace("No file selected");
						return;
					}

					var filepath = fileNames[0];

					Fs.readFile(filepath, 'utf-8', function (err, data) {
						if(err != null){
							trace("An error ocurred reading the file :" + err.message);
							return;
						}

						// Change how to handle the file content
						// trace("The file content is : " + data);

						event.sender.send(Channel.SEND_FILE_CONTENT, filepath, data);
					});
				});

			});

			IpcMain.on(Channel.SAVE_FILE, function (event, filepath, content){

				// trace(filepath,content);

				Fs.writeFile(filepath, content, function (err) {
					if (err != null) {
						trace("An error ocurred updating the file" + err.message);
						trace(err);
						return;
					}

					trace("The file has been succesfully saved");
				});
			});



			IpcMain.on('asynchronous-message', function(event, arg) {
				trace(arg);  // prints "ping"
				// console.log(arg);  // prints "ping"
				event.sender.send('asynchronous-reply', 'pong');
			});

			IpcMain.on('synchronous-message', function(event, arg) {
				trace(arg);  // prints "ping"
				// console.log(arg);  // prints "ping"
				event.returnValue = 'pong';
			});


			IpcMain.on('doorBell', function(event, arg) {
				trace(arg); // 'ding'
				// console.log(arg); // 'ding'
				// trace(event);
				event.returnValue = 'dong';
			});



		});


	}

}