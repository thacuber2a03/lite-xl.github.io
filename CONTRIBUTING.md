# Welcome to Lite XL website contributing guide

We're grateful for your contribution. Your contribution will be reflected
on https://lite-xl.com.

This guide goes over several important notes you need to take account when
contributing to the website.

## Issues

#### Creating an issue

You should search the issue tracker for a similar issue before creating one.
When creating an issue, ensure that it has an appropriate title, description
and an example to recreate the issue.

#### Solving an issue

We do not assign issues to anyone.
You're welcome to submit PRs for an existing issue.

## Contributing code changes

We accept PRs for website content. If you want to contribute, make sure
that you've read the [site rules].

## Localization

We don't have full support for translations due to a lack of contributors.
Localized files belong to the directory `locales/(language)`.

## Site Rules

You must follow these rules when contributing to the website.
Do note that this is not a complete list; we may advise on further
improvements as we review your PRs.

#### Don't

Submit content that is badly-written or irrelevant to Lite XL.

#### Do

Submit content that is well-written and relevant to Lite XL.

Proofread your work before submitting.

#### Don't

Omit the title/heading when creating a new page content.

```md
This will generate the title "Lite XL" which conflicts with the home page.
```

#### Do

Create a simple title/heading that is relevant to the page content.

```md
# A title

This will generate the title "Lite XL - A title" which is better.
```

#### Don't

Use irregular indentation on the website code.

```js
function updatePage() {
   if (this.length === 0)
      this.push(1);
   this.forEach(function(e) { return e + 1; });
}
```

#### Do

Follow the EditorConfig (2 space as indentation).

```js
function updatePage() {
  if (this.length === 0)
    this.push(1);
  this.forEach(function(e) { return e + 1; });
}
```

#### Don't

Write incredibly long lines that cannot be broken down.

> This does not apply to links as they cannot be broken down.

```md
I love Lite XL because the editor provides many features out of the box such as syntax highlighting, filesystem tree and lua scripting which I use extensively to customize the editor to such an extent where it is so much better than the original jeez >//< i love lite-xl so muchhhhh!!!!
```

#### Do

Ensure that each line does not exceed the 80-character limit.

For long list items, break them down into multiple lines and indent
the following lines with 2 spaces.

```md
I love Lite XL because the editor provides many features:

- syntax highlighting
- filesystem tree
- lua scripting
- a killer feature that we probably don't have yet but we'll
  have in the future

I use the lua scripting feature extensively to customize the editor so
that it is better than the original jeez >//< i love lite-xl so
muchhhhh!!!!
```

#### Don't

Omit newlines between markdown elements.

````md
# Installation
You can install Lite XL by running:
```sh
# sudo apt install lite-xl
```
or the following ways:
- download a release
- install it via lpm
````

#### Do

Introduce a newline between Markdown elements.
This helps with certain picky Markdown parsers.

````md
# Installation

You can install Lite XL by running:

```sh
# sudo apt install lite-xl
```

or the following ways:

- download a release
- install it via lpm
````

#### Don't

Use `<` and `>` without surrounding them in backticks.

```md
Watch me! <script>alert("hey");</script>
```

#### Do

Use `‹` and `›` or surround `<` and `>` in backticks.

```md
Watch me! `<script>alert("hey");</script>`
```

#### Don't

Link to insecure websites.

```
[1]: http://example.com
```

#### Do

Link to secure websites.

```
[1]: https://example.com
```

#### Don't

Use inline links.

> This rule does not apply to autolinks or anchor links.

```md
Follow [this link](https://someurl.com) and also [this interesting one](https://interesting-one.com).

[We allow this](#this-will-be-allowed)

# this will be allowed

We allow this form of inline linking because it is short and useful.
```

#### Do

Use reference-style links.

```md
Follow [this link] and also [this interesting one].

<!-- at the bottom of the page after 2 blank lines, vertically aligned: -->
[this link]:            https://someurl.com
[this interesting one]: https://interesting-one.com
```

Or

```md
Follow [this link][1] and also [this interesting one][2].

<!-- at the bottom of the page after 2 blank lines, vertically aligned: -->
[1]: https://someurl.com
[2]: https://interesting-one.com
```

#### Don't

Create messy Markdown tables (unless machine generated).

```md
| name | Description
|---:|---|
| John | Doe
| Jeanne | Doe
```

#### Do

- Align the pipe character (`|`) to the left.
- Ensure dashes (excluding the alignment colon character(`:`)) aligns with
  the table header.

```md
| name   | Description
| ----:  | -----------
| John   | Doe
| Jeanne | Doe
```


[site rules]: #site-rules
