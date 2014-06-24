BookPDF
=======

### Functions
iOS 7 iBooks like PDF Viewer with Thumbnail Bar
* Thumbnail Bar
* Hide/ Show UI

### Code

initWithPDFAtURL:
```
NSString *path = [[NSBundle mainBundle] pathForResource:@"demo1" ofType:@"pdf"];
NSURL *url = [NSURL fileURLWithPath:path];
BookPDF *page = [[BookPDF alloc] initWithPDFAtURL:url];
[self presentViewController:page animated:YES completion:NULL];
```

initWithData:
```
NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"pdf"];
NSData *dat = [NSData dataWithContentsOfFile:path];
BookPDF *page = [[BookPDF alloc] initWithData:dat];
[self presentViewController:page animated:YES completion:NULL];
```



### Demo

![alt text](https://raw.githubusercontent.com/janniklorenz/BookPDF/Alpha/Demo/Example%20Landscape%201.png "Example Landscape 1")
