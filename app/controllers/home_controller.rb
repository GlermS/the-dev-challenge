class HomeController < ApplicationController
  def index
    @purchase = Purchase.new
    @all_times_total_gross_income = PurchasesController.new.get_all_time
  end
end
