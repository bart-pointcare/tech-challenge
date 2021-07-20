({
    doInit : function(component, event, helper) {

        // create serialized object document label and contact info
        // community user does not have access to contact records
        // contact reference is created by trigger via fileFieldValue
        // also including the document label to overwrite the filename
        var fileFieldValue = {
            FileName: component.get("v.label"),
            LinkedEntityId: component.get("v.contactId")
        };
        component.set("v.fileFieldValue", JSON.stringify(fileFieldValue));

        // custom label translation is done by reference
        // needed because custom labels are passed dynamically
        var labelReference = $A.getReference("$Label.c." + component.get("v.label"));
        component.set("v.tempLabelAttr", labelReference);
        var dynamicLabel = component.get("v.tempLabelAttr");
    },
    
    // community user has uploaded file(s)
    handleUploadFinished : function(component, event, helper) {
        
        // get uploaded file info from event and append attribute
        var uploadedFiles = component.get("v.uploadedFiles");
        var newUploadedFiles = event.getParam("files");
        newUploadedFiles.forEach(file => uploadedFiles.push(file));
        component.set("v.uploadedFiles", uploadedFiles);
        
        // notify representative that patient has uploaded file(s)
        var action = component.get("c.NotifyOnUpload");
        action.setParams({
            "ContactId": component.get("v.contactId"),
            "UserId": component.get("v.userId"),
            "DocumentLabel": component.get("v.label")
        });
        $A.enqueueAction(action);
    },
    
    // removing an uploaded document is not part of the prototype
    // but is included for demonstration
    PillClick : function(component) {
        alert("File removal out of scope for this prototype.");
    }
})