//
//  SMStyle.h
//  SMTestRoposo
//
//  Created by Shubham Mandal on 18/09/16.
//  Copyright © 2016 Shubham Mandal. All rights reserved.
//

#ifndef SMStyle_h
#define SMStyle_h

#define kLightFontName @"HelveticaNeue-Light"
#define kRegularFontName @"HelveticaNeue"
#define kMediumFontName @"HelveticaNeue-Medium"
#define kBoldFontName @"HelveticaNeue-Bold"

#define RGB(x, y, z) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:1.0]
#define RGBA(x, y, z, a) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:a]
#define GRAY(x) [UIColor colorWithWhite:x alpha:1.0]
#define GRAY_255(x) [UIColor colorWithWhite:x/255.0f alpha:1.0]
#define GRAYA(x, a) [UIColor colorWithWhite:x alpha:a]

#define LIGHT(x) [UIFont fontWithName:kLightFontName size:x]
#define REGULAR(x) [UIFont fontWithName:kRegularFontName size:x]
#define MEDIUM(x) [UIFont fontWithName:kMediumFontName size:x]



#define kSidePadding     20.0
#define kTopPadding       8.0
#define kUserImageHeight 50.0
#define kInterItemSpace  16.0

#define kImageRatio 1.33
#define kImageBorderWidth 1.0
#define kImageWidth        [UIScreen mainScreen].bounds.size.width
#define kImageDummyHeight   kImageWidth * kImageRatio


#endif /* SMStyle_h */
