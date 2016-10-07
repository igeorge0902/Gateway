// Generated by Apple Swift version 2.3 (swiftlang-800.10.12 clang-800.0.38)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import Realm;
@import CoreData;
@import Foundation;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;
@class NSObject;
@class NSURL;
@class NSManagedObjectModel;
@class NSPersistentStoreCoordinator;
@class NSManagedObjectContext;

SWIFT_CLASS("_TtC16SwiftLoginScreen11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * _Nullable window;
- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary * _Nullable)launchOptions;
- (void)applicationWillResignActive:(UIApplication * _Nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * _Nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * _Nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;
- (void)applicationWillTerminate:(UIApplication * _Nonnull)application;
@property (nonatomic, strong) NSURL * _Nonnull applicationDocumentsDirectory;
@property (nonatomic, strong) NSManagedObjectModel * _Nonnull managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator * _Nonnull persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext * _Nonnull managedObjectContext;
- (void)saveContext;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSData;
@class NSString;
@class NSDate;

SWIFT_CLASS("_TtC16SwiftLoginScreen14CachedResponse")
@interface CachedResponse : RLMObject
@property (nonatomic, strong) NSData * _Null_unspecified data;
@property (nonatomic, copy) NSString * _Null_unspecified encoding;
@property (nonatomic, strong) NSString * _Null_unspecified mimeType;
@property (nonatomic, copy) NSString * _Null_unspecified url;
@property (nonatomic, strong) NSDate * _Null_unspecified timestamp;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSEntityDescription;

SWIFT_CLASS("_TtC16SwiftLoginScreen17CachedURLResponse")
@interface CachedURLResponse : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end

@class NSNumber;

@interface CachedURLResponse (SWIFT_EXTENSION(SwiftLoginScreen))
@property (nonatomic, strong) NSData * _Nullable data;
@property (nonatomic, copy) NSString * _Nullable encoding;
@property (nonatomic, copy) NSString * _Nullable mimeType;
@property (nonatomic, strong) NSNumber * _Nullable statusCode;
@property (nonatomic, strong) NSDate * _Nullable timestamp;
@property (nonatomic, copy) NSString * _Nullable url;
@end

@class NSURLRequest;
@class NSURLSession;
@class NSURLSessionDataTask;
@class NSURLResponse;
@class NSURLSessionTask;
@class NSError;
@class NSCachedURLResponse;
@protocol NSURLProtocolClient;

SWIFT_CLASS("_TtC16SwiftLoginScreen17CustomURLProtocol")
@interface CustomURLProtocol : NSURLProtocol <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>
+ (NSString * _Nonnull)CustomKey;
+ (BOOL)canInitWithRequest:(NSURLRequest * _Nonnull)request;
+ (NSURLRequest * _Nonnull)canonicalRequestForRequest:(NSURLRequest * _Nonnull)request;
- (void)startLoading;
- (void)stopLoading;
- (void)URLSession:(NSURLSession * _Nonnull)session dataTask:(NSURLSessionDataTask * _Nonnull)dataTask didReceiveResponse:(NSURLResponse * _Nonnull)response completionHandler:(void (^ _Nonnull)(NSURLSessionResponseDisposition))completionHandler;
- (void)URLSession:(NSURLSession * _Nonnull)session dataTask:(NSURLSessionDataTask * _Nonnull)dataTask didReceiveData:(NSData * _Nonnull)data;
- (void)URLSession:(NSURLSession * _Nonnull)session task:(NSURLSessionTask * _Nonnull)task didCompleteWithError:(NSError * _Nullable)error;
- (nonnull instancetype)initWithRequest:(NSURLRequest * _Nonnull)request cachedResponse:(NSCachedURLResponse * _Nullable)cachedResponse client:(id <NSURLProtocolClient> _Nullable)client OBJC_DESIGNATED_INITIALIZER;
@end

@class NSURLAuthenticationChallenge;
@class NSURLCredential;
@class NSHTTPURLResponse;

SWIFT_CLASS("_TtC16SwiftLoginScreen24CustomURLSessionDelegate")
@interface CustomURLSessionDelegate : NSURLSessionDownloadTask <NSURLSessionDelegate>
- (void)URLSession:(NSURLSession * _Nonnull)session downloadTask:(NSURLSessionDownloadTask * _Nonnull)downloadTask didFinishDownloadingToURL:(NSURL * _Nonnull)location;
- (void)URLSession:(NSURLSession * _Nonnull)session didReceiveChallenge:(NSURLAuthenticationChallenge * _Nonnull)challenge completionHandler:(void (^ _Nonnull)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler;
- (void)URLSession:(NSURLSession * _Nonnull)session task:(NSURLSessionTask * _Nonnull)task willPerformHTTPRedirection:(NSHTTPURLResponse * _Nonnull)response newRequest:(NSURLRequest * _Nonnull)request completionHandler:(void (^ _Nonnull)(NSURLRequest * _Nullable))completionHandler;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSUserDefaults;

SWIFT_CLASS("_TtC16SwiftLoginScreen21GeneralRequestManager")
@interface GeneralRequestManager : NSObject
@property (nonatomic, strong) NSURL * _Null_unspecified url;
@property (nonatomic, copy) NSString * _Null_unspecified errors;
@property (nonatomic, copy) NSString * _Null_unspecified method;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * _Nullable queryParameters;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * _Nullable bodyParameters;
@property (nonatomic, copy) NSString * _Nullable isCacheable;
@property (nonatomic, strong) NSUserDefaults * _Nonnull prefs;
- (nullable instancetype)initWithUrl:(NSString * _Nonnull)url errors:(NSString * _Nonnull)errors method:(NSString * _Nonnull)method queryParameters:(NSDictionary<NSString *, NSString *> * _Nullable)queryParameters bodyParameters:(NSDictionary<NSString *, NSString *> * _Nullable)bodyParameters isCacheable:(NSString * _Nullable)isCacheable OBJC_DESIGNATED_INITIALIZER;
@property (nonatomic, strong) NSURLSession * _Nonnull session;
@property (nonatomic) BOOL running;
@end

@class UIImageView;
@class UILabel;
@class UICollectionView;
@class UIButton;
@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC16SwiftLoginScreen6HomeVC")
@interface HomeVC : UIViewController
@property (nonatomic, strong) UIImageView * _Nonnull imageView;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * _Nonnull backgroundDict;
@property (nonatomic, strong) NSURLSession * _Nonnull session;
@property (nonatomic) BOOL running;
@property (nonatomic, strong) IBOutlet UILabel * _Null_unspecified usernameLabel;
@property (nonatomic, strong) IBOutlet UILabel * _Null_unspecified sessionIDLabel;
@property (nonatomic, strong) UICollectionView * _Null_unspecified collectionView;
@property (nonatomic, readonly, strong) NSManagedObjectContext * _Nonnull managedObjectContext;
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
@property (nonatomic, readonly, strong) NSURL * _Nonnull url;
- (IBAction)logoutTapped:(UIButton * _Nonnull)sender;
- (IBAction)NearbyVenues:(UIButton * _Nonnull)sender;
- (IBAction)Navigation:(UIButton * _Nonnull)sender;
- (IBAction)WebView:(UIButton * _Nonnull)sender;
- (IBAction)Movies:(UIButton * _Nonnull)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC16SwiftLoginScreen7LogItem")
@interface LogItem : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface LogItem (SWIFT_EXTENSION(SwiftLoginScreen))
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable itemText;
@end

@class UITextField;

SWIFT_CLASS("_TtC16SwiftLoginScreen7LoginVC")
@interface LoginVC : UIViewController <UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIImageView * _Nonnull imageView;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * _Nonnull backgroundDict;
@property (nonatomic, strong) NSURLSession * _Nonnull session;
@property (nonatomic) BOOL running;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified txtUsername;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified txtPassword;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
@property (nonatomic, readonly, strong) NSURL * _Nonnull url;
- (IBAction)signinTapped:(UIButton * _Nonnull)sender;
- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIRefreshControl;
@class UITableView;
@class NSMutableArray;
@class NSIndexPath;
@class UITableViewCell;

SWIFT_CLASS("_TtC16SwiftLoginScreen6MenuVC")
@interface MenuVC : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIRefreshControl * _Null_unspecified refreshControl;
@property (nonatomic, strong) UITableView * _Nullable tableView;
@property (nonatomic, strong) NSMutableArray * _Nonnull items;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)navigateBack;
- (void)addData;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSURLConnection;
@class NSMutableData;
@class NSMutableURLRequest;

SWIFT_CLASS("_TtC16SwiftLoginScreen13MyURLProtocol")
@interface MyURLProtocol : NSURLProtocol
@property (nonatomic, strong) NSURLConnection * _Null_unspecified connection;
@property (nonatomic, strong) NSMutableData * _Null_unspecified mutableData;
@property (nonatomic, strong) NSURLResponse * _Null_unspecified response;
@property (nonatomic, strong) NSHTTPURLResponse * _Null_unspecified httpresponse;
@property (nonatomic, strong) NSMutableURLRequest * _Null_unspecified newRequest;
+ (BOOL)canInitWithRequest:(NSURLRequest * _Nonnull)request;
+ (NSURLRequest * _Nonnull)canonicalRequestForRequest:(NSURLRequest * _Nonnull)request;
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest * _Nonnull)aRequest toRequest:(NSURLRequest * _Nonnull)bRequest;
- (void)startLoading;
- (void)stopLoading;
- (NSURLRequest * _Nullable)connection:(NSURLConnection * _Null_unspecified)connection willSendRequest:(NSURLRequest * _Nonnull)request redirectResponse:(NSURLResponse * _Nullable)response;
- (void)connection:(NSURLConnection * _Null_unspecified)connection didReceiveResponse:(NSURLResponse * _Null_unspecified)response;
- (void)connection:(NSURLConnection * _Null_unspecified)connection didReceiveData:(NSData * _Null_unspecified)data;
- (void)connectionDidFinishLoading:(NSURLConnection * _Null_unspecified)connection;
- (void)connection:(NSURLConnection * _Null_unspecified)connection didFailWithError:(NSError * _Null_unspecified)error;
- (void)saveCachedResponse;
- (NSManagedObject * _Nullable)cachedResponseForCurrentRequest;
- (nonnull instancetype)initWithRequest:(NSURLRequest * _Nonnull)request cachedResponse:(NSCachedURLResponse * _Nullable)cachedResponse client:(id <NSURLProtocolClient> _Nullable)client OBJC_DESIGNATED_INITIALIZER;
@end


