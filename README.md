# Playmaker

<p align="center">
    <img src="https://img.shields.io/badge/macOS-10.12+-brightgreen.svg" />
    <img src="https://img.shields.io/badge/Swift-4.0-blue.svg" />
    <a href="https://twitter.com/twostraws">
        <img src="https://img.shields.io/badge/Contact-@twostraws-lightgrey.svg?style=flat" alt="Twitter: @twostraws" />
    </a>
</p>

This is a simple Swift project to convert a collection of Markdown files to Swift playgrounds that can be used in Xcode.

To try it yourself, create a directory and place your Markdown files inside. You can add all the normal Markdown formatting you want; any code inside will automatically become editable in the final playground.

My motivation for this project is simple: it lets anyone create Swift playgrounds directly from Markdown, with no dependencies other than Swift itself.


## Usage

You can build this project just by running `swift build` from the command line. You can then move the binary from **.build/debug/playmaker** to wherever you want, so you call it as you wish.

Playmaker takes a directory containing Markdown files and converts them into a single playground file. The resulting file will have the same name as the directory.

For example, this will convert all Markdown files in **~/Desktop/example** into a single **example.playground**.

    playmaker ~/Desktop/example

There are some simple rules you should follow

* Each page of your playground should be one Markdown file.
* Playmaker will only read files that have the extension “.md”.
* To ensure your files are ordered as you want, number them like this: “5. Title Of Page.md”, “05. Title Of Page.md”, or even “005. Title Of Page.md”. The number and dot part won’t appear in the final playground, but will ensure your pages are ordered correctly.
* You must include at least one page called “Introduction”, numbered first. So, “1. Introduction.md”, “001. Introduction.md”, etc. Playmaker will automatically add a table of contents to this page.
* You can include any Markdown you want; it will be sent straight to the playground.

I have included an example you can try out – look in the Example directory of this project.


## Tips

On my site I have documented the [Markdown formatting you can add to Swift code](https://www.hackingwithswift.com/example-code/language/how-to-add-markdown-comments-to-your-code), but when making playgrounds there are a couple of extras you should use:

- Xcode likes to strip out unused whitespace, so if you want to force line breaks you should use the `&nbsp;` HTML – Xcode won’t strip that.
- If you want to add callouts, use `- important:`, `- note:`, and `- experiment:` to get special formatting. For example, `- important: Don’t do this` will be highlighted in red.
- The names of your Markdown files will appear in your playground, it’s better to name them “Title of Page” rather than “title-of-page”.


## Contributing

This was put together as part of a blog post on Swift playgrounds, but I’m happy to accept contributions from other developers. If you’ve found ways to clean up the code, add features, or improve the documentation, please open a pull request.


## License

The source code for Playmaker is licensed under the MIT License. Note: the Markdown files in the Example directory are taken from my article [what’s new in Swift 4.2](https://www.hackingwithswift.com/articles/77/whats-new-in-swift-4-2) and are *not* included in the MIT license.

Copyright (c) 2018 Paul Hudson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.