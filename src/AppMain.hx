package;

import js.jquery.Event;
import js.jquery.JQuery;
import js.html.*;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;

import js.html.FileReader;
import js.html.Blob;

import codemirror.CodeMirror;

#if (!browser)
import js.Node.process;
import electron.renderer.IpcRenderer;
#end

using StringTools;
using DateTools;
using Reflect;

import model.constant.Channel;

class AppMain {

	var isElectron = false;
	var currentFile:String;
	var currentFileName:String = 'monk';

	var editor : CodeMirror;

    // var inMarkdown : DivElement;
    var inMarkdown : TextAreaElement;
	var outMarkdown : DivElement;

	@:isVar public var inMarkdownValue(get, set):String;
	@:isVar public var outMarkdownValue(get, set):String;

	var markdowExample0 : String = haxe.Resource.getString("markdown00");
	var markdowExample1 : String = haxe.Resource.getString("markdown01");
	var markdowExample2 : String = haxe.Resource.getString("markdown02");

	var keyMarkdown : String;

	var isMac : Bool = true;
	var IS_FULL_SCREEN : Bool = false;

	var shortCuts : Array<KeyBindings> = haxe.Json.parse(haxe.Resource.getString("key"));

    public function new(){
		console.info('This project is a WIP-sideproject written in Haxe (www.haxe.org)');
		console.info('For more info about this markdown editor check https://github.com/MatthijsKamstra/hx-markdown-editor');

		// Some variables
		// var isMac = /Mac/.test(navigator.platform);

		#if (browser)
		isElectron = false;
		#else
		isElectron = true;
		trace( 'electron', 'electron '+process.versions['electron'] );
		trace( 'node', 'node '+process.version );
		trace( 'system', process.platform +' '+ process.arch );
		#end

		init();
	}

	function init(){
		new JQuery( function():Void {
			// when document is ready

			// setup editors
			initEditors();

			// keymaps
			initShortcuts();

			// register the handler
			document.getElementById('btn-new').addEventListener('click', newHandler, false);
			document.getElementById('btn-open').addEventListener('click', openHandler, false);
			document.getElementById('file-upload').addEventListener('change', openHandler);
			document.getElementById('btn-save').addEventListener('click', saveHandler, false);
			document.getElementById('btn-fullscreen').addEventListener('click', fullscreenToggleHandler, false);
			document.getElementById('btn-preview').addEventListener('click', previewToggleHandler, false);
			document.getElementById('btn-headphone').addEventListener('click', toggleDistractionFreeHandler, false);

			toggleOpenBtn();

			// setup up resizer
			window.addEventListener("resize", onResizeHandler);
			onResizeHandler(null);

			setMonkDocumentTitle('Monk Markdown Editor');

			updatePreview();

			// document.addEventListener('keydown', onKeydownHandler, false);
		});
	}

	// ____________________________________ init ____________________________________


	function initEditors() {
		// setup markdown area
		inMarkdown = document.createTextAreaElement();
		inMarkdown.id = 'in_markdown_default';
		inMarkdown.className = 'in-markdown';
		inMarkdown.cols = 30;
		inMarkdown.rows = 10;
		document.getElementById('workbench_parts_editor_one').appendChild(inMarkdown);

		// setup preview area
		outMarkdown = document.createDivElement();
		outMarkdown.id = 'out_markdown_default';
		outMarkdown.className = 'out-markdown';
		if(document.getElementById('workbench_parts_editor_two') != null) document.getElementById('workbench_parts_editor_two').appendChild(outMarkdown);

		// set the default markdown file (this needs to change in the future)
		var md = markdowExample2;
		inMarkdownValue = md;
		outMarkdownValue = md;

		// setup codemirror
		editor = CodeMirror.fromTextArea(inMarkdown, {
			tabSize: '2',
			indentWithTabs: true,
			lineWrapping: true,
			extraKeys: {
				"Enter": 'newlineAndIndentContinueMarkdownList'
			},
			mode: 'markdown',
			tabMode: 'indent',
			theme: 'monk',
			// lineNumbers: true,
			// lineWrapping: true,
			// viewportMargin: 'Infinity'
		});
		editor.on("change", function(cm, change) {
			updatePreview();
		});
		editor.focus(); // make sure the shortcuts work asap by focussing on the editor
	}