@interface NSURLRequest (SWIFT_EXTENSION(SwiftLoginScreen))
@end


@interface NSURLSession (SWIFT_EXTENSION(SwiftLoginScreen))

/// Just like sharedSession, this returns a shared singleton session object.
+ (NSURLSession * _Nonnull)sharedCustomSession;
@end


@interface NSURLSessionConfiguration (SWIFT_EXTENSION(SwiftLoginScreen))

/// Just like defaultSessionConfiguration, returns a newly created session configuration object, customised from the default to your requirements.
+ (NSURLSessionConfiguration * _Nonnull)CustomSessionConfiguration;
@end


@interface NSUserDefaults (SWIFT_EXTENSION(SwiftLoginScreen))
+ (NSString * _Nonnull)isFirstLaunch;
@end


SWIFT_CLASS("_TtC16SwiftLoginScreen6People")
@interface People : NSManagedObject
- (nonnull instancetype)initWithEntity:(NSEntityDescription * _Nonnull)entity insertIntoManagedObjectContext:(NSManagedObjectContext * _Nullable)context OBJC_DESIGNATED_INITIALIZER;
@end


@interface People (SWIFT_EXTENSION(SwiftLoginScreen))
@property (nonatomic, copy) NSString * _Nullable deviceId;
@property (nonatomic, copy) NSString * _Nullable email;
@property (nonatomic, copy) NSString * _Nullable name;
@property (nonatomic, copy) NSString * _Nullable uuid;
@end


