//
//  DataMember.m
//  YiDa
//
//  Created by meson on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <objc/runtime.h>
#import "DataMember.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "ChemicalInfo.h"
//#define IPAd  @"http://www.esquel.cn/wmis/WcfColor/Color.svc"

//NSString *IP = [defaults boolForKey:kServerIPkey];

//#define IPAd @"http://192.168.103.130.cn/msc/WcfColor/Color.svc"



@implementation NSString(DecodingXMLString)

- (NSString *)stringByDecodingXMLEntities {
    
    NSUInteger myLength = [self length];
    NSUInteger ampIndex = [self rangeOfString:@"&" options:NSLiteralSearch].location;
    
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return self;
    }
    // Make result string with some extra capacity.
    
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    
     // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:self];
    
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            return result;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
             else if ([scanner scanString:@"&lt;" intoString:NULL])
             [result appendString:@"<"];
             else if ([scanner scanString:@"&gt;" intoString:NULL])
             [result appendString:@">"];
             else if ([scanner scanString:@"&#" intoString:NULL]) {
                 BOOL gotNumber;
                 unsigned charCode;
                 NSString *xForHex = @"";
                 
                 // Is it hex or decimal?
                 if ([scanner scanString:@"x" intoString:&xForHex]) {
                     gotNumber = [scanner scanHexInt:&charCode];
                 }
                 else {
                     gotNumber = [scanner scanInt:(int*)&charCode];
                 }
                 
                 if (gotNumber) {
                     [result appendFormat:@"%C", charCode];
                     
                     [scanner scanString:@";" intoString:NULL];
                 }
                 else {
                     NSString *unknownEntity = @"";
                     
                     [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                     
                     
                     [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
                     
                     //[scanner scanUpToString:@";" intoString:&unknownEntity];
                     //[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                     NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
                 }
                 
             }
             else {
                 NSString *amp;
                 
                 [scanner scanString:@"&" intoString:&amp];      //an isolated & symbol
                 [result appendString:amp];
                 
                 
             }
             
             }
             while (![scanner isAtEnd]);
             
             return result;
    }

@end





@implementation DataMember
@synthesize tbxml;
//static DataMember *sharedInstance = nil;



-(void)dealloc
{
    tbxml=nil;
    [super dealloc];
}

+(DataMember*)shareInstance
{
    /*
     if (sharedInstance == nil)
     {
     sharedInstance = [[self alloc] init];
     }
     
     return sharedInstance; */
    
    static dispatch_once_t once; 
    static DataMember * __singleton__; 
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); 
    return __singleton__; 
}


#pragma mark---------------------------------------------------------
#pragma mark  json 部分
#pragma mark---------------------------------------------------------
-(NSString *)searchOneElementWithName:(NSString *)_elementName XMLContent:(NSString *)_content {

    
    NSString *elementValue=nil;
    
    @synchronized(self) {   

        if (_elementName!=nil&&_content!=nil) {
            //tbxml = [TBXML tbxmlWithXMLFile:@"longinXML.xml"] ;
            tbxml = [TBXML tbxmlWithXMLString:_content];
            // Obtain root element
            if (tbxml.rootXMLElement)
            {
                elementValue=  [self  traverseElement:tbxml.rootXMLElement elementName:_elementName];
                // NSLog(@"elementValue-- %@",elementValue);
            }
        }
        
    }
    return  elementValue;
}



- (NSString *) traverseElement:(TBXMLElement *)element elementName:(NSString *)_name{
	
    static  NSString *elementValue=nil;
    
	do {
        if ([[TBXML elementName:element] isEqualToString:_name]) {
            
            elementValue= [TBXML textForElement:element];
            
            break;
        }
		
		if (element->firstChild) [self traverseElement:element->firstChild elementName:_name];
        
	} while ((element = element->nextSibling));  
    
    return elementValue;
}



-(void)searchOneElementWithName1:(NSString *)_elementName XMLContent:(NSString *)_content valueBack:(const char **)valueBack {
    @synchronized(self) {   

        if (_elementName!=nil&&_content!=nil) {
            //tbxml = [TBXML tbxmlWithXMLFile:@"longinXML.xml"] ;
            tbxml = [TBXML tbxmlWithXMLString:_content];
            // Obtain root element
            if (tbxml.rootXMLElement)
            {
           
                [self  traverseElement1:tbxml.rootXMLElement elementName:_elementName valueBack:valueBack];
                printf("JSON STRING ---  %s \n",*valueBack);

            }
        }
    
    }
}


- (void) traverseElement1:(TBXMLElement *)element elementName:(NSString *)_name valueBack:(const char **)valueBack{
	
    @synchronized(self) {   

     NSString *elementValue=nil;
    
	do {
            if ([[TBXML elementName:element] isEqualToString:_name]) {
                
                 
                elementValue=[TBXML textForElement:element];
                *valueBack=[elementValue cStringUsingEncoding:NSUTF8StringEncoding];
                

                break;
            }
            
            if (element->firstChild) [self traverseElement1:element->firstChild elementName:_name valueBack:valueBack];
            
        } while ((element = element->nextSibling));  
        
    }

}








#pragma mark---------------------------------------------------------
#pragma mark  字典转换成类对象属性模块 部分
#pragma mark---------------------------------------------------------

-(NSArray *)tranformDicToDataObject:(NSString *)_objClassName dicAry:(NSArray *)itemAry
{
    
    NSMutableArray *objAry=[[[NSMutableArray alloc]initWithCapacity:5] autorelease];
    
    @synchronized(self) {   

        id _obj0=[[[NSClassFromString(_objClassName)alloc] init]autorelease];
        
        if (_obj0!=nil&&itemAry!=nil) {
            
            NSArray *atrAry= [self traversalObjAtr:_obj0];
            int dicAryCount=itemAry.count;
            int atrAryCount=atrAry.count;
            for (int i=0; i<dicAryCount; i++) {
                
                id _obj=[[[NSClassFromString(_objClassName)alloc] init]autorelease];
                
                NSDictionary *dd=[itemAry objectAtIndex:i];
                
                int keyCount=[dd allKeys].count;
                
                //if (keyCount==atrAryCount)
                {
                
                    for (int j=0; j<atrAryCount; j++) {
                        NSString *propertyNameString=[atrAry objectAtIndex:j];
                        NSString *UpperedPropertyNameString=[self UppercaseFirstChar:propertyNameString];
                        NSString *methdName=[NSString stringWithFormat:@"set%@:",UpperedPropertyNameString];
                        NSDictionary *_dicItem=[itemAry objectAtIndex:i];
                        NSString *valueString=[_dicItem objectForKey:propertyNameString];
                        if ([_obj respondsToSelector:NSSelectorFromString(methdName)])
                        {
                          [_obj performSelector:NSSelectorFromString(methdName) withObject:valueString];  
                        }
                        
                    } 
                }
                [objAry  addObject:_obj];
                
            }
            
        }
        
    }
    return [[[NSArray alloc]initWithArray:objAry]autorelease];
}


