function Transaction(attributes){
    this.user_id = attributes.user_id;
    this.coin_id = attributes.coin_id;
    this.coin_name = attributes.coin_name;
    this.id = attributes.id;
    this.last_value = parseInt(attributes.last_value).toFixed(2);
    this.money_in = attributes.money_in.toFixed(2);
    this.price_per_coin = attributes.price_per_coin.toFixed(2);
    this.quantity = attributes.quantity.toFixed(4);
    this.form = attributes.form;
    this.notes = attributes.notes;
}

Transaction.prototype.renderTxItem = function(){
    const src = $("#newly-created-transaction-template").html();
    const template = Handlebars.compile(src);
    const txItem = template(this);
    $("#preprend-new-transaction").prepend(txItem);
    if($("#no-transactions").text()){
        $("#no-transactions").empty();
        $("#no-transactions").removeClass();
        $("[id^='insert-show-more']").parent().removeClass("bb").removeClass("b--light-silver");
    } 
}

Transaction.prototype.reRenderFormWithErrors = function(){
    if (this.form === "closed"){
        const src = $("#error-closed-transaction-form-template").html();
        const template = Handlebars.compile(src);
        const newForm = template(this);
        $("#new_transaction_form").html(newForm);
        $(`#new_transaction_form option[value="${this.coin_id}"]`).attr("selected", true);
    } else if (this.form === "open"){

    }
    renderNotes(this);
    handleAddCommentClick();
    handleFormSubmitClick();
    //rerender form //open vs closed??? if open before want it to remain open
    //add error instructions
    //add error highlighting

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
   $("ol").on('click',"i", function(){
        const tx_id = $(this).data("txid"); 
        const user_id = $(this).data("userid");
        const image = $(this).data("image");
        const $thisIcon = $(this)
        $.getJSON(`/users/${user_id}/transactions/${tx_id}`,function(APIresponse){
            changeView(image, $thisIcon, APIresponse, tx_id, user_id); 
        }); 
   });

   $("fieldset#link_field_set").on('click',"#create-a-transaction-form", function(event){
       event.preventDefault();
       const user_id = $(this).data("userId");
       showNewTransactionForm({user_id: user_id});
       handleAddCommentClick();
       
       handleFormSubmitClick();
       
    }); 
});
function handleAddCommentClick() {
    $("#add_comment").on('click', "i", function(){
        $("#add_comment i").remove();
        $("#add_comment").removeClass("mt3")
        $("#add_comment").append('<label class="lh3 fw6 f6" for="transaction_note_attributes_comment">Comment:</label>');
        $("#add_comment").append('<textarea class="db pa2 input-reset ba bg-transparent hover-bg-black hover-white" type="text" name="transaction[note_attributes][comments][]" id="transaction_note_attributes_comment" rows="4" cols="30"></textarea>');
        $("#add_comment").append('<i class="mt3 fa fa-plus-circle ">Add <em>another</em> comment <em>(optional)</em></i>')
   });
}
function handleFormSubmitClick() {
    $("form#new_transaction.new_transaction").on('submit', function(event){
        //Code below is if want to explore caching typed in coin names so drop down options are fresh   
        // const typedCoinNames = localStorage['typedCoinNames'];
            event.preventDefault();            
            console.log("click");
                   //Code below is if want to explore caching typed in coin names so drop down options are fresh   
            // if ($(this)["0"][4].value !== ""){
           //     typedCoinNames.push($(this)["0"][4].value);
           //     localStorage['typedCoinNames'] = typedCoinNames;
           // }
            const params = $(this).serialize();
            const address = $(this).attr("action");
            const user_id =  /\d+/.exec(address)[0]
            const posting = $.ajax({
                type: "POST",
                url: address, 
                data: params,
                dataType: "json"
            }); 
            posting.done(function(APIresponse) {     
                console.log("called back")
               if (APIresponse.id === null){
                console.log("Form input not valid!")
                    
                const transaction = new Transaction(APIresponse);
                
                //delete form
                eliminateFormFromView();

                transaction.reRenderFormWithErrors();
                
                

               } else {
                console.log("APIresponse is good!")
                const transaction = new Transaction(APIresponse);
                transaction.renderTxItem();
                restoreCreateATransaction(user_id);

               }
            }); 
        });
}
function checkIfListed(selection) {
    if (selection.value == "-1"){
        $("#another-coin").show();
    } else{
        $("#another-coin").hide();
    }
}
function eliminateFormFromView(){
    $("#new_transaction_form").empty();
}
function restoreCreateATransaction(user_id) {
    eliminateFormFromView();
    $("#create-a-transaction-form").replaceWith(`<a data-user-id="${user_id}" id="create-a-transaction-form" class="link black-80 b ph3 pv2 input-reset ba b--black bg-transparent grow pointer f6 dib" href="/users/${user_id}/transactions/new">Create a transaction:</a>`)
    $("#link_field_set").addClass("pb4");
}

function showNewTransactionForm(userIdObj) {
    const src = $("#new-transaction-form-template").html();
    const template = Handlebars.compile(src);
    const newForm = template(userIdObj);
    $("#new_transaction_form").html(newForm);


    $("#create-a-transaction-form").replaceWith('<p id="create-a-transaction-form" class="black-80 mt0 mb0 pt1 b ph3 b--black f6" >Create a transaction:</p>')
    $("#link_field_set").removeClass("pb4");
}

function showTxsWithTemplate(txs) {
    const src = $("#transaction-template").html();
    const template = Handlebars.compile(src);
    const txList = template(txs.reverse());
    $("#transactions_in_wallet").html(txList);
}
function showExtraTxDataTemplate(txAdditionalInfo, tx_id, user_id) {
    const src = $("#transaction-show-template").html();
    
    const template = Handlebars.compile(src);
    const txExtra = template(txAdditionalInfo);
    $(`#insert-show-more-${tx_id}`).html(txExtra);

    const srcForMod = $("#edit-delete-icons-template").html();
    const templateForMod = Handlebars.compile(srcForMod);
    const deleteURL = `/users/${user_id}/transactions/${tx_id}`
    const editURL = `/users/${user_id}/transactions/${tx_id}/edit`
    const modFeature = templateForMod({deleteURL: deleteURL, editURL: editURL });

    $(`#insert-show-more-${tx_id}`).append(modFeature);
    $(`#insert-show-more-${tx_id}`).addClass("pb4");
}
function changeListLink(coinName){
    $("#list_txs_in_wallet").replaceWith(`<p id="list_txs_in_wallet" class="mt0 black-80 b ph3 pv2 f6 dib">${coinName} Transaction History:</p>`)
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
function renderNotes(transaction) {
    if (transaction.notes !== null){
        transaction.notes.forEach(comment => {
            $("#add_comment i").remove();
            $("#add_comment").removeClass("mt3")
            $("#add_comment").append('<label class="lh3 fw6 f6" for="transaction_note_attributes_comment">Comment:</label>');
            $("#add_comment").append(`<textarea class="db pa2 input-reset ba bg-transparent hover-bg-black hover-white" type="text" name="transaction[note_attributes][comments][]" id="transaction_note_attributes_comment" rows="4" cols="30">${comment}</textarea>`);
            $("#add_comment").append('<i class="mt3 fa fa-plus-circle ">Add <em>another</em> comment <em>(optional)</em></i>')
        });
    }
}
