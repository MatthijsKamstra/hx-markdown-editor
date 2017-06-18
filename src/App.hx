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

	var markdowExample1 : String = '# heading 1\n\nthis is a test piece of text just for testing\n\n## heading 2\n\njust because we can\n\n- one\n- two';
	var markdowExample2 : String = haxe.Resource.getString("markdown00");

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

			var md = markdowExample1;

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
					keyboardShortCut('1');
				case '2': trace('change to h2'); keyboardShortCut('2');
				case '3': trace('change to h3'); keyboardShortCut('3');
				case '4': trace('change to h4'); keyboardShortCut('4');
				case '5': trace('change to h5'); keyboardShortCut('5');
				case '6': trace('change to h6'); keyboardShortCut('6');
				case 'b':
					trace('change to bold');
					wrap('**');
				case 'i':
					trace('change to italic');
					wrap('_');
				case 's': trace('save');
				case 'o': trace('open');
			}
		}
		// this would test for whichever key is 40 and the ctrl key at the same time
		if (e.ctrlKey && e.keyCode == 40) {
			// call your function to do the thing
			// pauseSound();
		}

		// e.preventDefault();
		// e.stopPropagation();
	}

	function keyboardShortCut(cmdKey:String){
		// trace('vv '+getCaretPosition(inMarkdown));
		// replaceSelectedText('**');
		wrap('**');
	}

	function wrap(tag:String) {
		var sel, range;
		var selectedText:String;

		if (window.getSelection != null) {
			sel = window.getSelection();
			if (sel.rangeCount != null) {
				range = sel.getRangeAt(0);
				selectedText = Std.string(range);
				range.deleteContents();
				range.insertNode(document.createTextNode(tag + selectedText + tag));
			}
		}
		// else if (document.selection && document.selection.createRange) {
		// 	range = document.selection.createRange();
		// 	selectedText = document.selection.createRange().text + "";
		// 	range.text = '[' + tag + ']' + selectedText + '[/' + tag + ']';
		// }

	}


	// function surroundSelection(wrapperText:String) {
	// 	if (window.getSelection != null) {
	// 		var sel = window.getSelection();
	// 		if (sel.rangeCount != null) {
	// 			var range = sel.getRangeAt(0).cloneRange();
	// 			range.surroundContents(new Node(wrapperText));
	// 			sel.removeAllRanges();
	// 			sel.addRange(range);
	// 		}
	// 	}
	// }


	// function replaceSelectedText(replacementText:String) {
	// 	var sel : Selection;
	// 	var range : Range;
	// 	var range2 : Range;
	// 	if (window.getSelection != null) {
	// 		sel = window.getSelection();

	// 		trace(sel);

	// 		if (sel.rangeCount != null) {
	// 			range = sel.getRangeAt(0);
	// 			range2 = sel.getRangeAt(sel.focusOffset - sel.anchorOffset);

	// 			// range.deleteContents();


	// 			range.insertNode(document.createTextNode(replacementText));
	// 			range2.insertNode(document.createTextNode(replacementText));


	// 		}
	// 	} else if (untyped document.selection && document.selection.createRange) {
	// 		range = untyped document.selection.createRange();
	// 		untyped range.text = replacementText;
	// 	}
	// }


	// function getCaretPosition(editableDiv) {
	// 	var caretPos = 0;
	// 	var range;
	// 	var selection : Selection;
	// 	if (window.getSelection != null) {
	// 		selection = window.getSelection();
	// 		trace( 'selection: ' + selection );
	// 		trace(selection.anchorNode );
	// 		trace(selection.anchorOffset );
	// 		trace(selection.caretBidiLevel );
	// 		trace(selection.containsNode );
	// 		trace(selection.focusNode );
	// 		trace(selection.rangeCount );
	// 		if (selection.rangeCount != null) {
	// 			range = selection.getRangeAt(0);
	// 			if (range.commonAncestorContainer.parentNode == editableDiv) {
	// 				caretPos = range.endOffset;
	// 			}
	// 		}
	// 	}
	// 	return caretPos;
	// }

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
