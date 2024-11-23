package com.example.senior_design;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.os.Bundle;

/**copied from lecture*/
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

/**my imports*/
//import org.json.JSONArray;
//import org.json.JSONObject;
import org.json.simple.parser.*;
import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

import java.io.IOException;
import java.time.DayOfWeek;
import java.util.Calendar;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnSuccessListener;
import com.jjoe64.graphview.GraphView;
import com.jjoe64.graphview.series.DataPoint;
import com.jjoe64.graphview.series.LineGraphSeries;

import java.lang.Double;
import java.util.List;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {
    private double latitude;
    private double longitude;
    private double[] temperatures;
    private double maxTemp;
    private double[] humidity;
    private double[] rain;
    private double maxRain;
    private double[] wind;
    private double maxWind;
    private Context context;
    private int weatherCode; //from weather code
    private int[] config;
    private boolean[] resetGraph;

    //0: temperature:   (0: Fahrenheit  1: Celsius)
    //1: rain:          (0: inches      1: millimeter)
    //2: wind speed:    (0: Mph         1: m/s          2: Km/h     3: Knots)
    //3: graph:         (0: temperature 1: humidity     2: rain     3: wind)
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        /*Button helloButton = (Button) findViewById(R.id.button2);
        helloButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                Log.i("UI Event Handler", "The Hello button was tapped");
                volleyRequest();
            }
        });*/
        context = this;
        temperatures = new double[168];
        humidity = new double[168];
        rain = new double[168];
        wind = new double[168];
        config = new int[]{0, 0, 0, 0};
        resetGraph = new boolean[]{false, false, false, false, false}; //unitChange, temp, humi, rain, wind
        setUnits();
        printDate();
        //volleyRequest(); //calls ParseInput, calls output to Screen
        //printGraph(); xsvf
        //printCity();
        volleyRequest();

        Button clearButton = (Button) findViewById(R.id.button_clr);
        clearButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                Log.i("UI Event Handler", "The temp button was tapped");
                config[3] = 0;
                printGraph(config[3]);
                for(int index = 0; index < 5; index++){
                    resetGraph[index] = false;
                }
            }
        });
        Button tempButton = (Button) findViewById(R.id.button_tmp);
        tempButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                Log.i("UI Event Handler", "The temp button was tapped");
                config[3] = 1;
                printGraph(config[3]);
            }
        });
        Button humiButton = (Button) findViewById(R.id.button_hum);
        humiButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                Log.i("UI Event Handler", "The humi button was tapped");
                config[3] = 2;
                printGraph(config[3]);
            }
        });
        Button rainButton = (Button) findViewById(R.id.button_rain);
        rainButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                Log.i("UI Event Handler", "The rain button was tapped");
                config[3] = 3;
                printGraph(config[3]);
            }
        });
        Button windButton = (Button) findViewById(R.id.button);
        windButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                Log.i("UI Event Handler", "The wind button was tapped");
                config[3] = 4;
                printGraph(config[3]);
            }
        });

        Button tmpUnit = (Button) ((TableRow)((TableLayout) findViewById(R.id.unit_tmp)).getChildAt(0)).getChildAt(0);
        tmpUnit.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                Log.i("UI Event Handler", "The tmpUnit button was tapped");
                config[0] = (config[0] + 1)%2;
                setUnits();
                //printCity();
                volleyRequest();
            }
        });
        Button rainUnit = (Button) ((TableRow)((TableLayout) findViewById(R.id.unit_tmp)).getChildAt(1)).getChildAt(0);
        rainUnit.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                Log.i("UI Event Handler", "The rainUnit button was tapped");
                config[1] = (config[1] + 1)%2;
                setUnits();
                //printCity();
                volleyRequest();
            }
        });
        Button windUnit = (Button) ((TableRow)((TableLayout) findViewById(R.id.unit_tmp)).getChildAt(2)).getChildAt(0);
        windUnit.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view){
                Log.i("UI Event Handler", "The rainUnit button was tapped");
                config[2] = (config[2] + 1)%4;
                setUnits();
                //printCity();
                volleyRequest();
            }
        });
    }

    private void setUnits(){
        TextView text = (TextView) ((TableRow)((TableLayout) findViewById(R.id.data)).getChildAt(1)).getChildAt(0);
        Button graph = (Button) ((TableRow)((TableLayout) findViewById(R.id.data)).getChildAt(9)).getChildAt(0);
        Button unit = (Button) ((TableRow)((TableLayout) findViewById(R.id.unit_tmp)).getChildAt(0)).getChildAt(0);
//        if(config[0] == 0){
//            text.setText("Temperature(°F)");
//            graph.setText("Temp(°F)");
//            unit.setText("°C");
//        }
//        else{
//            text.setText("Temperature(°C)");
//            graph.setText("Temp(°C)");
//            unit.setText("°F");
//        }
        text.setText("Heart Rate (BPM)");
        graph.setText("Heart");
        unit.setText("BPM");
        text = (TextView) ((TableRow)((TableLayout) findViewById(R.id.data)).getChildAt(5)).getChildAt(0);
        graph = (Button) ((TableRow)((TableLayout) findViewById(R.id.data)).getChildAt(9)).getChildAt(2);
        unit = (Button) ((TableRow)((TableLayout) findViewById(R.id.unit_tmp)).getChildAt(1)).getChildAt(0);
        if(config[1] == 0){
//            text.setText("Rain(in)");
//            graph.setText("Rain(in)");
            unit.setText("mm");
        }
        else{
//            text.setText("Rain(mm)");
//            graph.setText("Rain(mm)");
            unit.setText("in");
        }
        text.setText("y-axis");
        graph.setText("Y");
//        text = (TextView) ((TableRow)((TableLayout) findViewById(R.id.data)).getChildAt(7)).getChildAt(0);
//        graph = (Button) ((TableRow)((TableLayout) findViewById(R.id.data)).getChildAt(9)).getChildAt(3);
//        unit = (Button) ((TableRow)((TableLayout) findViewById(R.id.unit_tmp)).getChildAt(2)).getChildAt(0);
//        if(config[2] == 0){
//            text.setText("Wind(Mph)");
//            graph.setText("Wind(Mph)");
//            unit.setText("m/s");
//        }
//        else if(config[2] == 1){
//            text.setText("Wind(m/s)");
//            graph.setText("Wind(m/s)");
//            unit.setText("Km/h");
//        }
//        else if(config[2] == 2){
//            text.setText("Wind(Km/h)");
//            graph.setText("Wind(Km/h)");
//            unit.setText("Knots");
//        }
//        else if(config[2] == 3){
//            text.setText("Wind(Knots)");
//            graph.setText("Wind(Knots)");
//            unit.setText("Mph");
//        }
    }

    private void printTop() {
        TextView text = (TextView) findViewById(R.id.text_Degrees);
//        text.setText(temperatures[0] + "°");
        text.setText(temperatures[0] + "");


        double low = temperatures[0];
        double high = low;
        for (int index = 1; index < 168; index++) {
            if (low > temperatures[index]) {
                low = temperatures[index];
            }
            if (high < temperatures[index]) {
                high = temperatures[index];
            }
        }
        text = (TextView) findViewById(R.id.text_HL);
//        text.setText("H:" + high + "° L:" + low+"°");
        text.setText("H:" + high + "L:" + low);

        String weather;
        switch (weatherCode) {
            case 0:
                weather = "clear skies";
                break;
            case 1:
                weather = "mainly clear";
                break;
            case 2:
                weather = "partly cloudy";
                break;
            case 3:
                weather = "overcast";
                break;
            case 45:
                weather = "fog";
                break;
            case 48:
                weather = "depositing rime fog";
                break;
            case 51:
                weather = "light drizzle";
                break;
            case 53:
                weather = "moderate drizzle";
                break;
            case 55:
                weather = "dense drizzle";
                break;
            case 56:
                weather = "light freezing drizzle";
                break;
            case 57:
                weather = "dense freezing drizzle";
                break;
            case 61:
                weather = "slight rain";
                break;
            case 63:
                weather = "moderate rain";
                break;
            case 65:
                weather = "heavy rain";
                break;
            case 66:
                weather = "light freezing rain";
                break;
            case 67:
                weather = "heavy freezing rain";
                break;
            case 71:
                weather = "slight snow";
                break;
            case 73:
                weather = "moderate snow";
                break;
            case 75:
                weather = "heavy snow";
                break;
            case 77:
                weather = "snow grains";
                break;
            case 80:
                weather = "slight rain showers";
                break;
            case 81:
                weather = "moderate rain showers";
                break;
            case 82:
                weather = "violent rain showers";
                break;
            case 85:
                weather = "slight snow showers";
                break;
            case 86:
                weather = "heavy snow showers";
                break;
            case 95:
                weather = "thunderstorm";
                break;
            default:
                weather = "";
                break;

        }
        weather = "nickname/group";
        text = (TextView) findViewById(R.id.text_weatherShort);
        text.setText(weather);

        //printCity();
    }

    private void printCity() {
        //https://stackoverflow.com/questions/18221614/how-i-can-get-the-city-name-of-my-current-position
        /*LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        Criteria criteria = new Criteria();
        //String provider = locationManager.getBestProvider(criteria, false);
        //AndroidStudio gave the suppress missing permission suggestion
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return;
        }
        //https://stackoverflow.com/questions/9873190/my-current-location-always-returns-null-how-can-i-fix-this
        List<String> providers = locationManager.getAllProviders();
        Location bestLocation = null;
        for (String provider : providers) {
            /*Location l = locationManager.getLastKnownLocation(provider);
            //ALog.d("last known location, provider: %s, location: %s", provider, l);
            if (l == null) {
                continue;
            }
            if (bestLocation == null
                    || l.getAccuracy() < bestLocation.getAccuracy()) {
                //ALog.d("found best last known location: %s", l);
                bestLocation = l;
            }*//*
            locationManager.requestLocationUpdates(provider, 1000, 0,
                    new LocationListener() {

                        public void onLocationChanged(Location location) {}

                        public void onProviderDisabled(String provider) {}

                        public void onProviderEnabled(String provider) {}

                        public void onStatusChanged(String provider, int status,
                                                    Bundle extras) {}
                    });
            Location location = locationManager.getLastKnownLocation(provider);
            bestLocation = location;
            if(location != null){ break; }
        }
        //Location location = locationManager.getLastKnownLocation(provider);*/
        FusedLocationProviderClient fusLo = LocationServices.getFusedLocationProviderClient(this);

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return;
        }
        fusLo.getLastLocation().addOnSuccessListener(this, new OnSuccessListener<Location>() {
            @Override
            public void onSuccess(Location location) {
                if (location != null) {
                    latitude = (double) (location.getLatitude());
                    longitude = (double) (location.getLongitude());

                    Geocoder geoCoder = new Geocoder(context, Locale.getDefault()); //it is Geocoder
                    StringBuilder builder = new StringBuilder();
                    try {
                        List<Address> address = geoCoder.getFromLocation(latitude, longitude, 1);
            /*int maxLines = address.get(0).getMaxAddressLineIndex();
            for (int i=0; i<maxLines; i++) {
                String addressStr = address.get(0).getAddressLine(i);
                builder.append(addressStr);
                builder.append(" ");
            }
            String finalAddress = builder.toString(); //This is the complete address.*/
                        String city = address.get(0).getLocality();
                        TextView text = (TextView) findViewById(R.id.text_city);
                        text.setText(city);
                        volleyRequest();
                    } catch (IOException e) {
                    } catch (NullPointerException e) {
                    }
                }
            }
        });


        /*if(bestLocation != null){
            latitude = (double) (bestLocation.getLatitude());
            longitude = (double) (bestLocation.getLongitude());

            Geocoder geoCoder = new Geocoder(this, Locale.getDefault()); //it is Geocoder
            StringBuilder builder = new StringBuilder();
            try {
                List<Address> address = geoCoder.getFromLocation(latitude, longitude, 1);
            /*int maxLines = address.get(0).getMaxAddressLineIndex();
            for (int i=0; i<maxLines; i++) {
                String addressStr = address.get(0).getAddressLine(i);
                builder.append(addressStr);
                builder.append(" ");
            }
            String finalAddress = builder.toString(); //This is the complete address.*/
                /*String city = address.get(0).getLocality();
                TextView text = (TextView) findViewById(R.id.text_city);
                text.setText(city);
            } catch (IOException e) {}
            catch (NullPointerException e) {}
        }*/
    }

    private void printGraph(int value){
        //copied from geeksforgeeks and modified (https://www.geeksforgeeks.org/line-graph-view-in-android-with-example/)
        //on below line we are initializing our graph view.
        resetGraph[value] = true;
        GraphView graphView = findViewById(R.id.idGraphView);
        if(value == 0){ graphView.removeAllSeries(); return; }
            double[] array;
        switch(value){
            case 1:
                array = temperatures;
                graphView.getViewport().setMaxY(((Double)maxTemp).intValue() * 1.05);
                break;
            case 2:
                array = humidity;
                graphView.getViewport().setMaxY(100);
                break;
            case 3:
                array = rain;
                graphView.getViewport().setMaxY(((Double)maxRain).intValue() * 1.05);
                break;
            case 4:
                array = wind;
                graphView.getViewport().setMaxY(10);
                graphView.getViewport().setMaxY(((Double)maxWind).intValue() * 1.05);
                break;
            default:
                array = new double[168];
                break;
        }

        DataPoint[] dp = new DataPoint[168];
        if(value >=1 && value <=4){
            for(int index = 0; index < 168; index++){
                dp[index] = new DataPoint((double) index/24, array[index]);
            }
            graphView.getViewport().setMaxX(7);
            graphView.getViewport().setYAxisBoundsManual(true);
            graphView.getViewport().setXAxisBoundsManual(true);
            //on below line we are adding data to our graph view.
            LineGraphSeries<DataPoint> series;
            series = new LineGraphSeries<DataPoint>(dp);

            switch(value){
                case 1:
                    series.setColor(0xffBF5700);
                    break;
                case 2:
                    series.setColor(0xFF6200EE);
                    break;
                case 3:
                    series.setColor(0xff0057BF);
                    break;
                case 4:
                    series.setColor(0xff00BF57);
                    break;
                default:
                    series.setColor(0xffFFFFFF);
                    break;
            }
            graphView.addSeries(series);
            graphView.setHorizontalScrollBarEnabled(true);
        }
        else{
            graphView.removeAllSeries();
        }
        //graphView.setScaleX(100);
        //graphView.setScaleY(168);

        //temp: orange, humidity: purple, rain: blue, wind: green
    }

    private void printDate(){
        int day = Calendar.getInstance().get(Calendar.DAY_OF_WEEK);
        day = (day-3)%7 +1;
        day = (day + 1)%7;
        TableLayout layout = (TableLayout) findViewById(R.id.data);
        TableRow row = (TableRow) layout.getChildAt(0);
        for(int index = 0; index < 7; index++){
            TextView text = (TextView) row.getChildAt(index);
//            text.setText(DayOfWeek.of(day).toString().substring(0,3));
//            day = (day)%7 +1;
            text.setText(index +"");
        }
    }
    private void outputToScreen(){
        //https://stackoverflow.com/questions/3327599/get-all-tablerows-in-a-tablelayout
        TableRow tempRow = (TableRow) findViewById(R.id.text_temp);
        TableRow humidRow = (TableRow) findViewById(R.id.text_humid);
        TableRow rainRow = (TableRow) findViewById(R.id.text_rain);
        TableRow windRow = (TableRow) findViewById(R.id.text_wind);
        for(int day = 0; day < 7; day++){
            double tempAverage = 0;
            double humidAverage = 0;
            double rainAverage = 0;
            double windAverage = 0;
            for(int hour = 0; hour < 24; hour++){
                tempAverage += temperatures[day*24 + hour];
                humidAverage += humidity[day*24 + hour];
                rainAverage += rain[day*24 + hour];
                windAverage += wind[day*24 + hour];
            }
            tempAverage /= 24;
            humidAverage /= 24;
            rainAverage /= 24;
            windAverage /= 24;
            TextView text = (TextView) tempRow.getChildAt(day);
            text.setText(String.format("%3.2f" , tempAverage) + "°");
            text = (TextView) humidRow.getChildAt(day);
            text.setText(String.format("%3.2f", humidAverage));
            text = (TextView) rainRow.getChildAt(day);
            text.setText(String.format("%3.2f", rainAverage));
            text = (TextView) windRow.getChildAt(day);
            text.setText(String.format("%3.2f", windAverage));

        }


    }

    //https://google.github.io/volley/simple.html
    private void volleyRequest(){
        latitude = 30.28;
        longitude = -97.76;
        String tempUnits;
        String rainUnits;
        String windUnits;
        if(config[0] == 0){
            tempUnits = "fahrenheit";
        }
        else{
            tempUnits = "celsius";
        }
        if(config[1] == 0){
            rainUnits = "inch";
        }
        else{
            rainUnits = "mm";
        }
        if(config[2] == 0){
            windUnits = "mph";
        }
        else if(config[2] == 1){
            windUnits = "ms";
        }
        else if(config[2] == 2){
            windUnits = "kmh";
        }
        else{
            windUnits = "kn";
        }
        /**imported text for Volley (only changed URL and output location)*/
        //final TextView textView = (TextView) findViewById(R.id.text_temp);

        // Instantiate the RequestQueue.
        RequestQueue queue = Volley.newRequestQueue(this);

        String url = "https://api.open-meteo.com/v1/forecast?latitude="+latitude+"&longitude="+longitude+"&hourly=temperature_2m,weathercode,relativehumidity_2m,rain,windspeed_10m&temperature_unit="+tempUnits+"&windspeed_unit="+windUnits+"&precipitation_unit="+rainUnits;
        // Request a string response from the provided URL.
        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        // Display the first 500 characters of the response string.
                        //textView.setText("Response is: " + response.substring(0,500));
                        MainActivity.this.parseInput(response); //my code to try and pass response
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                //textView.setText("That didn't work!");
                temperatures[0] = -1;
                //TODO: Lol hopefully no errors happen, figure what to do at some point
            }
        });

        // Add the request to the RequestQueue.
        queue.add(stringRequest);


    }

    private void parseInput(String response){
        try {
            JSONObject depression = (JSONObject) new JSONParser().parse(response);
            JSONObject inputs = (JSONObject) depression.get("hourly");
            JSONArray tempInputs = (JSONArray) inputs.get("temperature_2m");
            JSONArray humidInputs = (JSONArray) inputs.get("relativehumidity_2m");
            JSONArray rainInput = (JSONArray) inputs.get("rain");
            JSONArray windInput = (JSONArray) inputs.get("windspeed_10m");

            /*//Debugging
            String output = "Output: ";
            for (int i = 0; i < 168; i++) {
                output += i + ": " + tempInputs.get(i) + "\n";
            }
            textView.setText(output);*/
            maxTemp = 0;
            maxRain = 0;
            maxWind = 0;
            weatherCode = ((Number)((JSONArray)inputs.get("weathercode")).get(0)).intValue();
            for(int index = 0; index < 168; index++){
                temperatures[index] = (double) tempInputs.get(index);
                humidity[index] = ((Number)humidInputs.get(index)).doubleValue();
                rain[index] = (double) rainInput.get(index);
                wind[index] = (double) windInput.get(index);
                if(temperatures[index] > maxTemp){ maxTemp = temperatures[index];}
                if(rain[index] > maxRain){ maxRain = rain[index]; }
                if(wind[index] > maxWind){ maxWind = wind[index]; }
            }

            printGraph(0);
            for(int index = 1; index < 5; index++){
                if(resetGraph[index]){
                    printGraph(index);
                }
            }
            printGraph(config[3]);
            outputToScreen();
            printTop();
        } catch (ParseException pe) {
            //textView.setText("Parse Error");
            //See above...lol
        }
    }
}