-(NSArray *)traversalObjAtr:(id)_class_object
{
    
    NSLog(@"testkk class %@",[_class_object class]);
    NSMutableArray *itemMutAry=[[[NSMutableArray alloc]initWithCapacity:6]autorelease];
    @synchronized(self) {   

        
        int i;
        unsigned int propertyCount = 0;
        
        objc_property_t *propertyList = class_copyPropertyList([_class_object class], &propertyCount);
        
        
        for ( i=0; i < propertyCount; i++ ) {
            
            objc_property_t *thisProperty = propertyList + i;
            const char* propertyName = property_getName(*thisProperty);
            
            NSString *propertyNameString=[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            
            
            [itemMutAry addObject:propertyNameString];
            
        }
            
    }
    return [[[NSArray alloc]initWithArray:itemMutAry]autorelease];
}
-(NSString *)UppercaseFirstChar:(NSString *)string
{
    //加上如果是大写就不用执行，提高效率
    NSString *reString=nil;
    @synchronized(self) {   

        if (string!=nil&&[string length]!=0) {
            NSRange range = NSMakeRange(0,1);
            reString=   [string stringByReplacingCharactersInRange:range withString:[[string substringWithRange:range] capitalizedString]];
        }
    }
    return reString;
}

#pragma mark---------------------------------------------------------
#pragma mark  网络接口 部分
#pragma mark---------------------------------------------------------

-(NSString *)NetInterface:(NSString *)bodyMessage 
{
    
    NSString *responseString=nil;
    //like this should repalce
    if (bodyMessage!=nil&&[bodyMessage length]!=0) {
        
        
        NSString *urlString = [NSString stringWithFormat:IPAd];
        
        NSURL *url = [NSURL URLWithString:urlString];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request addRequestHeader:@"Content-Type" value: @"application/soap+xml; charset=utf-8"];
        
        NSString *dataContent = bodyMessage;
        [request appendPostData:[dataContent dataUsingEncoding:NSUTF8StringEncoding]];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
            responseString = [[request responseString]stringByDecodingXMLEntities];
        
            NSLog(@"NetInterface>responseString:%@",responseString);
        }
        
    }
    return responseString;
    
}

#pragma mark-----------------------------------------------------------
#pragma mark  系统登录
#pragma mark-----------------------------------------------------------
// amolst all the method return string is json format
#pragma mark-
#pragma mark 系统登录
#pragma mark-
-(NSString *)LoginIn:(NSString *)User_ID password:(NSString *)Password
{
    NSString *jsonString=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/LoginIn</a:Action><a:MessageID>urn:uuid:93ae1353-b52a-40bb-b8d1-147d178a4a75</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><LoginIn xmlns=\"http://tempuri.org/\"><User_ID>%@</User_ID><Password>%@</Password></LoginIn></s:Body></s:Envelope>",User_ID,Password];
    NSString *webString=[self NetInterface:bodyMessage];    
    NSString *itemName=@"LoginInResult";
    if (webString!=nil) {

        
        const  char *staticValue=NULL;
        
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            jsonString=[self jsonParesModelOne:@"LoginIn" JsonString:UnpasredJsonString];
        }
  
    }
    NSLog(@"LoginIn>jsonPasredString %@",jsonString);
    return jsonString;
}


#pragma mark-
#pragma mark  系统注销
#pragma mark-
-(NSString *)LoginOut:(NSString *)User_ID
{
    
    NSString *jsonString=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/LoginOut</a:Action><a:MessageID>urn:uuid:50e7258e-1d03-4486-8c4d-f98bd45fcc96</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><LoginOut xmlns=\"http://tempuri.org/\"><User_ID>%@</User_ID></LoginOut></s:Body></s:Envelope>",User_ID];
    NSString *webString=[self NetInterface:bodyMessage];
    
    NSString *itemName=@"LoginOutResult";
    if (webString!=nil) {
     
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        //printf("staticValue myValue=====suny  %s \n",staticValue);
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            //NSLog(@"UnpasredJsonString %@",UnpasredJsonString);
            jsonString=[self jsonParesModelOne:@"LoginOut" JsonString:UnpasredJsonString]; 
        }
        
    }
    NSLog(@"LoginOut>jsonPasredString %@",jsonString);
    
    return jsonString;
    
}

#pragma mark||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#pragma mark|| LAB-DIP 
#pragma mark||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

#pragma mark-----------------------------------------------------------
#pragma mark  LAB-DIP 选料
#pragma mark-----------------------------------------------------------
#pragma mark-
#pragma mark  获取步骤列表
#pragma mark-
-(NSArray *)GetStepList
{
    NSArray *stepAry=nil;
    
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetStepList</a:Action><a:MessageID>urn:uuid:2c1f1b84-790f-46ce-893c-c148bfbbef54</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetStepList xmlns=\"http://tempuri.org/\"/></s:Body></s:Envelope>"];
    NSString *webString=[self NetInterface:bodyMessage];
    
    NSString *itemName=@"GetStepListResult";
    if (webString!=nil) {

        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        //printf("staticValue myValue=====suny  %s \n",staticValue);
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
             stepAry=[self jsonParesModelTwo:@"Step" JsonString:UnpasredJsonString];
        }
    }
    
    
    NSLog(@"stepAry Step %d  ",stepAry.count);
    return stepAry;
    
}




#pragma mark-
#pragma mark  获取分类列表
#pragma mark-
-(NSArray *)GetTypeList
{
    NSArray *stepAry=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetTypeList</a:Action><a:MessageID>urn:uuid:43fc296a-c2d5-4787-a2d7-6a5fab33e12c</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetTypeList xmlns=\"http://tempuri.org/\"/></s:Body></s:Envelope>"];    
    NSString *webString=[self NetInterface:bodyMessage];
    
    NSString *itemName=@"GetTypeListResult";
    if (webString!=nil) {

        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
        stepAry=[self jsonParesModelTwo:@"Type" JsonString:UnpasredJsonString];

        }
    }
    
    return stepAry;
    
}




#pragma mark-
#pragma mark  获取色系列表
#pragma mark-

-(NSArray *)GetSimpleColorList
{
    
    NSArray *stepItemAry=nil;
    
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetSimpleColorList</a:Action><a:MessageID>urn:uuid:7ab11530-7eb9-4ff0-8996-c785c97f78b5</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetSimpleColorList xmlns=\"http://tempuri.org/\"/></s:Body></s:Envelope>"];    
    NSString *itemName=@"GetSimpleColorListResult";
    NSString *webString=[self NetInterface:bodyMessage];
    
    if (webString!=nil) {

        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            stepItemAry=[self jsonParesModelTwo:@"SimpleColor" JsonString:UnpasredJsonString];

        }
        
        
    }
    return stepItemAry;
    
}
#pragma mark-
#pragma mark  获取深浅列表
#pragma mark-
-(NSArray *)GetColorDeepList
{
    NSArray *itemAry=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetColorDeepList</a:Action><a:MessageID>urn:uuid:889e4b0b-6ca9-4aaf-9d8e-77419406f908</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetColorDeepList xmlns=\"http://tempuri.org/\"/></s:Body></s:Envelope>"];    
    NSString *itemName=@"GetColorDeepListResult";
    NSString *webString=[self NetInterface:bodyMessage];
    
    if (webString!=nil) {

        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            itemAry=[self jsonParesModelTwo:@"ColorDeep" JsonString:UnpasredJsonString];
        }
        
    }
    return itemAry;
    
}

#pragma mark-
#pragma mark  获取成本列表
#pragma mark-
-(NSArray *)GetCostList
{
    NSArray *itemAry=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetCostList</a:Action><a:MessageID>urn:uuid:8a0c02c3-4c69-4d42-a8fc-37d37b911a86</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetCostList xmlns=\"http://tempuri.org/\"/></s:Body></s:Envelope>"];    
    NSString *itemName=@"GetCostListResult";
    NSString *webString=[self NetInterface:bodyMessage];
    
    if (webString!=nil) {
 
        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        //printf("staticValue myValue=====suny  %s \n",staticValue);
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            itemAry=[self jsonParesModelTwo:@"Cost" JsonString:UnpasredJsonString];
        }
        
    }
    
    return itemAry;
}

#pragma mark-
#pragma mark  获取开单号列表
#pragma mark-
//获取开单号列表
//string GetKDNOList("LB2012-2809")
-(NSArray *)GetKDNOList:(NSString*)LB_NO
{
    NSArray *itemAry=nil;
    
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetKDNOList</a:Action><a:MessageID>urn:uuid:738a3f52-209d-4d09-ba5e-77db0e3fb6af</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetKDNOList xmlns=\"http://tempuri.org/\"><LB_NO>%@</LB_NO></GetKDNOList></s:Body></s:Envelope>",LB_NO];    
    NSString *itemName=@"GetKDNOListResult";
    NSString *webString=[self NetInterface:bodyMessage];
    
    if (webString!=nil) {

        
        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        //printf("staticValue myValue=====suny  %s \n",staticValue);
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            itemAry=[self jsonParesModelTwo:@"KDNO" JsonString:UnpasredJsonString];

        }
        
    }
    return itemAry;
    
}


