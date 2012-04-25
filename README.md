#amCharts tutorial for Ruby on Rails - pulling data from your database to populate your graph
- - -
[amCharts](http://www.amcharts.com/) is a set of JavaScript/HTML5 charts.  In this tutorial, I will go over how to pull the data from a database to populate your graph or chart.

A big thanks to [@chiragsinghal](https://twitter.com/chiragsinghal) for helping me get this working. However, any mistakes in this tutorial our purely my own.

For this tutorial I am using Rails 3.2.3 and Ruby 1.9.3p125 (2012-02-16 revision 34643) [x86_64-darwin10.8.0].

#amCharts Tutorial
- - -
###Section 1 - Creating a new project

1) Create a new repository on [GitHub](https://github.com) named 'amcharts_example'

2) Create a new rails project

    $ rails new amcharts_example
    $ cd amcharts_example

3) Open the project in your favorite text editor (example: I am using Sublime Text 2)

    $ subl .

4) Update the Gemfile

    source 'https://rubygems.org'

    gem 'rails', '3.2.3'

    group :development, :test do
     gem 'sqlite3', '1.3.5'
     gem 'rspec-rails', '2.9.0'
    end

    # Gems used only for assets and not required
    # in production environments by default.
    group :assets do
     gem 'sass-rails',   '3.2.4'
     gem 'coffee-rails', '3.2.2'
     gem 'uglifier', '1.2.3'
    end

    gem 'jquery-rails', '2.0.0'

    group :test do
     gem 'capybara', '1.1.2'
    end

    group :production do
     gem 'pg', '0.12.2'
    end

5) Install and include the new gems

    $ bundle install

6) Initialize the Git repository and push to GitHub

    $ git init
    $ git add .
    $ git commit -m "Initial commit"
    $ git remote add origin git@github.com:<username>/amcharts_example.git
    $ git push -u origin master

7) (Optional) Deploy the app to Heroku. (Assuming you have already created a Heroku account. If not, check out this [tutorial](http://ruby.railstutorial.org/chapters/beginning?version=3.2#sec:1.4.1)) 

    $ heroku create --stack cedar
    $ git push heroku master

###Section 2 - Creating a static page to display our graph

8) Generate a StaticPages controller

$ rails generate controller StaticPages mygraph

9) Download the latest version of the [amCharts JavaScript Charts](http://www.amcharts.com/download) release from their website

10) From the download, copy the file 'amcharts.js' and paste it in your project file directory in the [app/assets/javascripts](https://github.com/diasks2/amcharts_example/tree/master/app/assets/javascripts) folder.

11) Add a graph to the view of your new static page [mygraph.html.erb](https://github.com/diasks2/amcharts_example/blob/master/app/views/static_pages/mygraph.html.erb)

    <h1>StaticPages#mygraph</h1>
    <p>Find me in app/views/static_pages/mygraph.html.erb</p>

    <div id="chartdiv" style="width: 100%; height: 400px;"></div>

     <script type="text/javascript">
            var chart;

            var chartData = [{
                country: "USA",
                visits: 4025
            }, {
                country: "China",
                visits: 1882
            }, {
                country: "Japan",
                visits: 1809
            }, {
                country: "Germany",
                visits: 1322
            }, {
                country: "UK",
                visits: 1122
            }, {
                country: "France",
                visits: 1114
            }, {
                country: "India",
                visits: 984
            }, {
                country: "Spain",
                visits: 711
            }, {
                country: "Netherlands",
                visits: 665
            }, {
                country: "Russia",
                visits: 580
            }, {
                country: "South Korea",
                visits: 443
            }, {
                country: "Canada",
                visits: 441
            }, {
                country: "Brazil",
                visits: 395
            }, {
                country: "Italy",
                visits: 386
            }, {
                country: "Australia",
                visits: 384
            }, {
                country: "Taiwan",
                visits: 338
            }, {
                country: "Poland",
                visits: 328
            }];


            AmCharts.ready(function () {
                // SERIAL CHART
                chart = new AmCharts.AmSerialChart();
                chart.dataProvider = chartData;
                chart.categoryField = "country";
                chart.startDuration = 1;

                // AXES
                // category
                var categoryAxis = chart.categoryAxis;
                categoryAxis.labelRotation = 90;
                categoryAxis.gridPosition = "start";

                // value
                // in case you don"t want to change default settings of value axis,
                // you don"t need to create it, as one value axis is created automatically.

                // GRAPH
                var graph = new AmCharts.AmGraph();
                graph.valueField = "visits";
                graph.balloonText = "[[category]]: [[value]]";
                graph.type = "column";
                graph.lineAlpha = 0;
                graph.fillAlphas = 0.8;
                chart.addGraph(graph);

                chart.write("chartdiv");
            });
        </script>

12) Commit the changes

    $ git add .
    $ git commit -am "Added a StaticPages Controller and amcharts.js"
    $ git push
    $ git push heroku

13) Test it on the local server (start the server)

    $ rails s

And visit: [http://localhost:3000/static_pages/mygraph](http://localhost:3000/static_pages/mygraph)

14) Deploy and test it on Heroku

    $ heroku open

Now navigate to http://[yourappname].herokuapp.com/static_pages/mygraph

You can visit the example for this tutorial here: [http://amcharts-example.herokuapp.com/static_pages/mygraph](http://surveyor-example.herokuapp.com/static_pages/mygraph)

