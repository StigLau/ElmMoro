import okhttp3.*;
import org.apache.camel.Header;

import java.io.IOException;

import static org.apache.camel.Exchange.HTTP_PATH;

public class ElmFiles {
    OkHttpClient client = new OkHttpClient();
    final String targetDir;

    public ElmFiles(String targetDir) {
        this.targetDir = targetDir;
    }

    public String perform(@Header(HTTP_PATH) String theFile
    ) throws IOException {
        Request request = new Request.Builder()
                .url("http://localhost:8000/" + targetDir + "/" + theFile)
                .build();
        Response response = null;
        try {
            response = client.newCall(request).execute();
            String result = response.body().string();
            return result;
        } finally {
            response.body().close();
            response.close();
        }
    }
}
