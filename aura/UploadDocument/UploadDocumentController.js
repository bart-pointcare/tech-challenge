({
    doInit : function(component, event, helper) {
        
        // decode JWT from email link
        var action = component.get("c.Init");
        action.setParams({
            "token": component.get("v.token")
        });
        action.setCallback(this, function(response){
            
            // set data attribute 
            var Data = JSON.parse(action.getReturnValue());
            component.set("v.data", Data.ContentMap);
        });
        $A.enqueueAction(action);
        
    },
    
    // close window/tab when "Done"
    done : function(component) {
        window.close();
    }
    
})