public class UploadDocumentController {

    // link to site to upload files
    // link URL hardcoded for prototype simplicity
    public static String URL = 'https://tem-developer-edition.na162.force.com/documentrequest/s/';
    
    @AuraEnabled
    public static String Init(String token) {
        return JSON.serialize(new UploadDocumentInput(token));
    }
    
    // queries custom metadata for uploaded file options
    @AuraEnabled
    public static String GetOptions() {
        return JSON.serialize([SELECT DeveloperName, Label, Selected__c FROM Document_Request_Option__mdt ORDER BY Label]);
    }

	// sends email to contact with link to upload documents
    @AuraEnabled
    public static void SendEmail(String Payload, String Language, String Email) {
        
        // create link for the email
        // payload created in component includes link info
        // if there is no preferred language, use English 
        String link = URL + '?language=' + (Language == null ? 'en_US' : Language) + '&token=' + getJWT(Payload);
        
        // send email via SendGrid
        // URL shortening is necessary for SMS and included here to make note
        SendGridService.SendLinkEmail(BitlyService.shorten(link), Language, Email);
    }
    
    // notify representative when patient uploads a file
    @AuraEnabled
    public static void NotifyOnUpload(String ContactId, String UserId, String DocumentLabel) {
        // Get the Id for DocumentUploaded notification
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='DocumentUploaded'];
        
      	// Get the contact name to include in the notification
      	Contact c = [SELECT Id, Name FROM Contact WHERE Id = :ContactId LIMIT 1];
        
        // Create a new custom notification and set parameters
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(ContactId);

        // Notification text indicates WHO uploaded WHAT
        notification.setTitle('Uploaded Document');
        notification.setBody(c.Name + ' uploaded a document: ' + DocumentLabel);
        
        // send the notification
        notification.send(new Set<String>{ UserId });
    }
    
    // turn JSON serialized Payload into serialized JWT
    public static String getJWT(String Payload) {
        Map<String,Object> claims = (Map<String,Object>)JSON.deserializeUntyped(Payload);
        Auth.JWT jwt = new Auth.JWT();
        jwt.setAdditionalClaims(claims);
        Auth.JWS signedToken = new Auth.JWS(jwt, 'PointCare');
        String serializedToken = signedToken.getCompactSerialization();
        return serializedToken;
        
    }
    
    // wrapper class to decode JWT content
    // JWT source verification is needed but left out of prototype
    public class UploadDocumentInput {
        public Object ContentMap;
        public UploadDocumentInput(String Token) {
            
            // only the second of three JWT components holds the relevant information
	        List<String> tokenParts = Token.split('[.]');
            ContentMap = JSON.deserializeUntyped(
                EncodingUtil.base64decode(tokenParts[1].replace('-','+').replace('_','/')).toString()
            );
        }
    }
    
}