	/**
	 *  create shortcut list (and render the `shortcut.md` file)
	 *  @param keys -  WIP
	 */
	function initShortcuts (?keys : {}){
		keyMarkdown = 'Keyboard Shortcuts\n\n';
		keyMarkdown += '| Command | Keybinding | Shortcut OsX | Electron | CodeMirror |\n';
		keyMarkdown += '| ------- | ---------- | :----------: | :------: | :--------: |\n';
		var map = {
			"Alt-Space" : function (cm) { onKeyMappedHandler ('boo'); }
		};
		for (i in 0...shortCuts.length){
			var item = shortCuts[i];
			map.setField(item.key, function(cm){ onKeyMappedHandler(item.action); } );
			keyMarkdown += '| ${item.action} | ${item.key} | ${replaceString2Symbols (item.key)} | x | ${item.key} |\n';
		}
		editor.addKeyMap(map);
		// console.info(keyMarkdown);
	}

	// ____________________________________ misc ____________________________________

	// Symbol	Meaning
	// ⌘	Command
	// ⌥	ALT
	// ⌃	Control
	// ⇧	Shift
	function replaceString2Symbols (keybinding:String):String{
		var str = '`' + keybinding.replace('Cmd', '⌘').replace('Alt','⌥').replace('Ctrl','⌃').replace('Shift','⇧').replace('-','` `') + '`';
		return str.replace('``' , '`');
	}

	/**
	 * Fix shortcut. Mac use Command, others use Ctrl.
	 */
	function fixShortcut(name:String) {
		if(isMac) {
			name = name.replace("Ctrl", "Cmd");
		} else {
			name = name.replace("Cmd", "Ctrl");
		}
		return name;
	}

	/**
	 *  set the document title (draggable part in electron)
	 *  @param title -  String
	 */
	function setMonkDocumentTitle(title:String){
		var widowtitle : Element = document.getElementsByClassName('window-title')[0];
		widowtitle.innerText = title;
	}

	/**
	 *  this is a rought estimation, need to look better at this
	 *  @param content - editor.getValue()
	 */
	function setWordcount(content:String){
		// trace(content);
		var wordcount : Element = document.getElementsByClassName('window-wordcount')[0];
		// replace the basic markdown stuff
		var str = content.replace('\t', '')
					.replace('\n', '')
					.replace('\r', '')
					.replace('#', '')
					.replace('*', '')
					.replace('_', '')
					.replace('`', '')
					.replace('  ', '');
		var array = str.split(' ');
		// trace(array);
		wordcount.innerText = '${array.length} words';
	}

	/**
	 *  open files work diferently for electron and browser, so they are grouped and hidden when not they don't apply
	 */
	function toggleOpenBtn (){
		var electronContainer : Element = document.getElementById('container-btn-open-electron');
		var browserContainer : Element = document.getElementById('container-btn-open-browser');
		#if (browser)
			electronContainer.style.display = 'none';
			browserContainer.style.display = 'initial';
		#else
			electronContainer.style.display = 'initial';
			browserContainer.style.display = 'none';
		#end
	}

	function setWorkbench (content){
		inMarkdownValue = content;
		outMarkdownValue = content;
		editor.setValue(content);
		editor.focus();
	}

	// ____________________________________ change/manipulate lines in codemirror ____________________________________

	/**
	 * Insert a string at cursor position
	 * @param  {String} insertion
	 */
	function insert(insertion:String) {
		var doc = this.editor.getDoc();
		var cursor = doc.getCursor();
		doc.replaceRange(insertion, { line: cursor.line, ch: cursor.ch });
	}

	/**
	 * Insert a string at the start and end of a selection
	 * @param  {String} start
	 * @param  {String} end
	 */
	function insertAround(start:String, end:String) {
		var doc = this.editor.getDoc();
		var cursor = doc.getCursor();
		if (doc.somethingSelected()) {
			var selection = doc.getSelection();
			doc.replaceSelection(start + selection + end);
		} else {
			// If no selection then insert start and end args and set cursor position between the two.
			doc.replaceRange(start + end, { line: cursor.line, ch: cursor.ch });
			doc.setCursor({ line: cursor.line, ch: cursor.ch + untyped start.length });
		}
	}

	/**
	 * Insert a string before a selection
	 * @param  {String} insertion
	 */
	function insertBefore(insertion:String, ?cursorOffset:Int) {
		var doc = this.editor.getDoc();
		var cursor = doc.getCursor();
		if (doc.somethingSelected()) {
			var selections = doc.listSelections();
			// [mck] TODO this is an array, so use it!
			trace(selections);
			var pos = [selections[0].head.line , selections[0].anchor.line];
			pos.sort(function(a, b):Int {
				if (a < b) return -1;
				else if (a > b) return 1;
				return 0;
			});
			for (i in pos[0]...pos[1]+1){
				doc.replaceRange(insertion, { line: i, ch: 0 });
			}
			doc.setCursor({ line: pos[0], ch: (cursorOffset!=null) ? cursorOffset : 0 });
		} else {
			// trace('check hier');
			doc.setSelection({line:cursor.line, ch:cursor.ch},{line:cursor.line, ch:0});
			var selection = doc.getSelection();
			doc.replaceSelection(insertion + selection.replace("#",'').replace(insertion,'').trim());
			// doc.replaceRange(insertion, { line: cursor.line, ch: 0 });
			// doc.setCursor({ line: cursor.line, ch: (cursorOffset!=null) ? cursorOffset : 0 });
		}
	}





