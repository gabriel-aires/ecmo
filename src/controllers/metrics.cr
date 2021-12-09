class Metrics < Application
  {% for model in [Host, Boot, CPU, Load, Memory, Net, Disk, Partition, Pid] %}

    get {{ ("\"/" + model.stringify.downcase + "\"").id }}, {{ (":" + model.stringify.downcase).id }} do
      render json: {{model}}.all
    end

  {% end %}
end
