import okhttp3.*;
import org.apache.camel.Body;
import org.apache.camel.Exchange;
import org.apache.camel.Header;

import java.io.IOException;

import static org.apache.camel.Exchange.HTTP_PATH;

public class KompostFiles {
    //Basic aHJpb25zaW9uZXNzaWNlcHJlZGlkc3RyOjE4NWQ4MDgyMzE0MGY4Yzg0NDk5YTU3OTkxNGNkZDZhNTIzYjM5ZjA=
    //Before hrionsionessicepredidstr:185d80823140f8c84499a579914cdd6a523b39f0
    //Now stlyindedifeldreightermi:42f7afe856973fe24d6699801721854a200b0213
    //Basic c3RseWluZGVkaWZlbGRyZWlnaHRlcm1pOjQyZjdhZmU4NTY5NzNmZTI0ZDY2OTk4MDE3MjE4NTRhMjAwYjAyMTM=
    public static final String auth = "Basic c3RseWluZGVkaWZlbGRyZWlnaHRlcm1pOjQyZjdhZmU4NTY5NzNmZTI0ZDY2OTk4MDE3MjE4NTRhMjAwYjAyMTM=";
    public static final String url = "https://e82fe3cb-c41e-4b17-b0d1-a5f3d0bcb833-bluemix.cloudant.com/kompost/";

    OkHttpClient client = new OkHttpClient();

    public String perform(@Header(HTTP_PATH) String theFile,
                          @Header(Exchange.HTTP_METHOD) String httpMethod,
                          @Body String body
    ) throws IOException {
        Request.Builder requestBuilder = new Request.Builder();
        if (httpMethod.equals("POST")) {
            requestBuilder = requestBuilder.post(RequestBody.create(MediaType.parse("application/json"), body));
        }
        //Ny migration
        //requestBuilder.header("Authorization", "Basic cmRseWluc2hlaWdoZXJlY3R1cmRzb2NrOjAyNzc4ZjE5Y2Y0ZmIyMTVmMzViNjQyYWI0ZDc1YWZlNDYxY2YyN2Y=")
        //.url("https://2ef36937-3285-4d66-8134-196d8f1c9051-bluemix.cloudant.com/migration/" + theFile);

        //Gammel Kompost
        requestBuilder.header("Authorization", auth)
                .url(url + theFile);

        Response response = null;
        try {
            response = client.newCall(requestBuilder.build()).execute();
            String result = response.body().string();
            return result;
        } finally {
            response.body().close();
            response.close();
        }
    }
}