#pragma mark-
#pragma mark  获取颜色列表
#pragma mark-
//获取颜色列表
//string GetColorCodeList(string LB_NO,string KD_NO)
-(NSArray *)GetColorCodeList:(NSString *)LB_NO KD_NO:(NSString *)KD_NO
{
    NSArray *itemAry=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetColorCodeList</a:Action><a:MessageID>urn:uuid:3cd53f5a-dc08-479f-afa2-80f06943fa4c</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetColorCodeList xmlns=\"http://tempuri.org/\"><LB_NO>%@</LB_NO><KD_NO>%@</KD_NO></GetColorCodeList></s:Body></s:Envelope>",LB_NO,KD_NO];    
    NSString *itemName=@"GetColorCodeListResult";
    NSString *webString=[self NetInterface:bodyMessage];
    
    if (webString!=nil) {

        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        //printf("staticValue myValue=====suny  %s \n",staticValue);
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            itemAry=[self jsonParesModelTwo:@"ColorCode" JsonString:UnpasredJsonString];

        }
        
        
    }
    return itemAry;
    
}


#pragma mark-
#pragma mark  获取来样单信息
#pragma mark-
//获取来样单信息
//string GetLBInfo(string LB_NO,string Color_Code)
-(LBInfo *)GetLBInfo:(NSString *)LB_NO Color_Code:(NSString *)Color_Code
{
    LBInfo *lBInfo=nil;
    NSArray *itemAry=nil;
    
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetLBInfo</a:Action><a:MessageID>urn:uuid:21b2063b-da68-4e04-b338-18fa569bc2e3</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetLBInfo xmlns=\"http://tempuri.org/\"><LB_NO>%@</LB_NO><Color_Code>%@</Color_Code></GetLBInfo></s:Body></s:Envelope>",LB_NO,Color_Code];    
    NSString *itemName=@"GetLBInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    
    if (webString!=nil) {
   
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        //printf("staticValue myValue=====suny  %s \n",staticValue);
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            itemAry=[self jsonParesModelTwo:@"LBInfo" JsonString:UnpasredJsonString];
           
            if (itemAry!=nil) {
                lBInfo=[[[LBInfo alloc]init]autorelease];
                
                if (itemAry.count==1) {
                    
                    lBInfo.Customer=[[itemAry objectAtIndex:0]objectForKey:@"Customer"];
                    lBInfo.Light=[[itemAry objectAtIndex:0]objectForKey:@"Light"];
                    lBInfo.FWeight=[[itemAry objectAtIndex:0]objectForKey:@"FWeight"];
                    lBInfo.WWeight=[[itemAry objectAtIndex:0]objectForKey:@"WWeight"];
                    lBInfo.Weight=[[itemAry objectAtIndex:0]objectForKey:@"Weight"];
                    lBInfo.RGB=[[itemAry objectAtIndex:0]objectForKey:@"RGB"];
                    lBInfo.Delivery_Date=[[itemAry objectAtIndex:0]objectForKey:@"Delivery_Date"];
                    lBInfo.Color_Remarks=[[itemAry objectAtIndex:0]objectForKey:@"Color_Remarks"];
                    lBInfo.FinishList=[[itemAry objectAtIndex:0]objectForKey:@"FinishList"];
                    lBInfo.FinishMethod=[[itemAry objectAtIndex:0]objectForKey:@"FinishMethod"]; 
                }
            } 
        }
    }
    
    
    
    return lBInfo;
    
}


#pragma mark-
#pragma mark  获取最优的组合信息
#pragma mark-
//获取最优的组合信息
//string GetBestGroupInfo(string Step,string Type,string Simple_Color,string Color_Deep,string Customer,string FinishList)
-(NSArray *)GetBestGroupInfo:(NSString *)Type Simple_Color:(NSString *)Simple_Color Color_Deep:(NSString *)Color_Deep Customer:(NSString *)Customer FinishList:(NSString *)FinishList
{
    NSArray *objectAry=nil;
    BestGroupInfo *bestGroupInfo=[[[BestGroupInfo alloc]init]autorelease];
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetBestGroupInfo</a:Action><a:MessageID>urn:uuid:be670038-e68b-4d50-b6db-f6bde36157d9</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetBestGroupInfo xmlns=\"http://tempuri.org/\"><Sel_Type>%@</Sel_Type><Simple_Color>%@</Simple_Color><Color_Deep>%@</Color_Deep><Customer>%@</Customer><Finish_List>%@</Finish_List></GetBestGroupInfo></s:Body></s:Envelope>",Type,Simple_Color,Color_Deep,Customer,FinishList];    
    NSString *itemName=@"GetBestGroupInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    
    if (webString!=nil) {
        NSArray *itemAry=nil;

        
        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            itemAry=[self jsonParesModelTwo:@"BestGroup" JsonString:UnpasredJsonString];
            bestGroupInfo.bestGroupInfoAry=[self tranformDicToDataObject:@"BGI_Atr_BestGroupInfo" dicAry:itemAry];
        }
    }
    objectAry=[bestGroupInfo getOneGroup];
    return objectAry;
}

#pragma mark-
#pragma mark  保存配方信息
#pragma mark-
//保存配方信息
//string SaveRecipeInfo(string LB_NO,string Color_Code,float Weight,string Customer,string User_ID,string Step,string ChemicalIDStr,string UsageStr)
-(NSString *)SaveRecipeInfo:(NSString *)LB_NO Color_Code:(NSString *)Color_Code Weight:(NSString *)Weight  User_ID:(NSString *)User_ID Step:(NSString *)Step Group_ID:(NSString *)Group_ID ChemicalIDStr:(NSString *)ChemicalIDStr UsageStr:(NSString *)UsageStr
{
    
    NSString *jsonString=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/SaveRecipeInfo</a:Action><a:MessageID>urn:uuid:809040ad-fc69-478e-9f78-60857f9f6f0d</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><SaveRecipeInfo xmlns=\"http://tempuri.org/\"><LB_NO>%@</LB_NO><Color_Code>%@</Color_Code><Weight>%@</Weight><User_ID>%@</User_ID><Step>%@</Step><Group_ID>%@</Group_ID><ChemicalIDStr>%@</ChemicalIDStr><UsageStr>%@</UsageStr></SaveRecipeInfo></s:Body></s:Envelope>",LB_NO,Color_Code,Weight,User_ID,Step,Group_ID,ChemicalIDStr,UsageStr];    
    NSString *itemName=@"SaveRecipeInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    
    if (webString!=nil) {
        

        
        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
             jsonString=[self jsonParesModelOne:@"Save" JsonString:UnpasredJsonString];
            

        }
    }
    NSLog(@"jsonString:%@",jsonString);
    return jsonString;
    
}

- (NSString *)CheckPercent:(NSString *)_ChemicalIDStr
               newUsageStr:(NSString *)_NewUsageStr
               oldUsageStr:(NSString *)_OldUsageStr
{
    NSString *jsonString=nil;
    
    
    
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/CheckPercent</a:Action><a:MessageID>urn:uuid:809040ad-fc69-478e-9f78-60857f9f6f0d</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><CheckPercent xmlns=\"http://tempuri.org/\"><ChemicalIDStr>%@</ChemicalIDStr><NewUsageStr>%@</NewUsageStr><OldUsageStr>%@</OldUsageStr></CheckPercent></s:Body></s:Envelope>",_ChemicalIDStr,_NewUsageStr,_OldUsageStr];
    
    
    NSString *webString=[self NetInterface:bodyMessage];
    NSString *itemName=@"CheckPercentResult";
    if (webString!=nil) {
        
        
        const  char *staticValue=NULL;
        
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            jsonString=[self jsonParesModelOne:@"CheckPercent" JsonString:UnpasredJsonString];
        }
        
    }
    NSLog(@"CheckPercent>jsonPasredString %@",jsonString);
    return jsonString;
}

