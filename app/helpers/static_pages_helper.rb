module StaticPagesHelper
  def convert_to_amcharts_json(data_array)
    data_array.to_json.gsub(/\"text\"/, "text").html_safe
  end
end
