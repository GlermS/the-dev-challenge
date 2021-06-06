class HomeController < ApplicationController
  def index
    
    @purchase = Purchase.new
    @current_user = check_login
    @all_times_total_gross_income = PurchasesController.new.get_all_time(@current_user)
  end
end
