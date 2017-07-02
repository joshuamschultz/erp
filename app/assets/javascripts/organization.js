$(document).ready(function(){
  function get_address(type){
      $('#org_contact').html("");
       var address_label = "Addresses";
       var address_button = "Address"
      if(type === 'address'){
         address_label = "Addresses";
         address_button = "Address"
      }
      else if(type === 'contact'){
          address_label = "Contacts";
          address_button = "Contact"
      }
      var adress = '<div class="widget-head"><div class="row-fluid"><h4 class="span6 heading">'+address_label+'</h4><span class="span6 heading right"><a href="/contacts/new?contact_type='+type+'&amp;object_id=<%= @organization.id %>" class="btn btn-mini btn-success">New '+address_button+'</a></span></div></div><div class="widget-body"><table id="table_report_contacts" class="dynamicTable table table-striped table-bordered table-condensed row-fluid"><thead><tr><th>Title</th><th>Description</th><th>City</th><th>Telephone</th><th>Email</th><th>Fax</th><th></th></tr></thead><tbody></tbody></table></div></div>'
      $('#org_contact').html(adress);


          data_table_report_contacts = $('#table_report_contacts').dataTable({
              "bAutoWidth": false,
              "bProcessing": true,
              "sAjaxSource": '/contacts?contact_type='+type+'&amp;object_id=<%= @organization.id %>',
              "aaSorting": [[0, "asc"]],
              "aoColumns": [
                          { "mData": "contact_title" },
                          {"mData": "contact_description"},
                          {"mData": "contact_city"},
                          { "mData": "contact_telephone" },
                          { "mData": "contact_email" },
                          { "mData": "contact_fax" },
                          { "mData": "links", "bSortable": false, "bSearchable": false }
                      ],
              "bFilter": true,
              "bLengthChange": true
      });

  }
});
