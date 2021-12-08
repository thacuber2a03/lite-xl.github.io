# [Lite XL](https://github.com/lite-xl/lite-xl) website

This website is built using markdown, and a few line ruby script.

## Local Build Quick-start Guide
- Install the required dependencies: `ruby`, and the `redcarpet` and `rouge` gems. 
- If you have ruby, you can install `redcarpet` and `rouge` with `gem install redcarpet rouge`.
- Run `scripts/site.rb`. It should generate static HTML files; of which index.html can be opened directly in your browser. 
To regenerate the keymap documentation, supply a path to `lite-xl`. Otherwise, it will remain static.
