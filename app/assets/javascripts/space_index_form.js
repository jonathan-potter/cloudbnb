$(document).ready(function(){

  $("#space-index-filter-form").on("ajax:success", function(event, data){

    console.log("space-index-filter-form submitted")
    var html = data
    $("#space-list-wrapper").html(html);
  });


  // $("#cat-list").on("ajax:success", ".cat-favorite-form", function(event, data){
  //   var $form = $(this);
  //   var $li = $form.closest("li");
  //
  //   // data is the `cat` json object
  //   if(data.is_favorite){
  //     $li.addClass("is-favorite");
  //   } else {
  //     $li.removeClass("is-favorite");
  //   }
  // });
  //
  //
  // $("#cat-new-form").on("ajax:success", function(event, data){
  //   var $form = $(this);
  //
  //   // data is the `_cat_list_item` partial
  //   $("#cat-list").append(data);
  //
  //   $form[0].reset();
  // });

});