SWIFT_CLASS("_TtC16SwiftLoginScreen14RequestManager")
@interface RequestManager : NSObject
@property (nonatomic, strong) NSURL * _Null_unspecified url;
@property (nonatomic, copy) NSString * _Null_unspecified errors;
@property (nonatomic, strong) NSUserDefaults * _Nonnull prefs;
- (nullable instancetype)initWithUrl:(NSString * _Nonnull)url errors:(NSString * _Nonnull)errors OBJC_DESIGNATED_INITIALIZER;
@property (nonatomic, strong) NSURLSession * _Nonnull session;
@property (nonatomic) BOOL running;
@end

@class UIAlertView;

SWIFT_CLASS("_TtC16SwiftLoginScreen14RestApiManager")
@interface RestApiManager : NSObject <UIAlertViewDelegate>
+ (RestApiManager * _Nonnull)sharedInstance;
- (void)alertView:(UIAlertView * _Nonnull)View clickedButtonAtIndex:(NSInteger)buttonIndex;
@property (nonatomic, readonly, copy) NSString * _Nonnull baseURL;
@property (nonatomic) BOOL running;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC16SwiftLoginScreen8SignupVC")
@interface SignupVC : UIViewController
@property (nonatomic, strong) UIImageView * _Nonnull imageView;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * _Nonnull backgroundDict;
@property (nonatomic, strong) NSURLSession * _Nonnull session;
@property (nonatomic) BOOL running;
@property (nonatomic, strong) IBOutlet UITextField * _Null_unspecified txtVoucher;
@property (nonatomic, strong) IBOutlet UITextField * _Null_unspecified txtEmail;
@property (nonatomic, strong) IBOutlet UITextField * _Null_unspecified txtUsername;
@property (nonatomic, strong) IBOutlet UITextField * _Null_unspecified txtPassword;
@property (nonatomic, strong) IBOutlet UITextField * _Null_unspecified txtConfirmPassword;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (IBAction)gotoLogin:(UIButton * _Nonnull)sender;
@property (nonatomic, readonly, strong) NSURL * _Nonnull url;
@property (nonatomic, readonly, strong) NSURL * _Nonnull urlR;
- (IBAction)signupTapped:(UIButton * _Nonnull)sender;
- (BOOL)textFieldShouldReturn:(UITextField * _Null_unspecified)textField;
- (void)URLSession:(NSURLSession * _Nonnull)session didReceiveChallenge:(NSURLAuthenticationChallenge * _Nonnull)challenge completionHandler:(void (^ _Nonnull)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler;
- (void)URLSession:(NSURLSession * _Nonnull)session task:(NSURLSessionTask * _Nonnull)task willPerformHTTPRedirection:(NSHTTPURLResponse * _Nonnull)response newRequest:(NSURLRequest * _Nonnull)request completionHandler:(void (^ _Nonnull)(NSURLRequest * _Nullable))completionHandler;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface UIView (SWIFT_EXTENSION(SwiftLoginScreen))
@end


@interface UIViewController (SWIFT_EXTENSION(SwiftLoginScreen))
- (void)hideKeyboardWhenTappedAround;
- (void)dismissKeyboard;
@end


SWIFT_CLASS("_TtC16SwiftLoginScreen17URLSessionManager")
@interface URLSessionManager : NSObject <NSURLSessionTaskDelegate, NSURLSessionDelegate>
@property (nonatomic, copy) void (^ _Nonnull callback)(NSString * _Nonnull result, NSString * _Nullable error);
- (void)httpGet:(NSMutableURLRequest * _Null_unspecified)request callback:(void (^ _Nonnull)(NSString * _Nonnull, NSString * _Nullable))callback;
- (void)URLSession:(NSURLSession * _Nonnull)session task:(NSURLSessionTask * _Nonnull)task willPerformHTTPRedirection:(NSHTTPURLResponse * _Nonnull)response newRequest:(NSURLRequest * _Nonnull)request completionHandler:(void (^ _Nonnull)(NSURLRequest * _Nullable))completionHandler;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UIWebView;

SWIFT_CLASS("_TtC16SwiftLoginScreen17WebViewController")
@interface WebViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified close;
@property (nonatomic, weak) IBOutlet UIWebView * _Null_unspecified webView;
- (void)viewDidLoad;
- (void)reloadPage:(id _Nonnull)sender;
- (void)webViewDidStartLoad:(UIWebView * _Nonnull)_;
- (void)webViewDidFinishLoad:(UIWebView * _Nonnull)_;
- (BOOL)webView:(UIWebView * _Nonnull)_ shouldStartLoadWithRequest:(NSURLRequest * _Nonnull)request navigationType:(UIWebViewNavigationType)navigationType;
- (IBAction)close:(UIButton * _Nonnull)sender;
- (void)webView:(UIWebView * _Nonnull)webView didFailLoadWithError:(NSError * _Nonnull)error;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop