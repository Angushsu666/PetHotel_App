import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('隱私政策'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: RichText(
          text: const TextSpan(
            style: TextStyle(
                color: Colors.black, fontSize: 16), // Default text style
            children: <TextSpan>[
              TextSpan(
                  text: '概述\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(
                text:
                    '本隱私政策適用於由捲毛叔叔寵物美容創建的捲毛寶寶寵物服務平台應用程序，此應用為移動裝置提供免費服務，包括但不限於網站或手機APP介面（以下稱本應用）。請詳讀本隱私權條款並於使用捲毛寶寶App服務前確定了解本條款內容。當您瀏覽或使用本應用提供之服務，即表示您同意捲毛寶寶App蒐集、使用與轉載您提供的個人資訊。\n\n',
              ),
              TextSpan(
                  text: '捲毛寶寶App將需要哪些您的個人資訊？\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(
                text:
                    '我們蒐集您提供於本應用上的資訊，包括您所訂購的寵物服務，且對您所完成的消費者心得作紀錄。本應用有可能紀錄您在網站的瀏覽歷程紀錄。捲毛寶寶App 將會蒐集您的個人資訊，包括您的所在位置及所需資訊（可能包含您的姓名、電子郵件、住家地址、電話號碼、與地理位置等），但僅會在您自願提供給我們的時候才使用該資訊。我們蒐集這些資訊僅會用於提供給您有關捲毛寶寶App或其他我們認為您可能有興趣的服務上。我們蒐集這些資訊可能經由：線上訂房、參加活動、訂閱我們的電子報、創立使用者帳戶、傳送"聯絡我們"訊息或其他經由網站所得到的回覆，或經由廣告、調查與直銷。\n\n',
              ),
              // Continue adding all other sections similarly

              TextSpan(
                  text: '我們如何使用您的個人資訊\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(
                text:
                    '受捲毛寶寶App聘僱的第三人或其他捲毛寶寶App集團的成員，在我們職務上執行或提供商品與服務，如付款的流程、發送信件、債款紀錄、調查、數值資訊、宣傳與直間接行銷；如果您不希望訂閱並接收到這些來自捲毛寶寶App的廣告資訊，或不想要我們分享您的個人資訊給這些單位，請email 至 我們公司的官方郵箱 或參考指示以取消訂閱任何您所收到我們寄送的資訊，並要求我們將您的個人資訊中自寄送清單中移除。我們將於收到您的要求的適當期間內，會盡應盡的努力以符合您的期望。請注意您的個人資訊收回任何的第三方授權，將會使我們無法再提供任何服務給您。如具必要性或法律規定，或有合理必要性而需維護捲毛寶寶App的權益或資產，或因任何第三方，或避免任何個人受有侵害的情形下，捲毛寶寶App保留權利以揭露您的個人資訊。如果捲毛寶寶App轉賣或合併予其他主體，將有部分或所有的個人資訊被提供給第三人。\n\n',
              ),
              TextSpan(
                  text: '信息收集與使用\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(
                text:
                    '當您下載並使用本應用時，應用將收集信息。這些信息可能包括：\n*   您的裝置的網際網路協定地址（例如IP地址）\n*   您訪問應用的頁面、訪問的日期和時間、在這些頁面上花費的時間\n*   在應用上花費的時間\n*   您在移動裝置上使用的作業系統 \n\n應用不收集有關您移動裝置精確位置的信息。\n應用會收集您裝置的位置信息，這有助於服務提供者確定您的大致地理位置，並以以下方式使用：\n*   地理定位服務：服務提供者利用位置數據提供個性化內容、相關建議和基於位置的服務。\n*   分析和改進：匯總和匿名的位置數據有助於服務提供者分析用戶行為、識別趨勢，以及提升應用的整體性能和功能。\n*   第三方服務：服務提供者可能會不定期地將匿名位置數據傳輸給外部服務。這些服務幫助他們增強應用並優化他們的產品。\n\n服務提供者可能會使用您提供的信息，不時聯繫您，提供重要信息、必要通知及市場推廣活動。\n為了在使用應用時提供更佳的體驗，服務提供者可能會要求您提供某些個人身份識別信息，包括但不限於捲毛寶寶。服務提供者所要求的信息將被保留，並按照本隱私政策所述使用。\n\n',
              ),
              TextSpan(
                  text: '第三方存取\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(
                text:
                    '只有匯總、匿名的數據會定期傳輸給外部服務，以幫助服務提供者改進應用和他們的服務。服務提供者可能會以本隱私聲明所述的方式與第三方分享您的信息。\n\n請注意，應用使用的第三方服務具有自己的隱私政策，關於數據處理。以下是應用中使用的第三方服務提供者的隱私政策連結：\n\n*   [Google Play 服務](https://www.google.com/policies/privacy/)\n*   [Google Analytics for Firebase](https://firebase.google.com/support/privacy)\n*   [Facebook](https://www.facebook.com/about/privacy/update/printable)\n\n服務提供者可能會披露用戶提供的信息和自動收集的信息：\n\n*   如法律要求，例如遵從傳票或類似的法律程序；\n*   當他們誠信地認為披露是保護他們的權利、保護您的安全或他人的安全、調查欺詐或應對政府請求所必需的；\n*   與他們的可信服務提供商共享，這些服務提供商代表他們工作，不會獨立使用我們披露給他們的信息，並且已同意遵守本隱私聲明中設定的規則。\n\n',
              ),
              TextSpan(
                  text: '數據保留政策\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(
                text:
                    '服務提供者將保留您通過應用提供的用戶提供的數據，只要您使用應用以及之後的合理時間。如果您希望他們刪除您通過應用提供的用戶提供的數據，請通過 angushsu123@gmail.com 與他們聯繫，他們將在合理的時間內做出回應。\n\n',
              ),
              TextSpan(
                  text: '兒童\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(
                text:
                    '服務提供者不使用應用來有意從13歲以下的兒童那裡收集數據或向他們市場推廣。\n\n應用不針對13歲以下的人群。服務提供者不會有意收集13歲以下兒童的個人身份識別信息。如果服務提供者發現13歲以下的兒童提供了個人信息，他們將立即從他們的服務器中刪除這些信息。如果您是父母或監護人，並且您知道您的孩子向我們提供了個人信息，請通過 angushsu123@gmail.com 與服務提供者聯繫，以便他們能夠採取必要的行動。\n\n',
              ),
              TextSpan(
                  text: '安全\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(
                text:
                    '服務提供者關注保護您的信息的機密性。服務提供者提供物理、電子和程序上的保護措施，以保護他們處理和維護的信息。\n\n',
              ),
              TextSpan(
                  text: '隱私權條款更改\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(
                text:
                    '本隱私政策可能會不時更新。服務提供者將通過更新本頁面上的新隱私政策來通知您任何隱私政策的更改。建議您定期查閱本隱私政策以了解任何更改，持續使用被視為批准所有更改。\n本隱私政策自2024年4月16日起生效。\n\n',
              ),
              TextSpan(
                  text: '您的同意\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(
                text: '通過使用應用，您同意按照本隱私政策現在及未來修訂的内容處理您的信息。\n\n',
              ),
              TextSpan(
                  text: '其他網站\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(
                text: '我們的應用可能連結到其他網站。本隱私權條款僅適用於本應用。您應先行閱讀其他網站的隱私權條款再行使用。\n\n',
              ),
              TextSpan(
                  text: '聯絡我們\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(
                  text:
                      '如果您在使用應用時對隱私有任何疑問，或對實踐有疑問，請通過 angushsu123@gmail.com 與服務提供者聯繫。\n\n'),
              // ),  TextSpan(
              // text: '我們如何使用您的個人資訊\n',
              // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              // TextSpan(
              // text: '\n\n',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