	// ____________________________________ handlers for electron and browser ____________________________________


	function newHandler(e){
		currentFileName = 'new_document';
		editor.setValue('# New document\n\nmonk');
		editor.focus();
	}

	function saveHandler(e){
		#if (browser)
			onBrowserSaveHandler(e);
		#else
			onSaveHandler();
		#end
	}

	function openHandler(e){
		#if (browser)
			onBrowserFileOpenHandler(e);
		#else
			onFolderOpenHandler();
		#end
	}

	/**
	 *  set fullscreen and hide preview
	 */
	function toggleDistractionFreeHandler(){
		var isToggle = true;
		if( IS_FULL_SCREEN ) {
			isToggle = false;
		}
		fullscreenToggleHandler(isToggle);
		previewToggleHandler(isToggle);
	}

	/**
	 *
	 *  @param isFocus - force the issue!
	 */
	function previewToggleHandler(?isFocus:Bool = false){
		var toggle = document.getElementById('workbench_parts_editor_two');
		var button = document.getElementById('btn-preview').firstElementChild;
		// [mck] weird js stuff going on... onclick the mouseevent is send
		if(isFocus != true) isFocus = false;
		if(isFocus){
			toggle.style.display = "none";
			button.setAttribute('class', 'fa fa-eye-slash');
			return;
		}
		if(toggle.style.display == 'none'){
			toggle.style.display = "initial";
			button.setAttribute('class', 'fa fa-eye');
		} else {
			toggle.style.display = "none";
			button.setAttribute('class', 'fa fa-eye-slash');
		}
	}


	/**

		function requestFullScreen(element) {
			// Supports most browsers and their versions.
			var requestMethod = element.requestFullScreen || element.webkitRequestFullScreen || element.mozRequestFullScreen || element.msRequestFullScreen;

			if (requestMethod) { // Native full screen.
				requestMethod.call(element);
			} else if (typeof window.ActiveXObject !== "undefined") { // Older IE.
				var wscript = new ActiveXObject("WScript.Shell");
				if (wscript !== null) {
					wscript.SendKeys("{F11}");
				}
			}
		}

		var elem = document.body; // Make the body go full screen.
		requestFullScreen(elem);
	 */
	function fullscreenToggleHandler(?isFocus:Bool=false){
		trace('fullscreenToggleHandler');
		// https://developer.mozilla.org/en-US/docs/DOM/Using_fullscreen_mode
		var doc = document;
		// var el = this.editor.getWrapperElement();
		var el = document.documentElement;
		// [mck] weird js stuff going on... onclick the mouseevent is send
		if(isFocus != true) isFocus = false;
		if(isFocus) IS_FULL_SCREEN = false;
		if (!IS_FULL_SCREEN) {
			if (el.requestFullscreen != null) {
				el.requestFullscreen();
			} else if (untyped el.webkitRequestFullscreen) {
				untyped el.webkitRequestFullscreen();
			} else if (untyped el.mozRequestFullScreen) {
				untyped el.mozRequestFullScreen();
			} else if (untyped el.msRequestFullscreen) {
				untyped el.msRequestFullscreen();
			}
			IS_FULL_SCREEN = true;
		} else {
			if (untyped doc.cancelFullScreen) {
				untyped doc.cancelFullScreen();
			} else if (untyped doc.mozCancelFullScreen) {
				untyped doc.mozCancelFullScreen();
			} else if (untyped doc.webkitCancelFullScreen) {
				untyped doc.webkitCancelFullScreen();
			}
			IS_FULL_SCREEN = false;
		}

		// trace('document.fullscreenElement: ${document.fullscreenElement}');
	}

	// ____________________________________ electron calls / handlers ____________________________________

	#if !browser
	function onFolderOpenHandler(){
		IpcRenderer.send(Channel.OPEN_DIALOG, function (){
			trace('${Channel.OPEN_DIALOG}');
		});
		IpcRenderer.on(Channel.SEND_FILE_CONTENT, function(event, filepath, data) {
			trace(filepath);
			currentFile = filepath;
			inMarkdownValue = data;
			editor.setValue(data);
		});
	}

	function onSaveHandler(){
		if(currentFile == null) return;
		IpcRenderer.send(Channel.SAVE_FILE, currentFile, inMarkdownValue,  function (){
			trace('${Channel.SAVE_FILE}');
		});
	}
	#end

