import okhttp3.*;
import org.apache.camel.*;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.impl.DefaultCamelContext;
import org.apache.camel.model.language.MethodCallExpression;
import org.eclipse.jetty.http.HttpStatus;
import java.io.IOException;
import java.net.ConnectException;
import java.util.List;
import java.util.Map;
import static org.apache.camel.Exchange.CONTENT_TYPE;
import static org.apache.camel.Exchange.HTTP_PATH;

class Proxy {
    public static void main(String[] args) throws Exception {
        CamelContext context = new DefaultCamelContext();
        context.addRoutes(new Routes());
        context.start();
        Thread.sleep(1000000);
    }
}

class Routes extends RouteBuilder {

    final String ERROR_ELM_NOT_STARTED = "{\"status\":\"Integration failed. Have you started elm?\"}";
    final String ERROR_ELM_SERVER_ERRONOUS = "{\"status\":\"Integration failed. Elm not started correctly, or other issue\"}";

    @Override
    public void configure() {
        onException(ConnectException.class)
                .handled(true)
                .removeHeaders("*")
                .setHeader(Exchange.HTTP_RESPONSE_CODE, constant(HttpStatus.INTERNAL_SERVER_ERROR_500))
                .setBody(constant(ERROR_ELM_NOT_STARTED));

        onException(IOException.class)
                .handled(true)
                .removeHeaders("*")
                .setHeader(Exchange.HTTP_RESPONSE_CODE, constant(HttpStatus.INTERNAL_SERVER_ERROR_500))
                .setBody(constant(ERROR_ELM_SERVER_ERRONOUS));

        from("jetty:http://0.0.0.0:8001/_elm/?matchOnUriPrefix=true")
                .setBody(new MethodCallExpression(new ElmFiles("_elm")));

        from("jetty:http://0.0.0.0:8001/src/?matchOnUriPrefix=true")
                .setBody(new MethodCallExpression(new ElmFiles("src")));

        from("jetty:http://0.0.0.0:8001/kompost/?matchOnUriPrefix=true")
                .process(fetchFilesAdapter())
                .removeHeaders("*", CONTENT_TYPE, "ETag")
        ;

        restConfiguration().port(8080);
        rest("/src").get("/{file}").produces("text/html")
                .route()
                .setBody(new MethodCallExpression(new ElmFiles("src")))
                .removeHeaders("*");
    }

    private Processor fetchFilesAdapter() {
        return exchange -> {
            Message in = exchange.getIn();
            String httpMethod = in.getHeader(Exchange.HTTP_METHOD, String.class);
            String theFile = in.getHeader(Exchange.HTTP_PATH, String.class);
            String body = in.getBody(String.class);
            Response result = FetchFiles(theFile, httpMethod, body);
            if(result.networkResponse().isSuccessful()) {
                Message out = exchange.getOut();
                out.setBody(result.body().string());
                Map<String, List<String>> headers = result.headers().toMultimap();
                for (String headerName : headers.keySet()) {
                    out.setHeader(headerName, headers.get(headerName));
                }
            }
            result.body().close();
            result.close();
        };
    }

    private Response FetchFiles(@Header(HTTP_PATH) String theFile, @Header(Exchange.HTTP_METHOD) String httpMethod, @Body String body) throws IOException {
        Request.Builder requestBuilder = new Request.Builder();
        if (httpMethod.equals("POST")) {
            requestBuilder = requestBuilder.post(RequestBody.create(MediaType.parse("application/json"), body));
        }
        requestBuilder.header("Authorization", KompostFiles.auth)
                .url(KompostFiles.url +theFile);
        OkHttpClient client = new OkHttpClient();
        return client.newCall(requestBuilder.build()).execute();
    }
}

