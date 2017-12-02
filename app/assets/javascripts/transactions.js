$(function() {
   $("#list_txs_in_wallet").on('click', function(){
       debugger;
       const coin_id = $(this).data("coinid"); //expect 1
       const user_id = $(this).data("userid"); //expect 2
        $.getJSON(`/users/${user_id}/transactions?coin_id=${coin_id}`,function(APIresponse){
            debugger;
            //id="coin_list_in_wallet"

        });
   }); 
});