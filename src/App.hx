package;

import js.jquery.Event;
import js.jquery.JQuery;
import js.html.*;
import js.html.KeyboardEvent;
import js.html.Selection;




import js.Browser;
import js.Browser.console;
import js.Browser.document;
import js.Browser.window;

// import js.Node.process;

import js.html.FileReader;
import js.html.Blob;

import Markdown;

class App {

    var inMarkdown : DivElement;
	var outMarkdown : DivElement;

	var markdowExample0 : String = haxe.Resource.getString("markdown00");
	var markdowExample1 : String = haxe.Resource.getString("markdown01");
	var markdowExample2 : String = haxe.Resource.getString("markdown02");

    public function new()
	{
		new JQuery( function():Void
		{
			// when document is ready
			console.log('document ready');

			inMarkdown = cast document.getElementById('in_markdown');
			outMarkdown = cast document.getElementById('out_markdown');

			// inMarkdown.onkeydown = onChange;
			// inMarkdown.onpaste = onChange;
			inMarkdown.oninput = onChange;
			// inMarkdown.onchange = onChange;

			var md = markdowExample2;

			inMarkdown.innerText = (md);
			convert(md);

			// register the handler
			document.getElementById('file-upload').addEventListener('change', readSingleFile, false);
			document.getElementById('btn-save').addEventListener('click', onSaveHandler, false);
			document.addEventListener('keydown', onKeydownHandler, false);

		});
	}

	function onSaveHandler(e:Event){
		e.preventDefault();
		var text = inMarkdown.innerText;
		// var filename = $("#input-fileName").val();
		var filename = 'foo';
		var blob = new Blob([text], {type: "text/plain;charset=utf-8"});
		untyped saveAs(blob, filename+".md");
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
		onChange (null);
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
		onChange (null);
	}

	function readSingleFile(e) {
		// trace(e);
		var file : Blob = e.target.files[0];
		if (file == null) {
			return;
		}
		var reader = new FileReader();
		reader.onload = function(e) {
			var contents = e.target.result;
			displayContents(contents);
		};
		reader.readAsText(file);
	}

	function displayContents(contents) {
		// trace(contents);
		inMarkdown.innerText = contents;
		convert (contents);
	}

	function onChange (e:Event){
		trace( 'onChange: ' + e );
		var str = inMarkdown.innerText;

		// trace(str);
		convert (str);
	}

	function convert ( str )
	{
		// inMarkdown.innerText = (str);
		// outMarkdown.innerText = (Markdown.markdownToHtml(str));
		outMarkdown.innerHTML = (Markdown.markdownToHtml(str));

		// previewArea.scrollTop = outTextArea.scrollHeight;
		// previewArea.select();
	}

	// function selectAll():Void {
	// 	previewArea.select();
	// }

	private function onClick (e:Dynamic) : Void
	{
		var id = e.currentTarget.id;
		switch (id) {
			case "example1": convert(markdowExample1);
			case "example2": convert(markdowExample2);
			case "btn_convert": convert(inMarkdown.innerText);
			// case "btn_select": selectAll();
		}
		e.preventDefault();
	}

	static public function main(){
		var app = new App();
	}

    // static inline function setText( id : String, text : String ) {
    //     document.getElementById( id ).textContent = text;
    // }

    // static function main() {

    //     window.onload = function() {

    //         document.getElementById( 'logo' ).style.opacity = '1';

    //         setText( 'electron', 'electron '+process.versions['electron'] );
    //         setText( 'node', 'node '+process.version );
    //         setText( 'system', process.platform +' '+ process.arch );
    //     }
    // }

}
