//Crawl PDF filenames from an html page.
//Run following code on dev console of browser
var pdflinks =[]; Array.prototype.map. call(document.querySelectorAll("a[href$=\".pdf\"]"), function(e, i){if((pdflinks||[]).indexOf(e.href)==-1){ pdflinks.push( e.href);} }); console.log(pdflinks.join(" "));

//http://superuser.com/questions/260087/download-all-pdf-links-in-a-web-page

