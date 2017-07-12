import electron.main.Menu;
import js.Node.process;


class MainMenu {


	public function new () {
		var template : Array<MenuObj>  =
		[
			{
				label: 'File',
				submenu: [
					{
						label: 'New File',
						accelerator: 'CmdOrCtrl+N'
					},
					{type: 'separator'},
					{
						label: 'Open...',
						accelerator: 'CmdOrCtrl+O'
					},
					{type: 'separator'},
					{
						label: 'Save',
						accelerator: 'CmdOrCtrl+S'
					},
					{
						label: 'Save As...',
						accelerator: 'Shift+CmdOrCtrl+S'
					},
					{
						label: 'Save all',
						accelerator: 'Alt+CmdOrCtrl+S'
					}
				]
			},
			{
				label: 'Edit',
				submenu: [
				{
					label: 'Undo',
					accelerator: 'CmdOrCtrl+Z',
					role: Roles.undo
				},
				{
					label: 'Redo',
					accelerator: 'Shift+CmdOrCtrl+Z',
					role: Roles.redo
				},
				{
					label: 'Cut',
					accelerator: 'CmdOrCtrl+X',
					role: Roles.cut
				},
				{
					label: 'Copy',
					accelerator: 'CmdOrCtrl+C',
					role: Roles.copy
				},
				{
					label: 'Paste',
					accelerator: 'CmdOrCtrl+V',
					role: Roles.paste
				},
				{
					label: 'Select All',
					accelerator: 'CmdOrCtrl+A',
					role: Roles.selectall
				}]
			},
			{
				label: 'View',
				submenu: [
					{role: Roles.reload},
					{role: Roles.forcereload},
					{role: Roles.toggledevtools},
					{type: 'separator'},
					{role: Roles.resetzoom},
					{role: Roles.zoomin},
					{role: Roles.zoomout},
					{type: 'separator'},
					{role: Roles.togglefullscreen}
				]
			},
			{
				role: 'window',
				submenu: [
					{role: Roles.minimize},
					{role: Roles.close}
				]
			},
			{
				role: 'help',
				submenu: [
				{
					label: 'Learn More'
				}
				]
			}
		];

		if (process.platform == 'darwin') {
			template.unshift({
				label: electron.main.App.getName(),
				submenu: [
					{role: Roles.about},
					{type: 'separator'},
					{role: Roles.services},
					{type: 'separator'},
					{role: Roles.hide},
					{role: Roles.hideothers},
					{role: Roles.unhide},
					{type: 'separator'},
					{role: Roles.quit}
				]
			});
		};

		var menu = Menu.buildFromTemplate(template);
		Menu.setApplicationMenu(menu);
	}
}

// https://github.com/electron/electron/blob/master/docs/api/menu-item.md
typedef MenuObj = {
	// click Function (optional) - Will be called with click(menuItem, browserWindow, event) when the menu item is clicked.
	// menuItem MenuItem
	// browserWindow BrowserWindow
	// event Event
	@:optional var role : String; // (optional) - Define the action of the menu item, when specified the click property will be ignored. See roles.
	@:optional var type : String; // (optional) - Can be normal, separator, submenu, checkbox or radio.
	@:optional var label : String; // - (optional)
	@:optional var sublabel : String; // - (optional)
	// @:optional var accelerator : Accelerator; // (optional)
	@:optional var icon : String; //(; //NativeImage | String) (optional)
	@:optional var enabled : Bool; // (optional) - If false, the menu item will be greyed out and unclickable.
	@:optional var visible : Bool; // (optional) - If false, the menu item will be entirely hidden.
	@:optional var checked : Bool; // (optional) - Should only be specified for checkbox or radio type menu items.
	@:optional var submenu : Array<SubMenuObj>; //(; //MenuItemConstructorOptions[] | Menu) (optional) - Should be specified for submenu type menu items. If submenu is specified, the type: 'submenu' can be omitted. If the value is not a Menu then it will be automatically converted to one using Menu.buildFromTemplate.
	@:optional var id : String; // (optional) - Unique within a single menu. If defined then it can be used as a reference to this item by the position attribute.
	@:optional var position : String; // (optional) - This field allows fine-grained definition of the specific location within a given menu.

};

typedef SubMenuObj = {
	@:optional var role:Roles; 			// 'selectall'
	@:optional var type:String; 		// 'separator',
	@:optional var label:String;		// 'Select All',
	@:optional var accelerator:String;	// 'CmdOrCtrl+A',
};

@:enum abstract Roles(String) {

	// not really a role
	var separator = 'separator';

	var undo = 'undo';
	var redo = 'redo';
	var cut = 'cut';
	var copy = 'copy';
	var paste = 'paste';
	var pasteandmatchstyle = 'pasteandmatchstyle';
	var selectall = 'selectall';
	var delete = 'delete';
	var minimize = 'minimize';						// - Minimize current window
	var close = 'close';							// - Close current window
	var quit = 'quit';								//- Quit the application
	var reload = 'reload';							// - Reload the current window
	var forcereload = 'forcereload';				// - Reload the current window ignoring the cache.
	var toggledevtools = 'toggledevtools';			// - Toggle developer tools in the current window
	var togglefullscreen = 'togglefullscreen';		//- Toggle full screen mode on the current window
	var resetzoom = 'resetzoom';					// - Reset the focused page's zoom level to the original size
	var zoomin = 'zoomin';							// - Zoom in the focused page by 10%
	var zoomout = 'zoomout';						// - Zoom out the focused page by 10%
	var editMenu = 'editMenu';						// - Whole default "Edit" menu (Undo, Copy, etc.)
	var windowMenu = 'windowMenu';					// - Whole default "Window" menu (Minimize, Close, etc.)

	// The following additional roles are available on macOS:

	var about = 'about';							// - Map to the orderFrontStandardAboutPanel action
	var hide = 'hide';								// - Map to the hide action
	var hideothers = 'hideothers';					// - Map to the hideOtherApplications action
	var unhide = 'unhide';							// - Map to the unhideAllApplications action
	var startspeaking = 'startspeaking';			// - Map to the startSpeaking action
	var stopspeaking = 'stopspeaking';				// - Map to the stopSpeaking action
	var front = 'front';							// - Map to the arrangeInFront action
	var zoom = 'zoom';								// - Map to the performZoom action
	var window = 'window';							// - The submenu is a "Window" menu
	var help = 'help';								// - The submenu is a "Help" menu
	var services = 'services';						// - The submenu is a "Services" menu

}