- (NSString *)CheckIsNeedFixing:(NSString *)_LBNO
                      colorCode:(NSString *)_colorCode
                    chemicalStr:(NSString *)_chemicalIds
                       usageStr:(NSString *)_usagesStr
{
    NSString *jsonString=nil;
    

    
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/CheckIsNeedFixing</a:Action><a:MessageID>urn:uuid:809040ad-fc69-478e-9f78-60857f9f6f0d</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><CheckIsNeedFixing xmlns=\"http://tempuri.org/\"><LB_NO>%@</LB_NO><Color_Code>%@</Color_Code><ChemicalIDStr>%@</ChemicalIDStr><UsageStr>%@</UsageStr></CheckIsNeedFixing></s:Body></s:Envelope>",_LBNO,_colorCode,_chemicalIds,_usagesStr];
    
    
    NSString *webString=[self NetInterface:bodyMessage];
    NSString *itemName=@"CheckIsNeedFixingResult";
    if (webString!=nil) {
        
        
        const  char *staticValue=NULL;
        
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            jsonString=[self jsonParesModelOne:@"NeedFixing" JsonString:UnpasredJsonString];
        }
        
    }
    NSLog(@"NeedFixing>jsonPasredString %@",jsonString);
    return jsonString;
}



#pragma mark-----------------------------------------------------------
#pragma mark LAB-DIP 调方 
#pragma mark-----------------------------------------------------------
#pragma mark-
#pragma mark  获取色号的配方信息 获取色号标记OK方信息
#pragma mark-
//获取色号的配方信息
-(ChemicalInfo *)GetChemicalInfo:(NSString *)BatchNO_OR_ColorCode Type:(NSString *)Type
{
    
    ChemicalInfo * chemicalInfo=[[[ChemicalInfo alloc]init] autorelease];
    // NSArray *itemAry=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetChemicalInfo</a:Action><a:MessageID>urn:uuid:0ead26ab-0075-4cc5-a8ba-8df1a6dcfcf0</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetChemicalInfo xmlns=\"http://tempuri.org/\"><BatchNO_OR_ColorCode>%@</BatchNO_OR_ColorCode><Type>%@</Type></GetChemicalInfo></s:Body></s:Envelope>",BatchNO_OR_ColorCode,Type];    
    NSString *itemName=@"GetChemicalInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    if (webString!=nil) {

        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        //printf("staticValue myValue=====suny  %s \n",staticValue);
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
             //NSString * UnpasredJsonString = @"{\"GroupInfo\": [{\"GroupID\": \"71\",\"RecipeNOs\": [\"NewRecipe\",\"R301081099\",\"R301081097\",\"R301072055\",\"R301070817\",\"R301063304\",\"R212210775\"]}],\"ChemicalInfo\": [{\"Chemical_Name\": \"SS YELLOW 3RF150%\",\"Chemical_ID\": \"319\",\"Stuff_Bat\": \"100429\",\"NewRecipe\": \"0.115\",\"R301081099\":\"0.115\",\"R301081097\":\"0.13\",\"R301072055\":\"0.15\",\"R301070817\":\"0.16\",\"R301063304\":\"0.16\",\"R212210775\":\"0.16\"},{\"Chemical_Name\": \"SS BR RED 3BF150%\",\"Chemical_ID\": \"307\",\"Stuff_Bat\": \"N/A\",\"NewRecipe\": \"2.4\",\"R301081099\": \"2.4\",\"R301081097\": \"2.5\",\"R301072055\": \"2.6\",\"R301070817\": \"2.65\",\"R301063304\": \"2.65\",\"R212210775\": \"2.65\"},{\"Chemical_Name\": \"SS BLUE BRF150%\",\"Chemical_ID\": \"305\",\"Stuff_Bat\": \"100465\",\"NewRecipe\": \"2.1\",\"R301081099\": \"2.1\",\"R301081097\": \"2.2\",\"R301072055\": \"2.4\",\"R301070817\": \"2.7\",\"R301063304\": \"2.8\",\"R212210775\": \"2.8\"}]}";
            
            NSArray *dicGroupInfoAry=[self jsonParesModelTwo:@"GroupInfo" JsonString:UnpasredJsonString];
            NSArray *aryKeyForSort=nil;
            if (dicGroupInfoAry!=nil && dicGroupInfoAry.count==1)
            {
               aryKeyForSort= [[dicGroupInfoAry objectAtIndex:0] objectForKey:@"RecipeNOs"];
            }
            
           
             NSArray *dicxriteAry=[self jsonParesModelTwo:@"xriteItemNO" JsonString:UnpasredJsonString];
            if (dicxriteAry!=nil&&dicxriteAry.count==1) {
                CI_Atrb_xriteItemNO *ciaxItem=[[[CI_Atrb_xriteItemNO alloc]init]autorelease];
                ciaxItem.xriteNO= [[dicxriteAry objectAtIndex:0]objectForKey:@"xriteNO"];
                chemicalInfo.xriteItemNO=ciaxItem;
            }
            
            //chemicalInfo.xriteNOAry=dicxriteAry;
            
            NSArray *dicChemicalInfoAry=[self jsonParesModelTwo:@"ChemicalInfo" JsonString:UnpasredJsonString];
            
            //NSArray *dicChemicalInfoAry=[self jsonParesModelThree:@"ChemicalInfo" JsonString:UnpasredJsonString];
            NSLog(@"dicChemicalInfoAry==== %@",dicChemicalInfoAry);
        
            
            chemicalInfo.groupInfoAry=[self tranformDicToDataObject:@"CI_Atrb_GroupInfo" dicAry:dicGroupInfoAry];
            chemicalInfo.chemicalInfoAry=[self tranChemicalInfodicAry:dicChemicalInfoAry];
            for (int i = 0;i<[chemicalInfo.chemicalInfoAry count];i++)
            {
                NSLog(@"log the chemical %@",[chemicalInfo.chemicalInfoAry objectAtIndex:i]);
            }
            chemicalInfo.group_Head=[chemicalInfo getValueForGroup_Head];
            //chemicalInfo.grouplistAry=[chemicalInfo getValueListForGroup_List];
            //按照服务器的顺序来显示，因为hash 没顺序
            NSArray *unsortedGrpAry=[chemicalInfo getValueListForGroup_List];
            NSMutableArray *sortedGrpAry=[NSMutableArray arrayWithCapacity:5];
            if (unsortedGrpAry!=nil && unsortedGrpAry.count>0 && aryKeyForSort!=nil )
            {
                for (int i=0; i<aryKeyForSort.count; i++)
                {
                    NSString *keyString=[aryKeyForSort objectAtIndex:i];
                    if(keyString!=nil && [keyString length]!=0)
                    {
                        for (int j=0; j<unsortedGrpAry.count; j++)
                        {
                            Group_List *aGrpLsit=[unsortedGrpAry objectAtIndex:j];
                            if (aGrpLsit!=nil) {

                                if ([aGrpLsit.titleName isEqualToString:keyString])
                                {

                                    [sortedGrpAry addObject:aGrpLsit];
                                }

                            }
                        }
                    }

                }
                chemicalInfo.grouplistAry=sortedGrpAry;
                NSLog(@"chemicalInfo.grouplistAry= %@ %d",chemicalInfo.grouplistAry,chemicalInfo.grouplistAry.count);
            }
        
        }        
    }
    
    
    
    return chemicalInfo;
    
}

