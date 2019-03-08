import okhttp3.*
import org.apache.camel.*
import org.apache.camel.builder.RouteBuilder
import org.apache.camel.impl.DefaultCamelContext
import org.apache.camel.model.language.MethodCallExpression
import org.eclipse.jetty.http.HttpStatus
import java.io.IOException
import java.net.ConnectException
import org.apache.camel.Exchange.CONTENT_TYPE
import org.apache.camel.Exchange.HTTP_PATH

internal object Proxy {
    @JvmStatic
    fun main(args: Array<String>) {
        val context = DefaultCamelContext()
        context.addRoutes(Routes())
        context.start()
        Thread.sleep(1000000)
    }
}

internal class Routes : RouteBuilder() {

    val ERROR_ELM_NOT_STARTED = "{\"status\":\"Integration failed. Have you started elm?\"}"
    val ERROR_ELM_SERVER_ERRONOUS = "{\"status\":\"Integration failed. Elm not started correctly, or other issue\"}"

    override fun configure() {
        onException(ConnectException::class.java)
                .handled(true)
                .removeHeaders("*")
                .setHeader(Exchange.HTTP_RESPONSE_CODE, constant(HttpStatus.INTERNAL_SERVER_ERROR_500))
                .setBody(constant(ERROR_ELM_NOT_STARTED))

        onException(IOException::class.java)
                .handled(true)
                .removeHeaders("*")
                .setHeader(Exchange.HTTP_RESPONSE_CODE, constant(HttpStatus.INTERNAL_SERVER_ERROR_500))
                .setBody(constant(ERROR_ELM_SERVER_ERRONOUS))

        from("jetty:http://0.0.0.0:8001/_elm/?matchOnUriPrefix=true")
                .setBody(MethodCallExpression(ElmFiles("_elm")))

        from("jetty:http://0.0.0.0:8001/src/?matchOnUriPrefix=true")
                .setBody(MethodCallExpression(ElmFiles("src")))

        from("jetty:http://0.0.0.0:8001/kompost/?matchOnUriPrefix=true")
                .process(fetchFilesAdapter())
                .removeHeaders("*",
                        CONTENT_TYPE,
                        "Cache-Control",
                        "ETag"
                )

        restConfiguration().port(8080)
        rest("/src").get("/{file}").produces("text/html")
                .route()
                .setBody(MethodCallExpression(ElmFiles("src")))
                .removeHeaders("*")
    }

    private fun fetchFilesAdapter(): Processor =
            Processor { exchange ->
                val `in` = exchange.getIn()
                val httpMethod = `in`.getHeader(Exchange.HTTP_METHOD, String::class.java)
                val theFile = `in`.getHeader(Exchange.HTTP_PATH, String::class.java)

                val request: Request =
                        if (httpMethod == "GET") {
                            Request.Builder().get()
                                    .url(KompostFiles.url + theFile)
                                    .header("Authorization", KompostFiles.auth)
                                    .build()
                        } else {
                            OtherBuild(
                                    theFile,
                                    httpMethod,
                                    `in`.getHeader(Exchange.CONTENT_TYPE, String::class.java) ?:"",
                                    `in`.getBody(String::class.java))
                        }

                OkHttpClient().newCall(request).execute().use { response ->
                    val out = exchange.getOut()
                    if (response.networkResponse()!!.isSuccessful) {
                        out.setBody(response.body()!!.string())
                        val headers = response.headers().toMultimap()
                        for (headerName in headers.keys) {
                            out.setHeader(headerName, headers[headerName])
                        }
                    } else {
                        out.setBody("This sucked! " + response.networkResponse()!!.message())
                        out.setFault(true)
                    }
                    response.close()
                }
            }

    private fun OtherBuild(
            @Header(HTTP_PATH) theFile: String,
            @Header(Exchange.HTTP_METHOD) httpMethod: String,
            @Header(Exchange.CONTENT_TYPE) contentType: String,
            @Body body: String): Request =
            Request.Builder().method(
                    httpMethod,
                    RequestBody.create(MediaType.parse(contentType), body))
                    .header("Authorization", KompostFiles.auth)
                    .url(KompostFiles.url + theFile)
                    .build()
}
