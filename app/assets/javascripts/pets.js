$(function(){
    $('.add_owner').click(function(){
var pet_id = $(this).attr('pet_id');
    $.post(
        "services/adopt",
        {
            pet_id: pet_id
        })
        .done(function( data ) {
            console.log('added '+ pet_id);
        });

    console.log('adding '+ pet_id);
});
})