-(NSArray *)tranChemicalInfodicAry:(NSArray *)_dicAry 
{
     NSMutableArray*itemAry=[NSMutableArray arrayWithCapacity:5];
    if (_dicAry!=nil&&_dicAry.count!=0) {
        int count=[_dicAry count];
        for (int i=0; i<count;i++) {
            CI_Atrb_ChemicalInfo * _obj0=[[[CI_Atrb_ChemicalInfo alloc]init]autorelease];
         
          
            _obj0.Chemical_Name=[[_dicAry objectAtIndex:i] objectForKey:@"Chemical_Name"];
            _obj0.Chemical_ID=[[_dicAry objectAtIndex:i] objectForKey:@"Chemical_ID"];
            _obj0.Stuff_Bat=[[_dicAry objectAtIndex:i] objectForKey:@"Stuff_Bat"];
            _obj0.NewRecipe=[[_dicAry objectAtIndex:i] objectForKey:@"NewRecipe"];
            NSDictionary *dic=(NSDictionary *)[_dicAry objectAtIndex:i];
            NSArray *aryTest=[dic allKeys];
            int keyCont=aryTest.count;
            //除了Chemical_Name,Chemical_ID,Stuff_Bat，都是方块中的元素
            _obj0.rowItemAry=[NSMutableArray arrayWithCapacity:5];
            _obj0.mutDic=[NSMutableDictionary dictionaryWithCapacity:5];
        
            for (int j=0; j<keyCont; j++) {
                NSString *keyString=[aryTest objectAtIndex:j];
                if (![keyString isEqualToString:@"Chemical_Name"]&&![keyString isEqualToString:@"Chemical_ID"]&&![keyString isEqualToString:@"Stuff_Bat"]) {
                    
                    [_obj0.mutDic setValue:[[_dicAry objectAtIndex:i] objectForKey:keyString]forKey:keyString];
            
                  
                    
                }
            }

            [itemAry addObject:_obj0];
        }   

    }
    
    
    
    //NSLog(@"tranChemicalInfo %@",_dicAry );
    return [NSArray arrayWithArray:itemAry];
}

#pragma mark-
#pragma mark  计算助剂
#pragma mark-
//计算助剂
//string GetLabAuxiliariesInfo(string ChemicalIDStr, string UsageStr)

-(LabAuxiliariesInfo *)GetLabAuxiliariesInfo:(NSString *)ChemicalIDStr UsageStr:(NSString *)UsageStr
{
    
    LabAuxiliariesInfo *labAuxiliariesInfo=[[[LabAuxiliariesInfo alloc]init]autorelease];
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetLabAuxiliariesInfo</a:Action><a:MessageID>urn:uuid:e2387ecd-e031-409d-aca7-8549d6466237</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetLabAuxiliariesInfo xmlns=\"http://tempuri.org/\"><ChemicalIDStr>%@</ChemicalIDStr><UsageStr>%@</UsageStr></GetLabAuxiliariesInfo></s:Body></s:Envelope>",ChemicalIDStr,UsageStr];    
    NSString *itemName=@"GetLabAuxiliariesInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    if (webString!=nil) {

        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
      
            NSArray *dicArtInfoAry=[self jsonParesModelTwo:@"ArtInfo" JsonString:UnpasredJsonString];
            NSArray *dicChemicalInfoAry=[self jsonParesModelTwo:@"ChemicalInfo" JsonString:UnpasredJsonString];
      
        
            
            labAuxiliariesInfo.ArtInfoAry=[self tranformDicToDataObject:@"LAI_Atrb_ArtInfo" dicAry:dicArtInfoAry];
            labAuxiliariesInfo.ChemicalInfoAry=[self tranformDicToDataObject:@"LAI_Atrb_ChemicalInfo" dicAry:dicChemicalInfoAry];
            labAuxiliariesInfo.laiUIData=[labAuxiliariesInfo getLAIUIData];

        }
        
    }
    
    //LAI_Atrb_ChemicalInfo *tt=[labAuxiliariesInfo.ChemicalInfoAry objectAtIndex:0];
   // NSLog(@"labAuxiliariesInfo.ChemicalInfoAry %@",tt.Chemical_Name);
    
    return labAuxiliariesInfo;
}


#pragma mark-
#pragma mark  保存LAB-DIP调方配方信息
#pragma mark-
//保存LAB-DIP调方配方信息
//string SaveLabRecipeInfo(string Color_Code,string User_ID,string Recipe_NO,string Dye_Art_NO,int Keep_Temperature_Time，string ChemicalIDStr,string UsageStr,string StuffBatStr)
-(NSString *)SaveLabRecipeInfo:(NSString *)LB_NO Color_Code:(NSString *)Color_Code Weight:(NSString *)Weight User_ID:(NSString *)User_ID Recipe_NO:(NSString *)Recipe_NO NA2CO3:(NSString *)NA2CO3 NA2SO4:(NSString *)NA2SO4 Keep_Temperature_Time:(NSString *)Keep_Temperature_Time Group_ID:(NSString *)Group_ID ChemicalIDStr:(NSString *)ChemicalIDStr UsageStr:(NSString *)UsageStr OldUsageStr:(NSString *)OldUsageStr
{
    //LB_NO Color_Code Weight User_ID Recipe_NO NA2CO3 NA2SO4 Keep_Temperature_Time Group_ID ChemicalIDStr UsageStr OldUsageStr
    NSString *jsonString=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/SaveLabRecipeInfo</a:Action><a:MessageID>urn:uuid:263c7e48-da57-46fd-8b0f-ac391113de92</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><SaveLabRecipeInfo xmlns=\"http://tempuri.org/\"><LB_NO>%@</LB_NO><Color_Code>%@</Color_Code><Weight>%@</Weight><User_ID>%@</User_ID><Recipe_NO>%@</Recipe_NO><NA2CO3>%@</NA2CO3><NA2SO4>%@</NA2SO4><Keep_Temperature_Time>%@</Keep_Temperature_Time><Group_ID>%@</Group_ID><ChemicalIDStr>%@</ChemicalIDStr><UsageStr>%@</UsageStr><OldUsageStr>%@</OldUsageStr></SaveLabRecipeInfo></s:Body></s:Envelope>",LB_NO,Color_Code,Weight,User_ID,Recipe_NO,NA2CO3,NA2SO4,Keep_Temperature_Time,Group_ID,ChemicalIDStr,UsageStr,OldUsageStr];    
    NSString *itemName=@"SaveLabRecipeInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    if (webString!=nil) {
        
        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        //printf("staticValue myValue=====suny  %s \n",staticValue);
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            jsonString=[self jsonParesModelOne:@"Save" JsonString:UnpasredJsonString]; 
        }
   
    }
    NSLog(@"SaveLabRecipeInfo jsonString:%@",jsonString);
    return jsonString;
    
}



#pragma mark-----------------------------------------------------------
#pragma mark  LAB-DIP 标记OK方
#pragma mark-----------------------------------------------------------
//获取色号的配方信息
//string GetChemicalInfo(string BatchNO_OR_ColorCode,int Type)
//if Type==0 ==>类型 0 获取色号调方信息;if Type==1 ==>类型 1 获取色号标记OK方信息; 
//共用函数 GetChemicalInfo



#pragma mark-
#pragma mark  标记LAP-DIP OK方
#pragma mark-
//标记LAP-DIP OK方
//string CheckLabRecipeInfo(string RecipeNOStr,string GradeStr,string User_ID)
-(NSString *)CheckLabRecipeInfo:(NSString *)RecipeNOStr GradeStr:(NSString *)GradeStr User_ID:(NSString *)User_ID;
{
    
    NSString *jsonString=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/CheckLabRecipeInfo</a:Action><a:MessageID>urn:uuid:a371c9cb-9642-4a5f-a05b-a84be1f01c50</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><CheckLabRecipeInfo xmlns=\"http://tempuri.org/\"><RecipeNOStr>%@</RecipeNOStr><GradeStr>%@</GradeStr><User_ID>%@</User_ID></CheckLabRecipeInfo></s:Body></s:Envelope>",RecipeNOStr,GradeStr,User_ID];    
    NSString *itemName=@"CheckLabRecipeInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    if (webString!=nil) {

        
        
        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
        
              jsonString=[self jsonParesModelOne:@"Save" JsonString:UnpasredJsonString];
        }
    }
    NSLog(@"jsonString:%@",jsonString);
    return jsonString;
    
}






