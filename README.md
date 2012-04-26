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

    <h1>My amCharts Graph</h1>
    <p>This is my amCharts graph</p>

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

You can visit the example for this tutorial here: [http://amcharts-example.herokuapp.com/static_pages/mygraph](http://amcharts-example.herokuapp.com/static_pages/mygraph)

###Section 3 - Adding a model

We will add a 'Country' model (and the corresponding 'Countries' controller).  Here we will store the data for each country and the number of visits.

15) Add a 'Countries' controller

    $ rails generate controller Countries new

16) Add a 'Country' model

    $ rails generate model Country country:string visits:integer

(Note that, in contrast to the plural convention for controller names, model names are singular.)

17) Migrate up the database

    $ bundle exec rake db:migrate

18) Update the [routes.rb](https://github.com/diasks2/amcharts_example/blob/master/config/routes.rb) file

    resources :countries, only: [:new, :create]

    match '/countries/new', to: 'countries#new'
    match '/static_pages/mygraph',   to: 'static_pages#mygraph'

19) Update the countries controller

    class CountriesController < ApplicationController
      def new
        @countries = Country.new
 
         respond_to do |format|
          format.html  # new.html.erb
          format.json  { render :json => @countries }
         end
      end

     def create
        @countries = Country.new(params[:country])
        if @countries.save
          redirect_to '/static_pages/mygraph'
        else
          redirect_to '/countries/new'
        end
     end
   end

20) Update the countries/new.html.erb view

    <h1>New Country</h1>
    <p>Enter some new data</p>

    <%= form_for(@countries) do |f| %>

    <%= f.label :country %>
    <%= f.text_field :country %>

    <%= f.label :visits %>
    <%= f.text_field :visits %>

    <%= f.submit "Save" %>

    <% end %>       

*Note that we have not added any validations to our model (and we also do not have any validations on the client side, just a text field). When you create your own model, you will want to make sure that you our vaildating the data that is going into your model.

21) Make our graph dynamic (pulling the data from our database).  Update 'var chartData' in the [static_pages/mygraph view](https://github.com/diasks2/amcharts_example/blob/master/app/views/static_pages/mygraph.html.erb) 

    var chartData = <%= raw @countries.to_json.gsub(/\"created_at\"/, "created_at").gsub(/\"id\"/, "id").gsub(/\"country\"/, "country").gsub(/\"visits\"/, "visits").gsub(/\"updated_at\"/, "updated_at") %>;

22) Update the [StaticPages controller](https://github.com/diasks2/amcharts_example/blob/master/app/controllers/static_pages_controller.rb)

    class StaticPagesController < ApplicationController
      def mygraph
        @countries = Country.find(:all)
      end
    end

23) Commit our changes and test on the local server

    $ git add .
    $ git commit -am "completed dynamic graph"
    $ git push
    $ rails s

And visit: [http://localhost:3000/countries/new](http://localhost:3000/countries/new) and enter in some data: 

Example; Country: Japan Visits: 300

You should now see a bar graph with one bar! Your graph is now dynamic and tied to your model.

24) Push to Heroku and test

    $ git push heroku
    $ heroku run rake db:migrate
    $ heroku open

Now navigate to http://[yourappname].herokuapp.com/countries/new

You can visit the example for this tutorial here: [http://amcharts-example.herokuapp.com/countries/new](http://amcharts-example.herokuapp.com/countries/new)and enter in some data.








