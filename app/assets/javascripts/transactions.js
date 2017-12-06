function Transaction(attributes){

}

Transaction.prototype.renderTxItem = function(){

}


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
            changeView(image, $thisIcon, APIresponse, tx_id, user_id); 
        }); 
   });
   $("#create-a-transaction-form").on('click', function(event){
       event.preventDefault();
       const user_id = $(this).data("userId");
       showNewTransactionForm({user_id: user_id});

       //"new-transaction-form"
   });

   $("form#new_transaction.new_transaction").on('submit', function(event){
        event.preventDefault();
        console.log("click");
        debugger;
   });
});

function showNewTransactionForm(userIdObj) {
    
    const src = $("#new-transaction-form-template").html();
    const template = Handlebars.compile(src);
    const newForm = template(userIdObj);
    $("#new_transaction_form").html(newForm);
    $("#create-a-transaction-form").replaceWith('<p id="create-a-transaction-form" class="black-80 mt0 mb0 pt1 b ph3 b--black f6" >Create a transaction:</p>')
    $("#link_field_set").removeClass("pb4");
}

function showTxsWithTemplate(txs) {
    //Handlebars.registerPartial("notesPartial", $("#notes-partial-template").html());
    const src = $("#transaction-template").html();
    const template = Handlebars.compile(src);
    const txList = template(txs);
    $("#transactions_in_wallet").html(txList);
}
function showExtraTxDataTemplate(txAdditionalInfo, tx_id, user_id) {
    //insert-show-more-<%=transaction.id%>
    const src = $("#transaction-show-template").html();
    
    const template = Handlebars.compile(src);
    const txExtra = template(txAdditionalInfo);
    $(`#insert-show-more-${tx_id}`).html(txExtra);

    const srcForMod = $("#edit-delete-icons-template").html();
    const templateForMod = Handlebars.compile(srcForMod);
    const deleteURL = `/users/${user_id}/transactions/${tx_id}`
    const editURL = `/users/${user_id}/transactions/${tx_id}/edit`
    const modFeature = templateForMod({deleteURL: deleteURL, editURL: editURL });
    // $(`#insert-edit-delete-${tx_id}`).html(modFeature);
    //<div id="insert-edit-delte-<%=transaction.id%>"></div>
    $(`#insert-show-more-${tx_id}`).append(modFeature);
    $(`#insert-show-more-${tx_id}`).addClass("pb4");
}
function changeListLink(coinName){
    $("#list_txs_in_wallet").replaceWith(`<p id="list_txs_in_wallet" class="mt0 black-80 b ph3 pv2 ba f6 dib">${coinName} Transaction History</p>`)
}

function changeView(displayedImage, $icon, APIresponse, tx_id, user_id) {
    if (displayedImage === "ellipses"){
        showExtraTxDataTemplate(APIresponse, tx_id, user_id);
        changeToDownArrowIcon($icon);
       
    } else if (displayedImage === "downArrow") {
        $(`#insert-show-more-${tx_id}`).empty();
        $(`#insert-show-more-${tx_id}`).removeClass("pb4");
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