#pragma mark-----------------------------------------------------------
#pragma mark  LAB-DIP 查询
#pragma mark-----------------------------------------------------------
//LAB-DIP 查询
////////////////////////////////////////////////////////////////////

#pragma mark-
#pragma mark  配方列表
#pragma mark-
//配方列表
-(NSArray *)GetRecipeNOList:(NSString *)BatchNO_OR_ColorCode;
{
    
    NSArray *itemAry=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetRecipeNOList</a:Action><a:MessageID>urn:uuid:6db8dc58-c7b5-40db-aec1-72ba0ae45cb3</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetRecipeNOList xmlns=\"http://tempuri.org/\"><BatchNO_OR_ColorCode>%@</BatchNO_OR_ColorCode></GetRecipeNOList></s:Body></s:Envelope>",BatchNO_OR_ColorCode];    
    NSString *itemName=@"GetRecipeNOListResult";
    NSString *webString=[self NetInterface:bodyMessage];
    if (webString!=nil) {

        
        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            itemAry=[self jsonParesModelTwo:@"RecipeList" JsonString:UnpasredJsonString];
        }
    }
    NSLog(@"itemAry %@",itemAry);
    return itemAry;
    
}

-(RecipetTraceInfo *) GetRecipetTraceInfo:(NSString *)Recipe_NO
{
    
    RecipetTraceInfo *recipetTraceInfo=[[[RecipetTraceInfo alloc]init]autorelease];
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetRecipetTraceInfo</a:Action><a:MessageID>urn:uuid:2bbfa1b8-1272-4915-b382-d47037826147</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetRecipetTraceInfo xmlns=\"http://tempuri.org/\"><Recipe_NO>%@</Recipe_NO></GetRecipetTraceInfo></s:Body></s:Envelope>",Recipe_NO];    
    NSString *itemName=@"GetRecipetTraceInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    if (webString!=nil) {
        
        NSArray *recipeTraceDicAry=nil;
        NSArray *chemicalInfoDicAry=nil;
  
        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            recipeTraceDicAry=[self jsonParesModelTwo:@"RecipeTrace" JsonString:UnpasredJsonString];
            chemicalInfoDicAry=[self jsonParesModelTwo:@"ChemicalInfo" JsonString:UnpasredJsonString];
            
        }
        
        
        recipetTraceInfo.RecipeTraceAry=[self tranformDicToDataObject:@"RTI_atb_RecipeTrace" dicAry:recipeTraceDicAry];
        
       /* RTI_atb_RecipeTrace *TTT;;
        TTT=[recipetTraceInfo.RecipeTraceAry objectAtIndex:0];
        NSLog(@" recipetTraceInfo.RecipeTraceAry %@", TTT.Handle_Time);*/
        
        
        recipetTraceInfo.ChemicalInfoAry=[self tranformDicToDataObject:@"RTI_atb_ChemicalInfo" dicAry:chemicalInfoDicAry];
        

    }
    
    
    return recipetTraceInfo;
}




//BULK
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

#pragma mark||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#pragma mark||  BULK 
#pragma mark||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

#pragma mark-----------------------------------------------------------
#pragma mark  //BULK 调方 
#pragma mark-----------------------------------------------------------
//BULK 调方 
////////////////////////////////////////////////////////////////////
//获取缸的信息
//string GetBatchInfo(string Batch_NO)


#pragma mark-
#pragma mark  BULK 获取缸的信息
#pragma mark-
-(NSArray *)GetBatchInfo:(NSString *)Batch_NO
{
    NSArray *itemTranformedAry=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetBatchInfo</a:Action><a:MessageID>urn:uuid:50bccf6a-e719-4d80-9909-a595df7fb33e</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetBatchInfo xmlns=\"http://tempuri.org/\"><Batch_NO>%@</Batch_NO></GetBatchInfo></s:Body></s:Envelope>",Batch_NO];    
    NSString *itemName=@"GetBatchInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    if (webString!=nil) {
        NSArray *itemAry=nil;

        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            itemAry=[self jsonParesModelTwo:@"BatchInfo" JsonString:UnpasredJsonString];
        }
        
        itemTranformedAry=[self tranformDicToDataObject:@"BatchInfo" dicAry:itemAry];
        
    }

    
    return itemTranformedAry;
    
}




#pragma mark-
#pragma mark  BULK 获取缸的配方信
#pragma mark-


//获取缸的配方信息
//string GetChemicalInfo(string BatchNO_OR_ColorCode,int Type)
//备注，这个函数 和和上面的一样 只是 type＝＝3






#pragma mark-
#pragma mark  BULK 计算助剂
#pragma mark-
//计算助剂
//string GetBulkAuxiliariesInfo (string xriteNO,string Batch_NO,string FirstDyeCotton, string ChemicalIDStr, string UsageStr)
-(BulkAuxiliariesInfo *)GetBulkAuxiliariesInfostring:(NSString *)xriteNO Batch_NO:(NSString *)Batch_NO FirstDyeCotton:(NSString *)FirstDyeCotton ChemicalIDStr:(NSString *)ChemicalIDStr UsageStr:(NSString *)UsageStr
{
    
    BulkAuxiliariesInfo *bulkAuxiliariesInfo=[[[BulkAuxiliariesInfo alloc]init]autorelease];
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetBulkAuxiliariesInfo</a:Action><a:MessageID>urn:uuid:de31b3a0-5920-4db8-9941-c7cc69faa2d5</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetBulkAuxiliariesInfo xmlns=\"http://tempuri.org/\"><xriteNO>%@</xriteNO><Batch_NO>%@</Batch_NO><FirstDyeCotton>%@</FirstDyeCotton><ChemicalIDStr>%@</ChemicalIDStr><UsageStr>%@</UsageStr></GetBulkAuxiliariesInfo></s:Body></s:Envelope>",xriteNO,Batch_NO,FirstDyeCotton,ChemicalIDStr,UsageStr];    
    NSString *itemName=@"GetBulkAuxiliariesInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    if (webString!=nil) {

        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            NSArray *artInfoAry=[self jsonParesModelTwo:@"ArtInfo" JsonString:UnpasredJsonString];
            NSArray *chemicalInfoAry=[self jsonParesModelTwo:@"ChemicalInfo" JsonString:UnpasredJsonString];
            
            bulkAuxiliariesInfo.ArtInfoAry=[self transformToArtInfoAry:artInfoAry];
            bulkAuxiliariesInfo.ChemicalInfoAry=[self transformToChemicalInfoAry:chemicalInfoAry];
            bulkAuxiliariesInfo.baiUIData=[bulkAuxiliariesInfo getBAIUIData];
        }
  
    }
    return bulkAuxiliariesInfo;
    
}

-(NSArray *)transformToArtInfoAry:(NSArray *)dicAry
{
    NSMutableArray *itemMutAry=[[[NSMutableArray alloc]initWithCapacity:6]autorelease];
    
    if (dicAry!=nil) {
        
        
        int count=[dicAry count];
        for (int i=0; i<count;i++) {
            
            BAI_Atrb_ArtInfo  *bAI_Atrb_ArtInfo=[[[BAI_Atrb_ArtInfo alloc]init]autorelease];
            
            bAI_Atrb_ArtInfo.PreArt=[[dicAry objectAtIndex:i]objectForKey:@"PreArt"];
            bAI_Atrb_ArtInfo.DyeArt=[[dicAry objectAtIndex:i]objectForKey:@"DyeArt"];
            
            bAI_Atrb_ArtInfo.KeepTime=[[dicAry objectAtIndex:i]objectForKey:@"KeepTime"];
            
            bAI_Atrb_ArtInfo.LaterArt=[[dicAry objectAtIndex:i]objectForKey:@"LaterArt"];
            bAI_Atrb_ArtInfo.OWF=[[dicAry objectAtIndex:i]objectForKey:@"OWF"];
            
            bAI_Atrb_ArtInfo.Remark=[[dicAry objectAtIndex:i]objectForKey:@"Remark"];
            
            NSLog(@"bAI_Atrb_ArtInfo.Remark %@",bAI_Atrb_ArtInfo.OWF);
            
            [itemMutAry addObject:bAI_Atrb_ArtInfo];
            
        }
        
    }
    return [[[NSArray alloc]initWithArray:itemMutAry]autorelease];
    
}


