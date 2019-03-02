import org.apache.camel.*;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.impl.DefaultCamelContext;
import org.apache.camel.model.language.MethodCallExpression;

class Proxy {
    public static void main(String[] args) throws Exception {
        CamelContext context = new DefaultCamelContext();
        context.addRoutes(new Routes());
        context.start();
        Thread.sleep(1000000);
    }
}

class Routes extends RouteBuilder {

    @Override
    public void configure() {
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

