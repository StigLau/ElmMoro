import okhttp3.*
import org.apache.camel.Header
import java.io.IOException
import org.apache.camel.Exchange.HTTP_PATH

class ElmFiles(internal val targetDir: String) {
    internal var client = OkHttpClient()

    fun perform(@Header(HTTP_PATH) filename: String): String {
        val request = Request.Builder()
                .url("http://localhost:8000/$targetDir/$filename")
                .build()
        client.newCall(request).execute().use {response ->
            return if (response.isSuccessful) {
                response.body()!!.string()
            } else {
                throw IOException("Could perform $filename. ${response.networkResponse()!!.message()}")
            }
        }
    }
}

