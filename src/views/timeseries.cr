[:div, {class: "timeseries"},
  [:div, {id: "plot"}],
  [:script, {type: "text/javascript"},
    <<-JAVASCRIPT
    new Dygraph(
      document.getElementById("plot"),
      "#{Metrics.csv}?id=#{params["id"]}",
      { legend: 'always', connectSeparatedPoints: true }
    );
    JAVASCRIPT
  ]]
