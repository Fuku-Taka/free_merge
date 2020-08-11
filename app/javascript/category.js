// $(function(){
  // $(document).ready(function(){
$(document).on('turbolinks:load', function(){
  function appendOption(category){
    var html = `<option value="${category.id}">${category.name}</option>`;
    return html;
  }
  function appendChildrenBox(insertHTML){
    var childSelectHtml = "";
    childSelectHtml = `<div class="CategoryBottom" id="children_wrapper">
                        <select id="child__category" name="content[category_id]" class="FormBox">
                          <option value="">選択して下さい</option>
                          ${insertHTML}
                        </select>
                      </div>`;
    $('.CategoryBottom#category__box--parent').append(childSelectHtml);
  }
  function appendGrandchildrenBox(insertHTML){
    var grandchildSelectHtml = "";
    grandchildSelectHtml = `<div class="CategoryBottom" id="grandchildren_wrapper">
                              <select id="grandchild__category" name="content[category_id]" class="FormBox">
                                <option value="">選択して下さい</option>
                                ${insertHTML}
                              </select>
                            </div>`;
    $('.CategoryBottom#category__box--parent').append(grandchildSelectHtml);
  }

  $('#content_category_id').on('change',function(){
    var parentId = document.getElementById('content_category_id').value;
    if (parentId != ""){
      $.ajax({
        url: '/contents/get_category_children/',
        type: 'GET',
        data: { parent_id: parentId },
        dataType: 'json'
      })
      .done(function(children){
        $('#children_wrapper').remove();
        $('#grandchildren_wrapper').remove();
        var insertHTML = '';
        children.forEach(function(child){
          insertHTML += appendOption(child);
        });
        appendChildrenBox(insertHTML);
      })
      .fail(function(){
        alert('カテゴリー取得に失敗しました');
      })
    }else{
      $('#children_wrapper').remove();
      $('#grandchildren_wrapper').remove();
    }
    
    
  });
  $('.CategoryBottom#category__box--parent').on('change','#child__category',function(){
    var childId = document.getElementById('child__category').value;
    if(childId != "" && childId != 46 && childId != 74 && childId != 134 && childId != 142 && childId != 147 && childId != 150 && childId != 158){
      $.ajax({
        url: '/contents/get_category_grandchildren',
        type: 'GET',
        data: { child_id: childId },
        dataType: 'json'
      })
      .done(function(grandchildren){
        $('#grandchildren_wrapper').remove();
        var insertHTML = '';
        grandchildren.forEach(function(grandchild){
          insertHTML += appendOption(grandchild);
        });
        appendGrandchildrenBox(insertHTML);
      })
      .fail(function(){
        alert('カテゴリー取得に失敗しました');
      })
    }else{
      $('#grandchildren_wrapper').remove();
    }
    
  })
  $('#content_category_id').on('change', function(){
    $('.childcategorys').remove();
  });
  $('#child__category').on('change', function(){
    $('#grandchild__category').remove();
  });
});