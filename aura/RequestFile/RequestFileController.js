({
	doInit : function(component, event, helper) {
        
        // query custom metadata to retrieve document options
        var action = component.get("c.GetOptions");
        action.setCallback(this, function(response){
            var Options = JSON.parse(action.getReturnValue());
            component.set("v.Options", Options);
        });
        $A.enqueueAction(action);
	},
    
    sendSMS : function(component, event, helper) {
        
        // SMS button is for demonstration purposes only
        alert("SMS Sending is not enabled for this prototype.")
    },
    
    sendEmail : function(component, event, helper) {
        
        // create Data object to pass as JWT in email link
        var Data = { 
            contactId: component.get("v.recordId"), 
            userId: $A.get('$SObjectType.CurrentUser.Id'), 
            documentLabels: [] 
        };
        
        // retrieve document options and add those which are selected
        var Options = component.get("v.Options");
        for (const Option of Options) { if(Option.Selected__c) Data.documentLabels.push(Option.DeveloperName); }
        
        // create variable for contact information
        var contactRecord = component.get("v.contactRecord");
        
        // send email using Data object as payload
        var action = component.get("c.SendEmail");
        action.setParams({
            "Payload": JSON.stringify(Data),
            "Language": contactRecord.Preferred_Language__c,
            "Email": contactRecord.Email
        });
        action.setCallback(this, function(response){
            
            // show toast notification that email has been sent
            var emailToast = $A.get("e.force:showToast");
            emailToast.setParams({
                "title": "Email sent",
                "message": "Email has been sent requesting documents."
            });
            emailToast.fire();
            
            // close quick action
            $A.get("e.force:closeQuickAction").fire();
            
        });
        $A.enqueueAction(action);
	}
})