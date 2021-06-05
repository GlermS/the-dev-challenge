function update_all_times(data){
    if (data.file_total_gross_income){
       $("#file_total_gross_income").text(data.file_total_gross_income);
    }
    if (data.all_times_total_gross_income){
       $("#all_times_total_gross_income").text(data.all_times_total_gross_income);
    }
}

document.body.addEventListener("ajax:success", function (response) {
         const [data, , ] = response.detail;
         update_all_times(data);
         $("#error").css("display","none");
    }
);

document.body.addEventListener("ajax:error", function (response) {
    const [, status,] = response.detail;
    $("#error").css("display","flex").text(status);
    }
);
(function() {


}).call(this);
