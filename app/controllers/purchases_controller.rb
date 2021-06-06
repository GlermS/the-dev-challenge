class PurchasesController < ApplicationController
  layout "api"
  before_action :check_login
  after_action :change_header
  
  def post_file(user=@current_user, req_params=params)
    if @current_user != nil
      items = receive_file_and_parse req_params[:purchase][:file]
      @gross_income = 0
      unless items.empty?
          items.each do |item|
            @gross_income = @gross_income + income(item)
            item[:user_id]= @current_user[:id]
            Purchase.create(item)
          end
          get_all_time
          @gross_income
      else
        respond_to do |format|
          format.any { render :json => {:response => 'No purchase found'}, :status => :bad_request  }
        end
      end
    else
      respond_to do |format|
          format.any { render :json => {:response => 'Please, login first' },:status => :unauthorized  }
      end
    end
  end

  def get_all_time(user=@current_user)
    @all_time_gross_income = 0
    if user!= nil
      purchases = Purchase.all
      purchases.each do |item|
        if item[:user_id]==user[:id]
          @all_time_gross_income = @all_time_gross_income + income(item)
        end
      end
    end
    @all_time_gross_income
  end
  
  private
  def income(item)
    item[:item_price]*item[:purchase_count]
  end
  
  def receive_file_and_parse(file)
    parse_text(file.read)
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
  
  def change_header
     response.set_header('Content-Type','application/json')
  end
end