	// ____________________________________ handlers (for browser and electron) ____________________________________


	function onKeyMappedHandler (value){

		trace('onKeyMappedHandler ( ${value} )');

		switch (value) {

			case 'new': newHandler(null);
			case 'save': saveHandler(null);
			case 'open': openHandler(null);
			case 'fullscreen': fullscreenToggleHandler();
			case 'preview': previewToggleHandler(false);

			case 'header1': this.insertBefore('# ', 2);
			case 'header2': this.insertBefore('## ', 3);
			case 'header3': this.insertBefore('### ', 4);
			case 'header4': this.insertBefore('#### ', 5);
			case 'header5': this.insertBefore('##### ', 6);
			case 'header6': this.insertBefore('###### ', 7);
			case 'header0': this.insertBefore('', 2);

			case 'bold': this.insertAround('**', '**');
			case 'italic': this.insertAround('_', '_');
			case 'comment': this.insertAround('<!-- ', ' -->');

			case 'inlinecode': this.insertAround('`', '`');
			case 'codeblock': this.insertAround('```\r\n', '\r\n```');

			case 'hr': this.insert('\n\n----\n\n');

			case 'orderedlist': this.insertBefore('1. ', 3);
            case 'unorderedlist': this.insertBefore('* ', 3);

			case 'blockquote': this.insertBefore('> ', 3);

            case 'image': this.insertBefore('![](http://)', 2);
            case 'link': this.insertAround('[', '](http://)');

            case 'table': this.insert('| colum 1 | colum 2 |\n| :--: | :--: |\n| a | b |\n| c | d |\n');


			default:
				trace('not sure what you want: $value');
		}

		// outMarkdownValue = str;
		// updatePreview();
	}

	function onResizeHandler(e){
		var myWidth : Int = window.innerWidth;
    	var myHeight : Int = window.innerHeight;
 		/**
 		 * var style = window.getComputedStyle(document.getElementById("Example"), null);
		 * style.getPropertyValue("height");
 		 */

		var offset = 23;
 		document.getElementById('monk_markdown_container').setAttribute("data-comment", 'w:${myWidth}px, h:${myHeight}px');
 		document.getElementById('workbench_parts_title'); // 20px height
 		document.getElementById('workbench_parts_editor_container').setAttribute("style", 'width:100%; height:${myHeight-offset}px;');
 		document.getElementById('workbench_parts_editor_container').setAttribute("data-comment", 'w:${myWidth}px, h:${myHeight-offset}px');
		// trace('width: $myWidth, height: $myHeight');
	}

	function onBrowserFileOpenHandler(e) {
		// trace(e);
		var file : File = e.target.files[0];
		if (file == null) {
			return;
		}
		currentFileName = file.name;
		setMonkDocumentTitle(currentFileName);

		var reader = new FileReader();
		reader.onload = function(e) {
			var content = e.target.result;
			setWorkbench(content);
		};
		reader.readAsText(file);
	}

	function onBrowserSaveHandler(?e:Event){
		if(e != null) e.preventDefault();
		if(e != null) e.stopPropagation();
		// inMarkdownValue
		// var text = inMarkdown.innerText;
		var text = editor.getValue();
		// var filename = $("#input-fileName").val();
		var date = DateTools.format(Date.now(), "%Y-%m-%d_%H:%M:%S");
		var blob = new Blob([text], {type: "text/plain;charset=utf-8"});
		untyped saveAs(blob, '${currentFileName}_${date}.md');
	}

	function updatePreview (){
		outMarkdownValue = editor.getValue();
		setWordcount(editor.getValue());
	}

	// ____________________________________ getter/setter ____________________________________

	/**
	 *  the original markdown
	 *
	 *  @return String
	 */
	function get_inMarkdownValue():String {
		inMarkdownValue = inMarkdown.innerText;
		return inMarkdownValue;
	}
	function set_inMarkdownValue(value:String):String {
		inMarkdown.innerHTML = value;
		return inMarkdownValue = value;
	}

	/**
	 *  return the generated html from markdown
	 *
	 *  @return String
	 */
	function get_outMarkdownValue():String {
		outMarkdownValue = convertToMarkdown(inMarkdownValue);
		return outMarkdownValue;
	}
	function set_outMarkdownValue(value:String):String {
		outMarkdown.innerHTML = convertToMarkdown(value);
		return outMarkdownValue = value;
	}


	function convertToMarkdown(md):String{
		// var result = Markdown.markdownToHtml(md);
		var result = untyped markdownit().render(md);
		return result;
	}
	// ____________________________________ main ____________________________________

	static public function main(){
		var app = new AppMain();
	}

}

typedef KeyBindings = {
	var key : String;
	var action : String;
}
