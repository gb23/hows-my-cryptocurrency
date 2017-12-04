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
        const image = $(this).data("image");
        const $thisIcon = $(this)
        $.getJSON(`/users/${user_id}/transactions/${tx_id}`,function(APIresponse){
            changeView(image, $thisIcon, APIresponse, tx_id); 
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
function showExtraTxDataTemplate(txAdditionalInfo, tx_id) {
    //insert-show-more-<%=transaction.id%>
    const src = $("#transaction-show-template").html();
    
    const template = Handlebars.compile(src);
    const txExtra = template(txAdditionalInfo);
    $(`#insert-show-more-${tx_id}`).html(txExtra);
}
function changeListLink(coinName){
    $("#list_txs_in_wallet").replaceWith(`<p id="list_txs_in_wallet" class="mt0 black-80 b ph3 pv2 ba f6 dib">${coinName} Transaction History</p>`)
}

function changeView(displayedImage, $icon, APIresponse, tx_id) {
    if (displayedImage === "ellipses"){
        showExtraTxDataTemplate(APIresponse, tx_id);
        changeToDownArrowIcon($icon);
       
    } else if (displayedImage === "downArrow") {
        $(`#insert-show-more-${tx_id}`).empty();
        changetoEllipsesIcon($icon);
    }
}

function changeToDownArrowIcon($icon) {
    $icon.data('image', "downArrow");
    $icon.removeClass("fa-ellipsis-h")
    $icon.addClass("fa-caret-down")
}
function changetoEllipsesIcon($icon) {
     $icon.data('image', "ellipses");
     $icon.removeClass("fa-caret-down");
     $icon.addClass("fa-ellipsis-h");
}
