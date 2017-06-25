package;

import js.jquery.Event;
import js.jquery.JQuery;
import js.html.*;
import js.html.KeyboardEvent;
import js.html.Selection;

import js.Browser.*;
import js.Browser.console;
import js.Browser.document;
import js.Browser.window;


import model.constant.Channel;


import js.html.FileReader;
import js.html.Blob;

import Markdown;

import js.Node;
import js.Node.process;
import electron.renderer.IpcRenderer;
import electron.renderer.Remote;

class AppMain {

    var inMarkdown : DivElement;
	var outMarkdown : DivElement;

	var markdowExample0 : String = haxe.Resource.getString("markdown00");
	var markdowExample1 : String = haxe.Resource.getString("markdown01");
	var markdowExample2 : String = haxe.Resource.getString("markdown02");

	var isElectron = false;

	@:isVar public var inMarkdownValue(get, set):String;
	@:isVar public var outMarkdownValue(get, set):String;


	var currentFile:String;


    public function new(){

		if(process.versions['electron'] != null) isElectron = true;

		trace( 'electron', 'electron '+process.versions['electron'] );
		trace( 'node', 'node '+process.version );
		trace( 'system', process.platform +' '+ process.arch );

		init();


		// IpcRenderer.send('show-dialog', {
		// 	type: 'info'
		// });

		// IpcRenderer.on('doorBell', function(event, arg) {
		// 	trace(arg); // prints "dong"
		// 	// console.log(arg); // prints "dong"
		// });
		// IpcRenderer.send('doorBell', 'ding');


		// console.log(IpcRenderer.sendSync('synchronous-message', 'ping')); // prints "pong"

		// IpcRenderer.on('asynchronous-reply', function(event, arg) {
		// 	trace(arg); // prints "pong"
		// 	// console.log(arg); // prints "pong"
		// });
		// IpcRenderer.send('asynchronous-message', 'ping');


	}

	function init(){
		new JQuery( function():Void
		{
			// when document is ready
			console.info('This project is a WIP-sideproject written in Haxe (www.haxe.org)');
			console.info('For more info about this markdown editor check https://github.com/MatthijsKamstra/hx-markdown-editor');

			inMarkdown = cast document.getElementById('in_markdown');
			outMarkdown = cast document.getElementById('out_markdown');

			// inMarkdown.onkeydown = onBrowserChange;
			// inMarkdown.onpaste = onBrowserChange;
			inMarkdown.oninput = onBrowserChange;
			// inMarkdown.onBrowserChange = onBrowserChange;

			var md = markdowExample2;

			inMarkdownValue = md;
			outMarkdownValue = md;

			// register the handler
			// document.getElementById('file-upload').addEventListener('change', onFolderOpenHandler, false);
			document.getElementById('btn-open').addEventListener('click', onFolderOpenHandler, false);
			document.getElementById('btn-save').addEventListener('click', onSaveHandler, false);
			document.addEventListener('keydown', onKeydownHandler, false);

		});
	}



	function onFolderOpenHandler(){
		IpcRenderer.send(Channel.OPEN_DIALOG, function (){
			trace('test');
		});
		IpcRenderer.on(Channel.SEND_FILE_CONTENT, function(event,filepath, data) {
			trace(filepath);
			currentFile = filepath;
			inMarkdownValue = data;
		});
	}

	function onSaveHandler(){
		IpcRenderer.send(Channel.SAVE_FILE, currentFile, inMarkdownValue,  function (){
			trace('test');
		});
	}




	// define a handler
	function onKeydownHandler(e:KeyboardEvent) {
		// trace(e);


		// CMD
		if(e.metaKey){
			switch(e.key.toLowerCase()){
				case '1':
					trace('change to h1');
					keyboardShortCut(e,1);
				case '2': trace('change to h2'); keyboardShortCut(e,2);
				case '3': trace('change to h3'); keyboardShortCut(e,3);
				case '4': trace('change to h4'); keyboardShortCut(e,4);
				case '5': trace('change to h5'); keyboardShortCut(e,5);
				case '6': trace('change to h6'); keyboardShortCut(e,6);
				case 'b':
					trace('change to bold');
					wrap('**');
				case 'i':
					trace('change to italic');
					wrap('_');
				case 'k':
					trace('change to inline code (k)');
					wrap('`');
				case '/':
					trace('change to comment');
					wrap('<!-- ', ' -->');
				case 's': trace('save');
				case 'o': trace('open');
			}
		}
		// this would test for whichever key is 40 and the ctrl key at the same time
		if (e.ctrlKey && e.keyCode == 40) {
			// call your function to do the thing
			// pauseSound();
		}


	}

