$(function() {
   $("#list_txs_in_wallet").on('click', function(){
       const coin_id = $(this).data("coinid"); 
       const user_id = $(this).data("userid");
       const coin_name = $(this).data("coinname");
        $.getJSON(`/users/${user_id}/transactions?coin_id=${coin_id}`,function(APIresponse){
            showTxsWithTemplate(APIresponse);
            changeListLink(coin_name);
        });
   }); 
   $("[id=transaction-show-more-icon]").on('click', function(){
        const tx_id = $(this).data("txid"); 
        const user_id = $(this).data("userid");
        $.getJSON(`/users/${user_id}/transactions/${tx_id}`,function(APIresponse){
            showExtraTxDataTemplate(APIresponse);
        }); 
   });
});

function showTxsWithTemplate(txs) {
    //Handlebars.registerPartial("notesPartial", $("#notes-partial-template").html());
    const src = $("#transaction-template").html();
    const template = Handlebars.compile(src);
    const txList = template(txs);
    $("#transactions_in_wallet").html(txList);
}
function showExtraTxDataTemplate(APIresponse) {
    //insert-show-more-<%=transaction.id%>
}
function changeListLink(coinName){
    $("#list_txs_in_wallet").replaceWith(`<p id="list_txs_in_wallet" class="mt0 black-80 b ph3 pv2 ba f6 dib">${coinName} Transaction History</p>`)
}

