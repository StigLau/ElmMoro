import org.apache.camel.*;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.impl.DefaultCamelContext;
import org.apache.camel.model.language.MethodCallExpression;
import org.eclipse.jetty.http.HttpStatus;

import java.io.IOException;
import java.net.ConnectException;

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
                .setBody(new MethodCallExpression(new KompostFiles()))
                .removeHeaders("*");

        restConfiguration().port(8080);
        rest("/src").get("/{file}").produces("text/html")
                .route()
                .setBody(new MethodCallExpression(new ElmFiles("src")))
                .removeHeaders("*");

        rest("/kompost").consumes("application/json").produces("application/json")
                .get("/{file}").route()
                .setBody(new MethodCallExpression(new KompostFiles()))
        ;

        rest("/kompost").post("/{file}").route()
                .setBody(new MethodCallExpression(new KompostFiles()))
        ;
    }
}

