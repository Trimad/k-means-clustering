import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;



class Network {

  JSONArray json_array;

  HttpClient httpClient = HttpClient.newBuilder()
    .version(HttpClient.Version.HTTP_1_1)
    .connectTimeout(Duration.ofSeconds(10))
    .build();

  Network() {
  }

  void Get(String url) throws IOException, InterruptedException {
    HttpRequest request = HttpRequest.newBuilder()
      .GET()
      .uri(URI.create(url))
      .build();

    HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

    // print response headers
    HttpHeaders headers = response.headers();
    headers.map().forEach((k, v) -> System.out.println(k + ":" + v));

    JSONObject json = parseJSONObject(response.body());
    json_array = json.getJSONObject("body").getJSONArray("tickers");

    System.out.println(json_array.getJSONObject(0).get("todaysChangePerc"));
  }

  void InitPoints() {

    float xMin = Float.MAX_VALUE;
    float xMax = 0;
    float yMin = Float.MAX_VALUE;
    float yMax = 0;
    float zMin = Float.MAX_VALUE;
    float zMax = 0;

    for (int i = 0; i < json_array.size(); i++) {

      float x = Float.parseFloat(json_array.getJSONObject(i).get("todaysChangePerc").toString());
      if (x==0)
        continue;
      if (x < xMin) {
        xMin = x;
      }
      if (x > xMax) {
        xMax = x;
      }
      //xMin = (x < xMin) ? x : xMin;
      //xMax = (x > xMax) ? x : xMax;
      float y = Float.parseFloat(json_array.getJSONObject(i).getJSONObject("min").get("o").toString());
      if (y==0)
        continue;

      yMin = (y < yMin) ? y : yMin;
      yMax = (y > yMax) ? y : yMax;
      float z = Float.parseFloat(json_array.getJSONObject(i).getJSONObject("min").get("c").toString());
      if (z==0)
        continue;

      zMin = (z < zMin) ? z : zMin;
      zMax = (z > zMax) ? z : zMax;
    }

    for (int i = 0; i < json_array.size(); i++) {
      float x = Float.parseFloat(json_array.getJSONObject(i).get("todaysChangePerc").toString());
      if (x==0)
        continue;

      x = map(x, xMin, xMax, 0, 1);
      float y = Float.parseFloat(json_array.getJSONObject(i).getJSONObject("min").get("o").toString());
      if (y==0)
        continue;

      y=map(y, yMin, yMax, 0, 1);
      float z = Float.parseFloat(json_array.getJSONObject(i).getJSONObject("min").get("c").toString());
      if (z==0)
        continue;

      z=map(z, zMin, zMax, 0, 1);

      //println("x: " + x + ", y: " + y + ", z: " + z);
      points.add(new Datum(-1, new float[] {x, random(0, 1), random(0, 1)}));
    }
    println("xMin: " + xMin + ", xMax: " + xMax);
    println("yMin: " + yMin + ", yMax: " + yMax);
    println("zMin: " + zMin + ", zMax: " + zMax);
  }
}
