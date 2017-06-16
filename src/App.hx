package;

import js.jquery.Event;
import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
// import js.Node.process;


import js.html.FileReader;
import js.html.Blob;

import Markdown;

import js.jquery.JQuery;
import js.Browser;
import js.html.TextAreaElement;
import js.html.DivElement;

class App {

    var inArea : Dynamic;
	var outArea : Dynamic;

	var inTextArea : TextAreaElement;
	var outTextArea : TextAreaElement;
	var previewArea : DivElement;

	var markdowExample1 : String = '# heading 1\n\ntest';
	var markdowExample2 : String = haxe.Resource.getString("markdown00");

    public function new()
	{
		new JQuery( function():Void
		{
			// when document is ready
			console.log('document ready');

			// // your magic
			new JQuery('#btn_convert').click(onClick);
			new JQuery('#btn_select').click(onClick);

			new JQuery('#example1').click(onClick);
			new JQuery('#example2').click(onClick);

			inArea = new JQuery('#in_markdown');
			outArea = new JQuery('#out_markdown');

			inTextArea = cast (js.Browser.document.getElementById('in_markdown'), TextAreaElement);
			outTextArea = cast (js.Browser.document.getElementById('out_markdown'), TextAreaElement);
			previewArea = cast (js.Browser.document.getElementById('preview_markdown'), DivElement);

			// inTextArea.onkeydown = onChange;
			// inTextArea.onpaste = onChange;
			inTextArea.oninput = onChange;
			// inTextArea.onchange = onChange;

			convert(markdowExample2);

			document.getElementById('file-upload').addEventListener('change', readSingleFile, false);

			new JQuery("#btn-save").click(function (e){
				e.preventDefault();
				var text = inArea.val();
				// var filename = $("#input-fileName").val();
				var filename = 'test';
				var blob = new Blob([text], {type: "text/plain;charset=utf-8"});
				untyped saveAs(blob, filename+".md");
			});

		});
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
		inArea.val(contents);
		convert (contents);
	}

	function onChange (e:Event){
		// trace( 'onChange: ' + e );
		var str = new JQuery(e.currentTarget).val();
		convert (str);
	}

	function convert ( str )
	{
		inArea.val(str);
		outArea.val(Markdown.markdownToHtml(str));
		previewArea.innerHTML = (Markdown.markdownToHtml(str));

		outTextArea.scrollTop = outTextArea.scrollHeight;
		outTextArea.select();
	}

	function selectAll():Void {
		outTextArea.select();
	}

	private function onClick (e:Dynamic) : Void
	{
		var id = e.currentTarget.id;
		switch (id) {
			case "example1": convert(markdowExample1);
			case "example2": convert(markdowExample2);
			case "btn_convert": convert(inArea.val());
			case "btn_select": selectAll();
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
