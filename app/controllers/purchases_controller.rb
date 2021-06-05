class PurchasesController < ApplicationController
  layout "api"
  after_action :change_header
 

  def post_file
    purchases = params[:purchase][:file]
    items = parse_text(purchases.read)
    @gross_income = 0
    unless items.empty?
        items.each do |item|
          @gross_income = @gross_income + item[:item_price]*item[:purchase_count]
          Purchase.create(item)
        end
        get_all_time
        @gross_income
    else
      respond_to do |format|
        format.any { render :json => {:response => 'No purchase found' },:status => :bad_request  }
      end
    end
  end

  def get_all_time
    purchases = Purchase.all
    @all_time_gross_income = 0
    purchases.each do |item|
      @all_time_gross_income = @all_time_gross_income + item.item_price.to_f*item.purchase_count.to_i
    end
    @all_time_gross_income
  end
  
  def parse_text(text)
    lines = text.split("\n")
    @accepted_fields = Purchase.column_names

    i = 0
    items = []
    headers = []
    lines.each do |line|
        if i == 0
          headers = line.downcase.force_encoding("utf-8").split("\t").map{|header| header.gsub(' ', '_')}
          unless headers.include? "purchaser_name" and headers.include? "item_price" and headers.include? "purchase_count"
            raise "Missing fields"
          end
        else
            data = line.force_encoding("utf-8").split("\t")
            j=0
            element = {}
            headers.each do |header|
                if !header.nil? and @accepted_fields.include? header
                  case header
                  when "item_price"
                    element[header.to_sym] = data[j].to_f
                  when "purchase_count"
                    element[header.to_sym] = data[j].to_i
                  else
                    element[header.to_sym] = data[j]
                  end
                end
                j=j+1
            end
            items<<element
        end
        i=i+1
    end
    items
  end
  
  private
  def change_header
     response.set_header('Content-Type','application/json')
  end
end
