There's a lot of confusion surrounding all the client-side frameworks and libraries available to web developers these days, prompting many blog posts full of complaints, which in turn result in posts complaining about the complaints. If you're a [Dart](https://www.dartlang.org/) developer, at the moment there are only two big ones to worry about: The [Angular 2](https://angular.io) application framework and the [Polymer](https://www.polymer-project.org/) web component library.

Now the big question is: Which one do I use? Angular 2 is so fast and elegant, but there aren't many convenient, pre-built components for it yet. Polymer, as a mere web component library, doesn't have dependency injection or an opinionated application model, but it sure does have a lot of [components](https://elements.polymer-project.org) ready to go.

Well, the good news is that you don't have to choose! You can have it all. In this tutorial, you'll build a simple Tic-Tac-Toe game. It will be an Angular 2 application, but you'll have access to the wonderful component collections from Polymer.

> *Note:* This tutorial's [full code](https://github.com/montyr75/tictactoe) is available on GitHub for those who would like to play with it or use it as a reference.

The code was tested with Dart SDK 1.15.0, Polymer Dart 1.0.0-rc.15, and Angular 2.0.0-beta.9.

##The Basics?
This is an intermediate tutorial, so we won't spend a lot of time covering Dart, HTML, or CSS basics, instead focusing on using Angular 2 and Polymer to build apps. For info on how you can set up a working Dart coding environment and a quick word on Polymer Dart, glance through the first few sections of [Polymer Dart Code Lab: Your First Elements](https://dart.academy/polymer-dart-code-lab-your-first-elements/). If you aren't a proficient user of HTML and CSS, you should probably go study up and come back when you are.

##Docs
We all love reading docs, don't we? Well, they can certainly come in handy. Follow these links for in-depth information:

 - [Dart: Up and Running](https://www.dartlang.org/docs/dart-up-and-running/)
 - [Angular 2 for Dart](https://angular.io/docs/dart/latest/index.html)
 - [Polymer Dart](https://github.com/dart-lang/polymer-dart/wiki)

##The Tutorial

![Tic-Tac-Toe Game](http://i.imgur.com/Rw4DpFU.png)

We're using a stupid, crazy-simple game on purpose here, because we don't want you distracted by complex application mechanics while you're trying to concentrate on how to build a great web app using components. So if you think Tic-Tac-Toe is boring, that's really the point. For an extra challenge, turn it into [Ultimate Tic-Tac-Toe](https://dart.academy/web-games-with-dart-ultimate-tic-tac-toe/), or add remote multiplayer capabilities! This version will require two human players on the same device.

###Step 1: Create Your Project
You can use [Stagehand](http://stagehand.pub/) on the command line or your favorite IDE/editor to create your project. Whatever you use, start off by creating an Angular 2 application or, for advanced users, I'll give you what you need to start from scratch.

    stagehand web-angular

To match the tutorial's **pubspec.yaml** and package imports, you should name your project **tic\_tac\_toe**.

###Step 2: Manage Your Dependencies
If you created an Angular 2 project, some of your **pubspec.yaml** file will already be correct, but you'll need to add Polymer to it.

**pubspec.yaml**

    name: tic_tac_toe
    version: 0.0.1
    description: An Angular 2 and Polymer Dart application.
    
    environment:
      sdk: '>=1.13.0 <2.0.0'
    
    dependencies:
      angular2: ^2.0.0-beta.9
      browser: ^0.10.0
      polymer: ^1.0.0-rc.15
      polymer_elements: ^1.0.0-rc.8
      web_components: ^0.12.0
    
    transformers:
    - polymer:
        entry_points: web/index.html
    - angular2:
        platform_directives:
        - 'package:angular2/common.dart#COMMON_DIRECTIVES'
        platform_pipes:
        - 'package:angular2/common.dart#COMMON_PIPES'
        entry_points: web/main.dart
    - $dart2js:
        $include: '**/*.bootstrap.initialize.dart'
        minify: true
        commandLineOptions:
        - --trust-type-annotations
        - --trust-primitives

As you'd expect, Angular 2 and Polymer are both in there, but note the `polymer_elements` dependency. That makes all of the [Polymer element collections](https://elements.polymer-project.org) available to your app. As for the `transformers`, I find things work better when Polymer's precedes Angular's.

Don't forget to use [Pub](https://www.dartlang.org/tools/pub/get-started.html) (or WebStorm's handy links) to download your dependencies after making adjustments to this file.

###Step 3: Index
Component-based Dart web apps don't usually do much in **index.html**. Make yours look like this:

**web/index.html**

    <!DOCTYPE html>
    <html>
      <head>
        <title>Tic-Tac-Toe</title>
    
        <script>
          window.Polymer = window.Polymer || {};
          window.Polymer.dom = 'shadow';
        </script>
    
        <script defer src="main.dart" type="application/dart"></script>
        <script defer src="packages/browser/dart.js"></script>
      </head>
    
      <body class="fullbleed">
        <main-app class="fit layout vertical">Loading...</main-app>
      </body>
    </html>

####Shadow DOM
That first `<script>` tag forces Polymer to use [Shadow DOM](http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom/) by default. When you're mixing things up with Angular 2 components, you don't want to play around with potentially incompatible emulation modes. You'll also be forcing your Angular 2 components to use native Shadow DOM, then everyone will be on the same page and things will work. 

>*Note:* Using native Shadow DOM means your app will work only on the latest and greatest [modern browsers](http://caniuse.com/#search=shadow%20dom).

####Iron Flex Layout
With Polymer's [iron-flex-layout](https://elements.polymer-project.org/elements/iron-flex-layout) convenience classes, it's easy to make your app fill the browser's display area (`<body class="fullbleed">`). Polymer provides classes that are handy wrappers around the CSS [flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) rules. The classes `fit`, `layout`, and `vertical` are also part of iron-flex-layout.

####What's a `<main-app>`?
It's a brand new HTML element that you're going to create using Angular 2! Exciting, right? Even your application itself will be a component. Not sure why components are cool? Read [Why Web Components?](http://webcomponents.org/articles/why-web-components/) for a primer. When your app is loading up, "Loading..." will be displayed until the `<main-app>` element *upgrades* to its full functionality.

>*Note:* If you used Stagehand (or the WebStorm IDE, which uses Stagehand behind the scenes) to create your project, your **index.html** file might have something like `<app-component>` in the `<body>` already, with corresponding code files in your **lib** folder. Angular 2 is young, and these naming conventions are still developing, but I find `<app-component>` to be a long and clunky name, so I prefer the more succinct `<main-app>`. Feel free to go either way, or even make up your own, but if you choose to deviate from my preference, you'll need to make the appropriate adjustments to the tutorial code.

###Sideline: Component Breakdown
When writing an app using components, you need to think about how to best break down your application into encapsulated parts. Some of the components you need will have been built by others, such as `<paper-header-panel>` or `<paper-material>`, and some are components you'll build specifically for your app, like `<board-view>` and `<message-bar>`. As you build up the app, refer to this handy image to help you visualize the hierarchy of the main view:

![Component Breakdown](http://i.imgur.com/tcfnacz.png)

###Step 4: Main
All Dart programs start with the `main()` function, and Angular apps are no exception. If you created your project with Stagehand, you'll already have a **main.dart** file, but if you don't, you'll need to create one in your project's **web** folder. In either case, use this code for that file:

**web/main.dart**

    import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
    import 'package:polymer/polymer.dart';
    import 'package:angular2/angular2.dart';
    import 'package:angular2/bootstrap.dart';
    
    import 'package:tic_tac_toe/views/main_app/main_app.dart';
    
    main() async {
      await initPolymer();
      bootstrap(MainApp);
    }

####Imports
The first `import` statement makes the iron-flex-layout CSS classes available to **index.html**. You'll see this one often. Polymer, Angular, and Angular's bootstrapper are next. Finally, you import your `<main-app>` component's Dart file, which you have yet to create. It will make your custom element, `<main-app>`, available to **index.html**.

####The `main()` Function
You use Dart's [async/await](https://www.dartlang.org/articles/await-async/) syntax to make sure Polymer's initialization completes before bootstrapping Angular. Angular wants to know the name of the Dart class associated with the app's main element (`MainApp`). Remember, you haven't created the `<main-app>` files yet, so the Dart analyzer will probably complain.

###Step 5: More Folders and a Data Model
Any good Dart project uses the canonical Dart package structure. If you created your project with Stagehand, it's all there.

####Step 5.1: Stay Organized
If you don't have one already, create a **lib** folder in your project's root directory. Inside it, you should create two more folders: **model** and **views**.

####Step 5.2: A Data Model for Tic-Tac-Toe
We won't go into any detail on how this class works (remember, concentrate on Angular and Polymer), except to point out that it's a good practice to keep your model data separate from your views. The less they know about each other, the better. This Dart class, which models a Tic-Tac-Toe board, would work just as well in a web application or a console application.

**lib/model/ttt_board.dart**

    class TTTBoard {
      static const List<List<int>> WIN_PATTERNS = const [
        const [0, 1, 2], // row 1
        const [3, 4, 5], // row 2
        const [6, 7, 8], // row 3
        const [0, 3, 6], // col 1
        const [1, 4, 7], // col 2
        const [2, 5, 8], // col 3
        const [0, 4, 8], // diag 1
        const [2, 4, 6]  // diag 2
      ];
    
      List<String> board;
      int moveCount = 0;
    
      TTTBoard() {
        board = new List<String>.filled(9, null);
      }
    
      String getWinner() {
        for (List<int> winPattern in WIN_PATTERNS) {
          String square1 = board[winPattern[0]];
          String square2 = board[winPattern[1]];
          String square3 = board[winPattern[2]];
    
          // if all three squares match and aren't empty, there's a win
          if (square1 != null &&
              square1 == square2 &&
              square2 == square3) {
            return square1;
          }
        }
    
        // if we get here, there is no win
        return null;
      }
    
      String move(int square, String player) {
        board[square] = player;
        moveCount++;
        return getWinner();
      }
    
      bool get isFull => moveCount >= 9;
      bool get isNotFull => !isFull;
      bool isSquareEmpty(int index) => board[index] == null;
    
      @override String toString() {
        String prettify(int square) => board[square] ?? " ";
    
        return """
    ${prettify(0)} | ${prettify(1)} | ${prettify(2)}
    ${prettify(3)} | ${prettify(4)} | ${prettify(5)}
    ${prettify(6)} | ${prettify(7)} | ${prettify(8)}
        """;
      }
    }

Your app can use an instance of TTTBoard to track a game of Tic-Tac-Toe. Neat! Note that since the class overrides the `toString()` method, it's possible to print the virtual board to the console at any time.

###Step 6: Main App
To create the `<main-app>` component with Dart, you need an HTML file and a Dart file. The `<main-app>` element is a view component, so add a **main_app** folder inside **lib/views**.

####Step 6.1: HTML
Angular 2 component views are built with HTML, but they're not full HTML files. Because they lack most of the core nodes like `<html>`, `<head>`, and `<body>`, they're often referred to as *partials*.

Create a new HTML file in **lib/views/main\_app** called **main_app.html**:

**lib/views/main\_app/main\_app.html**

    <style>
      .content {
        padding: 15px;
      }
    
      .app-title {
        text-align: center;
      }
    
      message-bar {
        margin-bottom: 10px;
      }
    </style>
    
    <paper-header-panel class="flex">
      <paper-toolbar>
        <div class="flex-auto">
          <div style="width: 40px; height: 40px;"></div>
        </div>
        <h2 class="app-title flex-auto">Tic-Tac-Toe</h2>
        <div class="flex-auto" style="text-align: right;">
          <paper-icon-button icon="refresh" (click)="newGame()">
          </paper-icon-button>
        </div>
      </paper-toolbar>
    
      <div class="layout vertical center content">
      </div>
    </paper-header-panel>

There's a lot going on in there, so let's take it a piece at a time.

#####Styles
You can include a `<style>` tag in your component's view, and thanks to the magic of Shadow DOM, your styles will be encapsulated and applied only to the HTML in this file.

#####Paper Elements
The "body" of your `<main-app>` element is one of Polymer's most useful components, the [paper-header-panel](https://elements.polymer-project.org/elements/paper-header-panel). This element expects a header section and a content section as children, which you provide in the form of a [paper-toolbar](https://elements.polymer-project.org/elements/paper-toolbar) and a plain old `<div>`. And that's all you need to create a nice, [Material Design](https://www.google.com/design/spec/material-design) app shell.

Inside the `<paper-toolbar>`, you put the app's title and a *New Game* button. Note that the first `<div>` in there has no visible content, and it's only there to make the layout work.

Let's take a closer look at the [paper-icon-button](https://elements.polymer-project.org/elements/paper-icon-button).

    <paper-icon-button icon="refresh" (click)="newGame()"></paper-icon-button>

It displays the `refresh` icon from Polymer's [iron-icons](https://elements.polymer-project.org/elements/iron-icons) collection, which you'll import later in **main_app.dart**, along with all your other custom element imports. The button is also sporting Angular 2's event listener syntax. When the button is clicked, it will call `newGame()`, a method you'll define in your main app's Dart class.

#####Content
The content `<div>` will contain the Tic-Tac-Toe board and the message bar, two new components you'll create shortly. It uses more iron-flex-layout tricks to set up a vertically oriented, centered layout.

####Step 6.2: Dart
Every custom component in Angular 2 has an associated Dart class, and that's what you'll build in **main_app.dart**.

**lib/views/main\_app/main\_app.dart**

    import 'package:angular2/angular2.dart';
    import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
    import 'package:polymer_elements/iron_icons.dart';
    import 'package:polymer_elements/paper_header_panel.dart';
    import 'package:polymer_elements/paper_toolbar.dart';
    import 'package:polymer_elements/paper_icon_button.dart';
    
    import '../../model/ttt_board.dart';
    
    @Component(selector: 'main-app',
        encapsulation: ViewEncapsulation.Native,
        templateUrl: 'main_app.html'
    )
    class MainApp {
      TTTBoard board;
      String currentPlayer;
      bool interfaceEnabled;
      int boardSize = 450;
      String message;
    
      MainApp() {
        newGame();
      }
    
      void newGame() {
        board = new TTTBoard();
        currentPlayer = null;
        interfaceEnabled = true;
    
        nextTurn();
      }
    
      void nextTurn() {
        currentPlayer = currentPlayer == "X" ? "O" : "X";
        message = "Player: $currentPlayer";
      }
    
      void onWin(String winner) {
        interfaceEnabled = false;
        message = "$currentPlayer wins!";
      }
    
      void onTie() {
        interfaceEnabled = false;
        message = "It's a tie!";
      }
    }

This class is a great example of the power Angular 2 gives you to separate concerns. Even though MainApp contains all the imperative code for the main view of the game, there is no DOM-manipulation code, no manual setup of event listeners, no activation of plugins. Each method modifies properties of the view-model, and Angular's data binding process handles all view updates for you. Nice and clean, and this code could theoretically be used as-is with an entirely different kind of view, one that's not based on HTML at all.

#####Imports
At the top of the file, you import Angular and the various Polymer elements you used in the view. Lastly, you import the definition of the TTTBoard class for use as the game's model.

>*Note:* If you forget to import a Polymer element, using it in the view will have no effect. It just won't show up. No errors will be displayed. This is the first thing to check when elements seem to be missing from your running application.

#####Component
The `@Component` annotation tells Angular that the MainApp class should be associated with the `<main-app>` element. That's what the `selector` parameter is for.

You use the `encapsulation` parameter to specify that true, native Shadow DOM should be used for your component, overriding the default of emulation. If you're an overachiever who actually likes to understand how things work, check out [View Encapsulation in Angular 2](http://blog.thoughtram.io/angular/2015/06/29/shadow-dom-strategies-in-angular2.html).

The `templateUrl` parameter is used to point to the component's view file, typically an HTML partial. It's also possible to create an inline template as a string here using the `template` parameter instead.

#####Properties
The handful of member variables declared at the top of the class comprise the view-model. 

 - `board`: Typed as a TTTBoard, this property holds an instance of the game model data.
 - `currentPlayer`: Typically "X" or "O".
 - `interfaceEnabled`: When the game is over, no more moves should be allowed.
 - `boardSize`: The width/height of the Tic-Tac-Toe board in pixels.
 - `message`: Any message that should be displayed to the user.

#####Constructor
The Angular framework will create a new instance of the MainApp class when it encounters `<main-app>` in the HTML. At that time, `MainApp()` will be executed, which will initialize the game variables with `newGame()`. Also, you may remember that the view contains a `<paper-icon-button>` that calls `newGame()` when clicked.

#####Game Methods
The `newGame()` and `nextTurn()` methods are very simple functions that track turns and keep the game running.

#####Event Handlers
Two methods are here to respond to events from the Tic-Tac-Toe board: `onWin()` and `onTie()`. The `nextTurn()` method is called directly in the class code, but it will also occasionally be called in response to `move` events from the board.

####Step 6.3: Run It
With a working `<main-app>` element defined, you've got enough to run the code and see some results. At the moment, it doesn't do much, but you should be able to see the `<paper-toolbar>` and such.

###Step 7: The Board Component
The `<board-view>` element will be another view component, of course, so go ahead and create a folder to house its files: **lib/views/board_view**.

####Step 7.1: HTML
Like so many Angular 2 web components, this one needs a bit of HTML to define its look and layout.

**lib/views/board\_view/board\_view.html**

    <style>
      .square {
        outline: 1px solid black;
        cursor: default;
        box-sizing: border-box;
        -webkit-touch-callout: none;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
      }
    
      .highlight {
        background-color: lightblue;
      }
    </style>
    
    <paper-material elevation="1" class="layout horizontal wrap"
                    [style.width.px]="boardSize">
      <div *ngFor="#square of model.board, #i=index"
           class="square layout vertical center center-justified"
           [class.highlight]="interfaceEnabled && model.isSquareEmpty(i)"
           (click)="squareSelected(i)"
           [ngStyle]="squareStyles">
        {{square}}
      </div>
    </paper-material>

#####A Little Bit of Polymer
The Tic-Tac-Toe board's template will be based on a [paper-material](https://elements.polymer-project.org/elements/paper-material) element just to give it a lovely Material Design frame. You set its [elevation](https://www.google.com/design/spec/what-is-material/elevation-shadows.html) to 1 to give it a nice shadow. To lay out the squares within the board, you use more iron-flex-layout CSS classes.

#####And a Whole Lot of Angular!
Now we've got a bunch of crazy Angular syntax to talk about.

    [style.width.px]="boardSize"

This is some of my favorite kind of stuff provided by the new framework. With this syntax, Angular will take the value of a property called `boardSize`, which needs to be present on the component's Dart class, and create a `width` style rule for the `<paper-material>` tag. So if `boardSize` is, say, `450`, the element will gain a rule like this: `style="width: 450px"`. The size of the board is now configurable by the host program.

    <div *ngFor="#square of model.board, #i=index" ...

Each square of the Tic-Tac-Toe board will be a `<div>`, and you need nine of them. Angular makes it easy to create lots of something with its `NgFor` directive. For each `#square` in the `model.board` List, a copy of this `<div>` will be stamped into the DOM. `model` will be an instance of the TTTBoard class, so its `board` property will be a `List<String>` representing the current state of the game board. With `#i=index`, you're telling Angular that you want the array (List) index available in the square template as a variable called `i`.

From the Angular 2 [template syntax docs](https://angular.io/docs/dart/latest/guide/template-syntax.html):
>The `*` is a bit of syntactic sugar that makes it easier to read and write directives that modify HTML layout with the help of templates. `NgFor`, `NgIf`, and `NgSwitch` all add and remove element subtrees that are wrapped in `<template>` tags.

    [class.highlight]="interfaceEnabled && model.isSquareEmpty(i)"

This part tells the framework to apply the `highlight` CSS class, defined in the view template's `<style>` section, to a square's `<div>` if the `interfaceEnabled` property is `true` and the square is currently empty. Using the `i` variable made available by `NgFor`, you pass the square's List index to TTTBoard's `isSquareEmpty()` method to determine its state. Basically, the game will highlight available squares in light blue for the user.

    (click)="squareSelected(i)"

You've seen event-handler syntax like this before, but to review, when a square's `<div>` is clicked, a `click` event is thrown, and this code tells Angular to run a method called `squareSelected()` on the component's Dart class when that happens. Once again, `i` is passed as an argument to help `squareSelected()` do its job. If the square at index 2 is clicked (the upper-right square on the board), that call will be translated to `squareSelected(2)`.

    [ngStyle]="squareStyles"

When you want to set more than a single style on an element through data binding, it's better to use the `NgStyle` directive rather than the `[style.]` syntax. `squareStyles` is a getter on the BoardView class that returns a Map of rules to apply.

    {{square}}

Like Angular 1.x and other data-binding frameworks (like Polymer), Angular 2 uses the double-mustache syntax (`{{ }}`) to bind values into the DOM. The `NgFor` directive, at your behest, created a scope variable called `square`, representing one element of the `model.board` List. It will always contain a value of "X", "O", or `null`. If it's `null`, nothing will be inserted here.

And the best part? All of these binding expressions will be continually updated in the DOM as property values are changed. If TTTBoard's `move()` method is called to add an "X" or "O" to the virtual game board, that change in the model will be auto-magically reflected in the view.

####Step 7.2: Dart
And now to see the definitions of all these properties you've been binding into the board's view template.

**lib/views/board\_view/board\_view.dart**

    import 'package:angular2/angular2.dart';
    import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
    import 'package:polymer_elements/paper_material.dart';
    
    import '../../model/ttt_board.dart';
    
    @Component(selector: 'board-view',
        encapsulation: ViewEncapsulation.Native,
        templateUrl: 'board_view.html'
    )
    class BoardView {
      @Input() TTTBoard model;
      @Input() String currentPlayer;
      @Input() bool interfaceEnabled;
    
      @Output() EventEmitter win = new EventEmitter<String>();
      @Output() EventEmitter tie = new EventEmitter();
      @Output() EventEmitter move = new EventEmitter();
    
      int boardSize;
      int squareSize;
    
      BoardView();
    
      void squareSelected(int squareIndex) {
        if (interfaceEnabled && model.isSquareEmpty(squareIndex)) {
          String winner = model.move(squareIndex, currentPlayer);
    
          if (winner != null) {
            win.emit(winner);
          }
          else if (model.isFull) {
            tie.emit(null);
          }
          else {
            move.emit(null);
          }
        }
      }
    
      @Input() void set size(int val) {
        boardSize = val;
        squareSize = boardSize ~/ 3;
      }
    
      Map get squareStyles => {
        "width": "${squareSize}px",
        "height": "${squareSize}px",
        "font-size": "${(squareSize * 0.8).round()}px"
      };
    }

Some of this code will be familiar from the MainApp class, so we'll highlight only the new stuff here.

#####Imports
You need to again import iron-flex-layout's classes to use them in the view template. Also, paper-material, since you made use of that one, and the definition of the model class, TTTBoard.

#####Inputs
When your component has properties that you want the outside world to be able to configure, you annotate them with `@Input()`. BoardView could receive a value for `currentPlayer` like this:

    <board-view currentPlayer="X"></board-view>

Or through a binding expression like this:

    <board-view [currentPlayer]="currentPlayer"></board-view>

That version would update `<board-view>`'s `currentPlayer` property to stay in sync with its parent's `currentPlayer` property. Useful!

#####Outputs
If your component needs to send information *out*, the best way is using events. For each event type you need to support, you create an EventEmitter instance and annotate the reference with `@Output()`. You can use Dart's support for generics to include a type for the event's payload, if any:

    @Output() EventEmitter win = new EventEmitter<String>();

The `win` event, when emitted, will expect a String as accompanying data; in this case, an "X" or "O", indicating which player has won. Your component's parent can easily listen for and react to these custom events.

#####Making Moves
The `squareSelected()` method is called whenever a square on the board is clicked, and if appropriate, it handles making a move in the model and checking for a winner or a tie condition. Events are emitted as needed, passing `null` to `emit()` when no data is associated with a given event.

#####Size Matters
A setter can also act as an input. You need to make a few calculations in response to the board changing size, and using a setter for this is a nice, elegant way to do it. When the board view's parent passes a `size`, both `boardSize` and `squareSize` get set, and these are bound to the board's DOM template. Yet again, you accomplish altering what the user sees on screen without any messy, unsightly jQuery or dart:html calls mucking around with the DOM.

#####Do It With Style
The `squareStyles` getter returns a Map of CSS rules for squares on the board, dynamically calculated. Cool, yes? The `NgStyle` Angular directive is a great way to set a bunch of rules at once.

####Step 7.3: Using the Board
Now to put a Tic-Tac-Toe board on the screen.

#####Import It
First, add a new import to your MainApp class:

**lib/views/main\_app/main\_app.dart**

    import '../board_view/board_view.dart';

#####Tell Angular About It
To use an Angular directive or component within another, the parent needs to be informed. Add a `directives` parameter to MainApp's `@Component` annotation:

**lib/views/main\_app/main\_app.dart**

    @Component(selector: 'main-app',
        encapsulation: ViewEncapsulation.Native,
        templateUrl: 'main_app.html',
        directives: const [BoardView]
    )

#####Use Your Custom Component
Now that `<main-app>` knows what a `<board-view>` is, and it's been told to expect it, add one to the HTML template, inside the content `<div>` of the `<paper-header-panel>`:

**lib/views/main\_app/main\_app.html**

    <div class="layout vertical center content">
      <board-view [size]="boardSize"
                  [model]="board"
                  [currentPlayer]="currentPlayer"
                  [interfaceEnabled]="interfaceEnabled"
                  (win)="onWin($event)" (tie)="onTie()" (move)="nextTurn()">
      </board-view>
    </div>

Whoa! That's one hell of an element.

#####Properties
The `size`, `model`, `currentPlayer`, and `interfaceEnabled` properties of BoardView are set to the values of the corresponding properties on MainApp using one-way bindings. Not only will those values be passed when MainApp's properties are initialized, but any changes to the values in MainApp will be automatically propagated into BoardView.

#####Events
Methods on MainApp will be called in response to custom event emissions from BoardView. The `move` and `tie` events are simple, no-argument function calls, but there is something weird about `win`. The `onWin()` event handler is passed a special Angular argument called `$event`, which contains any data that was attached to the event when it was emitted. In this case, `$event` will be a String with a value of "X" or "O".

####Step 7.4: Run It Again
At this point, you should have a working Tic-Tac-Toe game happening. Available squares will be highlighted so a player knows where he can move, and the highlight will be removed when the square becomes occupied. There is one more thing that would make the game a bit friendlier to the users...

###Step 8: The Message Bar

You'll add one more very simple component to keep the players apprised of what's going on. Create a **message_bar** folder in **lib/views** to hold the component's files.

####Step 8.1: HTML

**lib/views/message\_bar/message\_bar.html**

    <style>
      .box {
        cursor: default;
        padding: 5px;
        outline: 1px solid black;
        box-sizing: border-box;
      }
    </style>
    
    <paper-material elevation="1" class="box layout vertical center"
                    [style.width.px]="width">
      {{message}}
    </paper-material>

Move along...nothing to see here. You should be familiar now with everything going on in this view's template. It has a configurable width so that it will match the size of the Tic-Tac-Toe board, and it binds in the value of a property called `message`.

####Step 8.2: Dart

**lib/views/message\_bar/message\_bar.dart**

    import 'package:angular2/angular2.dart';
    import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
    import 'package:polymer_elements/paper_material.dart';
    
    @Component(selector: 'message-bar',
        encapsulation: ViewEncapsulation.Native,
        templateUrl: 'message_bar.html'
    )
    class MessageBar {
      @Input() String message;
      @Input() String width;
    
      MessageBar();
    }

Flex layout, paper-material, Shadow DOM, a few input properties... It all checks out. Let's use this thing.

####Step 8.3: Using the Message Bar
Now that it's built, let's use it.

#####Import It
First, you import it:

**lib/views/main\_app/main\_app.dart**

    import '../message_bar/message_bar.dart';

#####Tell Angular About It
Remember, to use your new component, you must first add MessageBar to MainApp's `@Component` annotation:

**lib/views/main\_app/main\_app.dart**

    @Component(selector: 'main-app',
        encapsulation: ViewEncapsulation.Native,
        templateUrl: 'main_app.html',
        directives: const [BoardView, MessageBar]
    )

#####Use Your Custom Component
Then, you insert it, right above the `<board-view>`:

**lib/views/main\_app/main\_app.html**

    <div class="layout vertical center content">
      <message-bar [width]="boardSize" [message]="message"></message-bar>
  
      <board-view [size]="boardSize"
                  [model]="board"
                  [currentPlayer]="currentPlayer"
                  [interfaceEnabled]="interfaceEnabled"
                  (win)="onWin($event)" (tie)="onTie()" (move)="nextTurn()">
      </board-view>
    </div>

So the `<message-bar>` and the `<board-view>` both use MainApp's `boardSize` property to present a unified front. Any message that should be displayed to the players will come from MainApp's `message` property. Within MainApp, doing this is all it'll take to get words on the screen:

    message = "You are ugly.";

Great!

####Step 8.4: Run It
With that, you're all done. Another fabulous addition to your GitHub portfolio. And the world is a better place with one more Tic-Tac-Toe implementation out there.

##Conclusion
With Dart, Angular 2, and Polymer, you really can have it all!

Angular's data binding is considerably easier to work with than Polymer's version, so it's awesome to structure your app and data models using Angular. Model classes in Angular are PODOs (plain old Dart objects), which means they can be shared between the client and the server if you've got Dart code running server side. Polymer models have to be reflectable to JavaScript, which means they're only suitable for running where there is a JavaScript VM.

But Polymer has so many useful components ready to use right now, including a full set of Material Design components, and you don't want to miss out on those. Polymer is also the best way to create web components that can be consumed by anyone, used in anything from a simple web site to a full Angular app, whereas Angular components won't function outside the framework.

Luckily, you don't have to choose between these two great tools.