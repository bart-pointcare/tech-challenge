// creates short URL from Bit.ly
public class BitlyService {

    public static String shorten(String url) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api-ssl.bitly.com/v4/shorten'); // endpoint hardcoded only for prototype
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer XXXXXXX'); // authentication is hard coded for prototype simplicity
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(new Map<String, Object>{
            'domain' => 'bit.ly',  
			'long_url' => url,
            'group_guid' => 'Bl7jbBUUSY6' // metadata hardcoded only for prototype
        }));

        HttpResponse res = new Http().send( req );
        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        return (String) response.get('link');
    }
    
}