-(NSArray *)transformToChemicalInfoAry:(NSArray *)dicAry
{
    NSMutableArray *itemMutAry=[[[NSMutableArray alloc]initWithCapacity:6]autorelease];
    
    if (dicAry!=nil) {
        
        
        int count=[dicAry count];
        for (int i=0; i<count;i++) {
            
            BAI_Atrb_ChemicalInfo  *bAI_Atrb_ChemicalInfo=[[[BAI_Atrb_ChemicalInfo alloc]init]autorelease];
            
            
            bAI_Atrb_ChemicalInfo.Chemical_Name=[[dicAry objectAtIndex:i]objectForKey:@"Chemical_Name"];
            bAI_Atrb_ChemicalInfo.Chemical_ID=[[dicAry objectAtIndex:i]objectForKey:@"Chemical_ID"];
            bAI_Atrb_ChemicalInfo.Stuff_Bat=[[dicAry objectAtIndex:i]objectForKey:@"Stuff_Bat"];
            bAI_Atrb_ChemicalInfo.NewRecipe=[[dicAry objectAtIndex:i]objectForKey:@"NewRecipe"];
            // NSLog(@"bAI_Atrb_ArtInfo.Remark11 %@",bAI_Atrb_ChemicalInfo.NewRecipe);
            
            
            [itemMutAry addObject:bAI_Atrb_ChemicalInfo];
            
        }
        
    }
    return [[[NSArray alloc]initWithArray:itemMutAry]autorelease];
    
    
}

#pragma mark---
#pragma mark SaveLog 保存日志信息
#pragma mark--
//requestMethod->要调用的接口名，requestTime->请求时间，responseTime->响应时间，runTime->逻辑处理时间
-(void)SaveLog:(NSString *)requestMethod
                requestTime:(NSDate *)requestTime
                responseTime:(NSDate *)responseTime
                runTime:(NSDate *)runTime
{
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *requestTimestr=[dateFormatter stringFromDate:requestTime];
    NSLog(@"请求服务名：%@,请求时间：%@,网络响应耗时：%f ms,Ipad逻辑处理耗时：%f ms",
          requestMethod,
          requestTimestr,
          [responseTime timeIntervalSince1970]*1000-[requestTime timeIntervalSince1970]*1000,
          [runTime timeIntervalSince1970]*1000-[responseTime timeIntervalSince1970]*1000
          );

    NSString *logInfo=[NSString stringWithFormat:@"%@,%@,%f,%f",
                       requestMethod,
                       requestTime,
                       [responseTime timeIntervalSince1970]*1000-[requestTime timeIntervalSince1970]*1000,
                       [runTime timeIntervalSince1970]*1000-[responseTime timeIntervalSince1970]*1000
                       ];
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/SaveLog</a:Action><a:MessageID>urn:uuid:4b7fd183-850f-4c80-8f38-232875652101</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><SaveLog xmlns=\"http://tempuri.org/\"><logInfo>%@</logInfo></SaveLog></s:Body></s:Envelope>",logInfo];
    NSString *webString=[self NetInterface:bodyMessage];
}

#pragma mark-
#pragma mark  BULK 保存Bulk调方配方信息
#pragma mark-
//保存Bulk调方配方信息
//string SaveBulkRecipeInfo(int Repair,string xriteNO,int FirstDyeCotton,string Batch_NO, string User_ID, string Recipe_NO, double NA2CO3, double NA2SO4, int Keep_Temperature_Time, string Group_ID, string ChemicalIDStr, string UsageStr, string OldUsageStr)

-(NSString *)SaveBulkRecipeInfo:(NSString *)Repair xriteNO:(NSString *)xriteNO FirstDyeCotton:(NSString *)FirstDyeCotton Batch_NO:(NSString *)Batch_NO User_ID:(NSString *)User_ID Recipe_NO:(NSString *)Recipe_NO NA2CO3:(NSString *)NA2CO3 NA2SO4:(NSString *)NA2SO4 Keep_Temperature_Time:(NSString *)Keep_Temperature_Time Group_ID:(NSString *)Group_ID ChemicalIDStr:(NSString *)ChemicalIDStr UsageStr:(NSString *)UsageStr OldUsageStr:(NSString *)OldUsageStr
{
    
    
    NSString *jsonString=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/SaveBulkRecipeInfo</a:Action><a:MessageID>urn:uuid:4b7fd183-850f-4c80-8f38-232875652100</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><SaveBulkRecipeInfo xmlns=\"http://tempuri.org/\"><Repair>%@</Repair><xriteNO>%@</xriteNO><FirstDyeCotton>%@</FirstDyeCotton><Batch_NO>%@</Batch_NO><User_ID>%@</User_ID><Recipe_NO>%@</Recipe_NO><NA2CO3>%@</NA2CO3><NA2SO4>%@</NA2SO4><Keep_Temperature_Time>%@</Keep_Temperature_Time><Group_ID>%@</Group_ID><ChemicalIDStr>%@</ChemicalIDStr><UsageStr>%@</UsageStr><OldUsageStr>%@</OldUsageStr></SaveBulkRecipeInfo></s:Body></s:Envelope>",Repair,xriteNO,FirstDyeCotton,Batch_NO,User_ID,Recipe_NO,NA2CO3,NA2SO4,Keep_Temperature_Time,Group_ID,ChemicalIDStr,UsageStr,OldUsageStr];    
    NSString *itemName=@"SaveBulkRecipeInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    if (webString!=nil) {
    
        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        //printf("staticValue myValue=====suny  %s \n",staticValue);
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            jsonString=[self jsonParesModelOne:@"Save" JsonString:UnpasredJsonString];

        }
    }
    NSLog(@"jsonString:%@",jsonString);
    return jsonString;
    
    
}



#pragma mark-----------------------------------------------------------
#pragma mark  BULK 标记OK方
#pragma mark-----------------------------------------------------------


#pragma mark-
#pragma mark  BULK 获取缸的配方信息
#pragma mark-
//获取缸的配方信息
//string GetChemicalInfo(string BatchNO_OR_ColorCode,int Type)
//备注，这个函数 和和上面的一样 只是 type＝＝4



#pragma mark-
#pragma mark  BULK 标记OK方
#pragma mark-
//标记OK方
//string CheckBulkRecipeInfo(string Recipe_NO,string User_ID)
-(NSString *)CheckBulkRecipeInfo:(NSString *)RecipeNOStr GradeStr:(NSString *)GradeStr User_ID:(NSString *)User_ID;
{
    
    
    NSString *jsonString=nil;
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/CheckBulkRecipeInfo</a:Action><a:MessageID>urn:uuid:c567f821-771f-47de-9dfa-78509d6b4460</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><CheckBulkRecipeInfo xmlns=\"http://tempuri.org/\"><RecipeNOStr>%@</RecipeNOStr><GradeStr>%@</GradeStr><User_ID>%@</User_ID></CheckBulkRecipeInfo></s:Body></s:Envelope>",RecipeNOStr,GradeStr,User_ID];    
    NSString *itemName=@"CheckBulkRecipeInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    if (webString!=nil) {

        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        //printf("staticValue myValue=====suny  %s \n",staticValue);
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            jsonString=[self jsonParesModelOne:@"Save" JsonString:UnpasredJsonString];

        }
    }
    NSLog(@"jsonString:%@",jsonString);
    return jsonString;
    
    
}



#pragma mark-----------------------------------------------------------
#pragma mark  BULK 加成
#pragma mark-----------------------------------------------------------

//Bulk 加成
////////////////////////////////////////////////////////////////////
//获取缸的信息

