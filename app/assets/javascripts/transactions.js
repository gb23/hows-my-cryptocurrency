$(function() {
   // 
   $("#list_txs_in_wallet").on('click', function(){
       const coin_id = $(this).data("coinid"); //expect 1
       const user_id = $(this).data("userid"); //expect 2
       const coin_name = $(this).data("coinname");
        $.getJSON(`/users/${user_id}/transactions?coin_id=${coin_id}`,function(APIresponse){
            showTxsWithTemplate(APIresponse);
            changeListLink(coin_name);
            //id="coin_list_in_wallet"

        });
   }); 




   function showTxsWithTemplate(txs) {
        //Handlebars.registerPartial("notesPartial", $("#notes-partial-template").html());
        const src = $("#transaction-template").html();
        const template = Handlebars.compile(src);
        const txList = template(txs);
        $("#transactions_in_wallet").html(txList);
    }
    function changeListLink(coinName){
        $("#list_txs_in_wallet").replaceWith(`<p id="list_txs_in_wallet" class="mt0 black-80 b ph3 pv2 ba f6 dib">${coinName} Transaction History</p>`)
        // $("#list_txs_in_wallet").text(`${coinName} Transactions:`);
        // $("#list_txs_in_wallet").removeClass("grow");
        // $("#list_txs_in_wallet").removeAttr('href');
        // $("#list_txs_in_wallet").replaceWith(()=>{'<div>',{

        // }
        
        // });
            // '<a href="#" id="list_txs_in_wallet" class="link black-80 b ph3 pv2 input-reset ba b--black bg-transparent grow pointer f6 dib">Transaction History</a>');
    }
   



});

