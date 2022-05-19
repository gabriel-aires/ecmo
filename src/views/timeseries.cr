[:div, {class: "row timeseries"},
  [:div, {class: "col", id: "plot"}],
  [:script, {type: "text/javascript"},
    <<-JAVASCRIPT
    new Dygraph(
      document.getElementById("plot"),
      "#{Metrics.csv}?id=#{params["id"]}&type=simple",
      {
        connectSeparatedPoints: true,
        stackedGraph: true,
        highlightCircleSize: 2,
        strokeWidth: 1,
        strokeBorderWidth: null,
        animatedZooms: true,
        highlightSeriesOpts: {
          strokeWidth: 3,
          strokeBorderWidth: 1,
          highlightCircleSize: 5
        }
      }
    );
    JAVASCRIPT
  ]]