	function keyboardShortCut(e:KeyboardEvent,cmdKey:Int){
		e.preventDefault();
		e.stopPropagation();
		// trace('vv '+getCaretPosition(inMarkdown));
		// replaceSelectedText('**');
		var str = '';
		var counter = 0;
		while (counter<cmdKey){
			str += '#';
			counter++;
		}
		// wrap(str, '');
		getCaretPosition(str);

	}

	function wrap(tag:String,?endtag:String) {
		var sel, range;
		var selectedText:String;
		if (window.getSelection != null) {
			sel = window.getSelection();
			if (sel.rangeCount != null) {
				range = sel.getRangeAt(0);
				selectedText = Std.string(range);
				range.deleteContents();
				if(endtag != null){
					range.insertNode(document.createTextNode(tag + selectedText + endtag));
				} else {
					range.insertNode(document.createTextNode(tag + selectedText + tag));
				}
			}
		}
		// else if (document.selection && document.selection.createRange) {
		// 	range = document.selection.createRange();
		// 	selectedText = document.selection.createRange().text + "";
		// 	range.text = '[' + tag + ']' + selectedText + '[/' + tag + ']';
		// }
		onBrowserChange (null);
	}


	function getCaretPosition(tag:String) {
		var caretPos = 0;
		var range;
		var selection : Selection;
		if (window.getSelection != null) {
			selection = window.getSelection();
			if (selection.rangeCount != null) {
				range = selection.getRangeAt(0);
				range.setStart(range.startContainer, range.startOffset - range.startOffset);
				// range.collapse(true);
				// caretPos = range.endOffset;

				// range.setStart(range.startContainer, range.startOffset - 1);
				// range.setEnd(range.endContainer, range.endOffset + 1);

				trace(untyped range.toString());
				// var selectedContent = range.extractContents().textContent;
				// trace(selectedContent);
				// if (range.commonAncestorContainer.parentNode == editableDiv) {
				// 	caretPos = range.endOffset;
				// }

				range.insertNode(document.createTextNode('${tag} '));
			}
		}
		onBrowserChange (null);
	}




	function setWorkbench (content){
		inMarkdownValue = content;
		outMarkdownValue = content;
	}

	// ____________________________________ handlers ____________________________________

	function onBrowserFileOpenHandler(e) {
		// trace(e);
		var file : Blob = e.target.files[0];
		if (file == null) {
			return;
		}
		var reader = new FileReader();
		reader.onload = function(e) {
			var content = e.target.result;
			setWorkbench(content);
		};
		reader.readAsText(file);
	}

	function onBrowserSaveHandler(e:Event){
		e.preventDefault();
		var text = inMarkdown.innerText;
		// var filename = $("#input-fileName").val();
		var filename = 'foo';
		var blob = new Blob([text], {type: "text/plain;charset=utf-8"});
		untyped saveAs(blob, filename+".md");
	}

	function onBrowserChange (e:Event){
		trace( 'onBrowserChange: ' + e );
		var str = inMarkdown.innerText;
		setWorkbench (str);
	}

	function onClick (e:Dynamic) {
		var id = e.currentTarget.id;
		switch (id) {
			case "example1": setWorkbench(markdowExample1);
			case "example2": setWorkbench(markdowExample2);
			case "btn_convert": setWorkbench(inMarkdown.innerText);
			// case "btn_select": selectAll();
		}
		e.preventDefault();
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
		inMarkdown.innerText = value;
		return inMarkdownValue = value;
	}

	/**
	 *  return the generated html from markdown
	 *
	 *  @return String
	 */
	function get_outMarkdownValue():String {
		outMarkdownValue = Markdown.markdownToHtml(inMarkdownValue);
		return outMarkdownValue;
	}
	function set_outMarkdownValue(value:String):String {
		outMarkdown.innerHTML = (Markdown.markdownToHtml(value));
		return outMarkdownValue = value;
	}

	// ____________________________________ main ____________________________________

	static public function main(){
		var app = new AppMain();
	}

}
