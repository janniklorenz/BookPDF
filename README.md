BookPDF
=======

### Functions
iOS 7 iBooks like PDF Viewer with Thumbnail Bar
* Thumbnail Bar
* Hide/ Show UI

### Set Up

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

#### Status Bar Hidden
http://stackoverflow.com/questions/18979837/how-to-hide-ios-7-status-bar
"View controller-based status bar appearance" -> "NO"


### Demo

![alt text](https://raw.githubusercontent.com/janniklorenz/BookPDF/Alpha/Demo/Example%20Landscape%201.png "Example Landscape 1")