#pragma mark-
#pragma mark  BULK 获取缸的信息
#pragma mark-
//备注，这个函数 和和上面的一样 



#pragma mark-
#pragma mark  BULK 获取缸的配方信息
#pragma mark-
//获取缸的配方信息
//string GetChemicalInfo(string BatchNO_OR_ColorCode,int Type)
//备注，这个函数 和和上面的一样 只是 type＝＝4





#pragma mark-
#pragma mark  BULK 保存Bulk加成配方信息
#pragma mark-
//保存Bulk加成配方信息
//string SaveBulkRecipeInfo(int Repair,string xriteNO,int FirstDyeCotton,string Batch_NO, string User_ID, string Recipe_NO, double NA2CO3, double NA2SO4, int Keep_Temperature_Time, string Group_ID, string ChemicalID

//-(NSString *)SaveBulkRecipeInfo:(NSString *)Repair xriteNO:(NSString *)xriteNO FirstDyeCotton:(NSString *)FirstDyeCotton Batch_NO:(NSString *)Batch_NO User_ID:(NSString *)User_ID Recipe_NO:(NSString *)Recipe_NO NA2CO3:(NSString *)NA2CO3 NA2SO4:(NSString *)NA2SO4 Keep_Temperature_Time:(NSString *)Keep_Temperature_Time Group_ID:(NSString *)Group_ID ChemicalIDStr:(NSString *)ChemicalIDStr UsageStr:(NSString *)UsageStr OldUsageStr:(NSString *)OldUsageStr;
//备注，这个函数 和和上面的一样 






#pragma mark-----------------------------------------------------------
#pragma mark  Bulk  查询
#pragma mark-----------------------------------------------------------

//Bulk  查询
////////////////////////////////////////////////////////////////////


#pragma mark-
#pragma mark  BULK 进度跟踪查询
#pragma mark-
//进度跟踪查询
//string GetBatchTraceInfo(string Batch_NO)
-(NSArray *)GetBatchTraceInfo:(NSString *)Batch_NO;
{
    
    NSArray *itemAry=nil;
    //BatchTraceInfo *batchTraceInfo=[[[BatchTraceInfo alloc]init]autorelease];
    NSString *bodyMessage=[NSString stringWithFormat:
                           @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetBatchTraceInfo</a:Action><a:MessageID>urn:uuid:6ae101ec-c0ab-42dc-9e82-e5f17358f713</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetBatchTraceInfo xmlns=\"http://tempuri.org/\"><Batch_NO>%@</Batch_NO></GetBatchTraceInfo></s:Body></s:Envelope>",Batch_NO];    
    NSString *itemName=@"GetBatchTraceInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    if (webString!=nil) {

        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
             NSArray *batchTraceInfoAry=[self jsonParesModelTwo:@"BatchTraceInfo" JsonString:UnpasredJsonString];
            
            
            itemAry=[self tranformDicToDataObject:@"BatchTraceInfo" dicAry:batchTraceInfoAry];
            
        }
   
        
    }

    return itemAry;
    
}


#pragma mark-
#pragma mark  BULK 品种进度查询
#pragma mark-
//品种进度查询
-(NSArray *)GetTotalProgressInfo:(NSString *)BatchNO_OR_GFNO
{
    
    NSArray *itemAry=nil;
    NSArray *itemAry1=nil;
    
    NSString *bodyMessage=[NSString stringWithFormat:@"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\"><s:Header><a:Action s:mustUnderstand=\"1\">http://tempuri.org/IColor/GetTotalProgressInfo</a:Action><a:MessageID>urn:uuid:9fa101e2-8b13-4668-a226-fde9d629445e</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">http://www.esquel.cn/wmis/WcfColor/Color.svc</a:To></s:Header><s:Body><GetTotalProgressInfo xmlns=\"http://tempuri.org/\"><BatchNO_OR_GFNO>%@</BatchNO_OR_GFNO></GetTotalProgressInfo></s:Body></s:Envelope>",BatchNO_OR_GFNO];    
    NSString *itemName=@"GetTotalProgressInfoResult";
    NSString *webString=[self NetInterface:bodyMessage];
    if (webString!=nil) {

        
        const  char *staticValue=NULL;
        [self searchOneElementWithName1:itemName XMLContent:webString valueBack:&staticValue];
        
        if (staticValue!=NULL) {
            NSString *UnpasredJsonString=[NSString stringWithCString:staticValue encoding:NSUTF8StringEncoding];
            
            itemAry1=[self jsonParesModelTwo:@"TotalProgress" JsonString:UnpasredJsonString];
        }
    }
  
    itemAry=[self tranformDicToDataObject:@"TotalProgressInfo" dicAry:itemAry1];
    

    return itemAry;
    
}
#pragma mark---------------------------------------------------------
#pragma mark  json 解析模型 部分
#pragma mark---------------------------------------------------------
-(NSString *)jsonParesModelOne:(NSString *)aKey JsonString:(NSString *)JsonString
{
    NSString *parsedsonString=nil;
    @synchronized(self) {   

        if (JsonString!=nil&&[JsonString length]!=0) {
            
            NSString *jsonString=JsonString;
            NSDictionary *rootDic=[jsonString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
            parsedsonString=[rootDic objectForKey:aKey];
            //NSLog(@"parsedsonString--- %@",parsedsonString);
        }
        
    }
    return parsedsonString;
    
    
}

//类似结构
//{"BestGroup":[{"Group_ID":"98","Chemical_ID":"205","Chemical_Name":"EVE YELLOW HE4R H/C"},{"Group_ID":"98","Chemical_ID":"195","Chemical_Name":"EVE RED HE7B H/C"}]}
-(NSArray *)jsonParesModelTwo:(NSString *)aKey JsonString:(NSString *)JsonString
{
    NSArray *itemAry=nil;
    @synchronized(self) {   

        if (JsonString!=nil&&[JsonString length]!=0) {
            
            NSDictionary *rootDic=[JsonString objectFromJSONStringWithParseOptions:JKParseOptionNone];
            itemAry=[rootDic objectForKey:aKey];
            
        }
        NSLog(@"******itemAry %d",itemAry.count);
    }
    return itemAry;
    
}


//use sbjson framwork
//-(NSArray *)jsonParesModelThree:(NSString *)aKey JsonString:(NSString *)JsonString
//{
//    NSArray *itemAry=nil;
//    @synchronized(self) {
//        
//        if (JsonString!=nil&&[JsonString length]!=0) {
//            
//            
//      
//        
//        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//        
//        NSMutableDictionary *rootDic = [jsonParser objectWithString:JsonString];
//
//        itemAry=[rootDic objectForKey:aKey];
//
//        [jsonParser release];
//            
//            
//        }
//        
//        NSLog(@"******itemAry %d  %@",itemAry.count,itemAry);
//    }
//    return itemAry;
    
//}

//支持多个纯数组构成的json
//{"GroupInfo":[{"GroupID":"99"}], "ChemicalInfo":[{"Chemical_Name":"EVE RED HE7B H/C","Chemical_ID":"195","Stuff_Bat":"N/A","R210260040":"3","R210253115":"3"},{"Chemical_Name":"EVE N BLUE HER","Chemical_ID":"187","Stuff_Bat":"R0500502","R210260040":"0,7","R210253115":"0,76"}]},两个数组
//aKey:获得这个类型数组要使用的key。
//-(NSArray *)jsonParesModelThree:(NSArray *)keyAry JsonString:(NSString *)JsonString{
//    NSArray *itemAry=nil;
//    
//    if (JsonString!=nil&&[JsonString length]!=0&&keyAry!=nil) {
//        int count=[keyAry count];
//        for (int i=0;i<count;i++)
//        {
//            NSDictionary *rootDic=[JsonString objectFromJSONStringWithParseOptions:JKParseOptionNone];
//          
//            itemAry=[rootDic objectForKey:[keyAry objectAtIndex:i] ];
//        }
//        
//    }
//    return itemAry;
//    
//}


@end
