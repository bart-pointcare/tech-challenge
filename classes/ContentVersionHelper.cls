public class ContentVersionHelper {
    
    // for before insert trigger
    public static void processGuestRecordUploads_before(List<ContentVersion> CVs) {
        for (ContentVersion cv : CVs) {
            try {

                // only parse fileFieldValue object if it exists
                if (cv.Guest_Record_fileupload__c != null) {
                    
                    // deserialize fileFieldValue object to get document label
                    // document label is used to overwrite filename
                    GuestRecordUploadWrapper UploadInfo = 
                        (GuestRecordUploadWrapper)JSON.deserialize(
                            cv.Guest_Record_fileupload__c, GuestRecordUploadWrapper.class
                        );
                    
                    cv.Title = UploadInfo.FileName;
                    
                }
            } catch (exception e) {
                // error handling not included in prototype
            }
        }
    }
    
    // for after insert trigger
    public static void processGuestRecordUploads_after(List<ContentVersion> CVs) {
        
        // will create a content document links to connect the uploaded file(s) to the patient contact record
        List<ContentDocumentLink> insCDL = new List<ContentDocumentLink>();
        
        // iterate through Content Version records that were just inserted
        for (ContentVersion cv : CVs) {
            try {
                
                // only parse fileFieldValue object if it exists
                if (cv.Guest_Record_fileupload__c != null) {
                    
                    // deserialize fileFieldValue object to get LinkedEntityId (ContactId)
                    GuestRecordUploadWrapper UploadInfo = 
                        (GuestRecordUploadWrapper)JSON.deserialize(
                            cv.Guest_Record_fileupload__c, GuestRecordUploadWrapper.class
                        );
                    
                    // add Content Document Link record to be inserted
                    // use the LinkedEntityId (ContactId) to make the connection 
                    insCDL.add( new ContentDocumentLink(
                        ContentDocumentId = cv.ContentDocumentId, 
                        LinkedEntityId = UploadInfo.LinkedEntityId
                    ) );
                                        
                }
            } catch (exception e) {

            }
        }
        
        // insert collection of Content Document Link records
        insert insCDL;
        
    }
    
    // wrapper class for fileFieldValue object
    public class GuestRecordUploadWrapper {
        public Id LinkedEntityId;
        public String FileName;
    }
}