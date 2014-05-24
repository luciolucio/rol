# Rol: control your expenses

Rol automatically registers and categorizes your expenses, based on emails and statements from your bank and credit card. Rol interprets that info and tries to categorize it based on previous categorization, which means it starts noisy but quiets down as you categorize stuff.

It needs no access to your bank account, but will need access to an email account. Email is its only interface, there is no web or desktop UI.

Rol is not very useful if you do not bank online or do not use credit and debit cards much.

## Roadmap

* Read email alert from Chase, parse and output something to standard output - DONE
* Start parsing dates - DONE
* Save parsed data to a text file in JSON format - DONE
* Start giving expenses an ID that can be traced back to the message it came from

## Usage

rol -u user -p password

# License

(The MIT License)

Copyright (c) 2009 BehindLogic

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
