## 1 implement-dokupaySDK

**1.1.	Inisial DokuPay framework ke dalam projek**
* Salin folder Dokupay yang berisi Dokupay.framework dan DokuPay.bundle ke dalam folder projek.
* Pilih projek dan tekan control+click, pilih ‘Add Files to …’ arahkan ke folder DokuPay yang telah di di salin.
* Pastikan DokuPay.framework sudah ada di list ‘General’ -> ‘Linked Frameworks and Libraries’.
* Pastikan DokuPay.bundle sudah ada di list ‘Build Phases’ -> ‘Copy Bundle Resources’.
* Panggil class DokuPay.h dari framework dengan ‘#import <DokuPay/DokuPay.h>’
* Tambahkan ‘<DokuPayDelegate>’ di interface class projek.

**1.2.	Dependencies**
* Tambahkan SVProgressHUD (https://github.com/SVProgressHUD/SVProgressHUD) ke projek.
* Pastikan SVProgressHUD.bundle sudah ada di list ‘Build Phases’ -> ‘Copy Bundle Resources’.

**1.3.	DKPAymentItem**
* Contoh Inisial DKPaymentItem :
```ObjC
-(DKPaymentItem*)getPaymentItem
{
DKPaymentItem *paymentItem = [[DKPaymentItem alloc] init];
NSArray *basket = @[@{@"name":@"sayur",@"amount":@"10000.00",@"quantity":@"1",@"subtotal":@"10000.00"},
@{@"name":@"buah",@"amount":@"10000.00",@"quantity":@"1",@"subtotal":@"10000.00"}];

paymentItem.dataAmount = @"15000.00";
paymentItem.dataBasket = basket;
paymentItem.dataImei = [self getMyUUID];
paymentItem.dataCurrency = @"360";
paymentItem.dataMerchantChain = @"NA";
paymentItem.dataSessionID = … session ID app merchant ... ;
paymentItem.dataTransactionID = … kode transaksi merchant ...;
paymentItem.isProduction = false;
paymentItem.dataMerchantCode = MerchantSharedMallID;
paymentItem.publicKey = MerchantPublicKey;
paymentItem.sharedKey = MerchantSharedKey;
paymentItem.dataWords = [paymentItem generateWords];
paymentItem.mobilePhone = @"08123123112";

return paymentItem;
}
```


**1.4. UUID device**
* Mendapatkan UUID (device id)
```ObjC
-(NSString*)getMyUUID
{
NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
return [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
}
```


## 2. Implementasi DokuPay Payment Channel

**2.1.	Credit Card**
* Tambahkan seting ke dalam file .plist projek (App Transport Security policy)
```XML
...
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
<key>NSExceptionDomains</key>
<dict>
<key>nsiapay.com</key>
<dict>
<key>NSIncludesSubdomains</key>
<true/>
<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
<true/>
</dict>
</dict>
</dict>
...
```
* Di action/selector method projek, ketika pilihan payment Credit Card dipilih biarkan sdk DokuPay melanjutkan nya :
```ObjC
...
DKPaymentItem *paymentItem = … inisial DKPaymentItem ...;    
[[DokuPay sharedInstance] setPaymentItem:paymentItem];
[[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeCC];
[[DokuPay sharedInstance] setDelegate:self];
[[DokuPay sharedInstance] presentPayment];
...
```

* Class projek bisa mendapatkan response dari sdk DokuPay dengan membuat method :
```ObjC
-(void)onDokuPaySuccess:(NSDictionary *)dictData
{
NSLog(@"catch Success delegate : %@", dictData);
}

-(void)onDokuPayError:(NSError *)error
{
NSLog(@"catch Error delegate : %@", error);
}
```
* Setelah response didapat projek bisa melakukan charge :
```ObjC
NSURL *URL = [NSURL URLWithString:@"http://crm.doku.com/doku-library/example-payment-mobile/merchant-example.php
"];

NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
[request setHTTPMethod:@"POST"];

NSString *params = [NSString stringWithFormat:@"data=%@", [self jsonStringWithPrettyPrint:NO fromDictionary:dictData]];

NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
[request setHTTPBody:data];

AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

[SVProgressHUD dismiss];

[self popError:error withReponse:responseObject];
}];
[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
[SVProgressHUD showWithStatus:@"Mohon Tunggu..."];
[task resume];
```


**2.2.	Virtual Account**
* Sederhana, di action/selector method projek, ketika pilihan payment Virtual Account dipilih :
```ObjC
...
DKPaymentItem *paymentItem = … inisial DKPaymentItem ...;    
[[DokuPay sharedInstance] setPaymentItem:paymentItem];
[[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeVirtualAccount
];
[[DokuPay sharedInstance] setDelegate:self];
[[DokuPay sharedInstance] presentPayment];
...
```
**2.3.	Virtual Account Mini**
* Sederhana, di action/selector method projek, ketika pilihan payment Virtual Account dipilih :
```ObjC
...
DKPaymentItem *paymentItem = … inisial DKPaymentItem ...;    
[[DokuPay sharedInstance] setPaymentItem:paymentItem];
[[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeVirtualMini];
[[DokuPay sharedInstance] setDelegate:self];
[[DokuPay sharedInstance] presentPayment];
...
```
**2.4.	Mandiri ClickPay**
* Di action/selector method projek, ketika pilihan payment Mandiri ClickPay dipilih :
```ObjC
...
DKPaymentItem *paymentItem = … inisial DKPaymentItem ...;    
[[DokuPay sharedInstance] setPaymentItem:paymentItem];
[[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeMandiriClickPay];
[[DokuPay sharedInstance] setDelegate:self];
[[DokuPay sharedInstance] presentPayment];
...
```
* Tambahkan seting .plist berikut :
```XML
…
<dict>
<key>doku.com</key>
<dict>
<key>NSIncludesSubdomains</key>
<true/>
<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
<true/>
</dict>
</dict>
… 
```
*Buat method untuk mendapatkan response dari sdk, langkah selanjutnya app merchant melakukan charge :
```ObjC
-(void)onDokuMandiriPaySuccess:(NSDictionary*)response
{
NSDictionary *dict = @{@"req_challenge_code_3": [response objectForKey:@"challenge3"],
@"req_response_token": [response objectForKey:@"responseValue"],
@"req_challenge_code_2": [response objectForKey:@"challenge2"],
@"req_challenge_code_1": [response objectForKey:@"challenge1"],
@"req_card_number": [response objectForKey:@"debitCard"],
@"req_transaction_id": … kode transaksi merchant ...,
@"req_payment_channel": @"02",
@"req_device_id": … UUID ...};

NSURL *URL = [NSURL URLWithString:@"http://crm.doku.com/doku-library-staging/example-payment-mobile/merchant-mandiri-example.php"];

NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
[request setHTTPMethod:@"POST"];

NSString *params = [NSString stringWithFormat:@"data=%@", [self jsonStringWithPrettyPrint:NO fromDictionary:dict]];

NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
[request setHTTPBody:data];

AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

[SVProgressHUD dismiss];

NSLog(@"mandiri charging : %@", dict);

[self popError:error withReponse:responseObject];
}];

[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
[SVProgressHUD showWithStatus:@"Mohon Tunggu..."];
[task resume];
}
```
* Contoh hasil charging sukses :
```json
{
"res_amount": "10000.00",
"res_approval_code": "3862000000",
"res_bank": "Mandiri Click Pay",
"res_mcn": "411111******1111",
"res_message": "PAYMENT APPROVED",
"res_payment_date": "20160614111626",
"res_request_code": "1406160416263743250",
"res_response_code": "0000",
"res_response_msg": "SUCCES",
"res_session_id": "6a5b6a576e23037b3aba634156fd8124a04bf5c2",
"res_trans_id_merchant": "invoice_1465852586",
"res_transaction_code": "4756b9f939a5c1557bf55d0e3bc8f47b34ca81e4"
}
```
**2.5.	Doku Wallet**
* Seperti biasa, di action/selector method projek, ketika pilihan payment Doku Wallet dipilih :
```ObjC
...
DKPaymentItem *paymentItem = … inisial DKPaymentItem ...;    
[[DokuPay sharedInstance] setPaymentItem:paymentItem];
[[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeWallet];
[[DokuPay sharedInstance] setDelegate:self];
[[DokuPay sharedInstance] presentPayment];
...
```

* Hasil sdk bisa di dapatkan di method delegate DokuPay, buatlah method berikut di class projek :
```ObjC
-(void)onDokuPaySuccess:(NSDictionary *)dictData
{
NSLog(@"catch Success delegate : %@", dictData);
}

-(void)onDokuPayError:(NSError *)error
{
NSLog(@"catch Error delegate : %@", error);
}
```

* Selanjutnya app merchant bisa melakukan charging, seperti berikut :
```ObjC
NSURL *URL = [NSURL URLWithString:@"http://crm.doku.com/doku-library/example-payment-mobile/merchant-example.php
"];

NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
[request setHTTPMethod:@"POST"];

NSString *params = [NSString stringWithFormat:@"data=%@", [self jsonStringWithPrettyPrint:NO fromDictionary:dictData]];

NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
[request setHTTPBody:data];

AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

[SVProgressHUD dismiss];

[self popError:error withReponse:responseObject];
}];
[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
[SVProgressHUD showWithStatus:@"Mohon Tunggu..."];
[task resume];
```
* Contoh charging sukses dengan metode Cash Balance :
```json
{
"res_amount": "15000.00",
"res_data_email": "dokutest1@techgroup.me",
"res_data_mobile_phone": "08123123112",
"res_device_id": "932998EFC771468FB7E78B698A0D7837",
"res_name": "Dokutest1",
"res_pairing_code": "14061604280030827504",
"res_payment_channel": "04",
"res_response_code": "0000",
"res_response_msg": "SUCCESS",
"res_token_code": "0000",
"res_token_id": "7bf6c696cbbce9becde1bb0b96e851cc4ac5ba71",
"res_transaction_id": "7668644704"
}
```

## 3. Implementasi DokuPay Custom Layout
DokuPay telah menyediakan class DKLayout untuk menyimpan setingan layout, berikut contoh inisial dan setingan nya : 
```ObjC
...
dokuLayout = [[DKLayout alloc] init];
dokuLayout.toolbarColor = [UIColor redColor];
dokuLayout.toolbarTextColor = [UIColor greenColor];
dokuLayout.toolbarTintColor = [UIColor whiteColor];
dokuLayout.fieldTextColor = [UIColor blueColor];
dokuLayout.labelTextColor = [UIColor orangeColor];
dokuLayout.BGColor = [UIColor lightGrayColor];
dokuLayout.buttonTextColor = [UIColor yellowColor];
dokuLayout.buttonBGColor = [UIColor darkGrayColor];
...
```
Setelah DKLayout di inisial kan, set ke class SDK seperti berikut :
```ObjC
...
DKPaymentItem *paymentItem = [self getPaymentItem];
[[DokuPay sharedInstance] setLayout:dokuLayout];
[[DokuPay sharedInstance] setPaymentItem:paymentItem];
[[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeCC];
[[DokuPay sharedInstance] setDelegate:self];
[[DokuPay sharedInstance] presentPayment];
...
```
## 4. Implementasi Virtual Account
Yang membedakan hanya pada parameter payment channel :
```ObjC
[[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeVirtualAccount];
```
berikut contoh lengkap nya :
```ObjC
DKPaymentItem *paymentItem = [[DKPaymentItem alloc] init];
NSArray *basket = @[@{@"name":@"sayur",@"amount":@"10000.00",@"quantity":@"1",@"subtotal":@"10000.00"},
@{@"name":@"buah",@"amount":@"10000.00",@"quantity":@"1",@"subtotal":@"10000.00"}];
paymentItem.dataAmount = @"15000.00";
paymentItem.dataBasket = basket;
paymentItem.dataImei = [self getMyUUID];
paymentItem.dataCurrency = @"360";
paymentItem.dataMerchantChain = @"NA";
paymentItem.dataSessionID = … session ID app merchant ... ;
paymentItem.dataTransactionID = … kode transaksi merchant ...;
paymentItem.isProduction = false;
paymentItem.dataMerchantCode = MerchantSharedMallID;
paymentItem.publicKey = MerchantPublicKey;
paymentItem.sharedKey = MerchantSharedKey;
paymentItem.dataWords = [paymentItem generateWords];
paymentItem.mobilePhone = @"08123123112";

DKPaymentItem *paymentItem = paymentItem;    
[[DokuPay sharedInstance] setPaymentItem:paymentItem];
[[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeVirtualAccount];
[[DokuPay sharedInstance] setDelegate:self];
[[DokuPay sharedInstance] presentPayment];
...
```

## 5. Implementasi Virtual Account Minimarket
Yang membedakan hanya pada parameter payment channel :
```ObjC
[[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeVirtualMini];
```

## 6. Implementasi Regular Credit Card First Tokenization
Yang membedakan hanya parameter customerID dan paymentChannel.
```ObjC
...
[[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeCCFirst];
...
paymentItem.customerID = @"12124";
...
```
Lengkapnya...
```ObjC
DKPaymentItem *paymentItem = [[DKPaymentItem alloc] init];
NSArray *basket = @[@{@"name":@"sayur",@"amount":@"10000.00",@"quantity":@"1",@"subtotal":@"10000.00"},
@{@"name":@"buah",@"amount":@"10000.00",@"quantity":@"1",@"subtotal":@"10000.00"}];

paymentItem.dataAmount = @"15000.00";
paymentItem.dataBasket = basket;
paymentItem.dataImei = [self getMyUUID];
paymentItem.dataCurrency = @"360";
paymentItem.dataMerchantChain = @"NA";
paymentItem.dataSessionID = … session ID app merchant ... ;
paymentItem.dataTransactionID = … kode transaksi merchant ...;
paymentItem.isProduction = false;
paymentItem.dataMerchantCode = MerchantSharedMallID;
paymentItem.publicKey = MerchantPublicKey;
paymentItem.sharedKey = MerchantSharedKey;
paymentItem.dataWords = [paymentItem generateWords];
paymentItem.mobilePhone = @"08123123112";
paymentItem.customerID = @"12124";
```

## 7. Implementasi Regular Credit Card Second Tokenization
Tambahkan parameter tokenPayment di DKPaymentItem dan ubah nilai paymentChannel.
```ObjC
...
[[DokuPay sharedInstance] setPaymentChannel:DokuPaymentChannelTypeCCSecond];
...
paymentItem.tokenPayment = @"0bea1c1c653dbc8e1e6c24155c629fe237325a06";
...
```

## 8. Other
If you seem warning from SDK about built sdk greater than target development your app, and you do not want see again please add into Build Setting -> Other Linker Flags: "-w".
