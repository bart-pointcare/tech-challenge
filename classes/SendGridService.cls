public class SendGridService {
    
    // send email with link to document upload
    // link is passed as a parameter
    public static void SendLinkEmail(String URL, String Language, String Email) {
        
        // create request body from serialized EmailWrapper object
        String jsonBody = json.serialize(new EmailWrapper(URL, Language, Email)).replace('_x','');
        
        // make callout to SendGrid; auth and endpoints hardcoded for prototype
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://api.sendgrid.com/v3/mail/send');
        req.setTimeout(120000);
        req.setHeader('content-type', 'application/json');
        req.setHeader('Authorization', 'Bearer XXXXXXXX');
        req.setBody(jsonBody);
        Http http = new Http();
        HTTPResponse res = http.send(req);
    }
    
    // for prototype simplicity, email template IDs are hardcoded
    public static Map<String, String> TemplateMap = new Map<String, String>{
        'en_US' => 'd-f843aa2d73e74ce7ad29fbad8541e3d2',
        'es' => 'd-549bcb17e99b4d56af29d377cb9e7e09'
    };
    
        /*
         * Wrapper classes for SendGrid API 
         * 
         */
         
    public class EmailWrapper {
        public String template_id { get; set; }
        public List<PersonalizationWrapper> personalizations { get; set; }
        public FromWrapper from_x { get; set; }
        public FromWrapper reply_to { get; set; }
        public EmailWrapper(String URL, String Language, String Email) {
            template_id = TemplateMap.get(Language);
            from_x = new FromWrapper();
            reply_to = new FromWrapper();
            personalizations = new List<PersonalizationWrapper>{ new PersonalizationWrapper(Email, URL) };
        }
    }
    
    // email sender would be professionalized and dynamic in multitenant architecture
    // this sender is for prototype ease and demonstration
    public class FromWrapper {
        public String email { get; set; }
        public String name { get; set; }
        public FromWrapper() {
            email = 'bartdcollins+noreply@gmail.com';
            name = 'Vandelay Medical';
        }
    }

    public class ToWrapper {
        public String email { get; set; }
        public ToWrapper(String iEmail) {
            email = iEmail;
        }
    }

    public class PersonalizationWrapper {
        public List<ToWrapper> to { get; set; }
        public DTDWrapper dynamic_template_data { get; set; }
        public PersonalizationWrapper(String Email, String URL) {
            to = new List<ToWrapper>{new ToWrapper(Email)};
            dynamic_template_data = new DTDWrapper(URL);
        }
    }
    
    public class DTDWrapper {
        public String Button1URL { get; set; }
        public DTDWrapper(String URL) {
            Button1URL = URL;
        }
    }

}
