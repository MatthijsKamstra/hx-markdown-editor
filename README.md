# hx markdown editor

I do a lot of writing in [markdown](http://daringfireball.net/projects/markdown/syntax) and I usually use [Macdown](http://macdown.uranusjr.com/) for that.

And I also use my normal (code) editors for it: VSCode and Sublime.

But wouldn't it be awesome to have that all in one?

That's the itch and this is how I scratch that!

## Screenshot

[![](wip02.png)](history.md)


## WIP

Almost everything is `wip` but this one is more.

Contribute if you like, I will update when I feel more itches.

## Improvement

I have looked at the editors that I use (for coding and writing)

- [VScode](https://code.visualstudio.com/)
- [Sublime text](https://www.sublimetext.com/)
- [Macdown](http://macdown.uranusjr.com/)

And want to take the good parts and integrate them:

- [x] editor short cuts
- [x] Fullscreen editing
- [x] Preview mode
- [x] distraction free edit
- [x] toggle preview
- [x] auto update preview
- [ ] subtle markdown styling (preview is full styling)
- [ ] Spell check
- [ ] scroll sync
- [ ] developers keys for text manipulation (like duplicate line, move line up/down)
- [ ] edit more then one file (tabs)
- [ ] export to different files (html/pdf/rich text/etc)
- [ ] snippets
- [ ] folder structure (might be useful with a lot of files in one folder...)
- [ ] Windows support for keymaps (can't test this, but might be useful for others)
- [ ] open last document
- [ ] start screen with links (for no documents open)



## Features

I "stole" these features from other (Markdown) editors, I think some make sense to have as well.
But they are not as important as the previously mentioned features:

(down the list the features are less important)

- [x] Read/Write/Preview mode
- [x] Focus mode
- [x] Live preview
- [x] Shortcuts (ctrl-S, Ctrl-O, etc) read the [shortcut list](/src/assets/shortcut.md)
- [x] Fullscreen (distraction-free) mode
- [x] Preview HTML
- [x] Markdown & code block highlighting
- [ ] GitHub Flavored Markdown
- [ ] Multiple documents
- [ ] Code highlight in preview
- [ ] Code highlight themes (powered by highlight.js)
- [ ] Syntax highlighting
- [ ] Auto reload
- [ ] Search in Markdown
- [ ] Find & replace
- [x] Words count
- [ ] Copy HTML to clipboard
- [ ] Export HTML
- [ ] Export PDF
- [ ] Printing
- [ ] Resizable panels
- [ ] Dialog for image
- [ ] Dialog for videos (mp4)
- [ ] Dialog for tables
- [ ] Allow drag’n’drop files onto app icon (Finder or Dock)
- [ ] Day & Night themes
- [ ] Localization
- [ ] Finder integration (OS X)
- [ ] App will stay alive in tray for quick usage
- [ ] Emoji Support


## Electron features

You can [test and try online](https://matthijskamstra.github.io/hx-markdown-editor/) the markdown editor.
But my personal focus is on Desktop

That needs a lot more love before its a workable app:


**key short cuts**

- [ ] new document
- [ ] save document
- [ ] toggle distraction free mode
- [ ] toggle Preview HTML
- [ ] toggle fullscreen

**electron stuff**

- [x] Status bar
- [ ] icon
- [ ] menu
- [ ] download app (osx, windows, linux)


## Technologies used

I use [Haxe](https://haxe.org/) for this project but essentially it's a JavaScript project.

- Haxe externs for [Codemirror](https://codemirror.net/): <https://github.com/clemos/try-haxe/tree/master/src/js/codemirror>
- Haxe type definitions for [Electron](http://electron.atom.io/) from <https://github.com/fponticelli/hxelectron>


The biggest part of this project is based upon:

- [Electron](http://electron.atom.io/)
- <https://codemirror.net/>

And some smaller libs are:

- default preview css from MacDown (like github.css)
- <http://fontawesome.io/>
- normalize.css
- FileSaver.js

And obviously **markdown** lib (haven't descides yet which one):

- ~~For the conversion of markdown to html I use haxe-markdown:  <https://github.com/dpeek/haxe-markdown>~~
- https://github.com/markdown-it/markdown-it
- https://github.com/chjj/marked


## Haxe

This is a [Haxe](http://www.haxe.org) project, read more about it in the [README_HAXE.MD](README_HAXE.MD)!



<!--

## Demo Application

Spin up the demo application to see electron in action:

```sh
## Make sure you have Electron installed (you only need to do this once)
npm install -g electron

## Clone repository
git clone https://github.com/fponticelli/hxelectron
cd hxelectron/

## Set the haxelib development directory
haxelib dev electron .

## Build and run the demo application
haxe build.hxml
electron bin/
```
-->

## Build

For automatic build

```
npm run watch
```

For electron test

```
npm run electron
```


## Info


**Markdown** is a plain text formatting syntax created by John Gruber, aiming to provide a easy-to-read and feasible markup. You can find the original Markdown syntax specification [here](http://daringfireball.net/projects/markdown/syntax).


**MacDown** is a simple-to-use editor for Markdown documents. It renders your Markdown contents real-time into HTML, and display them in a preview panel. You can download it [here](http://macdown.uranusjr.com/).



